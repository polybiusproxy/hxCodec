# hxCodec

![](https://img.shields.io/github/repo-size/polybiusproxy/hxCodec) ![](https://badgen.net/github/open-issues/polybiusproxy/hxCodec) ![](https://badgen.net/badge/license/MIT/green)

A library which adds native video support on HaxeFlixel.

--------------------------

Using [libVLC](https://www.videolan.org/vlc/libvlc.html), hxCodec allows to play hundreds of video codecs.<br />
**hxCodec supports all the video formats VLC can play!**

**[Original repository](https://github.com/polybiusproxy/PolyEngine)**          
**[Click here to check the roadmap](https://github.com/polybiusproxy/hxCodec/projects/1)**

--------------------------

## Instructions

### 1. Install the library
Install the latest stable version of hxCodec by running the following Haxelib command:
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
<haxelib name="hxCodec" if="desktop || android" />
```

**OPTIONAL: If you want debug traces in your console when compiling in debug mode, add this:**
```xml
<!-- Show debug traces for hxCodec -->
<haxedef name="HXC_DEBUG_TRACE" if="debug" />
```

--------------------------

## Playing videos

You can play videos in just 2 lines of code:
```hx
var video:hxcodec.VideoHandler = new hxcodec.VideoHandler();
video.playVideo('assets/video.mp4');
```

--------------------------

## Building

### Windows and MacOS

You don't need any special instructions in order to build for Windows or MacOS.
Just run the `lime build windows` / `lime build mac` command and the library will be building with your game.

### Linux

In order to build a application with the library, you **have to install** `libvlc-dev` and `libvlccore-dev` from your distro's package manager.

Example with APT:
```bash
sudo apt-get install libvlc-dev libvlccore-dev 
```

### Android

**Currently, hxCodec can load videos only from internal / external storage (not from the application storage).**
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

--------------------------

## Credits

- [PolybiusProxy](https://github.com/polybiusproxy) - Creator of hxCodec.
- [datee](https://github.com/datee) - Creator of HaxeVLC.
- [Jigsaw](https://github.com/MAJigsaw77) - Programmer and Android support.
- [Erizur](https://github.com/Erizur) - Linux support.
- [BushTrain](https://github.com/BushTrain460615) - macOS support.
- The contributors.
