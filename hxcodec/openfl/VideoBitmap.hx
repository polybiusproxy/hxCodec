package hxcodec.openfl;

import hxcodec.base.IVideoPlayer;
import hxcodec.vlc.VLCBitmap;
import openfl.events.Event;

class VideoBitmap extends VLCBitmap
{
	public function new():Void
	{
		super();

		if (stage != null)
			onAddedToStage();
		else
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	// Internal Methods
	private function onAddedToStage(?e:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
}
