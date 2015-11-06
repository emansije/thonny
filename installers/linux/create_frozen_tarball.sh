#!/bin/bash

SOURCE_DIR=../..
VERSION=$(<$SOURCE_DIR/VERSION)
ARCHITECTURE="$(uname -m)"
VERSION_NAME=thonny-$VERSION-$ARCHITECTURE 

# Clean #########################################################################
# prepare working folder
rm -rf build
rm -rf cx_build

TARGET_DIR=build/thonny
mkdir -p $TARGET_DIR

# Freeze #########################################################################
/opt/pythonny/bin/python3.5 ../cx_freeze/setup.py build -b cx_build > freezing.log

# move some dirs to correct location ##################
OUTPUT_DIR=cx_build/$(ls cx_build)
mv $OUTPUT_DIR/lib/VERSION $OUTPUT_DIR
mv $OUTPUT_DIR/lib/res $OUTPUT_DIR
mv $OUTPUT_DIR/lib/backend_private $OUTPUT_DIR

# copy tcltk libs
cp /opt/pythonny/lib/libtcl8.6.so $OUTPUT_DIR
cp /opt/pythonny/lib/libtk8.6.so $OUTPUT_DIR
cp -R /opt/pythonny/lib/tcl8.6 $OUTPUT_DIR/tcl
cp -R /opt/pythonny/lib/tk8.6 $OUTPUT_DIR/tk

# copy tkhtml
mkdir $OUTPUT_DIR/tcl/Tkhtml
cp /opt/pythonny/lib/Tkhtml3.0/libTkhtml3.0.so $OUTPUT_DIR/tcl/Tkhtml
cp /opt/pythonny/lib/Tkhtml3.0/pkgIndex.tcl $OUTPUT_DIR/tcl/Tkhtml


# move all to target_dir
mv $OUTPUT_DIR/* $TARGET_DIR

# put it together
mkdir -p dist
tar -cvzf dist/$VERSION_NAME.tar.gz -C build thonny

