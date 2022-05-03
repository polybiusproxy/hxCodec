package vlc.lib;

#if cpp
import cpp.Pointer;
import cpp.UInt8;
#end

/**
 * ...
 * @author Tommy S
 */
//
@:buildXml('<include name="${haxelib:hxCodec}/vlc/lib/LibVLCBuild.xml" />')
@:include("LibVLC.h")
@:unreflective
@:keep
@:native("LibVLC*")
extern class LibVLC {
	@:native("LibVLC::create")
	public static function create():LibVLC;

	@:native("LibVLC::setPath")
	public function setPath(path:String):Void;

	@:native("LibVLC::openMedia")
	public function openMedia(path:String):Void;

	@:native("LibVLC::play")
	@:overload(function():Void {})
	public function play(path:String):Void;

	@:native("LibVLC::playInWindow")
	@:overload(function():Void {})
	public function playInWindow(path:String):Void;

	@:native("LibVLC::stop")
	public function stop():Void;

	@:native("LibVLC::pause")
	public function pause():Void;

	@:native("LibVLC::resume")
	public function resume():Void;

	@:native("LibVLC::togglePause")
	public function togglePause():Void;

	@:native("LibVLC::fullscreen")
	public function setWindowFullscreen(fullscreen:Bool):Void;

	@:native("LibVLC::showMainWindow")
	public function showMainWindow(show:Bool):Void;

	@:native("LibVLC::getLength")
	public function getLength():Float;

	@:native("LibVLC::getDuration")
	public function getDuration():Float;

	@:native("LibVLC::getWidth")
	public function getWidth():Int;

	@:native("LibVLC::getHeight")
	public function getHeight():Int;

	@:native("LibVLC::getMeta")
	public function getMeta(meta:Dynamic):String;

	@:native("LibVLC::isPlaying")
	public function isPlaying():Bool;

	@:native("LibVLC::isSeekable")
	public function isSeekable():Bool;

	@:native("LibVLC::setVolume")
	public function setVolume(volume:Float):Void;

	@:native("LibVLC::getVolume")
	public function getVolume():Float;

	@:native("LibVLC::getTime")
	public function getTime():Int;

	@:native("LibVLC::setTime")
	public function setTime(time:Int):Void;

	@:native("LibVLC::getPosition")
	public function getPosition():Float;

	@:native("LibVLC::setPosition")
	public function setPosition(pos:Float):Void;

	@:native("LibVLC::useHWacceleration")
	public function useHWacceleration(hwAcc:Bool):Void;

	@:native("LibVLC::getLastError")
	public function getLastError():String;

	@:native("LibVLC::getRepeat")
	public function getRepeat():Int;

	@:native("LibVLC::setRepeat")
	public function setRepeat(repeat:Int = 1):Void;

	#if cpp
	@:native("LibVLC::getPixelData")
	public function getPixelData():Pointer<UInt8>;
	#end

	@:native("LibVLC::getFPS")
	public function getFPS():Float;

	@:native("LibVLC::flags")
	public var flags:Array<Int>;
}
