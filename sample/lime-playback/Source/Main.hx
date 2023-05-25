package;

import lime.app.Application;
import hxcodec.lime.VideoPlayer;

class Main extends Application
{
	private var player:VideoPlayer;

	public function new():Void
	{
		super();

		player = new VideoPlayer();
		player.onEndReached.add(player.dispose);
		player.playMedia(Sys.getCwd() + 'assets/video.mp4');

		onUpdate.add(function(elapsed:Int)
		{
			player.update();
		});
	}
}
