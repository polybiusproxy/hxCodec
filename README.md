# hxCodec

<!-- https://badgen.net/ includes badges that Shields.io is missing, like HaxeLib. -->
![](https://badgen.net/haxelib/v/hxcodec) ![](https://badgen.net/haxelib/d/hxcodec)

![](https://badgen.net/github/star/polybiusproxy/hxcodec) ![](https://badgen.net/github/open-issues/polybiusproxy/hxcodec) ![](https://badgen.net/github/contributors/polybiusproxy/hxcodec) ![](https://badgen.net/badge/license/MIT/blue)

hxCodec is a library for [Haxe](https://haxe.org/) which provides utilities for audio and video, including:

- Audio and video playback with every imaginable codec, for frameworks such as OpenFL and HaxeFlixel.
- Support for Windows, Mac, Linux, HTML5, and mobile.
- Efficient playback with features like streaming and hardware decoding.

hxCodec is powered by [libVLC](https://www.videolan.org/vlc/libvlc.html).

**NOTE::** If you are downloading this repo from GitHub, you will need to download the `thirdparty` folder separately, since these libraries include DLLs for multiple platforms and are very large (~1.5 GB uncompressed).

## Installation

Install `hxCodec` via Haxelib:

```
haxelib install hxcodec
```

## Basic Usage

### Friday Night Funkin'

If you're an FNF modder, here's a little section of the docs just for you! Skip this if you're making your own game.

To play a cutscene between levels, add this to your PlayState:

```
import hxcodec.flixel.FlxCutsceneState;

...

/**
 * Call this in your PlayState to switch to the cutscene, then switch to the next song.
 * Put the cutscene file into the `assets/shared/videos/` folder.
 */
FlxCutscene.playCutscene(Paths.file('videos/myCutscene.mp4'), new PlayState());
```

### HaxeFlixel

If you're using HaxeFlixel, the easiest way to play a cutscene is to use the provided `FlxCutsceneState`:

```
import hxcodec.flixel.FlxCutsceneState;

...

// This will open the video file at the provided file path, play it, then transition to the next FlxState
// when the video is complete or the user presses SPACE to skip (configurable).
FlxCutscene.playCutscene(videoPath, targetState);
```

If you want more control over video playback, you can do any of these:
- Extend `FlxVideoState` and add a function which calls `playVideo()`
- Extend `FlxVideoSubState` and add a function which calls `playVideo()`
- Add an `FlxVideoSprite` as an object to your state or substate and call `playVideo()`

### OpenFL

If you're using OpenFL, use `hxcodec.openfl.VideoSprite`:

```
var video:Sprite = new VideoSprite();
addChild(video);

...

video.playVideo(videoPath);
```

## Advanced Usage

- Follow this guide to cross-compile libvlc.dll:
    - https://code.videolan.org/videolan/vlc/-/blob/master/doc/BUILD-win32.md

## Licensing

hxCodec is made available under the MIT License. Check [LICENSE.md](./LICENSE.md) for more information.

hxCodec, when used on desktop platforms, links with code from VLC, which is made available under the Lesser GPLv2 license. Check [VideoLAN.org](https://www.videolan.org/legal.html) for more information. 

## Credits
- [PolybiusProxy](https://github.com/polybiusproxy) - Lead Programmer
- [EliteMasterEric](https://github.com/EliteMasterEric) - Programmer (v3 rewrite)
- [Jigsaw](https://github.com/MAJigsaw77) - Programmer (v2) and Android support (v2)
- [Erizur](https://github.com/Erizur) - Linux support (v2)
- [BushTrain460615](https://github.com/BushTrain460615) - macOS Support (v2)
- [Jonnycat](https://github.com/JonnycatMeow) - Mac Support (v3)
- [KadeDev](https://github.com/KadeDev) - Assisted with C++ interop
- [datee](https://github.com/datee) - Creator of HaxeVLC
