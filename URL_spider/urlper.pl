#!/usr/bin/perl -w
use strict;
use warnings;
#use Data::Dumper;
use threads;
use threads::shared;
use Thread::Queue;
use Thread::Semaphore;
 
use Bloom::Filter;
use URI::URL;
use Web::Scraper;
 
my $max_threads = 15;
my $base_url = $ARGV[0] || 'http://www.icylife.net';
my $host = URI::URL->new($base_url)->host;
 
my $queue = Thread::Queue->new( );
 
my $semaphore = Thread::Semaphore->new( $max_threads );
my $mutex = Thread::Semaphore->new( 1 );
 
my $filter = shared_clone( Bloom::Filter->new(capacity => 10000, error_rate => 0.0001) );
 
$queue->enqueue( $base_url );
$filter->add( $base_url );
 
while( 1 )
{
        # join all threads which can be joined
        #my $joined = 0;
        foreach ( threads->list(threads::joinable) )
        {
                #$joined ++;
                $_->join( );
        }
        #print $joined, " joined\n";
 
        # if there are no url need process.
        my $item = $queue->pending();
        if( $item == 0 )
        {
                my $active = threads->list(threads::running);
                # there are no active thread, we finish the job
                if( $active == 0 )
                {
                        print "All done!\n";
                        last;
                }
                # we will get some more url if there are some active threads, just wait for them
                else
                {
                        #print "[MAIN] 0 URL, but $active active thread\n";
                        sleep 1;
                        next;
                }
        }
 
        # if there are some url need process
        #print "[MAIN] $item URLn";
        $semaphore->down;
        #print "[MAIN]Create thread.n";
        threads->create( \&ProcessUrl );
}
 
# join all threads which can be joined
foreach ( threads->list() )
{
        $_->join( );
}
 
sub ProcessUrl
{
        my $scraper = scraper
        {
                process '//a', 'links[]' => '@href';
        };
 
        my $res;
        my $link;
 
        while( my $url = $queue->dequeue_nb() )
        {
                eval
                {
                        $res = $scraper->scrape( URI->new($url) )->{'links'};
                };
                if( $@ )
                {
                        warn "$@\n";
                        next;
                }
                next if (! defined $res );
 
                #print "there are ".scalar(threads->list(threads::running))." threads, ", $queue->pending(), " urls need process.\n";
 
                foreach( @{$res} )
                {
                        $link = $_->as_string;
                        $link = URI::URL->new($link, $url);
 
                        # not http and not https?
                        next if( $link->scheme ne 'http' && $link->scheme ne 'https' );
                        # another domain?
                        next if( $link->host ne $host );
 
                        $link = $link->abs->as_string;
 
                        if( $link =~ /(.*?)#(.*)/ )
                        {
                                $link = $1;
                        }
 
                        next if( $link =~ /.(jpg|png|bmp|mp3|wma|wmv|gz|zip|rar|iso|pdf)$/i );
 
                        $mutex->down();
                        if( ! $filter->check($link) )
                        {
                                print $filter->key_count(), " ", $link, "\n";
                                $filter->add($link);
                                $queue->enqueue($link);
                        }
                        $mutex->up();
                        undef $link;
                }
                undef $res;
        }
        undef $scraper;
        $semaphore->up( );
}
 
