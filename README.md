# hxCodec - Native video support for HaxeFlixel/OpenFL
*Made by PolybiusProxy.*

Original Repository - `https://github.com/polybiusproxy/PolyEngine`.

[Click here to check the roadmap of hxCodec here](https://github.com/brightfyregit/Friday-Night-Funkin-Mp4-Video-Support/projects/1)
  
### 1. Download the repository:
You can either download it as a ZIP,
or git cloning it.

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

### 4. Playing videos

Put your video in assets/videos.
**WARNING: IT MUST BE IN 1280x720px.**

To play a video at the beginning of a week in Story Mode, add the following code in `StoryMenuState.hx`:

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
{
    video.playMP4(Paths.video('yourvideonamehere'));
    video.finishCallback = function()
    {
    	LoadingState.loadAndSwitchState(new PlayState());
    }
    
    isCutscene = true;
}
else
{
    new FlxTimer().start(1, function(tmr:FlxTimer)
    {
        if (isCutscene)
            video.onVLCComplete();

        LoadingState.loadAndSwitchState(new PlayState(), true);
    });
}
```

To play a cutscene before another week, replace `curWeek == 0` with the number of the week of your choice (-1, because arrays start from 0).

To play a cutscene after an individual song, place the following code in `PlayState.hx` before the line `prevCamFollow = camFollow;` in the `endSong()` function. You can wrap it in an "if" statement if you'd like to restrict it to a specific song.

```haxe
var video:MP4Handler = new MP4Handler();

video.playMP4(Paths.video('yourvideonamehere'));
video.finishCallback = function()
{
	LoadingState.loadAndSwitchState(new PlayState());
}
```

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

- [PolybiusProxy (me)](https://github.com/polybiusproxy) - Creator of hxCodec.
- [datee]() - Creator of HaxeVLC.
- [BrightFyre](https://github.com/brightfyregit) - Creator of repository.
- [GWebDev](https://github.com/GrowtopiaFli) - Inspiring me to do this.
- [CryBit](https://github.com/CryBitDev) - fixing my shit lolololoolol
- The contributors.
