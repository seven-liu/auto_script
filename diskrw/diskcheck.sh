
echo 1GWrite
echo 1GWrite >>log/rwlog.txt
time dd if=/dev/zero bs=64K count=16K of=./1Gb.file &>>log/rwlog.txt

echo 1GRead 
echo 1GRead >>log/rwlog.txt
time dd if=./1Gb.file bs=64k |dd of=/dev/null &>>log/rwlog.txt

echo 1GReadandWrite
echo 1GReadandWrite >>log/rwlog.txt
time dd if=./1Gb.file of=./2.Gb.file bs=64k &>>log/rwlog.txt
rm 1Gb.file  
rm 2.Gb.file
