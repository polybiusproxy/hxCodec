# hxCodec - Native video support for OpenFL & Flixel

[Original Repository](https://github.com/polybiusproxy/PolyEngine).

[Click here to check the roadmap of hxCodec here](https://github.com/brightfyregit/Friday-Night-Funkin-Mp4-Video-Support/projects/1)

## Credits

- [PolybiusProxy (me!)](https://github.com/polybiusproxy) - Creator of hxCodec.
- [datee](https://github.com/datee) - Creator of HaxeVLC.
- [BrightFyre](https://github.com/brightfyregit) - Creator of repository.
- [GWebDev](https://github.com/GrowtopiaFli) - Inspiring me to do this.
- [CryBit](https://github.com/CryBitDev) - fixing my shit lolololoolol
- The contributors.

## Instructions
**These are for Friday Night Funkin mostly so it may not work for your flixel project.**

### 1. Download the repository:
You can either download it as a ZIP,
or git cloning it.

### 2. Edit `Project.xml`
Add
```xml
<assets path="assets/preload/videos" rename="assets/videos" include="*mp4" embed='false' />

<assets path="plugins/" rename='' if="cpp" />
<assets path="dlls/" rename='' if="cpp" />
```

**OPTIONAL: If your PC is ARM64, add this code:**

Add:

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