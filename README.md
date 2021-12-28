# hxCodec

*Made by PolybiusProxy.*

Original Repository - `https://github.com/polybiusproxy/PolyEngine`.

[Click here to check the roadmap of hxCodec here](https://github.com/brightfyregit/Friday-Night-Funkin-Mp4-Video-Support/projects/1)
  
### 1. Download the repository:
You can either download it as a ZIP,
or git cloning it.

WIP: You can use `haxelib git hxCodec https://github.com/Jrgamer4u/Friday-Night-Funkin-Mp4-Video-Support`

Might not work with this fork. For now, just use the PolybiusProxy version.

To play a video at the beginning of a week in Story Mode, add the following code in **`StoryMenuState.hx`**:

**Required** For files larger than what GitHub can handle, download the Git Large File Service.

[Download Git Large File Service](https://git-lfs.github.com/)

### wip

replace these lines:

```haxe 
new FlxTimer().start(1, function(tmr:FlxTimer)
{
	LoadingState.loadAndSwitchState(new PlayState(), true);
});
```

with:

```haxe
var isCutscene:Bool = false;
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

```haxe
var isCutscene:Bool = false;

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

# Credits

- [PolybiusProxy](https://github.com/polybiusproxy) - Creator of hxCodec.
- [datee](https://github.com/datee) - Creator of HaxeVLC.
- [BrightFyre](https://github.com/brightfyregit) - Creator of repository.
- [GWebDev](https://github.com/GrowtopiaFli) - Inspiring me to do this.
- [CryBit](https://github.com/CryBitDev) - fixing my shit lolololoolol
- The contributors.
