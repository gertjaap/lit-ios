#!/bin/bash
gomobile bind -target=android
mkdir -p ../android/litrpcproxy
rm ../android/litrpcproxy/litrpcproxy.aar
mv litrpcproxy.aar ../android/litrpcproxy

gomobile bind -target=ios
rm -rf ../ios/LitPOC/Litrpcproxy.framework
cp -r Litrpcproxy.framework ../ios/LitPOC

