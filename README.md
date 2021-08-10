# PolybiusProxy FNF MP4 Video Code
# How To Setup
  
1. Download the zip of this repository and copy paste the files inside your root project folder
2. Edit `Project.xml`\
\
After
```js	
<assets path="assets/week6"    library="week6"    exclude="*.ogg" if="web"/>
<assets path="assets/week6"    library="week6"    exclude="*.mp3" unless="web"/>
```

Put
```js
<assets path="assets/videos" exclude="*.mp3" if="web"/>
<assets path="assets/videos" exclude="*.ogg" unless="web"/>
```
\
3. Edit `Paths.hx`

You can really put this code wherever

After
```js	
inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
{
	return sound(key + FlxG.random.int(min, max), library);
}
```

Put
```js
inline static public function video(key:String, ?library:String)
{
	trace('assets/videos/$key.mp4');
	return getPath('videos/$key.mp4', BINARY, library);
}
```