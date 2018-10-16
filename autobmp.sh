#!/bin/bash

file=$1
dest=$2

size=`wc -c $file | xargs | cut -f 1 -d ' '`
ints=`expr $size / 6`
root=`echo "sqrt($ints)" | bc`


# Pad the file to be a square
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
#diff=`expr $squared - $ints`
#diff=`expr $diff \* 6`

diff=`expr $squared \* 6`

#echo "diff is $diff"

base=`basename $file`
temp=`echo "/tmp/$base"`
cp $file $temp

#truncate -s +$diff $temp
dd if=/dev/null of=$temp bs=1 count=1 seek=$diff

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
#command=`echo "convert -size $size -depth 16 rgb:$temp $dest"`
command=`echo "magick -size $size -depth 16 rgb:$temp $dest"`
echo $command
if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform
    export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib" && `$command`
else
    `$command`
fi
