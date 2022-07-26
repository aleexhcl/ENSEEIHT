#!/bin/bash

make clean;
mkdir $USER
cp -r norm1 ring sparse_nn server sched $USER;
cd $USER; find . -not \( -name  "*.c" -or  -name "Makefile" -or -name "*.h" -or -type d \) | xargs rm; cd ..;
tar zcvf $USER.tgz $USER;
rm -rf $USER;
