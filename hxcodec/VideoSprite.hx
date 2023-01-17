package hxcodec;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import hxcodec.VideoHandler;

/**
 * This class allows you to play videos using sprites (FlxSprite).
 */
class VideoSprite extends FlxSprite
{
	public var bitmap:VideoHandler;
	public var canvasWidth:Null<Int>;
	public var canvasHeight:Null<Int>;

	public var openingCallback:Void->Void = null;
	public var graphicLoadedCallback:Void->Void = null;
	public var finishCallback:Void->Void = null;

	public function new(X:Float = 0, Y:Float = 0)
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
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (bitmap.isPlaying && bitmap.isDisplaying && bitmap.bitmapData != null && !oneTime)
		{
			var graphic:FlxGraphic = FlxG.bitmap.add(bitmap.bitmapData, false, bitmap.mrl);
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

	/**
	 * Native video support for Flixel & OpenFL
	 * @param Path Example: `your/video/here.mp4`
	 * @param Loop Loop the video.
	 * @param PauseMusic Pause music until the video ends.
	 */
	public function playVideo(Path:String, Loop:Bool = false, PauseMusic:Bool = false):Void
		bitmap.playVideo(Path, Loop, PauseMusic);
}
