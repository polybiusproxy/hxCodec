package vlc;

#if !(desktop || android)
#error "The current target platform isn't supported by hxCodec. If you are targeting Windows/Mac/Linux/Android and you are getting this message, please contact us.";
#end
import cpp.Callable;
import cpp.ConstStar;
import cpp.Int64;
import cpp.Star;
import cpp.UInt32;

/**
 * ...
 * @author Datee
 * @additional coding M.A. Jigsaw
 *
 * This class lets you to use the C++ code of libvlc as a extern class which you can use in Haxe.
 */
@:buildXml("<include name='${haxelib:hxCodec}/src/vlc/LibVLCBuild.xml' />")
@:include("vlc/vlc.h")
@:unreflective
@:keep
extern class LibVLC
{
	@:native("libvlc_new")
	static function New(argc:Int, argv:String):Star<LibVLC_Instance>;

	@:native("libvlc_media_new_path")
	static function newMediaPath(p_instance:Star<LibVLC_Instance>, path:String):Star<LibVLC_Media>;

	@:native("libvlc_audio_output_list_get")
	static function getAudioOutputList(p_instance:Star<LibVLC_Instance>):Star<LibVLC_AudioOutput>;

	@:native("libvlc_audio_output_set")
	static function setAudioOutput(p_mi:Star<LibVLC_MediaPlayer>, deviceName:String):Void;

	@:native("libvlc_media_player_play")
	static function mediaPlayerPlay(p_mi:Star<LibVLC_MediaPlayer>):Void;

	@:native("libvlc_media_player_stop")
	static function mediaPlayerStop(p_mi:Star<LibVLC_MediaPlayer>):Void;

	@:native("libvlc_media_player_setause")
	static function mediaPlayerSetPause(p_mi:Star<LibVLC_MediaPlayer>, do_pause:Int):Void;

	@:native("libvlc_media_player_is_playing")
	static function mediaPlayerIsPlaying(p_mi:Star<LibVLC_MediaPlayer>):Bool;

	@:native("libvlc_media_player_release")
	static function mediaPlayerRelease(p_mi:Star<LibVLC_MediaPlayer>):Void;

	@:native("libvlc_release")
	static function release(p_instance:Star<LibVLC_Instance>):Void;

	@:native("libvlc_retain")
	static function retain(p_instance:Star<LibVLC_Instance>):Void;

	@:native("libvlc_audio_get_volume")
	static function audioGetVolume(p_mi:Star<LibVLC_MediaPlayer>):Int;

	@:native("libvlc_audio_set_volume")
	static function audioSetVolume(p_mi:Star<LibVLC_MediaPlayer>, i_volume:Int):Int;

	@:native("libvlc_media_release")
	static function mediaRelease(p_md:Star<LibVLC_Media>):Void;

	@:native("libvlc_media_parse")
	static function mediaParse(p_md:Star<LibVLC_Media>):Void;

	@:native("libvlc_video_set_format_callbacks")
	static function setFormatCallbacks(mp:Star<LibVLC_MediaPlayer>, setup:LibVLC_Video_Format_Callback, cleanup:LibVLC_Video_Cleanup_Callback):Void;

	@:native("libvlc_video_set_callbacks")
	static function setCallbacks(mp:Star<LibVLC_MediaPlayer>, lock:LibVLC_Video_Lock_Callback, unlock:LibVLC_Video_Unlock_Callback,
		display:LibVLC_Video_Display_Callback, opaque:Star<cpp.Void>):Void;

	@:native("libvlc_media_player_event_manager")
	static function setEventmanager(mp:Star<LibVLC_MediaPlayer>):Star<LibVLC_EventManager>;

	@:native("libvlc_event_attach")
	static function eventAttach(p_event_manager:Star<LibVLC_EventManager>, i_event_type:LibVLC_EventType, f_callback:LibVLC_Callback,
		user_data:Star<cpp.Void>):Int;

	@:native("libvlc_event_detach")
	static function eventDetach(p_event_manager:Star<LibVLC_EventManager>, i_event_type:LibVLC_EventType, f_callback:LibVLC_Callback,
		user_data:Star<cpp.Void>):Int;

	@:native("libvlc_set_exit_handler")
	static function setExitHandler(p_instance:Star<LibVLC_Instance>, cb:Star<cpp.Void>, opaque:Star<cpp.Void>):Void;

	@:native("libvlc_media_get_duration")
	static function mediaPlayerGetDuration(p_md:Star<LibVLC_Media>):Int64;

	@:native("libvlc_media_player_get_time")
	static function mediaPlayerGetTime(p_mi:Star<LibVLC_MediaPlayer>):Int64;

	@:native("libvlc_media_player_set_time")
	static function mediaPlayerSetTime(p_mi:Star<LibVLC_MediaPlayer>, i_time:Int64):Int;

	@:native("libvlc_video_get_size")
	static function videoGetSize(p_mi:Star<LibVLC_MediaPlayer>, num:UInt, width:Star<UInt32>, height:Star<UInt32>):Int;

	@:native("libvlc_media_add_option")
	static function mediaAddOption(p_md:Star<LibVLC_Media>, psz_options:String):Void;
}

