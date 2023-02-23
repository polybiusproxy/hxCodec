# hxcodec-thirdparty

Includes third-party libraries for hxcodec via Git LFS.

All third-party headers and library files go in this folder to ensure explicit distinction between the hxcodec codebase and any LGPL codebases.

## Download Links
- includes: https://artifacts.videolan.org/vlc/nightly-win64/
    - Download the latest `debug.7z` build, extract, and copy thse dirs:
        - `./sdk/include/vlc/`
- Windows x64: https://artifacts.videolan.org/vlc/nightly-win64/
    - Download latest build `.zip`, extract, copy these files/dirs:
        - `./libvlc.dll`
        - `./libvlccore.dll`
        - `./plugins/`
- Windows x32: https://artifacts.videolan.org/vlc/nightly-win32/
    - Download latest build `.zip`, extract, copy these files/dirs:
        - `./libvlc.dll`
        - `./libvlccore.dll`
        - `./plugins/`
- Mac x86_64: https://artifacts.videolan.org/vlc/nightly-macos-x86_64/
    - Download latest `.tar.gz`, extract, copy these files/dirs:
        - `./lib/libvlc.12.dylib`
        - `./lib/libvlc.dylib`
        - `./lib/libvlccore.9.dylib`
        - `./lib/libvlccore.dylib`
        - `./lib/vlc/`
- Mac arm64: https://artifacts.videolan.org/vlc/nightly-macos-arm64/
    - Download latest `.tar.gz`, extract, copy these files/dirs:
        - `./lib/libvlc.12.dylib`
        - `./lib/libvlc.dylib`
        - `./lib/libvlccore.9.dylib`
        - `./lib/libvlccore.dylib`
        - `./lib/vlc/`
- Linux: https://artifacts.videolan.org/vlc/nightly-snap/
    - Download the latest `.snap`, extract, copy these files/dirs:
        - `./usr/lib/libvlc.so.12.0.0`
        - `./usr/lib/libvlc.so.12`
        - `./usr/lib/libvlc.so`
        - `./usr/lib/libvlccore.so.9.0.0`
        - `./usr/lib/libvlccore.so.9`
        - `./usr/lib/libvlccore.so`
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

