#!/bin/bash

make clean;
mkdir $USER
cp -r butterfly neural_network norm2 pipelining tree_bottomup $USER;
cd $USER; find . -not \( -name  "*.c" -or  -name "Makefile" -or -name "*.h" -or -type d \) | xargs rm; cd ..;
tar zcvf $USER.tgz $USER;
rm -rf $USER;
