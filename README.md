# hxCodec

*Made by PolybiusProxy.*

[Original Repository](https://github.com/polybiusproxy/PolyEngine).

[Click here to check the roadmap of hxCodec here](https://github.com/brightfyregit/Friday-Night-Funkin-Mp4-Video-Support/projects/1)

## NOTE

This version only works with VScode, send me your solutions at https://github.com/Jrgamer4u/FNKNGT/labels/Source-code%20editor%20can%20not%20find%20plugins%20and%20dlls

## Instructions
**These are for Friday Night Funkin mostly so it may not work for your flixel project.**

### 1. Download the repository:
You can either download it as a ZIP,
or git cloning it.

WIP: You can use `haxelib git hxCodec https://github.com/Jrgamer4u/Friday-Night-Funkin-Mp4-Video-Support`

Code might not work with this fork.

### 2. Create `Videos` Folder

Create a `Videos` Folder inside of `Assets`

```
assets/videos
```

### 3. Edit `Project.xml`

Put:

```xml
<assets path="assets/videos"/>

<assets path="plugins/" rename=''/>
<assets path="dlls/" rename=''/>
```

**OPTIONAL: If your PC is ARM64, add this code:**

```xml
<haxedef name="HXCPP_ARM64" />
```
<br>

### 4. Edit `Paths.hx`

```haxe
inline static public function video(key:String, ?library:String)
{
	return getPath('videos/$key.mp4', BINARY, library);
}
```
<br>

### 5. Videos

**Required** 

For files larger than what GitHub can handle, download the Git Large File Service.

[Download Git Large File Service](https://git-lfs.github.com/)
<br><br>

### 6. Playing videos

1. Put your video in `assets/videos`.
2. Create at the places where the variables are in PlayState

```haxe
var isCutscene:Bool = false;
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
<br>

### 7. Examples
At PlayState create function
```haxe
switch (curSong.toLowerCase())
{
	case 'yoursonghere':
		playCutscene('yourcutscene');
	default:
		startCountdown();
}
```

At PlayState endSong function
```haxe
if (SONG.song.toLowerCase() == 'yoursonghere')
	playEndCutscene('yourcutscene');
```
<br>

# Credits

- [PolybiusProxy](https://github.com/polybiusproxy) - Creator of hxCodec.
- [datee](https://github.com/datee) - Creator of HaxeVLC.
- [BrightFyre](https://github.com/brightfyregit) - Creator of repository.
- [GWebDev](https://github.com/GrowtopiaFli) - Inspiring me to do this.
- [CryBit](https://github.com/CryBitDev) - fixing my shit lolololoolol
- The contributors.
