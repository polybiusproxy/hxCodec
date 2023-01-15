package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * This class allows you to play videos using sprites (FlxSprite).
 */
class VideoSprite extends FlxSprite
{
	public var bitmap:VideoHandler;
	public var canvasWidth:Null<Int>;
	public var canvasHeight:Null<Int>;

	public var openingCallback:Void->Void = null;
	public var finishCallback:Void->Void = null;

	public function new(X:Float = 0, Y:Float = 0)
	{
		super(X, Y);

		makeGraphic(1, 1, FlxColor.TRANSPARENT);

		bitmap = new VideoHandler();
		bitmap.canUseAutoResize = false;
		bitmap.alpha = 0;
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
			var graph:FlxGraphic = FlxG.bitmap.add(bitmap.bitmapData, false, '');
			if (graph.imageFrame.frame == null)
			{
				trace('imageFrame is null?');
				return;
			}

			sprite.loadGraphic(graph);
			if (canvasWidth != null && canvasHeight != null)
			{
				sprite.setGraphicSize(canvasWidth, canvasHeight);
				sprite.updateHitbox();

				var r = (fillScreen ? Math.max : Math.min)(sprite.scale.x, sprite.scale.y);
				sprite.scale.set(r, r); // lol
			}
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
