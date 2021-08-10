# PolybiusProxy FNF MP4 Video Code Installation
  
### 1. Download the zip of this repository and copy paste the files inside your root project folder (except for README.md and .gitattributes)
### 2. Edit `Project.xml`

After

```xml
<assets path="assets/week6"    library="week6"    exclude="*.ogg" if="web"/>
<assets path="assets/week6"    library="week6"    exclude="*.mp3" unless="web"/>
```

Put

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
WARNING: IT MUST BE IN 1280x720px.

If you are targeting HTML5, your code will be

```haxe
var video:VideoHandlerMP4 = new VideoHandlerMP4();
video.playWebMP4(Paths.video('nameofyourvideohere'), new PlayState());
```

If you are targeting windows, your code will be

```haxe
var video:VideoHandlerMP4 = new VideoHandlerMP4();
video.playMP4(Paths.video('nameofyourvideohere'), new PlayState(), false, false, false);
```
