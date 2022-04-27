# hxCodec - Native video support for OpenFL & HaxeFlixel

[Original Repository](https://github.com/polybiusproxy/PolyEngine).

[Click here to check the roadmap of hxCodec](https://github.com/brightfyregit/Friday-Night-Funkin-Mp4-Video-Support/projects/1)

## Credits

- [PolybiusProxy (me!)](https://github.com/polybiusproxy) - Creator of hxCodec.
- [datee](https://github.com/datee) - Creator of HaxeVLC.
- [BrightFyre](https://github.com/brightfyregit) - Creator of repository.
- [GWebDev](https://github.com/GrowtopiaFli) - Inspiring me to do this.
- [CryBit](https://github.com/CryBitDev) - fixing my shit lolololoolol
- [Erizur](https://github.com/Erizur) - Linux Support
- [Saw (M.A. Jigsaw)](https://github.com/jigsaw-4277821) - Android Support + Turned this into a Haxelib
- [luckydog7](https://github.com/luckydog7) - Helper for Android Support
- The contributors.

## About Linux Support
Recently we achieved Linux support thanks to the contributors, but every Linux user has to download "libvlc-dev" and "libvlccore-dev" from your distro's package manager.
You can also install them through the terminal:
```bash
sudo apt-get install libvlc-dev
sudo apt-get install libvlccore-dev
```

## About Android Support
Recently we achieved Android support thanks to the contributors, if you want to run the videos, the videos needs to be in external storage (phone root folder)

## Instructions
**These are for Friday Night Funkin' mostly so it may not work for your HaxeFlixel project.**

### 1. Install the Haxelib:

To Install Them You Need To Open Command prompt/PowerShell And To Tipe
```cmd
haxelib git hxCodec https://github.com/brightfyregit/hxCodec.git
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
2. Create somewhere in PlayState
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

### 5. Example
At PlayState create function
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

At PlayState endSong function
```haxe
if (SONG.song.toLowerCase() == 'triple-trouble')
	playEndCutscene('soundtestcodes');
```
