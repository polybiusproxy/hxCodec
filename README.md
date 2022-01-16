# hxCodec

*Made by PolybiusProxy.*

[Original Repository](https://github.com/polybiusproxy/PolyEngine)

[Click here to check the roadmap of hxCodec here](https://github.com/brightfyregit/Friday-Night-Funkin-Mp4-Video-Support/projects/1)
  
### 1. Haxelib

You can use `haxelib git hxCodec https://github.com/Jrgamer4u/Friday-Night-Funkin-Mp4-Video-Support`

You need [Git](https://git-scm.com/downloads) to use `haxelib git`.

## NOTE

[Git Large File Service](https://git-lfs.github.com/) might be required for large video files.

### 2. Edit `Project.xml`

Put:

```xml
<assets path="assets/videos"/>

<assets path="${haxelib:hxcodec}/plugins" rename=''/>
<assets path="${haxelib:hxcodec}/dlls" rename=''/>
```

**OPTIONAL: If your PC is ARM64, add this code:**

```xml
<haxedef name="HXCPP_ARM64" />
```


### 3. Setting up the paths

In `Paths.hx`, put this code:

```haxe
inline static public function video(key:String, ?library:String)
{
	trace('assets/videos/$key.mp4');
	return getPath('videos/$key.mp4', BINARY, library);
}
```

### 4. Playing videos

Put your video in `assets/videos`,
put your silent audio in `assets/music`.

To play a video at the beginning of a week in Story Mode, add the following code in **`StoryMenuState.hx`**:

First, add a variable called `isCutscene`:

```haxe
var isCutscene:Bool = false;
```

Then replace these lines:

```haxe 
new FlxTimer().start(1, function(tmr:FlxTimer)
{
	if (FlxG.sound.music != null)
    FlxG.sound.music.stop();
    FlxG.switchState(new PlayState());
});
```

with:

```haxe
var video:MP4Handler = new MP4Handler();

if (curWeek == 0 && !isCutscene) // Checks if the current week is Tutorial.
new FlxTimer().start(1, function(tmr:FlxTimer)
{
	{
        FlxG.sound.playMusic(Paths.music('yoursilentaudio'), 0);
		video.playVideo(Paths.video('yourcutscenenamehere'));
		video.finishCallback = function()
	{
		if (FlxG.sound.music != null)
        FlxG.sound.music.stop();
        FlxG.switchState(new PlayState());
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

        if (FlxG.sound.music != null)
        FlxG.sound.music.stop();
        FlxG.switchState(new PlayState());
    });
```

To play a cutscene before another week, replace `curWeek == 0` with the number of the week of your choice (-1, because arrays start from 0).

To play a cutscene at the end of a song, place the following code in **`PlayState.hx`** before the line `prevCamFollow = camFollow;` in the `endSong()` function. You can wrap it in an "if" statement if you'd like to restrict it to a specific song.

you should also add the isCutscene variable to PlayState, it solved a crash for some.

```haxe
var video:MP4Handler = new MP4Handler();

FlxG.sound.playMusic(Paths.music('yoursilentaudio'), 0);
video.playVideo(Paths.video('yourcutscene'));
video.finishCallback = function()
{
	if (FlxG.sound.music != null)
    FlxG.sound.music.stop();
    FlxG.switchState(new PlayState());
}
```
If you are using the if statement, this code will work on Kade Engine 1.7 and up.
```haxe
if (curSong.toLowerCase() == 'yoursonghere' && !isCutscene)
{	
	var video:MP4Handler = new MP4Handler();
	
    FlxG.sound.playMusic(Paths.music('yoursilentaudio'), 0);
	video.playVideo(Paths.video('yourcutscene'));
	video.finishCallback = function()
	{
		if (FlxG.sound.music != null)
        FlxG.sound.music.stop();
        FlxG.switchState(new PlayState());
	}
	isCutscene = true;
}
else
{
	if (FlxG.sound.music != null)
    FlxG.sound.music.stop();
    FlxG.switchState(new PlayState());
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
FlxG.sound.playMusic(Paths.music('yoursilentaudio'), 0);
video.playVideo(Paths.video('yourvideonamehere'), null, sprite); // make the transition null so it doesn't take you out of this state

add(sprite);
```


# Credits

- [PolybiusProxy](https://github.com/polybiusproxy) - Creator of hxCodec.
- [datee](https://github.com/datee) - Creator of HaxeVLC.
- [BrightFyre](https://github.com/brightfyregit) - Creator of repository.
- [GWebDev](https://github.com/GrowtopiaFli) - Inspiring me to do this.
- [CryBit](https://github.com/CryBitDev) - fixing my shit lolololoolol
- The contributors.
