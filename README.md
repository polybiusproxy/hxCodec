# hxCodec
A library which adds native video support for OpenFL and HaxeFlixel.

**[Original repository](https://github.com/polybiusproxy/PolyEngine)**          
**[Click here to check the roadmap](https://github.com/polybiusproxy/hxCodec/projects/1)**

--------------------------

## Instructions for Friday Night Funkin'

1. Install the Haxelib
You can install it through haxelib:
```
haxelib install hxCodec
```

You can also install it through Git for the latest updates:
```
haxelib git hxCodec https://github.com/polybiusproxy/hxCodec
```

2. Add this code in `Project.xml`
```xml
<haxelib name="hxCodec"/>
```

**OPTIONAL: If your PC is ARM64, add this code also:**
```xml
<haxedef name="HXCPP_ARM64" />
```

**OPTIONAL: If you want debug traces in your console, add this code also:**
```xml
<!-- Show debug traces for hxCodec -->
<haxedef name="HXC_DEBUG_TRACE" if="debug" />
```

3. Create a folder called `videos` in your `assets/preload` folder.

4. Add this code in `Paths.hx`:
```haxe
inline static public function video(key:String)
{
	return 'assets/videos/$key';
}
```

--------------------------

### Playing videos

1. Put your video in the videos folder.

**Note: hxCodec supports all the video formats VLC can play!**

2. Add somewhere in PlayState:
```haxe
function playCutscene(name:String, atEndOfSong:Bool = false)
{
	inCutscene = true;
	FlxG.sound.music.stop();

	var video:VideoHandler = new VideoHandler();
	video.finishCallback = function()
	{
		if (atEndOfSong)
		{
			if (storyPlaylist.length <= 0)
				FlxG.switchState(new StoryMenuState());
			else
			{
				SONG = Song.loadFromJson(storyPlaylist[0].toLowerCase());
				FlxG.switchState(new PlayState());
			}
		}
		else
			startCountdown();
	}
	video.playVideo(Paths.video(name));
}
```

--------------------------

#### Examples

At the PlayState "create()" function:
```haxe
switch (curSong.toLowerCase())
{
	case 'song1':
		playCutscene('song1scene.asf');
	case 'song2':
		playCutscene('song2scene.avi');
	default:
		startCountdown();
}
```

At the PlayState "endSong()" function:
```haxe
if (SONG.song.toLowerCase() == 'song1')
	playCutscene('song1scene.mjpeg', true);
```

#### Examples for Kade Engine 1.8

At the PlayState "create()" function:
```haxe
generateSong(SONG.songId);

switch (curSong.toLowerCase())
{
	case 'song1':
		playCutscene('song1scene.mp4');
	default:
		startCountdown();
}

```

At the PlayState "endSong()" function:
```haxe
PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0], diff);
FlxG.sound.music.stop();

switch (curSong.toLowerCase())
{
	case 'song1':
		playCutscene('song1scene.ogg', true);
	case 'song2':
		playCutscene('song2scene.wav', true);
}
```

--------------------------

## Building

### Windows & macOS

You don't need any special instructions in order to build for Windows / macOS.
Just pull the `lime build windows` or `lime build mac` command and the library will be building with your game.

### Linux

In order to make your game work with the library, you **have to install** `libvlc-dev` and `libvlccore-dev` from your distro's package manager.

Example with APT:
```
sudo apt-get install libvlc-dev
sudo apt-get install libvlccore-dev
sudo apt-get install vlc-bin
```

### Android

In order for hxCodec to work on Android, you will need a library called [extension-androidtools](https://github.com/jigsaw-4277821/extension-androidtools).

To install it, enter the following in a terminal:
```
haxelib git extension-androidtools https://github.com/jigsaw-4277821/extension-androidtools.git
```

Next, add this into `Project.xml`
```xml
<haxelib name="extension-androidtools" if="android" />
```

**Currently, hxCodec will search the videos only on the external storage of the device (`/storage/emulated/0/MyAppName/assets/videos/yourvideo.mp4`).
You will also have to put the location manually in the paths.**

--------------------------

## Credits

- [PolybiusProxy](https://github.com/polybiusproxy) - Creator of hxCodec.
- [datee](https://github.com/datee) - Creator of HaxeVLC.
- [Jigsaw](https://github.com/jigsaw-4277821) - Android support and x86 Support.
- [Erizur](https://github.com/Erizur) - Linux support.
- [BushTrain460615](https://github.com/BushTrain460615) - macOS Support.
- The contributors.