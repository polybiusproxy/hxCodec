package;

import hxcodec.lime.VideoPlayer;

class Main extends Application
{
	private var player:VideoPlayer;

	public function new():Void
	{
		super();

		player = new VideoPlayer();
		player.onEndReached.add(player.dispose);
		player.play(Sys.getCwd() + 'assets/video.mp4')

		onUpdate.add(function(elapsed:Int)
		{
			hxcodec.update();
		});
	}
}
