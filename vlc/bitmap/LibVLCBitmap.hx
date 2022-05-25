package vlc.bitmap;

import flixel.FlxG;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.geom.Rectangle;
import vlc.lib.LibVLC;

/**
 * @Original Author: Tommy S
 */

@:cppFileCode('#include "LibVLC.cpp"')
class LibVLCBitmap extends Bitmap {
	//////////////////////////////////////////////////////////////////////////////////////
	//====================================================================================
	// Consts && Properties
	//------------------------------------------------------------------------------------
	public var initComplete:Bool;
	public var repeat:Int = 0;
	public var volume(default, set):Float = 0;
	public var isDisposed:Bool;
	public var isPlaying:Bool;
	public var time:Int;
	public var oldTime:Int;
	public var onReady:Void->Void;
	public var onPlay:Void->Void;
	public var onStop:Void->Void;
	public var onPause:Void->Void;
	public var onResume:Void->Void;
	public var onBuffer:Void->Void;
	public var onOpening:Void->Void;
	public var onComplete:Void->Void;
	public var onError:String->Void;
	public var onTimeChanged:Int->Void;
	public var onPositionChanged:Int->Void;
	public var onSeekableChanged:Int->Void;
	public var onForward:Void->Void;
	public var onBackward:Void->Void;

	//====================================================================================
	// Declarations && Variables
	//------------------------------------------------------------------------------------
	var _width:Float;
	var _height:Float;
	var libvlc:LibVLC;
	var bufferMem:Array<cpp.UInt8>;
	var frameSize:Int;
	var frameRect:Rectangle;
	var bitmapAutoResize:Bool = true;

	/////////////////////////////////////////////////////////////////////////////////////

	public function new(width:Float = 320, height:Float = 240, autoResize:Bool = true, smooting:Bool = true) {
		super(null, null, smooting);

		bitmapAutoResize = autoResize;

		if (bitmapAutoResize) {
			calc("Height");
			calc("Width");
		} else {
			set_height(height);
			set_width(width);
		}

		init();
	}

	/////////////////////////////////////////////////////////////////////////////////////

