package hxcodec.lime;

#if (!(desktop || android) && macro)
#error "The current target platform isn't supported by hxCodec. If you're targeting Windows/Mac/Linux/Android and getting this message, please contact us."
#end
import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.Path;
import hxcodec.vlc.LibVLC;
import hxcodec.vlc.Types;
import lime.app.Event;

using StringTools;

/**
 * ...
 * @author Mihai Alexandru (M.A. Jigsaw).
 *
 * This class lets you to use LibVLC externs on a separated window which can display a video.
 */
#if windows
@:headerInclude('windows.h')
@:headerInclude('winuser.h')
#end
@:headerInclude('stdio.h')
@:headerInclude('stdlib.h')
@:headerInclude('stdarg.h')
@:cppInclude('string')
@:cppNamespaceCode('
#ifndef vasprintf
int vasprintf(char **sptr, const char *__restrict fmt, va_list ap)
{
	int count = vsnprintf(NULL, 0, fmt, ap); // Query the buffer size required.

	*sptr = NULL;

	if (count >= 0)
	{
		char *p = static_cast<char *>(malloc(count + 1)); // Allocate memory for it.

		if (p == NULL)
			return -1;

		if (vsnprintf(p, count + 1, fmt, ap) == count) // We should have used exactly what was required.
		{
			*sptr = p;
		}
		else // Otherwise something is wrong, likely a bug in vsnprintf. If so free the memory and report the error.
		{
			free(p);
			return -1;
		}
	}

	return count;
}
#endif

static void callbacks(const libvlc_event_t *event, void *data)
{
	VideoPlayer_obj *self = reinterpret_cast<VideoPlayer_obj *>(data);

	switch (event->type)
	{
		case libvlc_MediaPlayerOpening:
			self->flags[0] = true;
			break;
		case libvlc_MediaPlayerPlaying:
			self->flags[1] = true;
			break;
		case libvlc_MediaPlayerPaused:
			self->flags[2] = true;
			break;
		case libvlc_MediaPlayerStopped:
			self->flags[3] = true;
			break;
		case libvlc_MediaPlayerEndReached:
			self->flags[4] = true;
			break;
		case libvlc_MediaPlayerEncounteredError:
			self->flags[5] = true;
			break;
		case libvlc_MediaPlayerForward:
			self->flags[6] = true;
			break;
		case libvlc_MediaPlayerBackward:
			self->flags[7] = true;
			break;
	}
}

static void logging(void *data, int level, const libvlc_log_t *ctx, const char *fmt, va_list args)
{
	VideoPlayer_obj *self = reinterpret_cast<VideoPlayer_obj *>(data);

	char *msg = NULL;
	if (vasprintf(&msg, fmt, args) < 0)
		return;

	std::string logMsg = "[ ";

	switch (level)
	{
		case LIBVLC_DEBUG:
			logMsg.append("DEBUG");
			break;
		case LIBVLC_NOTICE:
			logMsg.append("INFO");
			break;
		case LIBVLC_WARNING:
			logMsg.append("WARNING");
			break;
		case LIBVLC_ERROR:
			logMsg.append("ERROR");
			break;
	}

	logMsg.append(" ] ");
	logMsg.append(std::string(msg));

	self->messages.push_back(logMsg.c_str());
}')
class VideoPlayer
{
	// Variables
	public var time(get, set):Int;
	public var position(get, set):Single;
	public var length(get, never):Int;
	public var duration(get, never):Int;
	public var mrl(get, never):String;
	public var volume(get, set):Int;
	public var channel(get, set):Int;
	public var delay(get, set):Int;
	public var rate(get, set):Single;
	public var role(get, set):Int;
	public var isPlaying(get, never):Bool;
	public var isSeekable(get, never):Bool;
	public var canPause(get, never):Bool;
	public var mute(get, set):Bool;

	// Callbacks
	public var onOpening(default, null):Event<Void->Void>;
	public var onPlaying(default, null):Event<String->Void>;
	public var onPaused(default, null):Event<Void->Void>;
	public var onStopped(default, null):Event<Void->Void>;
	public var onEndReached(default, null):Event<Void->Void>;
	public var onEncounteredError(default, null):Event<String->Void>;
	public var onForward(default, null):Event<Void->Void>;
	public var onBackward(default, null):Event<Void->Void>;
	public var onLogMessage(default, null):Event<String->Void>;

	// Declarations
	private var flags:Array<Bool> = [];
	private var messages:cpp.StdVectorConstCharStar;
	private var instance:cpp.RawPointer<LibVLC_Instance_T>;
	private var mediaPlayer:cpp.RawPointer<LibVLC_MediaPlayer_T>;
	private var mediaItem:cpp.RawPointer<LibVLC_Media_T>;
	private var eventManager:cpp.RawPointer<LibVLC_EventManager_T>;

	public function new():Void
	{
		for (event in 0...7)
			flags[event] = false;

		messages = cpp.StdVectorConstCharStar.create();

		onOpening = new Event<Void->Void>();
		onPlaying = new Event<String->Void>();
		onStopped = new Event<Void->Void>();
		onPaused = new Event<Void->Void>();
		onEndReached = new Event<Void->Void>();
		onEncounteredError = new Event<String->Void>();
		onForward = new Event<Void->Void>();
		onBackward = new Event<Void->Void>();
		onLogMessage = new Event<String->Void>();

		#if windows
		untyped __cpp__('char const *argv[] = { "--reset-plugins-cache" }');

		instance = LibVLC.create(1, untyped __cpp__('argv'));
		#else
		instance = LibVLC.create(0, null);
		#end

		#if HXC_LIBVLC_LOGGING
		LibVLC.log_set(instance, untyped __cpp__('logging'), untyped __cpp__('this'));
		#end
	}

	// Methods
	public function play(?location:String, shouldLoop:Bool = false):Int
	{
		if (location == null || (location != null && !location.contains('.')))
			return -1;

		if ((location.startsWith('http') || location.startsWith('file')) && location.contains(':'))
		{
			#if HXC_DEBUG_TRACE
			trace("setting location to: " + location);
			#end

			mediaItem = LibVLC.media_new_location(instance, location);
		}
		else
		{
			final path:String = #if windows Path.normalize(location).split("/").join("\\") #else Path.normalize(location) #end;

			#if HXC_DEBUG_TRACE
			trace("setting path to: " + path);
			#end

			mediaItem = LibVLC.media_new_path(instance, path);
		}

		mediaPlayer = LibVLC.media_player_new_from_media(mediaItem);

		attachEvents();

		LibVLC.media_add_option(mediaItem, shouldLoop ? "input-repeat=65535" : "input-repeat=0");

		LibVLC.media_release(mediaItem);

		#if windows
		LibVLC.media_player_set_hwnd(mediaPlayer, untyped __cpp__('GetActiveWindow()'));
		#end

		return LibVLC.media_player_play(mediaPlayer);
	}

	public function stop():Void
	{
		if (mediaPlayer != null)
			LibVLC.media_player_stop(mediaPlayer);
	}

	public function pause():Void
	{
		if (mediaPlayer != null)
			LibVLC.media_player_set_pause(mediaPlayer, 1);
	}

	public function resume():Void
	{
		if (mediaPlayer != null)
			LibVLC.media_player_set_pause(mediaPlayer, 0);
	}

	public function togglePaused():Void
	{
		if (mediaPlayer != null)
			LibVLC.media_player_pause(mediaPlayer);
	}

	public function update():Void
	{
		#if HXC_LIBVLC_LOGGING
		updateLogging();
		#end

		checkFlags();
	}

	public function dispose():Void
	{
		if (mediaPlayer == null || instance == null)
			return;

		detachEvents();

		LibVLC.media_player_stop(mediaPlayer);
		LibVLC.media_player_release(mediaPlayer);

		onOpening = null;
		onPlaying = null;
		onStopped = null;
		onPaused = null;
		onEndReached = null;
		onEncounteredError = null;
		onForward = null;
		onBackward = null;
		onLogMessage = null;

		#if HXC_LIBVLC_LOGGING
		LibVLC.log_unset(instance);
		#end
		LibVLC.release(instance);

		eventManager = null;
		mediaPlayer = null;
		mediaItem = null;
		instance = null;

		#if HXC_DEBUG_TRACE
		trace('disposing done!');
		#end
	}

	// Get & Set Methods
	@:noCompletion private function get_time():Int
	{
		if (mediaPlayer != null)
		{
			#if (haxe >= "4.3.0")
			return LibVLC.media_player_get_time(mediaPlayer).toInt();
			#else
			return LibVLC.media_player_get_time(mediaPlayer);
			#end
		}

		return -1;
	}

	@:noCompletion private function set_time(value:Int):Int
	{
		if (mediaPlayer != null)
			LibVLC.media_player_set_time(mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_position():Single
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_get_position(mediaPlayer);

		return -1;
	}

	@:noCompletion private function set_position(value:Single):Single
	{
		if (mediaPlayer != null)
			LibVLC.media_player_set_position(mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_length():Int
	{
		if (mediaPlayer != null)
		{
			#if (haxe >= "4.3.0")
			return LibVLC.media_player_get_length(mediaPlayer).toInt();
			#else
			return LibVLC.media_player_get_length(mediaPlayer);
			#end
		}

		return -1;
	}

	@:noCompletion private function get_duration():Int
	{
		if (mediaItem != null)
		{
			#if (haxe >= "4.3.0")
			return LibVLC.media_get_duration(mediaItem).toInt();
			#else
			return LibVLC.media_get_duration(mediaItem);
			#end
		}

		return -1;
	}

	@:noCompletion private function get_mrl():String
	{
		if (mediaItem != null)
			return cast(LibVLC.media_get_mrl(mediaItem), String);

		return null;
	}

	@:noCompletion private function get_volume():Int
	{
		if (mediaPlayer != null)
			return LibVLC.audio_get_volume(mediaPlayer);

		return -1;
	}

	@:noCompletion private function set_volume(value:Int):Int
	{
		if (mediaPlayer != null)
			LibVLC.audio_set_volume(mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_channel():Int
	{
		if (mediaPlayer != null)
			return LibVLC.audio_get_channel(mediaPlayer);

		return -1;
	}

	@:noCompletion private function set_channel(value:Int):Int
	{
		if (mediaPlayer != null)
			LibVLC.audio_set_channel(mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_delay():Int
	{
		if (mediaPlayer != null)
		{
			#if (haxe >= "4.3.0")
			return LibVLC.audio_get_delay(mediaPlayer).toInt();
			#else
			return LibVLC.audio_get_delay(mediaPlayer);
			#end
		}

		return -1;
	}

	@:noCompletion private function set_delay(value:Int):Int
	{
		if (mediaPlayer != null)
			LibVLC.audio_set_delay(mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_rate():Single
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_get_rate(mediaPlayer);

		return -1;
	}

	@:noCompletion private function set_rate(value:Single):Single
	{
		if (mediaPlayer != null)
			LibVLC.media_player_set_rate(mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_role():Int
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_get_role(mediaPlayer);

		return -1;
	}

	@:noCompletion private function set_role(value:Int):Int
	{
		if (mediaPlayer != null)
			LibVLC.media_player_set_role(mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_isPlaying():Bool
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_is_playing(mediaPlayer);

		return false;
	}

	@:noCompletion private function get_isSeekable():Bool
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_is_seekable(mediaPlayer);

		return false;
	}

	@:noCompletion private function get_canPause():Bool
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_can_pause(mediaPlayer);

		return false;
	}

	@:noCompletion function get_mute():Bool
	{
		if (mediaPlayer != null)
			return LibVLC.audio_get_mute(mediaPlayer) > 0;

		return false;
	}

	@:noCompletion function set_mute(value:Bool):Bool
	{
		if (mediaPlayer != null)
			LibVLC.audio_set_mute(mediaPlayer, value);

		return value;
	}

	// Internal Methods
	#if HXC_LIBVLC_LOGGING
	@:noCompletion private function updateLogging():Void
	{
		while (messages.size() > 0)
		{
			// Pop the last message in the vector.
			if (onLogMessage != null)
				onLogMessage.dispatch(cleanupLogMsg(cast(messages.back(), String)));

			// Free the messages.
			messages.pop_back();
		}
	}
	#end

	@:noCompletion private function checkFlags():Void
	{
		for (i in 0...flags.length)
		{
			if (flags[i])
			{
				flags[i] = false;

				switch (i)
				{
					case 0:
						if (onOpening != null)
							onOpening.dispatch();
					case 1:
						if (onPlaying != null)
							onPlaying.dispatch(mrl);
					case 2:
						if (onPaused != null)
							onPaused.dispatch();
					case 3:
						if (onStopped != null)
							onStopped.dispatch();
					case 4:
						if (onEndReached != null)
							onEndReached.dispatch();
					case 5:
						if (onEncounteredError != null)
							onEncounteredError.dispatch("error cannot be specified");
					case 6:
						if (onForward != null)
							onForward.dispatch();
					case 7:
						if (onBackward != null)
							onBackward.dispatch();
				}
			}
		}
	}

	@:noCompletion private function cleanupLogMsg(str:String):String
	{
		#if windows
		return str.replace('/home/jenkins/workspace/vlc-release/windows/vlc-release-win32-x64/extras/package/win32/../../..', '');
		#else // TODO
		return str;
		#end
	}

	@:noCompletion private function attachEvents():Void
	{
		if (mediaPlayer == null)
			return;

		eventManager = LibVLC.media_player_event_manager(mediaPlayer);

		LibVLC.event_attach(eventManager, LibVLC_MediaPlayerOpening, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_MediaPlayerPlaying, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_MediaPlayerPaused, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_MediaPlayerStopped, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_MediaPlayerEndReached, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_MediaPlayerEncounteredError, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_MediaPlayerForward, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_MediaPlayerBackward, untyped __cpp__('callbacks'), untyped __cpp__('this'));
	}

	@:noCompletion private function detachEvents():Void
	{
		if (eventManager == null)
			return;

		LibVLC.event_detach(eventManager, LibVLC_MediaPlayerOpening, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_MediaPlayerPlaying, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_MediaPlayerPaused, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_MediaPlayerStopped, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_MediaPlayerEndReached, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_MediaPlayerEncounteredError, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_MediaPlayerForward, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_MediaPlayerBackward, untyped __cpp__('callbacks'), untyped __cpp__('this'));
	}
}