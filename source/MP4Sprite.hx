package;

import flixel.FlxSprite;

class MP4Sprite extends FlxSprite
{
	public var readyCallback:Void->Void;
	public var finishCallback:Void->Void;

	var video:MP4Handler;

	public function new(x:Float, y:Float, path:String, ?repeat:Bool = false)
	{
		super(x, y);

		video = new MP4Handler(path, repeat);
		video.alpha = 0;

		video.readyCallback = function()
		{
			loadGraphic(video.bitmapData);

			if (readyCallback != null)
				readyCallback();
		}

		video.finishCallback = function()
		{
			if (finishCallback != null)
				finishCallback();

			destroy();
		};
	}

	public function pauseVideo()
	{
		video.pause();
	}

	public function resumeVideo()
	{
		video.resume();
	}
}
