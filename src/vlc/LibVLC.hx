package vlc;

#if !(desktop || android)
#error "The current target platform isn't supported by hxCodec. If you are targeting Windows/Mac/Linux/Android and you are getting this message, please contact us.";
#end
import cpp.Callable;
import cpp.ConstCharStar;
import cpp.RawConstPointer;
import cpp.Int64;
import cpp.UInt32;

/**
 * ...
 * @author Datee
 * @additional coding M.A. Jigsaw
 *
 * This class contains some LibVLC externs whitch you can use in Haxe.
 */
@:include("vlc/vlc.h")
@:unreflective
@:keep
extern class LibVLC
{
	@:native("libvlc_new")
	static function init(argc:Int, argv:RawConstPointer<ConstCharStar>):LibVLC_Instance;

	@:native("libvlc_release")
	static function release(p_instance:LibVLC_Instance):Void;

	@:native("libvlc_retain")
	static function retain(p_instance:LibVLC_Instance):Void;

	@:native("libvlc_errmsg")
	static function errmsg():ConstCharStar;

	@:native("libvlc_clearerr")
	static function clearerr():Void;

	@:native("libvlc_printerr")
	static function printerr(fmt:ConstCharStar):ConstCharStar;

	@:native("libvlc_audio_output_list_get")
	static function audio_output_list_get(p_instance:LibVLC_Instance):LibVLC_AudioOutput;

	@:native("libvlc_audio_output_set")
	static function audio_output_set(p_mi:LibVLC_MediaPlayer, deviceName:ConstCharStar):Void;

	@:native("libvlc_event_attach")
	static function event_attach(p_event_manager:LibVLC_EventManager, i_event_type:LibVLC_EventType, f_callback:LibVLC_Event_Callback,
		user_data:cpp.Star<cpp.Void>):Int;

	@:native("libvlc_event_detach")
	static function event_detach(p_event_manager:LibVLC_EventManager, i_event_type:LibVLC_EventType, f_callback:LibVLC_Event_Callback,
		user_data:cpp.Star<cpp.Void>):Int;

	@:native("libvlc_audio_get_volume")
	static function audio_get_volume(p_mi:LibVLC_MediaPlayer):Int;

	@:native("libvlc_audio_set_volume")
	static function audio_set_volume(p_mi:LibVLC_MediaPlayer, i_volume:Int):Int;

	@:native("libvlc_media_new_path")
	static function media_new_path(p_instance:LibVLC_Instance, path:ConstCharStar):LibVLC_Media;

	@:native("libvlc_media_add_option")
	static function media_add_option(p_md:LibVLC_Media, psz_options:ConstCharStar):Void;

	@:native("libvlc_media_get_duration")
	static function media_get_duration(p_md:LibVLC_Media):Int64;

	@:native("libvlc_media_release")
	static function media_release(p_md:LibVLC_Media):Void;

	@:native("libvlc_media_parse")
	static function media_parse(p_md:LibVLC_Media):Void;

	@:native("libvlc_media_player_play")
	static function media_player_play(p_mi:LibVLC_MediaPlayer):Void;

	@:native("libvlc_media_player_stop")
	static function media_player_stop(p_mi:LibVLC_MediaPlayer):Void;

	@:native("libvlc_media_player_set_pause")
	static function media_player_set_pause(p_mi:LibVLC_MediaPlayer, do_pause:Int):Void;

	@:native("libvlc_media_player_is_playing")
	static function media_player_is_playing(p_mi:LibVLC_MediaPlayer):Bool;

	@:native("libvlc_media_player_release")
	static function media_player_release(p_mi:LibVLC_MediaPlayer):Void;

	@:native("libvlc_media_player_event_manager")
	static function media_player_event_manager(mp:LibVLC_MediaPlayer):LibVLC_EventManager;

	@:native("libvlc_media_player_get_time")
	static function media_player_get_time(p_mi:LibVLC_MediaPlayer):Int64;

	@:native("libvlc_media_player_set_time")
	static function media_player_set_time(p_mi:LibVLC_MediaPlayer, i_time:Int64):Int;

	@:native("libvlc_media_player_new_from_media")
	static function media_player_new_from_media(p_md:LibVLC_Media):LibVLC_MediaPlayer;

	@:native("libvlc_video_set_format_callbacks")
	static function video_set_format_callbacks(mp:LibVLC_MediaPlayer, setup:LibVLC_Video_Setup_Callback, cleanup:LibVLC_Video_Cleanup_Callback):Void;

	@:native("libvlc_video_set_callbacks")
	static function video_set_callbacks(mp:LibVLC_MediaPlayer, lock:LibVLC_Video_Lock_Callback, unlock:LibVLC_Video_Unlock_Callback,
		display:LibVLC_Video_Display_Callback, opaque:cpp.Star<cpp.Void>):Void;

	@:native("libvlc_video_get_size")
	static function video_get_size(p_mi:LibVLC_MediaPlayer, num:UInt, width:cpp.Star<UInt32>, height:cpp.Star<UInt32>):Int;

	@:native("libvlc_set_exit_handler")
	static function set_exit_handler(p_instance:LibVLC_Instance, cb:cpp.Star<cpp.Void>, opaque:cpp.Star<cpp.Void>):Void;
}

