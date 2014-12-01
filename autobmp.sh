#!/bin/bash

file=$1
dest=$2

size=`wc -c $file | cut -f 1 -d ' '`
ints=`expr $size / 6`
root=`echo "sqrt($ints)" | bc`

x=$root
y=$root
#echo "$x x $y"
squared=`expr $x \* $y`
    #echo "squared is $squared"

while [[ $squared -lt $ints ]];do
    x=`expr $x + 1`
    squared=`expr $x \* $y`
    #echo "squared is $squared"
done

#echo "expr $squared - $ints"
diff=`expr $squared - $ints`
diff=`expr $diff \* 6`

#echo "diff is $diff"

base=`basename $file`
temp=`echo "/tmp/$base"`
cp $file $temp

truncate -s +$diff $temp


size=$x
size+="x"
size+=$y

#check if destination file is specified
if [[ ! $dest ]]; then
    $dest=$file
fi

#check file extension
dbase=`basename $dest`
extension=`echo "$dbase" | sed 's/^.*\.//'`
if [[ $extension == $dbase ]]; then
    #no extension
    extension=""
fi

if [[ $extension != "bmp" ]]; then
    dest+=".bmp"
fi

#echo $size
command=`echo "convert -size $size -depth 16 rgb:$temp $dest"`
echo $command
`$command`
