# hxCodec

![](https://img.shields.io/github/repo-size/polybiusproxy/hxCodec) ![](https://badgen.net/github/open-issues/polybiusproxy/hxCodec) ![](https://badgen.net/badge/license/MPL2.0/green)

A Haxe library which adds native video playback on [HaxeFlixel](https://haxeflixel.com) and [OpenFL](https://www.openfl.org).

`hxCodec` is powered by [libVLC](https://www.videolan.org/vlc/libvlc.html).

**[Click here to check the roadmap](https://github.com/polybiusproxy/hxCodec/projects/1)**

## Instructions

1. Install the latest stable version of `hxCodec` by running the following haxelib command.
    ```bash
    haxelib install hxCodec
    ```

    You can also install it through `Git` to get the latest changes.
    ```bash
    haxelib git hxCodec https://github.com/polybiusproxy/hxCodec
    ```

2. Add this code in the ***project.xml*** file.
    ```xml
    <haxelib name="hxCodec" if="desktop || android" />
    ```

    **OPTIONAL: Some defines you can add to your project**
    ```xml
    <!-- LibVLC Logging for hxCodec -->
    <haxedef name="HXC_LIBVLC_LOGGING" if="debug" />
    ```

## Linux Specific Instructions

In order to build a application with the library on ***Linux***, you **have to install** `libvlc` and `libvlccore` from your distro's package manager.

### Debian based distributions:
```bash
sudo apt-get install libvlc-dev libvlccore-dev 
```

### Arch based distributions:
```bash
sudo pacman -S vlc 
```

## Usage Example

Check out the [Samples Folder](samples/) for examples on how to use this library.

## Licensing
**hxCodec** is made available under the **Mozilla Public License 2.0\***. Check [LICENSE](./LICENSE) for more information.

\*Haxelib does not support MPL2.0; therefore, regardless of what Haxelib reports, this library's license is still **MPL2.0**.

![](https://raw.githubusercontent.com/videolan/vlc/master/share/icons/256x256/vlc.png)

[***libVLC***](https://www.videolan.org/vlc/libvlc.html) is the engine of **VLC** released under the **LGPLv2 License** (or later). Check [VideoLAN.org](https://www.videolan.org/legal.html) for more information.

## Credits

| Avatar | UserName | Involvement |
| ------ | -------- | ----------- |
| ![](https://avatars.githubusercontent.com/u/47796739?s=64) | [polybiusproxy](https://github.com/polybiusproxy) | Creator of **hxCodec**.
| ![](https://avatars.githubusercontent.com/u/1677550?s=64) | [datee](https://github.com/datee) | Creator of **HaxeVLC**.
| ![](https://avatars.githubusercontent.com/u/77043862?s=64) | [MAJigsaw77](https://github.com/MAJigsaw77) | Programmer, Android & Linux support.
| ![](https://avatars.githubusercontent.com/u/4635334?s=64) | [EliteMasterEric](https://github.com/EliteMasterEric) | Additional Programmer.
| ![](https://avatars.githubusercontent.com/u/84131849?s=64) | [RapperGF](https://github.com/RapperGF) | Rendering Overhaul & Testing.
| ![](https://avatars.githubusercontent.com/u/49110074?s=64) | [swordcube](https://github.com/swordcube) | Testing Linux Support. 
| ![](https://avatars.githubusercontent.com/u/107599365?v=64) | [Jonnycat](https://github.com/JonnycatMeow) | MacOS Support.
