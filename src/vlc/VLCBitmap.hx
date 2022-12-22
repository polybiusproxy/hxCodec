package vlc;

#if !(desktop || android)
#error "The current target platform isn't supported by hxCodec. If you're targeting Windows/Mac/Linux/Android and getting this message, please contact us.";
#end
import cpp.NativeArray;
import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.Path;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display3D.textures.RectangleTexture;
import openfl.events.Event;
import vlc.LibVLC;

/**
 * ...
 * @author Datee
 *
 * This class lets you to use LibVLC as a bitmap then you can displaylist along other items.
 */
@:cppFileCode("#include <LibVLC.cpp>")
class VLCBitmap extends Bitmap
{
	public var videoFPS:Int = 60;
	public var videoHeight(get, never):Int;
	public var videoWidth(get, never):Int;
	public var volume(default, set):Float;
	public var initComplete:Bool = false;
	public var onReady:Void->Void = null;
	public var onPlay:Void->Void = null;
	public var onStop:Void->Void = null;
	public var onPause:Void->Void = null;
	public var onResume:Void->Void = null;
	public var onBuffer:Void->Void = null;
	public var onOpening:Void->Void = null;
	public var onComplete:Void->Void = null;
	public var onError:String->Void = null;
	public var onTimeChanged:Int->Void = null;
	public var onPositionChanged:Int->Void = null;
	public var onSeekableChanged:Int->Void = null;
	public var onForward:Void->Void = null;
	public var onBackward:Void->Void = null;

	private var libvlc:LibVLC;
	private var pixels:BytesData;
	private var texture:RectangleTexture;

	private var _width:Null<Float>;
	private var _height:Null<Float>;

