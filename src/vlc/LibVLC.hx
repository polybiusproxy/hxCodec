package vlc;

#if !(desktop || android)
#error "The current target platform isn't supported by hxCodec. If you are targeting Windows/Mac/Linux/Android and you are getting this message, please contact us.";
#end

/**
 * ...
 * @author Datee
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
	static function New(argc:Int, argv:String):LibVLC_Instance;

	@:native("libvlc_media_new_path")
	static function newMediaPath(p_instance:LibVLC_Instance, path:String):LibVLC_Media;

	@:native("libvlc_audio_output_list_get")
	static function getAudioOutputList(vlcInst:LibVLC_Instance):LibVLC_AudioOutput;

	@:native("libvlc_audio_output_set")
	static function setAudioOutput(p_mi:LibVLC_MediaPlayer, deviceName:String):Void;

	@:native("libvlc_media_player_play")
	static function mediaPlayerPlay(p_mi:LibVLC_MediaPlayer):Void;

	@:native("libvlc_media_player_stop")
	static function mediaPlayerStop(p_mi:LibVLC_MediaPlayer):Void;

	@:native("libvlc_media_player_setause")
	static function mediaPlayerSetPause(p_mi:LibVLC_MediaPlayer, doause:Int):Void;

	@:native("libvlc_media_player_is_playing")
	static function mediaPlayerIsPlaying(p_mi:LibVLC_MediaPlayer):Bool;

	@:native("libvlc_media_player_release")
	static function mediaPlayerRelease(p_mi:LibVLC_MediaPlayer):Void;

	@:native("libvlc_release")
	static function release(p_instance:LibVLC_Instance):Void;

	@:native("libvlc_retain")
	static function retain(p_instance:LibVLC_Instance):Void;

	@:native("libvlc_audio_get_volume")
	static function audioGetVolume(p_mi:LibVLC_MediaPlayer):Int;

	@:native("libvlc_audio_set_volume")
	static function audioSetVolume(p_mi:LibVLC_MediaPlayer, i_volume:Int):Int;

	@:native("libvlc_media_release")
	static function mediaRelease(p_md:LibVLC_Media):Void;

	@:native("libvlc_media_parse")
	static function mediaParse(p_md:LibVLC_Media):Void;

	@:native("libvlc_video_set_format_callbacks")
	static function setFormatCallbacks(mp:LibVLC_MediaPlayer, setup:LibVLC_Video_Format_CB, cleanup:LibVLC_Video_Cleanup_CB):Void;

	@:native("libvlc_video_set_callbacks")
	static function setCallbacks(mp:LibVLC_MediaPlayer, lock:LibVLC_Video_Lock_CB, unlock:LibVLC_Video_Unlock_CB,
		display:LibVLC_Video_Display_CB, opaque:cpp.Star<cpp.Void>):Void;

	@:native("libvlc_media_player_event_manager")
	static function setEventmanager(mp:LibVLC_MediaPlayer):LibVLC_EventManager;

	@:native("libvlc_event_attach")
	static function eventAttach(p_event_manager:LibVLC_EventManager, i_event_type:LibVLC_EventType, f_callback:LibVLC_Callback,
		user_data:cpp.Star<cpp.Void>):Int;

	@:native("libvlc_event_detach")
	static function eventDetach(p_event_manager:LibVLC_EventManager, i_event_type:LibVLC_EventType, f_callback:LibVLC_Callback,
		user_data:cpp.Star<cpp.Void>):Int;

	@:native("libvlc_set_exit_handler")
	static function setExitHandler(p_instance:LibVLC_Instance, cb:cpp.Star<cpp.Void>, opaque:cpp.Star<cpp.Void>):Void;

	@:native("libvlc_media_get_duration")
	static function mediaPlayerGetDuration(p_md:LibVLC_Media):LibVLC_Time_t;

	@:native("libvlc_media_player_get_time")
	static function mediaPlayerGetTime(p_mi:LibVLC_MediaPlayer):LibVLC_Time_t;

	@:native("libvlc_media_player_set_time")
	static function mediaPlayerSetTime(p_mi:LibVLC_MediaPlayer, i_time:LibVLC_Time_t):Int;

	@:native("libvlc_video_get_size")
	static function videoGetSize(p_mi:LibVLC_MediaPlayer, num:UInt, width:cpp.Star<cpp.UInt32>, height:cpp.Star<cpp.UInt32>):Int;

	@:native("libvlc_media_add_option")
	static function mediaAddOption(p_md:LibVLC_Media, psz_options:String):Void;
}

typedef LibVLC_Instance = cpp.Star<LibVLC_Instance>;
typedef LibVLC_AudioOutput = cpp.Star<LibVLC_AudioOutput>;
typedef LibVLC_MediaPlayer = cpp.Star<LibVLC_MediaPlayer>;
typedef LibVLC_Media = cpp.Star<LibVLC_Media>;
typedef LibVLC_EventManager = cpp.Star<LibVLC_EventManager>;
typedef LibVLC_Event = cpp.Star<LibVLC_Event>;
typedef LibVLC_Time_t = cpp.Int64;

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

typedef LibVLC_PixelBuffer = cpp.Star<LibVLC_PixelBuffer_t>;
typedef LibVLC_PixelBuffer_t = cpp.UInt8;
typedef LibVLC_Video_Format_CB = cpp.Callable<(opaque:cpp.Star<cpp.Star<cpp.Void>>, chroma:cpp.Star<cpp.Char>, width:cpp.Star<cpp.UInt32>, height:cpp.Star<cpp.UInt32>, pitches:cpp.Star<cpp.UInt32>,
		lines:cpp.Star<cpp.UInt32>) -> cpp.UInt32>;
typedef LibVLC_Video_Cleanup_CB = cpp.Callable<(opaque:cpp.Star<cpp.Void>) -> Void>;
typedef LibVLC_Video_Lock_CB = cpp.Callable<(data:cpp.Star<cpp.Void>, p_pixels:cpp.Star<cpp.Star<cpp.Void>>) -> cpp.Star<cpp.Void>>;
typedef LibVLC_Video_Unlock_CB = cpp.Callable<(data:cpp.Star<cpp.Void>, id:cpp.Star<cpp.Void>, p_pixels:cpp.ConstStar<cpp.Star<cpp.Void>>) -> Void>;
typedef LibVLC_Video_Display_CB = cpp.Callable<(opaque:cpp.Star<cpp.Void>, picture:cpp.Star<cpp.Void>) -> Void>;
typedef LibVLC_Callback = cpp.Callable<(p_event:cpp.ConstStar<LibVLC_Event>, p_data:cpp.Star<cpp.Void>) -> Void>;

@:native("libvlc_event_t")
@:structAccess
extern class LibVLC_Event
{
	public var type:LibVLC_EventType;
	public var u:LibVLC_Event_U;
}

@:native("libvlc_event_t::u")
@:structAccess
extern class LibVLC_Event_U
{
	public var media_player_position_changed:LibVLC_MediaPlayer_PositionChanged;
	public var media_player_time_changed:LibVLC_MediaPlayer_TimeChanged;
	public var media_player_length_changed:LibVLC_MediaPlayer_LengthChanged;
	public var media_player_buffering:LibVLC_MediaPlayer_Buffering;
	public var media_player_seekable_changed:LibVLC_MediaPlayer_SeekableChanged;
	public var media_player_pausable_changed:LibVLC_MediaPlayer_PausableChanged;
}

@:native("media_player_position_changed")
@:structAccess
extern class LibVLC_MediaPlayer_PositionChanged
{
	public var new_position:Float;
}

@:native("media_player_time_changed")
@:structAccess
extern class LibVLC_MediaPlayer_TimeChanged
{
	public var new_time:cpp.Int64;
}

@:native("media_player_length_changed")
@:structAccess
extern class LibVLC_MediaPlayer_LengthChanged
{
	public var new_length:cpp.Int64;
}

@:native("media_player_buffering")
@:structAccess
extern class LibVLC_MediaPlayer_Buffering
{
	public var new_cache:Float;
}

@:native("media_player_seekable_changed")
@:structAccess
extern class LibVLC_MediaPlayer_SeekableChanged
{
	public var new_seekable:Bool;
}

@:native("media_player_pausable_changed")
@:structAccess
extern class LibVLC_MediaPlayer_PausableChanged
{
	public var new_pausable:Bool;
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