typedef LibVLC_Event_Callback = Callable<(p_event:RawConstPointer<LibVLC_Event_T>, p_data:cpp.Star<cpp.Void>) -> Void>;
typedef LibVLC_Video_Setup_Callback = Callable<(opaque:cpp.Star<cpp.Star<cpp.Void>>, chroma:cpp.Star<cpp.Char>, width:cpp.Star<UInt32>, height:cpp.Star<UInt32>, pitches:cpp.Star<UInt32>, lines:cpp.Star<UInt32>) -> UInt32>;
typedef LibVLC_Video_Cleanup_Callback = Callable<(opaque:cpp.Star<cpp.Void>) -> Void>;
typedef LibVLC_Video_Lock_Callback = Callable<(data:cpp.Star<cpp.Void>, p_pixels:cpp.Star<cpp.Star<cpp.Void>>) -> cpp.Star<cpp.Void>>;
typedef LibVLC_Video_Unlock_Callback = Callable<(data:cpp.Star<cpp.Void>, id:cpp.Star<cpp.Void>, p_pixels:RawConstPointer<cpp.Star<cpp.Void>>) -> Void>;
typedef LibVLC_Video_Display_Callback = Callable<(opaque:cpp.Star<cpp.Void>, picture:cpp.Star<cpp.Void>) -> Void>;

typedef LibVLC_Instance = cpp.Star<LibVLC_Instance_T>;
typedef LibVLC_AudioOutput = cpp.Star<LibVLC_AudioOutput_T>;
typedef LibVLC_MediaPlayer = cpp.Star<LibVLC_MediaPlayer_T>;
typedef LibVLC_Media = cpp.Star<LibVLC_Media_T>;
typedef LibVLC_EventManager = cpp.Star<LibVLC_EventManager_T>;

@:include("vlc/vlc.h")
@:unreflective
@:keep
@:native("libvlc_instance_t")
extern class LibVLC_Instance_T {}

@:include("vlc/vlc.h")
@:unreflective
@:keep
@:native("libvlc_audio_output_t")
extern class LibVLC_AudioOutput_T {}

@:include("vlc/vlc.h")
@:unreflective
@:keep
@:native("libvlc_media_t")
extern class LibVLC_Media_T {}

@:include("vlc/vlc.h")
@:unreflective
@:keep
@:native("libvlc_media_player_t")
extern class LibVLC_MediaPlayer_T {}

@:include("vlc/vlc.h")
@:unreflective
@:keep
@:native("libvlc_event_manager_t")
extern class LibVLC_EventManager_T {}

