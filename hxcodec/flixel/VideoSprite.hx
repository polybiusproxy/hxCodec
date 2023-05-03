package hxcodec.flixel;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import hxcodec.VideoHandler;

class VideoSprite extends FlxSprite
{
	public var bitmap:VideoHandler;
	public var canvasWidth:Null<Int>;
	public var canvasHeight:Null<Int>;

	public var openingCallback:Void->Void = null;
	public var graphicLoadedCallback:Void->Void = null;
	public var finishCallback:Void->Void = null;

	public function new(X:Float = 0, Y:Float = 0):Void
	{
		super(X, Y);

		makeGraphic(1, 1, FlxColor.TRANSPARENT);

		bitmap = new VideoHandler();
		bitmap.canUseAutoResize = false;
		bitmap.visible = false;
		bitmap.openingCallback = function()
		{
			if (openingCallback != null)
				openingCallback();
		}
		bitmap.finishCallback = function()
		{
			oneTime = false;

			if (finishCallback != null)
				finishCallback();

			kill();
		}
	}

	private var oneTime:Bool = false;

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if ((bitmap != null && (bitmap.isPlaying && bitmap.bitmapData != null)) && !oneTime)
		{
			var graphic:FlxGraphic = FlxG.bitmap.add(bitmap.bitmapData, false, bitmap.mrl); // mrl usually starts with file:/// but is fine ig
			if (graphic.imageFrame.frame == null)
			{
				#if HXC_DEBUG_TRACE
				trace('the frame of the image is null?');
				#end
				return;
			}

			loadGraphic(graphic);

			if (canvasWidth != null && canvasHeight != null)
			{
				setGraphicSize(canvasWidth, canvasHeight);
				updateHitbox();
			}

			if (graphicLoadedCallback != null)
				graphicLoadedCallback();

			oneTime = true;
		}
	}

	override function destroy():Void
	{
		if (bitmap != null && bitmap.onEndReached != null)
			bitmap.onVLCEndReached();

		super.destroy();
	}

	/**
	 * Native video support for Flixel & OpenFL
	 * @param Path Example: `your/video/here.mp4`
	 * @param Loop Loop the video.
	 * @param PauseMusic Pause music until the video ends if `FLX_SOUND_SYSTEM` is defined.
	 *
	 * @return 0 if playback started (and was already started), or -1 on error.
	 */
	public function playVideo(Path:String, Loop:Bool = false, PauseMusic:Bool = false):Int
		return bitmap.playVideo(Path, Loop, PauseMusic);
}
