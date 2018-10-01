#!/bin/bash
gomobile bind -target=android
mkdir -p ../android/litrpcproxy
rm ../android/litrpcproxy/litrpcproxy.aar
mv litrpcproxy.aar ../android/litrpcproxy


## TODO: IOS
