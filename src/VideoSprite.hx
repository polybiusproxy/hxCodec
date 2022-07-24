package;

import flixel.FlxSprite;

class VideoSprite extends FlxSprite
{
	public var readyCallback:Void->Void = null;
	public var finishCallback:Void->Void = null;

	public var bitmap:VideoHandler;

	public function new(X:Float = 0, Y:Float = 0)
	{
		super(X, Y);

		bitmap = new VideoHandler();
		bitmap.visible = false;

		bitmap.readyCallback = function()
		{
			loadGraphic(bitmap.bitmapData);

			if (readyCallback != null)
				readyCallback();
		}

		bitmap.finishCallback = function()
		{
			if (finishCallback != null)
				finishCallback();

			kill();
		};
	}

	/**
	 * Native video support for Flixel & OpenFL
	 * @param Path Example: `your/video/here.mp4`
	 * @param Loop Loop the video.
	 * @param Haccelerated if you want the hardware to accelerated for the video.
	 * @param PauseMusic Pause music until done video.
	 */
	public function playVideo(Path:String, Loop:Bool = false, Haccelerated:Bool = true, PauseMusic:Bool = false):Void
	{
		bitmap.playVideo(Path, Loop, Haccelerated, PauseMusic);
	}
}
