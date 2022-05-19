package vlc;

import flixel.FlxSprite;
import vlc.VideoHandler;

/**
 * This class will play the video in the form of a FlxSprite, which you can control.
 */
class VideoSprite extends FlxSprite {
	/////////////////////////////////////////////////////////////////////////////////////

	public var bitmap:VideoHandler;

	public var readyCallback:Void->Void;
	public var finishCallback:Void->Void;

	public function new(x:Float = 0, y:Float = 0, width:Float = 320, height:Float = 240, autoResize:Bool = true, smooting:Bool = true) {
		super(x, y);

		bitmap = new VideoHandler(width, height, autoResize, smooting);
		bitmap.alpha = 0;
		bitmap.canSkip = false;

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

	/////////////////////////////////////////////////////////////////////////////////////

	/**
	 * Native video support for Flixel & OpenFL
	 * @param path Example: `your/video/here.mp4`
	 * @param repeat Repeat the video.
	 * @param pauseMusic Pause music until done video.
	 */
	public function playVideo(path:String, repeat:Bool = false, pauseMusic:Bool = false) {
		bitmap.playVideo(path, repeat, pauseMusic);
	}

	/////////////////////////////////////////////////////////////////////////////////////
}
