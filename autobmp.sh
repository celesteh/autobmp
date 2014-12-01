#!/bin/bash

file=$1

size=`wc -c $1 | cut -f 1 -d ' '`
ints=`expr $size / 6`
root=`echo "sqrt($ints)" | bc`

x=$root
y=$root
echo "$x x $y"
squared=`echo "$x * $y" | bc`
    echo "squared is $squared"

while [ $squared -lt $ints ];do
    x=`expr $x + 1`
    squared=`echo "$x * $y" | bc`
    echo "squared is $squared"
done

echo "expr $squared - $ints"
diff=`expr $squared - $ints`
diff=`echo "$diff * 6" |bc`

echo "diff is $diff"

base=`basename $file`
temp=`echo "/tmp/$base"`
cp $file $temp

truncate -s +$diff $temp


size=$x
size+="x"
size+=$y

echo $size
command=`echo "convert -size $size -depth 16 rgb:$temp $file.bmp"`
echo $command
`$command`
