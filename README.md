# lit-mobile
Remote control clients for LIT running on iOS and Android

# Building

Build the RPC proxy framework. Requires gomobile, Android NDK and/or XCode:
```
cd lit-rpc-proxy
./build.sh
```

Build the WebUI and place the build output into two folders:

```
android/app/src/main/assets/lit-webui
```
(For Android)

and 

```
ios/LitPOC/webui
```
(For iOS)

Then, open `ios/LitPOC/LitPOC.xcodeproj` in XCode or the `android` folder in Android Studio and build/run it.