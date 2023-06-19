package;

import lime.app.Application;
import hxcodec.lime.MediaPlayer;

class Main extends Application
{
	public function new():Void
	{
		super();

		var player:MediaPlayer = new MediaPlayer();
		player.onEndReached.add(player.dispose);
		player.play(Sys.getCwd() + 'assets/video.mp4');

		onUpdate.add(player.update);
	}
}
