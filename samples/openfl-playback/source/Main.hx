package;

import openfl.display.Sprite;
import hxcodec.openfl.VideoSprite;

class Main extends Sprite
{
	public function new():Void
	{
		super();

		var video:VideoSprite = new VideoSprite();
		video.bitmap.onEndReached.add(video.dispose);
		video.play('assets/video.mp4');
		addChild(video);
	}
}
