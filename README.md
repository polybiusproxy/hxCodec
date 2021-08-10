# PolybiusProxy FNF MP4 Video Code
# How To Setup
  
1. Download the zip of this repository and copy paste the files inside your root project folder
2. Edit `Project.xml`

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