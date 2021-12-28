# hxCodec

*Made by PolybiusProxy.*

[Original Repository](https://github.com/brightfyregit/Friday-Night-Funkin-Mp4-Video-Support)

[Click here to check the roadmap of hxCodec here](https://github.com/brightfyregit/Friday-Night-Funkin-Mp4-Video-Support/projects/1)
  
### Haxelib

You can use `haxelib git hxCodec https://github.com/Jrgamer4u/Friday-Night-Funkin-Mp4-Video-Support`

You need git to use haxelib git.

[Download Git Source-Control Management](https://git-scm.com/downloads)

## NOTE

This version only works with VScode, send me your solutions at https://github.com/Jrgamer4u/FNKNGT/labels/Source-code%20editor%20can%20not%20find%20plugins%20and%20dlls

## NOTE

For files larger than what GitHub can handle, download the Git Large File Service.

[Download Git Large File Service](https://git-lfs.github.com/)

### The code required to change from the Original Repository to make this fork work.

[Original Repository's Readme](https://github.com/brightfyregit/Friday-Night-Funkin-Mp4-Video-Support/blob/main/README.md)

replace these lines:

```haxe
video.playMP4
```
to
```haxe
video.playVideo
```
<br><br>

```haxe
LoadingState.loadAndSwitchState
```
to
```haxe
if (FlxG.sound.music != null)
FlxG.sound.music.stop();
FlxG.switchState(new PlayState());
```

# Credits

- [PolybiusProxy](https://github.com/polybiusproxy) - Creator of hxCodec.
- [datee](https://github.com/datee) - Creator of HaxeVLC.
- [BrightFyre](https://github.com/brightfyregit) - Creator of repository.
- [GWebDev](https://github.com/GrowtopiaFli) - Inspiring me to do this.
- [CryBit](https://github.com/CryBitDev) - fixing my shit lolololoolol
- The contributors.
