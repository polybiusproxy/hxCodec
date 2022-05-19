package vlc.lib;

/**
 * @Original Author: Tommy S
 */

@:buildXml('<include name="${haxelib:hxCodec}/vlc/lib/LibVLCBuild.xml" />')
@:include("LibVLC.h")
@:unreflective
@:keep
@:native("LibVLC*")

extern class LibVLC {
	/////////////////////////////////////////////////////////////////////////////////////
	@:native("LibVLC::create")
	public static function create():LibVLC;

	@:native("play")
	@:overload(function():Void {})
	public function play(path:String):Void;

	@:native("stop")
	public function stop():Void;

	@:native("togglePause")
	public function togglePause():Void;

	@:native("release")
	public function release():Void;

	@:native("getLength")
	public function getLength():Float;

	@:native("getDuration")
	public function getDuration():Float;

	@:native("getWidth")
	public function getWidth():Int;

	@:native("getHeight")
	public function getHeight():Int;

	@:native("isPlaying")
	public function isPlaying():Bool;

	@:native("getPixelData")
	public function getPixelData():cpp.Pointer<cpp.UInt8>;

	@:native("setVolume")
	public function setVolume(volume:Float):Void;

	@:native("getVolume")
	public function getVolume():Float;

	@:native("getTime")
	public function getTime():Int;

	@:native("setTime")
	public function setTime(time:Int):Void;

	@:native("getPosition")
	public function getPosition():Float;

	@:native("setPosition")
	public function setPosition(pos:Float):Void;

	@:native("isSeekable")
	public function isSeekable():Bool;

	@:native("setRepeat")
	public function setRepeat(repeat:Int = -1):Void;

	@:native("getRepeat")
	public function getRepeat():Int;

	@:native("getLastError")
	public function getLastError():String;

	@:native("openMedia")
	public function openMedia(path:String):Void;

	@:native("flags")
	public var flags:Array<Int>;
	/////////////////////////////////////////////////////////////////////////////////////
}
