package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import openfl.display.BitmapData;

/**
 * This class allows you to play videos using sprites (FlxSprite).
 */
class VideoSprite extends FlxSprite
{
	public var bitmap:VideoHandler;
	public var readyCallback:Void->Void = null;
	public var finishCallback:Void->Void = null;

	private var startDrawing:Bool = false;

	public function new(X:Float = 0, Y:Float = 0)
	{
		super(X, Y);

		bitmap = new VideoHandler();
		bitmap.visible = false;
		bitmap.readyCallback = function()
		{
			makeGraphic(getBitmapDataFromTexture().width, getBitmapDataFromTexture().height, FlxColor.TRANSPARENT);

			startDrawing = true;

			if (readyCallback != null)
				readyCallback();
		}
		bitmap.finishCallback = function()
		{
			if (finishCallback != null)
				finishCallback();

			kill();
		}
	}

	/**
	 * Native video support for Flixel & OpenFL
	 * @param Path Example: `your/video/here.mp4`
	 * @param Loop Loop the video.
	 * @param Haccelerated if you want the video to be hardware accelerated.
	 * @param PauseMusic Pause music until the video ends.
	 */
	public function playVideo(Path:String, Loop:Bool = false, Haccelerated:Bool = true, PauseMusic:Bool = false):Void
	{
		bitmap.playVideo(Path, Loop, Haccelerated, PauseMusic);
	}

	private var frameCount:Float = 0;
	override function update(elapsed:Float):Void
	{
		if (startDrawing && bitmap.isPlaying)
		{
			frameCount += elapsed;
			if (frameCount >= 1 / bitmap.getVideoFPS())
			{
				pixels.draw(getBitmapDataFromTexture()); // im not sure how good the performance will be but ok
				frameCount = 0;
			}
		}
	}

	private function getBitmapDataFromTexture():BitmapData
	{
		@:privateAccess
		return BitmapData.fromTexture(bitmap.texture);
	}
}
