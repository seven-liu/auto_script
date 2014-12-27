#!/usr/bin/perl -w
use LWP::Simple;
my @hosts;
my @urls;
my $totalCnt = 0;
&main;
exit;


sub main
{
    push(@urls, "http://www.hao123.com/");
    open $fp, ">urls.txt";	
    foreach $url(@urls)
    {
        &parse_website($url, $fp);
    }
    close $fp;
}
sub parse_website
{
    my $url = $_[0];
    my $file = $_[1];	
    #ץȡ��ҳ
    my $webData = get $url;
    #die "couldn't get $url" unless defined $webData;
    if (defined($webData))
    {
        #��ȡa��ǩ
        while ($webData =~ /\s*<\s*a\s*href\s*=\s*"\s*([^"]+)"/)
        {
            my $match = $1;
            my $left = $';
            my $host;		
            my $tag = $match."/";
            #��ȡhost
            if ($tag =~ /\/\/([^\/]+)\//)
            {
                $host = $1;		
                #ȥ���ظ���host
                if (hostExist($host) == 0)
                {
                    push(@hosts, $host);
                    print $file $match."\n";		
                    #�´�ץȡ�����url
                    push(@urls, $match);		
                    $totalCnt++;
                    print $totalCnt."\t".$match."\n";
                    if ($totalCnt == 999999999999)
                    {
                        print "\nDone!\n";
                        exit;
                    }
                }
            }
            $webData = $left;
        }
    }
}
sub hostExist
{
    my $ret = 0;
    my $str = $_[0];	
    foreach $h(@hosts)
    {
        if ($h eq $str)
        {
            $ret = 1;
            break;
        }
    }	
    $ret = $ret;
}
