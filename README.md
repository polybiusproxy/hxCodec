# hxCodec

![](https://img.shields.io/github/repo-size/polybiusproxy/hxCodec) ![](https://badgen.net/github/open-issues/polybiusproxy/hxCodec) ![](https://badgen.net/badge/license/MPL2.0/green)

A Haxe library which adds native video playback on [HaxeFlixel](https://haxeflixel.com) and [OpenFL](https://www.openfl.org).

--------------------------

Using [libVLC](https://www.videolan.org/vlc/libvlc.html), `hxCodec` allows to play hundreds of video codecs.
          
**[Click here to check the roadmap](https://github.com/polybiusproxy/hxCodec/projects/1)**

--------------------------

## Instructions

### 1. Install the library
Install the latest stable version of `hxCodec` by running the following Haxelib command:
```
haxelib install hxCodec
```

You can also install it through Git to get the latest changes:
```
haxelib git hxCodec https://github.com/polybiusproxy/hxCodec
```

### 2. Modify Project.xml
Add this code in the Project.xml file:
```xml
<haxelib name="hxCodec" if="windows || linux || android" />
```

**OPTIONAL: Some defines you can add to your project**
```xml
<!-- LibVLC Logging for hxCodec -->
<haxedef name="HXC_LIBVLC_LOGGING" if="debug" />
```

--------------------------

## Usage Example

Check out the [Samples Folder](samples/) for examples on how to use this library.

--------------------------

## Building

### Windows

You don't need any special instructions in order to build for Windows.
Just run the `lime build windows` command and the library will be building with your application.

### Linux

In order to build a application with the library, you **have to install** `libvlc-dev` and `libvlccore-dev` from your distro's package manager.

Example with APT:
```bash
sudo apt-get install libvlc-dev libvlccore-dev 
```

### Android

**Currently `hxCodec` can load videos only from internal / external storage (not from the application's storage).**
In order for hxCodec to work on Android, you will need a library called [extension-androidtools](https://github.com/jigsaw-4277821/extension-androidtools).

To install it, enter the following in a terminal:
```
haxelib git extension-androidtools https://github.com/MAJigsaw77/extension-androidtools.git
```

Next, add this into `Project.xml`
```xml
<haxelib name="extension-androidtools" if="android" />
```

You can choose whether you want to use after you import this in your code.

```haxe
import android.content.Context;
```

* From internal storage: `Context.getFilesDir()` or `Context.getCacheDir()`<br />
* From external storage: `Context.getExternalFilesDir()` or `Context.getExternalCacheDir()`.

You will also have to put the location manually in the paths and to copy that video to the respective path.

## Licensing

**hxCodec** is made available under the **Mozilla Public License 2.0**. Check [LICENSE](./LICENSE) for more information.

![](https://github.com/videolan/vlc/blob/master/share/icons/256x256/vlc.png)

**libVLC** is the engine of **VLC** released under the **LGPLv2 License** (or later). Check [VideoLAN.org](https://www.videolan.org/legal.html) for more information.

## Credits

- [PolybiusProxy](https://github.com/polybiusproxy) - Creator of hxCodec.
- [Datee](https://github.com/datee) - Creator of HaxeVLC.
- [MAJigsaw](https://github.com/MAJigsaw77) - Programmer, Android & Linux support.
- [MasterEric](https://github.com/MasterEric) - Programmer.
- [RapperGF](https://github.com/RapperGF) - Rendering Overhaul & Testing
- The contributors.
