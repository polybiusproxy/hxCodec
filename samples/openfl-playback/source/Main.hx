package;

import openfl.display.Sprite;
import openfl.events.Event;
import hxcodec.openfl.Video;

class Main extends Sprite
{
	private var video:Video;

	public function new():Void
	{
		super();

		video = new Video();
		video.onEndReached.add(video.dispose);
		addChild(video);

		video.play(Sys.getCwd() + 'assets/video.mp4');

		stage.addEventListener(Event.ENTER_FRAME, stage_onEnterFrame);
		stage.addEventListener(Event.ACTIVATE, stage_onActivate);
		stage.addEventListener(Event.DEACTIVATE, stage_onDeactivate);
	}

	private function stage_onEnterFrame(event:Event):Void
	{
		var aspectRatio:Float = video.videoWidth / video.videoHeight;

		if (stage.stageWidth / stage.stageHeight > aspectRatio)
		{
			// stage is wider than video
			video.width = stage.stageHeight * aspectRatio;
			video.height = stage.stageHeight;
		}
		else
		{
			// stage is taller than video
			video.width = stage.stageWidth;
			video.height = stage.stageWidth * (1 / aspectRatio);
		}

		video.x = (stage.stageWidth - video.width) / 2;
		video.y = (stage.stageHeight - video.height) / 2;
	}

	private function stage_onActivate(event:Event):Void
	{
		video.resume();
	}

	private function stage_onDeactivate(event:Event):Void
	{
		video.pause();
	}
}
