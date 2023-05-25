package;

import openfl.events.KeyboardEvent;
import openfl.display.Sprite;
import hxcodec.openfl.VideoSprite;

/**
 * This is a basic example of how to use the VideoSprite class in OpenFL.
 */
class Main extends Sprite
{
	var video:VideoSprite;

	public function new()
	{
		super();

		video = new VideoSprite();
		video.autoResize = true;
		addChild(video);

		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}

	function onKeyDown(event:KeyboardEvent):Void
	{
		trace(event);

		switch (event.keyCode)
		{
			case 81: // Q
				video.play('assets/video.mp4');

			case 65: // A
				video.pause();
			case 83: // S
				video.resume();
			case 68: // D
				video.dispose();
			case 70: // F
				video.bitmap.time -= 5000;
			case 71: // G
				video.bitmap.time += 5000;
			case 72: // H
				video.bitmap.position = 0.0;
			case 74: // J
				video.bitmap.rate = 0.5;
			case 75: // K
				video.bitmap.rate = 1.0;
			case 76: // L
				video.bitmap.rate = 2.0;
		}
	}
}
