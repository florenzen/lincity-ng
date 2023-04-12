#!/bin/bash

# Requires create-dmg and dylibbundler.
# Both can be installed via homebrew.

INSTALL_PREFIX="$PWD/lincity-ng"
APP_NAME="LinCity-NG.app"

cd ..
LIBS="-framework CoreFoundation" ./configure --with-apple-opengl-framework --prefix=$INSTALL_PREFIX
jam
jam install

cd ./osx

echo "* Removing any existing installation"
rm -rf ./$APP_NAME
rm -f *.dmg
rm -f *.xz
rm -rf dmg.tmp

echo "* Creating skeleton"
mkdir -p ./$APP_NAME/Contents/Resources
mkdir ./$APP_NAME/Contents/MacOS
cp info.plist ./$APP_NAME/Contents/info.plist
cp lincity-ng.icns ./$APP_NAME/Contents/Resources/lincity-ng.icns

echo "* Copying executable"
cp $INSTALL_PREFIX/bin/lincity-ng ./$APP_NAME/Contents/MacOS/lincity-ng

echo "* Copying data files"
cp -r $INSTALL_PREFIX/share ./$APP_NAME/Contents/Resources/

echo "* Bunling dependencies"

dylibbundler -od -b -x ./$APP_NAME/Contents/MacOS/lincity-ng -d ./$APP_NAME/Contents/libs/

echo "* Creating DMG"
DMG_NAME="LinCity-NG-`awk -F " " '{print $3}' ../RELNOTES | awk 'NR == 1'`.dmg"
mkdir dmg.tmp
cp -R LinCity-NG.app dmg.tmp
cp ../README dmg.tmp
cp ../COPYING dmg.tmp
cp ../COPYING-data.txt dmg.tmp
cp ../COPYING-fonts.txt dmg.tmp
create-dmg --eula ../COPYING $DMG_NAME dmg.tmp
rm -rf dmg.tmp
