package;

import lime.app.Application;
import hxcodec.lime.MediaPlayer;

class Main extends Application
{
	private var player:MediaPlayer;

	public function new():Void
	{
		super();

		player = new MediaPlayer();
		player.onEndReached.add(player.dispose);
		player.play(Sys.getCwd() + 'assets/video.mp4');

		onUpdate.add(function(elapsed:Int)
		{
			player.update();
		});
	}
}
