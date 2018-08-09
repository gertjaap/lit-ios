# lit-ios
Remote control client for LIT running on iOS

# Building

Build the RPC proxy framework:
```
cd lit-rpc-proxy
gomobile bind -target=ios
cp -r Litrpcproxy.framework ../LitPOC
```

Build the WebUI and place the build output into the `webui` subfolder of the project (overwrite existing files)

Then, open the LitPOC.xcodeproj and build/run it.