@:include("vlc/vlc.h")
@:unreflective
@:structAccess
@:keep
@:native("libvlc_event_t")
extern class LibVLC_Event_T
{
	var type:LibVLC_EventType;
	var u:LibVLC_Event_U;
}

@:include("vlc/vlc.h")
@:unreflective
@:structAccess
@:keep
@:native("libvlc_event_t::u")
extern class LibVLC_Event_U
{
	var media_player_position_changed:LibVLC_MediaPlayer_PositionChanged;
	var media_player_time_changed:LibVLC_MediaPlayer_TimeChanged;
	var media_player_length_changed:LibVLC_MediaPlayer_LengthChanged;
	var media_player_buffering:LibVLC_MediaPlayer_Buffering;
	var media_player_seekable_changed:LibVLC_MediaPlayer_SeekableChanged;
	var media_player_pausable_changed:LibVLC_MediaPlayer_PausableChanged;
}

@:include("vlc/vlc.h")
@:unreflective
@:structAccess
@:keep
@:native("media_player_position_changed")
extern class LibVLC_MediaPlayer_PositionChanged
{
	var new_position:Float;
}

@:include("vlc/vlc.h")
@:unreflective
@:structAccess
@:keep
@:native("media_player_time_changed")
extern class LibVLC_MediaPlayer_TimeChanged
{
	var new_time:Int64;
}

@:include("vlc/vlc.h")
@:unreflective
@:structAccess
@:keep
@:native("media_player_length_changed")
extern class LibVLC_MediaPlayer_LengthChanged
{
	var new_length:Int64;
}

@:include("vlc/vlc.h")
@:unreflective
@:structAccess
@:keep
@:native("media_player_buffering")
extern class LibVLC_MediaPlayer_Buffering
{
	var new_cache:Float;
}

@:include("vlc/vlc.h")
@:unreflective
@:structAccess
@:keep
@:native("media_player_seekable_changed")
extern class LibVLC_MediaPlayer_SeekableChanged
{
	var new_seekable:Bool;
}

@:include("vlc/vlc.h")
@:unreflective
@:structAccess
@:keep
@:native("media_player_pausable_changed")
extern class LibVLC_MediaPlayer_PausableChanged
{
	var new_pausable:Bool;
}

enum abstract LibVLC_EventType(Int) from Int to Int
{
	var MetaChanged = 0;
	var SubItemAdded = 1;
	var DurationChanged = 2;
	var ParsedChanged = 3;
	var Freed = 4;
	var StateChanged = 5;
	var SubItemTreeAdded = 6;
	var PlayerMediaChanged = 256;
	var PlayerNothingSpecial = 257;
	var PlayerOpening = 258;
	var PlayerBuffering = 259;
	var PlayerPlaying = 260;
	var PlayerPaused = 261;
	var PlayerStopped = 262;
	var PlayerForward = 263;
	var PlayerBackward = 264;
	var PlayerEndReached = 265;
	var PlayerEncounteredError = 266;
	var PlayerTimeChanged = 267;
	var PlayerPositionChanged = 268;
	var PlayerSeekableChanged = 269;
	var PlayerPausableChanged = 270;
	var PlayerTitleChanged = 271;
	var PlayerSnapshotTaken = 272;
	var PlayerLengthChanged = 273;
	var PlayerVout = 274;
	var PlayerScrambledChanged = 275;
	var PlayerCorked = 279;
	var PlayerUncorked = 280;
	var PlayerMuted = 281;
	var PlayerUnmuted = 282;
	var PlayerAudioVolume = 283;
	var ListItemAdded = 512;
	var ListWillAddItem = 513;
	var ListItemDeleted = 514;
	var ListWillDeleteItem = 515;
	var ListViewItemAdded = 768;
	var ListViewWillAddItem = 769;
	var ListViewItemDeleted = 770;
	var ListViewWillDeleteItem = 771;
	var ListPlayerPlayed = 1024;
	var ListPlayerNextItemSet = 1025;
	var ListPlayerStopped = 1026;
}
