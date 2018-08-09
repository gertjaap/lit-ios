# lit-ios
Remote control client for LIT running on iOS

# Building

Build the RPC proxy framework:
```
cd lit-rpc-proxy
gomobile bind -target=ios
cp -r Litrpcproxy.framework ../LitPOC
```

Then, open the LitPOC.xcodeproj and build/run it.