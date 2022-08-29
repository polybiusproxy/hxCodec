package;

#if android
import android.net.Uri;
#end
import flixel.FlxG;
import openfl.events.Event;
import lime.app.Application;
import vlc.VLCBitmap;

/**
 * Play a video using cpp.
 * Use bitmap to connect to a graphic or use `VideoSprite`.
 */
class VideoHandler extends VLCBitmap
{
	public var canSkip:Bool = true;
	public var canUseSound:Bool = true;
	public var canUseAutoResize:Bool = true;
	public var readyCallback:Void->Void = null;
	public var finishCallback:Void->Void = null;

	private var pauseMusic:Bool = false;

	public function new()
	{
		super();

		onReady = onVLCReady;
		onComplete = onVLCComplete;
		onError = onVLCError;

		FlxG.addChildBelowMouse(this);
	}

	private function update(?E:Event):Void
	{
		if (canSkip
			&& ((FlxG.keys.justPressed.ENTER && !FlxG.keys.pressed.ALT)
				|| FlxG.keys.justPressed.SPACE #if android || FlxG.android.justReleased.BACK #end)
			&& initComplete)
			onVLCComplete();

		if (FlxG.sound.muted || FlxG.sound.volume <= 0)
			volume = 0;
		else if (canUseSound)
			volume = FlxG.sound.volume;
	}

	private function resize(?E:Event):Void
	{
		if (canUseAutoResize)
		{
			set_width(calc(0));
			set_height(calc(1));
		}
	}

	private function createUrl(FileName:String):String
	{
		#if android
		return Uri.fromFile(FileName);
		#elseif linux
		return 'file://' + Sys.getCwd() + FileName;
		#elseif (windows || mac)
		return 'file:///' + Sys.getCwd() + FileName;
		#end
	}

	private function onVLCReady():Void
	{
		if (readyCallback != null)
			readyCallback();
	}

	private function onVLCError(E:String):Void
	{
		Application.current.window.alert(E, "VLC caught an error");
		onVLCComplete();
	}

	private function onVLCComplete()
	{
		if (FlxG.sound.music != null && pauseMusic)
			FlxG.sound.music.resume();

		if (FlxG.stage.hasEventListener(Event.ENTER_FRAME))
			FlxG.stage.removeEventListener(Event.ENTER_FRAME, update);

		if (FlxG.stage.hasEventListener(Event.RESIZE))
			FlxG.stage.removeEventListener(Event.RESIZE, resize);

		if (FlxG.autoPause)
		{
			if (FlxG.signals.focusGained.has(resume))
				FlxG.signals.focusGained.remove(resume);

			if (FlxG.signals.focusLost.has(pause))
				FlxG.signals.focusLost.remove(pause);
		}

		dispose();

		if (FlxG.game.contains(this))
		{
			FlxG.game.removeChild(this);

			if (finishCallback != null)
				finishCallback();
		}
	}

	/**
	 * Native video support for Flixel & OpenFL
	 * @param Path Example: `your/video/here.mp4`
	 * @param Loop Loop the video.
	 * @param Haccelerated if you want the video to be hardware accelerated.
	 * @param PauseMusic Pause music until the video ends.
	 */
	public function playVideo(Path:String, Loop:Bool = false, Haccelerated:Bool = true, PauseMusic:Bool = false):Void
	{
		pauseMusic = PauseMusic;

		if (FlxG.sound.music != null && PauseMusic)
			FlxG.sound.music.pause();

		resize();
		playFile(createUrl(Path), Loop, Haccelerated);

		FlxG.stage.addEventListener(Event.ENTER_FRAME, update);
		FlxG.stage.addEventListener(Event.RESIZE, resize);

		if (FlxG.autoPause)
		{
			FlxG.signals.focusGained.add(resume);
			FlxG.signals.focusLost.add(pause);
		}
	}

	private function calc(Ind:Int):Float
	{
		var appliedWidth:Float = FlxG.stage.stageHeight * (FlxG.width / FlxG.height);
		var appliedHeight:Float = FlxG.stage.stageWidth * (FlxG.height / FlxG.width);

		if (appliedHeight > FlxG.stage.stageHeight)
			appliedHeight = FlxG.stage.stageHeight;

		if (appliedWidth > FlxG.stage.stageWidth)
			appliedWidth = FlxG.stage.stageWidth;

		switch (Ind)
		{
			case 0:
				return appliedWidth;
			case 1:
				return appliedHeight;
		}

		return 0;
	}
}