	function init():Void {
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	function onAddedToStage(e:Event):Void {
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		libvlc = LibVLC.create();

		if (bitmapAutoResize)
			stage.addEventListener(Event.RESIZE, onResize);

		stage.addEventListener(Event.ENTER_FRAME, onLoop);
	}

	function calc(action:String):Void {
		var stageWidth:Float = Lib.current.stage.stageWidth;
		var stageHeight:Float = Lib.current.stage.stageHeight;
		var width:Float = FlxG.width;
		var height:Float = FlxG.height;
		var ratioX:Float = height / width;
		var ratioY:Float = width / height;
		var appliedWidth:Float = stageHeight * ratioY;
		var appliedHeight:Float = stageWidth * ratioX;
		
		if (appliedHeight > stageHeight) {
			appliedHeight = stageHeight;
		}
		
		if (appliedWidth > stageWidth) {
			appliedWidth = stageWidth;
		}
		
		return switch(action) {
			case "Height":
				set_height(appliedHeight);
				#if HXC_DEBUG_TRACE
				trace(appliedHeight);
				#end
			case "Width":
				set_width(appliedWidth);
				#if HXC_DEBUG_TRACE
				trace(appliedWidth);
				#end
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////

	public function play(?source:String) {
		if (libvlc != null) {
			if (source != null) {
				libvlc.setRepeat(repeat);
				libvlc.play(source);
			}
			else
				libvlc.play();
		}
	}

	public function stop() {
		if (libvlc != null && initComplete) {
			isPlaying = false;
			libvlc.stop();
		}
	}

	public function togglePause():Void {
		if (libvlc != null && initComplete) {
			if (isPlaying) {
				isPlaying = false;
				libvlc.togglePause();

				if (onPause != null)
					onPause();
			} else {
				isPlaying = true;
				libvlc.togglePause();

				if (onResume != null)
					onResume();
			}
		}
	}

	public function seek(seekTotime:Float) {
		if (libvlc != null && initComplete) {
			libvlc.setPosition(seekTotime);

			#if HXC_DEBUG_TRACE
			trace("new position: " + seekTotime);
			#end
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////

	private function checkFlags() {
		if (!isDisposed) {
			if (untyped __cpp__('libvlc->flags[1]') == 1) {
				untyped __cpp__('libvlc->flags[1] = -1');
				statusOnPlaying();
			}
			if (untyped __cpp__('libvlc->flags[2]') == 1) {
				untyped __cpp__('libvlc->flags[2] = -1');
				statusOnStopped();				
			}
			if (untyped __cpp__('libvlc->flags[3]') == 1) {
				untyped __cpp__('libvlc->flags[3] = -1');
				statusOnEndReached();
			}
			if (untyped __cpp__('libvlc->flags[4]') != -1) {
				var newtime:Int = untyped __cpp__('libvlc->flags[4]');
				statusOnTimeChanged(newtime);
			}
			if (untyped __cpp__('libvlc->flags[5]') != -1) {
				var newPos:Int = untyped __cpp__('libvlc->flags[5]');
				statusOnPositionChanged(newPos);
			}
			if (untyped __cpp__('libvlc->flags[6]') != -1) {
				var newPos:Int = untyped __cpp__('libvlc->flags[6]');
				statusOnSeekableChanged(newPos);
			}
			if (untyped __cpp__('libvlc->flags[7]') == 1) { 
				untyped __cpp__('libvlc->flags[7] = -1');
				statusOnError();
			}
			if (untyped __cpp__('libvlc->flags[8]') == 1) {
				untyped __cpp__('libvlc->flags[8] = -1');
				statusOnOpening(); 				
			}
			if (untyped __cpp__('libvlc->flags[9]') == 1) {
				untyped __cpp__('libvlc->flags[9] = -1');
				statusOnBuffering();
			}
			if (untyped __cpp__('libvlc->flags[10]') == 1) {
				untyped __cpp__('libvlc->flags[10] = -1');
				statusOnForward();
			}
			if (untyped __cpp__('libvlc->flags[11]') == 1) {
				untyped __cpp__('libvlc->flags[11] = -1');
				statusOnBackward();	
			}
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////

	private function finishInit():Void {
		#if HXC_DEBUG_TRACE
		trace("the video is starting");
		#end

		var videoWidth:Int = libvlc.getWidth();
		var videoHeight:Int = libvlc.getHeight();

		bitmapData = new BitmapData(videoWidth, videoHeight);
		frameRect = new Rectangle(0, 0, videoWidth, videoHeight);

		bufferMem = [];
		frameSize = (videoWidth * videoHeight) * 4;

		initComplete = true;

		if (onReady != null)
			onReady();
	}

	/////////////////////////////////////////////////////////////////////////////////////

	private function onLoop(e:Event):Void {
		width = _width;
		height = _height;

		checkFlags();
		render();
	}

	private function onResize(e:Event):Void {
		calc("Height");
		calc("Width");
	}

	/////////////////////////////////////////////////////////////////////////////////////

	private function render() {
		var cTime = Lib.getTimer();
		// min 8.3 ms between renders, but this is not a good way to do it...
		if ((cTime - oldTime) > 8.3) {
			oldTime = cTime;

			if (initComplete && isPlaying && bitmapData != null && frameRect != null) {
				try {
					#if HXC_DEBUG_TRACE
					trace("rendering...");
					#end

					if (libvlc.getPixelData() != null)
						cpp.NativeArray.setUnmanagedData(bufferMem, libvlc.getPixelData(), frameSize);

					if (libvlc.getPixelData() != null && bufferMem != null)
						bitmapData.setPixels(frameRect, haxe.io.Bytes.ofData(bufferMem));
				} catch (e:Error) {
					throw new Error("render error: " + e);
				}
			}
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////

	public function setVolume(vol:Float)
	{
		if (libvlc != null && initComplete) {
			libvlc.setVolume(vol * 100);

			#if HXC_DEBUG_TRACE
			trace("new volume: " + vol * 100);
			#end
		}
	}

	public function getVolume():Float
	{
		if (libvlc != null && initComplete) {
			return libvlc.getVolume();

			#if HXC_DEBUG_TRACE
			trace("the volume is: " + libvlc.getVolume());
			#end
		}
		else
			return 0;
	}

	public function setTime(time:Int)
	{
		if (libvlc != null && initComplete) {
			libvlc.setTime(time);

			#if HXC_DEBUG_TRACE
			trace("the new time is: " + time);
			#end
		}
	}

	public function getTime():Int
	{
		if (libvlc != null && initComplete) {
			return libvlc.getTime();

			#if HXC_DEBUG_TRACE
			trace(libvlc.getTime());
			#end
		}
		else
			return 0;
	}

	/////////////////////////////////////////////////////////////////////////////////////

	public function getDuration():Float
	{
		if (libvlc != null && initComplete) {
			return libvlc.getDuration();

			#if HXC_DEBUG_TRACE
			trace("the duration is: " + libvlc.getDuration());
			#end
		}
		else
			return 0;
	}

	public function getLength():Float {
		if (libvlc != null && initComplete) {
			return libvlc.getLength();

			#if HXC_DEBUG_TRACE
			trace("the length is: " + libvlc.getLength());
			#end
		}
		else
			return 0;
	}

	/////////////////////////////////////////////////////////////////////////////////////

	private function statusOnPlaying():Void {
		if (!isPlaying) {
			setVolume(volume);
			isPlaying = true;
		}

		#if HXC_DEBUG_TRACE
		trace("the video is playing");
		#end

		if (onPlay != null)
			onPlay();
	}

	private function statusOnStopped():Void {
		if (isPlaying)
			isPlaying = false;

		#if HXC_DEBUG_TRACE
		trace("the video stopped");
		#end

		if (onStop != null)
			onStop();
	}

	private function statusOnEndReached():Void {
		if (isPlaying)
			isPlaying = false;

		#if HXC_DEBUG_TRACE
		trace("video finished!");
		#end

		if (onComplete != null)
			onComplete();
	}

	private function statusOnTimeChanged(newTime:Int):Void {
		time = newTime;

		#if HXC_DEBUG_TRACE
		trace("new Time: " + newTime);
		#end

		if (onTimeChanged != null)
			onTimeChanged(newTime);
	}

	private function statusOnPositionChanged(newPos:Int):Void {
		#if HXC_DEBUG_TRACE
		trace("new Pos: " + newPos);
		#end

		if (onPositionChanged != null)
			onPositionChanged(newPos);
	}

	private function statusOnSeekableChanged(newPos:Int):Void {
		#if HXC_DEBUG_TRACE
		trace("new Seeked Pos: " + newPos);
		#end

		if (onSeekableChanged != null)
			onSeekableChanged(newPos);
	}

	private function statusOnError():Void {
		if (onError != null)
			onError(libvlc.getLastError());
	}

	private function statusOnOpening():Void {
		#if HXC_DEBUG_TRACE
		trace("the video is opening");
		#end

		if (!initComplete) {
			finishInit();
		}

		if (onOpening != null)
			onOpening();
	}

	private function statusOnBuffering():Void {
		#if HXC_DEBUG_TRACE
		trace("buffering");
		#end

		if (onBuffer != null)
			onBuffer();
	}

	private function statusOnForward():Void {
		#if HXC_DEBUG_TRACE
		trace("forwarding");
		#end

		if (onForward != null)
			onForward();
	}

	private function statusOnBackward():Void {
		#if HXC_DEBUG_TRACE
		trace("backwording");
		#end

		if (onBackward != null)
			onBackward();
	}

	/////////////////////////////////////////////////////////////////////////////////////

	private override function get_width():Float {
		#if HXC_DEBUG_TRACE
		trace(_width);
		#end

		return _width;
	}

	public override function set_width(value:Float):Float {
		_width = value;

		#if HXC_DEBUG_TRACE
		trace("new width is " + value);
		#end

		return super.set_width(value);
	}

	private override function get_height():Float {
		#if HXC_DEBUG_TRACE
		trace(_height);
		#end

		return _height;
	}

	public override function set_height(value:Float):Float {
		_height = value;

		#if HXC_DEBUG_TRACE
		trace("new height is " + value);
		#end

		return super.set_height(value);
	}

	function get_volume():Float {
		#if HXC_DEBUG_TRACE
		trace("the volume is " + volume);
		#end

		return volume;
	}

	function set_volume(value:Float):Float {
		#if HXC_DEBUG_TRACE
		trace("the new volume is " + value);
		#end

		setVolume(value);
		return volume = value;
	}

	//====================================================================================
	// Dispose
	//------------------------------------------------------------------------------------
	public function dispose() {
		#if HXC_DEBUG_TRACE
		trace("disposing the whole thing lol");
		#end

		libvlc.stop();
		libvlc.release();

		if (bitmapData != null)
			bitmapData.dispose();

		frameRect = null;

		if (bitmapAutoResize)
			stage.removeEventListener(Event.RESIZE, onResize);

		stage.removeEventListener(Event.ENTER_FRAME, onLoop);

		onReady = null;
		onComplete = null;
		onPause = null;
		onPlay = null;
		onResume = null;
		onStop = null;
		onBuffer = null;
		onTimeChanged = null;
		onPositionChanged = null;
		onSeekableChanged = null;
		onForward = null;
		onBackward = null;
		onError = null;

		bufferMem = null;
		isDisposed = true;
	}

	/////////////////////////////////////////////////////////////////////////////////////
}
