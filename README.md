# hxCodec

*Made by PolybiusProxy.*

Original Repository - `https://github.com/polybiusproxy/PolyEngine`.

[Click here to check the roadmap of hxCodec here](https://github.com/brightfyregit/Friday-Night-Funkin-Mp4-Video-Support/projects/1)
  
### 1. Download the repository:
You can either download it as a ZIP,
or git cloning it.

WIP: You can use `haxelib git hxCodec https://github.com/Jrgamer4u/Friday-Night-Funkin-Mp4-Video-Support`

Might not work with this fork. For now, just use the PolybiusProxy version.

### 2. Create `Videos` Folder

Create a `Videos` Folder inside of `Assets`

```
assets/videos
```

### 2. Edit `Project.xml`

After:

```xml
<assets path="assets/week6"    library="week6"    exclude="*.ogg" if="web"/>
<assets path="assets/week6"    library="week6"    exclude="*.mp3" unless="web"/>
```

Put:

```xml
<assets path="assets/videos" exclude="*.mp3" if="web"/>
<assets path="assets/videos" exclude="*.ogg" unless="web"/>

<assets path="plugins/" rename='' if="windows"/>
<assets path="dlls/" rename='' if="windows"/>
```

**OPTIONAL: If your PC is ARM64, add this code:**

After:

```xml
<!-- <haxedef name="SKIP_TO_PLAYSTATE" if="debug" /> -->
<haxedef name="NG_LOGIN" if="newgrounds" />
```

Put:

```xml
<haxedef name="HXCPP_ARM64" />
```

### 3. Setting up the paths

In `Paths.hx`, put this code:

After:
```haxe	
inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
{
	return sound(key + FlxG.random.int(min, max), library);
}
```

Put:
```haxe
inline static public function video(key:String, ?library:String)
{
	trace('assets/videos/$key.mp4');
	return getPath('videos/$key.mp4', BINARY, library);
}
```

### 4. Videos

Put your video in `assets/videos`.
To play a video at the beginning of a week in Story Mode, add the following code in **`StoryMenuState.hx`**:

**Required** For files larger than what GitHub can handle, download the Git Large File Service.

[Download Git Large File Service](https://git-lfs.github.com/)

### 5. Playing videos

First, add a variable called `isCutscene`:

```haxe
var isCutscene:Bool = false;
```

Then replace these lines:

```haxe 
new FlxTimer().start(1, function(tmr:FlxTimer)
{
	LoadingState.loadAndSwitchState(new PlayState(), true);
});
```

with:

```haxe
var video:MP4Handler = new MP4Handler();

if (curWeek == 0 && !isCutscene) // Checks if the current week is Tutorial.
new FlxTimer().start(1, function(tmr:FlxTimer)
{
	{
		video.playMP4(Paths.video('yourcutscenenamehere'));
		video.finishCallback = function()
	{
		LoadingState.loadAndSwitchState(new PlayState());
	}
   	 	isCutscene = true;
	}
});
else
{
    new FlxTimer().start(1, function(tmr:FlxTimer)
    {
        if (isCutscene)
            video.onVLCComplete();

        LoadingState.loadAndSwitchState(new PlayState(), true);
    });
```

To play a cutscene before another week, replace `curWeek == 0` with the number of the week of your choice (-1, because arrays start from 0).

To play a cutscene at the end of a song, place the following code in **`PlayState.hx`** before the line `prevCamFollow = camFollow;` in the `endSong()` function. You can wrap it in an "if" statement if you'd like to restrict it to a specific song.
you should also add the isCutscene variable to PlayState, it solved a crash for some.

```haxe
var video:MP4Handler = new MP4Handler();

video.playMP4(Paths.video('yourcutscene'));
video.finishCallback = function()
{
	LoadingState.loadAndSwitchState(new PlayState());
}
```
If you are using the if statement, this code will work on Kade Engine 1.7 and up.
```haxe
if (curSong.toLowerCase() == 'yoursonghere' && !isCutscene)
{	
	var video:MP4Handler = new MP4Handler();
	
	video.playMP4(Paths.video('yourcutscene'));
	video.finishCallback = function()
	{
		LoadingState.loadAndSwitchState(new PlayState());
	}
	isCutscene = true;
}
else
{
	LoadingState.loadAndSwitchState(new PlayState());
}

```
<!-- You may have noticed a "clean()" function under the LoadingState state switch call, where the other LoadingState is and my solution to that is to not add it as it makes things unstable and crash other bugs, so dont add it. -->

Make sure the name of the song is written correctly or else your game will **hard crash.**
Then, comment out or delete the following lines immediately next to the code you just added.

```haxe
FlxTransitionableState.skipNextTransIn = true;
FlxTransitionableState.skipNextTransOut = true;
```

## Outputting to a FlxSprite

There are many reasons to do this, as with a FlxSprite you can do layering in play state. or where ever else.
To do this simply make a FlxSprite and do a playMP4 call with the argument. Then just add the sprite, and you're done!

```haxe
var sprite:FlxSprite = new FlxSprite(0,0);

var video:MP4Handler = new MP4Handler();
video.playMP4(Paths.video('yourvideonamehere'), null, sprite); // make the transition null so it doesn't take you out of this state

add(sprite);
```

# Credits

- [PolybiusProxy](https://github.com/polybiusproxy) - Creator of hxCodec.
- [datee]() - Creator of HaxeVLC.
- [BrightFyre](https://github.com/brightfyregit) - Creator of repository.
- [GWebDev](https://github.com/GrowtopiaFli) - Inspiring me to do this.
- [CryBit](https://github.com/CryBitDev) - fixing my shit lolololoolol
- The contributors.