@:native("libvlc_audio_output_t")
extern class LibVLC_AudioOutput
{
}

@:native("libvlc_instance_t")
extern class LibVLC_Instance
{
}

@:native("libvlc_media_player_t")
extern class LibVLC_MediaPlayer
{
}

@:native("libvlc_media_t")
extern class LibVLC_Media
{
}

@:native("libvlc_event_manager_t")
extern class LibVLC_EventManager
{
}

typedef LibVLC_Video_Format_Callback = Callable<(opaque:Star<Star<cpp.Void>>, chroma:Star<cpp.Char>, width:Star<UInt32>, height:Star<UInt32>, pitches:Star<UInt32>,
		lines:Star<UInt32>) -> UInt32>;
typedef LibVLC_Video_Cleanup_Callback = Callable<(opaque:Star<cpp.Void>) -> Void>;
typedef LibVLC_Video_Lock_Callback = Callable<(data:Star<cpp.Void>, p_pixels:Star<Star<cpp.Void>>) -> Star<cpp.Void>>;
typedef LibVLC_Video_Unlock_Callback = Callable<(data:Star<cpp.Void>, id:Star<cpp.Void>, p_pixels:ConstStar<Star<cpp.Void>>) -> Void>;
typedef LibVLC_Video_Display_Callback = Callable<(opaque:Star<cpp.Void>, picture:Star<cpp.Void>) -> Void>;
typedef LibVLC_Callback = Callable<(p_event:ConstStar<LibVLC_Event>, p_data:Star<cpp.Void>) -> Void>;

@:native("libvlc_event_t")
@:structAccess
extern class LibVLC_Event
{
	var type:LibVLC_EventType;
	var u:LibVLC_Event_U;
}

@:native("libvlc_event_t::u")
@:structAccess
extern class LibVLC_Event_U
{
	var media_player_position_changed:LibVLC_MediaPlayer_PositionChanged;
	var media_player_time_changed:LibVLC_MediaPlayer_TimeChanged;
	var media_player_length_changed:LibVLC_MediaPlayer_LengthChanged;
	var media_player_buffering:LibVLC_MediaPlayer_Buffering;
	var media_player_seekable_changed:LibVLC_MediaPlayer_SeekableChanged;
	var media_player_pausable_changed:LibVLC_MediaPlayer_PausableChanged;
}

@:native("media_player_position_changed")
@:structAccess
extern class LibVLC_MediaPlayer_PositionChanged
{
	var new_position:Float;
}

@:native("media_player_time_changed")
@:structAccess
extern class LibVLC_MediaPlayer_TimeChanged
{
	var new_time:Int64;
}

@:native("media_player_length_changed")
@:structAccess
extern class LibVLC_MediaPlayer_LengthChanged
{
	var new_length:Int64;
}

@:native("media_player_buffering")
@:structAccess
extern class LibVLC_MediaPlayer_Buffering
{
	var new_cache:Float;
}

@:native("media_player_seekable_changed")
@:structAccess
extern class LibVLC_MediaPlayer_SeekableChanged
{
	var new_seekable:Bool;
}

@:native("media_player_pausable_changed")
@:structAccess
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
	var PlayerSeekableChange = 269;
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