	public function new(?smoothing:Bool = false):Void
	{
		super(bitmapData, AUTO, smoothing);

		if (libvlc == null)
			libvlc = LibVLC.create();

		if (stage != null)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	/**
		Play's the video file you put if the the path isn't null.

		@param location The video of the video.
		@param loop If you want to loop the video.
		@param haccelerated If you want to have hardware acceleration enabled for vlc.
	**/
	public function play(?location:String = null, loop:Bool = false, haccelerated:Bool = true):Void
	{
		if (libvlc != null && location != null)
		{
			final path:String = Path.normalize(location);

			#if HXC_DEBUG_TRACE
			trace("setting path to: " + path);
			#end

			if (libvlc.isPlaying())
				libvlc.stop();

			libvlc.play(path, loop, haccelerated);
		}
		else if (libvlc != null && libvlc.isMediaPlayerAlive())
			libvlc.play();
	}

	/**
		Stop the video.
	**/
	public function stop():Void
	{
		if (libvlc != null && libvlc.isMediaPlayerAlive())
			libvlc.stop();
	}

	/**
		Pause the video.
	**/
	public function pause():Void
	{
		if (libvlc != null && libvlc.isMediaPlayerAlive())
		{
			libvlc.pause();

			if (onPause != null)
				onPause();
		}
	}

	/**
		Resume the video.
	**/
	public function resume():Void
	{
		if (libvlc != null && libvlc.isMediaPlayerAlive())
		{
			libvlc.resume();

			if (onResume != null)
				onResume();
		}
	}

	/**
		Pause / Resume the video.
	**/
	public function togglePause():Void
	{
		if (libvlc != null && libvlc.isMediaPlayerAlive())
			libvlc.togglePause();
	}

	/**
		Seeking the procent of the video.

		@param seekProcent The procent you want to seek the video.
	**/
	public function seek(seekProcent:Float):Void
	{
		if (libvlc != null && (libvlc.isMediaPlayerAlive() && libvlc.isSeekable()))
			libvlc.setPosition(seekProcent);
	}

	/**
		Setting the time of the video.

		@param time The video time you want to set.
	**/
	public function setTime(time:Int):Void
	{
		if (libvlc != null && libvlc.isMediaPlayerAlive())
			libvlc.setTime(time);
	}

	/**
		Returns the time of the video.
	**/
	public function getTime():Int
	{
		if (libvlc != null && libvlc.isMediaPlayerAlive())
			return libvlc.getTime();
		else
			return 0;
	}

	/**
		Setting the volume of the video.

		@param vol The video volume you want to set.
	**/
	public function setVolume(vol:Float):Void
	{
		if (libvlc != null && libvlc.isMediaPlayerAlive())
			libvlc.setVolume(vol);
	}

	/**
		Returns the volume of the video.
	**/
	public function getVolume():Float
	{
		if (libvlc != null && libvlc.isMediaPlayerAlive())
			return libvlc.getVolume();
		else
			return 0;
	}

	/**
		Sets the FPS of the video.

		@param fps The video FPS you want to set.
	**/
	public function setVideoFPS(fps:Int):Void
	{
		videoFPS = fps;
	}

	/**
		Returns the FPS of the video.
	**/
	public function getVideoFPS():Int
	{
		return videoFPS;
	}

	/**
		Returns the duration of the video.
	**/
	public function getDuration():Float
	{
		if (libvlc != null && libvlc.isMediaItemAlive())
			return libvlc.getDuration();
		else
			return 0;
	}

	/**
		Returns the frames per second of the video.
	**/
	public function getFPS():Float
	{
		if (libvlc != null && libvlc.isMediaPlayerAlive())
			return libvlc.getFPS();
		else
			return 0;
	}

	/**
		Returns the length of the video.
	**/
	public function getLength():Float
	{
		if (libvlc != null && libvlc.isMediaPlayerAlive())
			return libvlc.getLength();
		else
			return 0;
	}

	private function checkFlags():Void
	{
		if (untyped __cpp__('libvlc -> flags[0]') == 1)
		{
			untyped __cpp__('libvlc -> flags[0] = -1');
			if (onPlay != null)
				onPlay();
		}

		if (untyped __cpp__('libvlc -> flags[1]') == 1)
		{
			untyped __cpp__('libvlc -> flags[1] = -1');
			if (onStop != null)
				onStop();
		}

		if (untyped __cpp__('libvlc -> flags[2]') == 1)
		{
			untyped __cpp__('libvlc -> flags[2] = -1');

			#if HXC_DEBUG_TRACE
			trace("the video got done!");
			#end

			if (onComplete != null)
				onComplete();
		}

		if (untyped __cpp__('libvlc -> flags[3]') != -1)
		{
			var newTime:Int = untyped __cpp__('libvlc -> flags[3]');

			#if HXC_DEBUG_TRACE
			trace("the time of the video now is: " + newTime);
			#end

			if (onTimeChanged != null)
				onTimeChanged(newTime);
		}

		if (untyped __cpp__('libvlc -> flags[4]') != -1)
		{
			var newPos:Int = untyped __cpp__('libvlc -> flags[4]');

			#if HXC_DEBUG_TRACE
			trace("the position of the video now is: " + newPos);
			#end

			if (onPositionChanged != null)
				onPositionChanged(newPos);
		}

		if (untyped __cpp__('libvlc -> flags[5]') != -1)
		{
			var newPos:Int = untyped __cpp__('libvlc -> flags[5]');

			#if HXC_DEBUG_TRACE
			trace("the seeked pos of the video now is: " + newPos);
			#end

			if (onSeekableChanged != null)
				onSeekableChanged(newPos);
		}

		if (untyped __cpp__('libvlc -> flags[6]') == 1)
		{
			untyped __cpp__('libvlc -> flags[6] = -1');
			if (onError != null)
				onError(libvlc.getLastError());
		}

		if (untyped __cpp__('libvlc -> flags[7]') == 1)
		{
			untyped __cpp__('libvlc -> flags[7] = -1');

			if (!initComplete)
				videoInitComplete();

			if (onOpening != null)
				onOpening();
		}

		if (untyped __cpp__('libvlc -> flags[8]') == 1)
		{
			untyped __cpp__('libvlc -> flags[8] = -1');
			if (onBuffer != null)
				onBuffer();
		}

		if (untyped __cpp__('libvlc -> flags[9]') == 1)
		{
			untyped __cpp__('libvlc -> flags[9] = -1');
			if (onForward != null)
				onForward();
		}

		if (untyped __cpp__('libvlc -> flags[10]') == 1)
		{
			untyped __cpp__('libvlc -> flags[10] = -1');
			if (onBackward != null)
				onBackward();
		}
	}

	private function videoInitComplete():Void
	{
		if (texture != null)
			texture.dispose();

		texture = Lib.current.stage.context3D.createRectangleTexture(libvlc.getWidth(), libvlc.getHeight(), BGRA, true);

		if (bitmapData != null)
			bitmapData.dispose();

		bitmapData = BitmapData.fromTexture(texture);

		if (pixels == null || (pixels != null && pixels.length > 0))
			pixels = [];

		if (_width != null)
			width = _width;
		else
			width = libvlc.getWidth();

		if (_height != null)
			height = _height;
		else
			height = libvlc.getHeight();

		initComplete = true;

		if (onReady != null)
			onReady();

		#if HXC_DEBUG_TRACE
		trace("video loaded!");
		#end
	}

	private function init(?e:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, init);

		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private var currentTime:Float = 0;
	private function onEnterFrame(?e:Event):Void
	{
		checkFlags();

		// libvlc.getPixelData() sometimes is null and the app hangs ...
		if ((libvlc.isPlaying() && initComplete) && libvlc.getPixelData() != null)
		{
			var time:Int = Lib.getTimer();
			var elements:Int = libvlc.getWidth() * libvlc.getHeight() * 4;
			renderToTexture(time - currentTime, elements);
		}
	}

	private function renderToTexture(deltaTime:Float, elementsCount:Int):Void
	{
		if (deltaTime > (1000 / videoFPS))
		{
			currentTime = deltaTime;

			#if HXC_DEBUG_TRACE
			trace("rendering...");
			#end

			NativeArray.setUnmanagedData(pixels, libvlc.getPixelData(), elementsCount);

			if (texture != null && (pixels != null && pixels.length > 0))
			{
				var bytes:Bytes = Bytes.ofData(pixels);
				if (bytes.length >= elementsCount)
				{
					texture.uploadFromByteArray(bytes, 0);
					width++;
					width--;
				}
			}
		}
	}

	/**
		Dispose the whole bitmap.
	**/
	public function dispose():Void
	{
		#if HXC_DEBUG_TRACE
		trace("disposing the bitmap!");
		#end

		if (libvlc.isPlaying())
			libvlc.stop();

		if (stage.hasEventListener(Event.ENTER_FRAME))
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);

		if (texture != null)
		{
			texture.dispose();
			texture = null;
		}

		if (bitmapData != null)
		{
			bitmapData.dispose();
			bitmapData = null;
		}

		if (pixels != null && pixels.length > 0)
			pixels = [];

		initComplete = false;

		onReady = null;
		onComplete = null;
		onPause = null;
		onOpening = null;
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

		#if HXC_DEBUG_TRACE
		trace("disposing done!");
		#end
	}

	@:noCompletion private function get_videoHeight():Int
	{
		if (libvlc != null && libvlc.isMediaPlayerAlive())
			return libvlc.getHeight();

		return 0;
	}

	@:noCompletion private function get_videoWidth():Int
	{
		if (libvlc != null && libvlc.isMediaPlayerAlive())
			return libvlc.getWidth();

		return 0;
	}

	private override function get_width():Float
	{
		return _width;
	}

	private override function set_width(value:Float):Float
	{
		_width = value;
		return super.set_width(value);
	}

	private override function get_height():Float
	{
		return _height;
	}

	private override function set_height(value:Float):Float
	{
		_height = value;
		return super.set_height(value);
	}

	private function set_volume(value:Float):Float
	{
		setVolume(value);
		return volume = value;
	}
}
