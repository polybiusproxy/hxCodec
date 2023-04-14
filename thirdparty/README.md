# hxcodec/thirdparty

All third-party headers and library files go in this folder to ensure explicit distinction between the hxcodec codebase and any LGPL codebases.

## Download Links
- includes: https://artifacts.videolan.org/vlc/nightly-win64/
    - Download the latest `debug.7z` build, extract, and copy these dirs:
        - `./vlc-4.0.0-dev/sdk/include/vlc/` to `./thirdparty/include/vlc/`
            - The whole folder is needed.
        - `./vlc-4.0.0-dev/sdk/lib/libvlc.lib` to `thirdparty/lib/vlc/Windows/x64/libvlc.lib`
        - `./vlc-4.0.0-dev/sdk/lib/libvlccore.lib` to `thirdparty/lib/vlc/Windows/x64/libvlccore.lib`
- Windows x64: https://artifacts.videolan.org/vlc/nightly-win64/
    - Download latest build `.zip`, extract, copy these files/dirs:
        - `./vlc-4.0.0-dev/libvlc.dll` to `./thirdparty/dll/vlc/Windows/libvlc.dll`
        - `./vlc-4.0.0-dev/libvlccore.dll` to `./thirdparty/dll/vlc/Windows/libvlccore.dll`
        - `./vlc-4.0.0-dev/plugins/` to `./thirdparty/dll/vlc/Windows/plugins`
            - The whole folder and all the plugins are needed.
- Mac x86_64: https://artifacts.videolan.org/vlc/nightly-macos-x86_64/
    - Download latest `.tar.gz`, extract, copy these files/dirs:
        - `./lib/libvlc.12.dylib` to `./thirdparty/lib/vlc/Mac/x86_64/libvlc.12.dylib`
        - `./lib/libvlc.dylib` to `./thirdparty/lib/vlc/Mac/x86_64/libvlc.dylib`
        - `./lib/libvlccore.9.dylib` to `./thirdparty/lib/vlc/Mac/x86_64/libvlccore.9.dylib`
        - `./lib/libvlccore.dylib` to `./thirdparty/lib/vlc/Mac/x86_64/libvlccore.dylib`
        - `./lib/vlc/` to `./thirdparty/lib/vlc/Mac/x86_64/vlc/`
- Mac arm64: https://artifacts.videolan.org/vlc/nightly-macos-arm64/
    - Download latest `.tar.gz`, extract, copy these files/dirs:
        - `./lib/libvlc.12.dylib` to `./thirdparty/lib/vlc/Mac/arm64/libvlc.12.dylib`
        - `./lib/libvlc.dylib` to `./thirdparty/lib/vlc/Mac/arm64/libvlc.dylib`
        - `./lib/libvlccore.9.dylib` to `./thirdparty/lib/vlc/Mac/arm64/libvlccore.9.dylib`
        - `./lib/libvlccore.dylib` to `./thirdparty/lib/vlc/Mac/arm64/libvlccore.dylib`
        - `./lib/vlc/` to `./thirdparty/lib/vlc/Mac/arm64/vlc/`
- Linux: https://artifacts.videolan.org/vlc/nightly-snap/
    - Download the latest `.snap`, extract, copy these files/dirs:
        - `./usr/lib/vlc/` to `./thirdparty/lib/vlc/Linux/vlc/`
            - Yes, the whole folder of plugins is needed and I haven't found a workaround, sorry it's so big.
        - `./usr/lib/libvlc.so.12.0.0` to `./thirdparty/lib/vlc/Linux/libvlc.so.12`
        - `./usr/lib/libvlccore.so.9.0.0` to `./thirdparty/lib/vlc/Linux/libvlccore.so.9`
        - `./lib/x86_64-linux-gnu/libidn.so.11.6.16` to `./thirdparty/lib/vlc/Linux/libidn.so.11`
        - `./lib/x86_64-linux-gnu/libusb-1.0.so.0.2.0` to `./thirdparty/lib/vlc/Linux/libusb-1.0.so-0.2.0`
        - `./lib/x86_64-linux-gnu/libz.so.1.2.11` to `./thirdparty/lib/vlc/Linux/libz.so.1`
- Android: https://search.maven.org/artifact/org.videolan.android/libvlc-all
    - Navigate to the latest `4.0.0` build on the Maven, download the `.aar` file.
    - Extract the `.aar` file, copy these files/dirs, FOR EACH ARCHITECTURE:
        - `./jni/<ARCH>/libc++_shared.so` 
        - `./jni/<ARCH>/libvlc.so`
    - Rename them and move them to the `thirdparty` folder:
        - Move the `arm64-v8a` files to `thirdparty/lib/vlc/Android/NAME-64.so`
        - Move the `armeabi-v7a` files to `thirdparty/lib/vlc/Android/NAME-v7.so`
        - Move the `x86` files to `thirdparty/lib/vlc/Android/NAME-x86.so`
        - Move the `x86_64` files to `thirdparty/lib/vlc/Android/NAME-x86_64.so`
- iOS: TODO
    - Something to do with VLCKit? https://code.videolan.org/videolan/VLCKit#build

