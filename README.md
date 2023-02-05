# hxCodecPro

hxCodecPro is a library for [Haxe](https://haxe.org/) which provides utilities for audio and video, including:

- Audio and video playback with every imaginable codec.
- Support for Windows, Mac, Linux, HTML5, and mobile.
- Efficient playback with features like streaming and hardware decoding.

hxCodecPro is powered by [libVLC](https://www.videolan.org/vlc/libvlc.html).

## Why hxCodecPro?

hxCodecPro has the following advantages over [hxCodec](https://github.com/polybiusproxy/hxCodec/) (its predecessor):
- Underlying libVLC libraries updated to 4.0 to take advantage of bleeding-edge development features.
- Cleaner codebase

And coming soon:
- Streaming playback for higher performance
- Playback over network (play videos from URLs)
- Compatibility with web (using browser playback when appropriate)
- New performance improvements taking advance
- MP3 audio playback
- Uncompressed audio for web

## Installation

Install `hxCodecPro` via Haxelib:

```
haxelib install hxcodecpro
```

## Advanced Usage

- Follow this guide to cross-compile libvlc.dll:
    - https://code.videolan.org/videolan/vlc/-/blob/master/doc/BUILD-win32.md

## Licensing

hxCodecPro is made available under the MIT License. Check [LICENSE.md](./LICENSE.md) for more information.

hxCodecPro is built using code adapted from [hxCodec](https://github.com/polybiusproxy/hxCodec/), which is also under the MIT License.

hxCodecPro, when used on desktop platforms, links with code from VLC, which is made available under the Lesser GPLv2 license. Check [VideoLAN.org](https://www.videolan.org/legal.html) for more information. 

# contributors 
- [Jonnycat] (https://github.com/JonnycatMeow) - Mac Support 
