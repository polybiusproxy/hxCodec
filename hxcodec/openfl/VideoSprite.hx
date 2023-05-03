package hxcodec.openfl;

import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import hxcodec.openfl.VideoBitmap;
import sys.FileSystem;

/**
 * This class allows you to play videos using sprites (Sprite).
 */
class VideoSprite extends Sprite
{
	public var bitmap:VideoBitmap;
	public var autoResize:Bool = false;
	public var maintainAspectRatio:Bool = true;

	public var openingCallback:Void->Void = null;
	public var finishCallback:Void->Void = null;

	public function new():Void
	{
		super();

		bitmap = new VideoBitmap();
		bitmap.onOpening = onVLCOpening;
		bitmap.onEndReached = onVLCEndReached;
		bitmap.onEncounteredError = onVLCEncounteredError;
		addChild(bitmap);
	}

	/**
	 * Plays a video.
	 *
	 * @param Path Example: `your/video/here.mp4`
	 * @param Loop Loop the video.
	 *
	 * @return 0 if playback started (and was already started), or -1 on error.
	 */
	public function playVideo(Path:String, Loop:Bool = false):Int
	{
		// stage.addEventListener(Event.ENTER_FRAME, update);

		// in case if you want to use another dir then the application one.
		// android can already do this, it can't use application's storage.
		if (FileSystem.exists(Sys.getCwd() + Path))
			return bitmap.play(Sys.getCwd() + Path, Loop);
		else
			return bitmap.play(Path, Loop);
	}

	// Internal Methods
	private function onVLCOpening():Void
	{
		#if HXC_DEBUG_TRACE
		trace("the video is opening!");
		#end

		if (openingCallback != null)
			openingCallback();
	}

	private function onVLCEncounteredError(msg:String):Void
	{
		Lib.application.window.alert(msg, "VLC Error!");
		onVLCEndReached();
	}

	private function onVLCEndReached():Void
	{
		#if HXC_DEBUG_TRACE
		trace("the video reached the end!");
		#end

		// if (stage.hasEventListener(Event.ENTER_FRAME))
		// stage.removeEventListener(Event.ENTER_FRAME, update);

		bitmap.dispose();

		removeChild(this);

		if (finishCallback != null)
			finishCallback();
	}

	private function update(e:Event):Void
	{
		if (autoResize)
		{
			if (!maintainAspectRatio && (bitmap.videoWidth > 0 && bitmap.videoHeight > 0))
			{
				width = Lib.current.stage.stageWidth;
				height = Lib.current.stage.stageHeight;
			}
			else if (bitmap.videoWidth > 0 && bitmap.videoHeight > 0)
			{
				var aspectRatio:Float = bitmap.videoWidth / bitmap.videoHeight;

				if (Lib.current.stage.stageWidth / Lib.current.stage.stageHeight > aspectRatio)
				{
					// stage is wider than video
					width = Lib.current.stage.stageHeight * aspectRatio;
					height = Lib.current.stage.stageHeight;
				}
				else
				{
					// stage is taller than video
					width = Lib.current.stage.stageWidth;
					height = Lib.current.stage.stageWidth * (1 / aspectRatio);
				}
			}
		}
	}
}
