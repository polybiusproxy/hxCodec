# hxCodec - Native video support for OpenFL & HaxeFlixel

[Original Repository](https://github.com/polybiusproxy/PolyEngine).  
[Click here to check the roadmap of hxCodec](https://github.com/brightfyregit/Friday-Night-Funkin-Mp4-Video-Support/projects/1).

## Table of Contents
- [Instructions](#instructions)  
- [Building](#building)  
- [Credits](#credits)  

## Instructions
**These are for Friday Night Funkin' mostly so it may not work for your HaxeFlixel project.**

### 1. Install the Haxelib:

```cmd
haxelib git hxCodec https://github.com/polybiusproxy/hxCodec.git
```

### 2. Create a folder called `videos` in `assets/preload` folder:

### 3. **OPTIONAL: If your PC is ARM64, add this code in `Project.xml`:**

```xml
<haxedef name="HXCPP_ARM64" />
```

### 3. Edit `Paths.hx`
```haxe
inline static public function video(key:String, ?library:String)
{
	return getPath('videos/$key.mp4', BINARY, library);
}
```

### 4. Playing videos

1. Put your video in `assets/preload/videos`.
2. Create somewhere in PlayState:
```haxe
import vlc.MP4Handler;

var video:MP4Handler;

function playCutscene(name:String)
{
	inCutscene = true;

	video = new MP4Handler();
	video.finishCallback = function()
	{
		startCountdown();
	}
	video.playVideo(Paths.video(name));
}

function playEndCutscene(name:String)
{
	inCutscene = true;

	video = new MP4Handler();
	video.finishCallback = function()
	{
		SONG = Song.loadFromJson(storyPlaylist[0].toLowerCase());
		LoadingState.loadAndSwitchState(new PlayState());
	}
	video.playVideo(Paths.video(name));
}
```

### EXAMPLE
At the PlayState "create()" function:
```haxe
switch (curSong.toLowerCase())
{
	case 'too-slow':
		playCutscene('tooslowcutscene1');
	case 'you-cant-run':
		playCutscene('tooslowcutscene2');
	default:
		startCountdown();
}
```

At the PlayState "endSong()" function:
```haxe
if (SONG.song.toLowerCase() == 'triple-trouble')
	playEndCutscene('soundtestcodes');
```

## BUILDING
### Windows
You don't need any special instructions in order to build for Windows.
Just pull the "lime build windows".

### Linux
In order to make your game work with the library, every Linux user (this includes the player) **has to download** "libvlc-dev" and "libvlccore-dev" from your distro's package manager.
You can also install them through the terminal:
```bash
sudo apt-get install libvlc-dev
sudo apt-get install libvlccore-dev
```

### Android
Currently, hxCodec will search the videos only on the external storage (`/storage/emulated/0/appname/yourvideo.mp4`).
This is not suitable for games and will be fixed soon.

## Credits

- [PolybiusProxy (me!)](https://github.com/polybiusproxy) - Creator of hxCodec.
- [datee](https://github.com/datee) - Creator of HaxeVLC.
- [BrightFyre](https://github.com/brightfyregit) - Creator of repository.
- [GWebDev](https://github.com/GrowtopiaFli) - Inspiring me to do this.
- [CryBit](https://github.com/CryBitDev) - fixing my shit lolololoolol
- The contributors. <!-- forgot this existed and i added contributors on the credits lol -->
