package hxcodec.flixel;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import hxcodec.openfl.VideoBitmap;
import openfl.events.Event;
import sys.FileSystem;

class FlxVideo extends VideoBitmap
{
	// Variables
	public var pauseMusic:Bool = false;
	public var skippable:Bool = true;
	public var skipKeys:Array<FlxKey> = [SPACE, ENTER, ESCAPE];
	public var autoResize:Bool = true;

	// Declarations
	private var skipTimer:Float = 0;

	public function new():Void
	{
		super();

		onOpening.add(function()
		{
			#if FLX_SOUND_SYSTEM
			volume = Std.int((FlxG.sound.muted ? 0 : 1) * (FlxG.sound.volume * 100));
			#end
		});

		FlxG.addChildBelowMouse(this);
	}

	override public function play(?path:String, loop:Bool = false):Int
	{
		#if FLX_SOUND_SYSTEM
		if (FlxG.sound.music != null && pauseMusic)
			FlxG.sound.music.pause();
		#end

		FlxG.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);

		if (FlxG.autoPause)
		{
			FlxG.signals.focusGained.add(resume);
			FlxG.signals.focusLost.add(pause);
		}

		// in case if you want to use another dir then the application one.
		// android can already do this, it can't use application's storage.
		if (FileSystem.exists(Sys.getCwd() + path))
			return super.play(Sys.getCwd() + path, loop);
		else
			return super.play(path, loop);
	}

	override public function dispose():Void
	{
		#if FLX_SOUND_SYSTEM
		if (FlxG.sound.music != null && pauseMusic)
			FlxG.sound.music.resume();
		#end

		if (FlxG.autoPause)
		{
			if (FlxG.signals.focusGained.has(resume))
				FlxG.signals.focusGained.remove(resume);

			if (FlxG.signals.focusLost.has(pause))
				FlxG.signals.focusLost.remove(pause);
		}

		if (FlxG.stage.hasEventListener(Event.ENTER_FRAME))
			FlxG.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);

		super.dispose();

		FlxG.removeChild(this);
	}

	@:noCompletion private function onEnterFrame(e:Event):Void
	{
		#if FLX_KEYBOARD
		if (skippable && FlxG.keys.anyPressed(skipKeys) && isPlaying)
		{
			skipTimer++;
			if (skipTimer > 10.0)
				onEndReached.dispatch();
		}
		else
			skipTimer = 0;
		#end

		#if FLX_TOUCH
		for (touch in FlxG.touches.list)
		{
			if (skippable && touch.pressed && isPlaying)
			{
				skipTimer++;
				if (skipTimer > 10.0)
					onEndReached.dispatch();
			}
			else
				skipTimer = 0;
		}
		#end

		if (autoResize && texture != null)
		{
			var aspectRatio:Float = FlxG.width / FlxG.height;

			if (FlxG.stage.stageWidth / FlxG.stage.stageHeight > aspectRatio)
			{
				// stage is wider than video
				width = FlxG.stage.stageHeight * aspectRatio;
				height = FlxG.stage.stageHeight;
			}
			else
			{
				// stage is taller than video
				width = FlxG.stage.stageWidth;
				height = FlxG.stage.stageWidth * (1 / aspectRatio);
			}
		}

		#if FLX_SOUND_SYSTEM
		volume = Std.int((FlxG.sound.muted ? 0 : 1) * (FlxG.sound.volume * 100));
		#end
	}
}
