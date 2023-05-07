package hxcodec.vlc;

#if (!(desktop || android) && macro)
#error "The current target platform isn't supported by hxCodec. If you're targeting Windows/Mac/Linux/Android and getting this message, please contact us."
#end

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:unreflective
@:keep
extern class LibVLC
{
	@:native("libvlc_new")
	static function create(argc:Int, argv:cpp.ConstCharStar):cpp.RawPointer<LibVLC_Instance_T>;

	@:native("libvlc_release")
	static function release(p_instance:cpp.RawPointer<LibVLC_Instance_T>):Void;

	@:native("libvlc_retain")
	static function retain(p_instance:cpp.RawPointer<LibVLC_Instance_T>):Void;

	@:native("libvlc_free")
	static function free(ptr:cpp.Pointer<cpp.Void>):Void;

	@:native("libvlc_errmsg")
	static function errmsg():cpp.ConstCharStar;

	@:native("libvlc_clearerr")
	static function clearerr():Void;

	@:native("libvlc_printerr")
	static function printerr(fmt:cpp.ConstCharStar):cpp.ConstCharStar;

	@:native("libvlc_get_version")
	static function get_version():cpp.ConstCharStar;

	@:native("libvlc_get_compiler")
	static function get_compiler():cpp.ConstCharStar;

	@:native("libvlc_get_changeset")
	static function get_changeset():cpp.ConstCharStar;

	@:native("libvlc_audio_output_set")
	static function audio_output_set(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>, deviceName:cpp.ConstCharStar):Void;

	@:native("libvlc_audio_get_delay")
	static function audio_get_delay(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):cpp.Int64;

	@:native("libvlc_audio_set_delay")
	static function audio_set_delay(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>, i_delay:cpp.Int64):Int;

	@:native("libvlc_audio_get_volume")
	static function audio_get_volume(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Int;

	@:native("libvlc_audio_set_volume")
	static function audio_set_volume(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>, i_volume:Int):Int;

	@:native("libvlc_audio_get_mute")
	static function audio_get_mute(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Int;

	@:native("libvlc_audio_set_mute")
	static function audio_set_mute(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>, i_status:Bool):Int;

	@:native("libvlc_event_attach")
	static function event_attach(p_event_manager:cpp.RawPointer<LibVLC_EventManager_T>, i_event_type:LibVLC_Event_Type, f_callback:LibVLC_Callback_T,
		user_data:cpp.Pointer<cpp.Void>):Int;

	@:native("libvlc_event_detach")
	static function event_detach(p_event_manager:cpp.RawPointer<LibVLC_EventManager_T>, i_event_type:LibVLC_Event_Type, f_callback:LibVLC_Callback_T,
		user_data:cpp.Pointer<cpp.Void>):Void;

	@:native('libvlc_log_get_context')
	static function log_get_context(ctx:cpp.RawConstPointer<LibVLC_Log_T>, module:cpp.RawPointer<cpp.ConstCharStar>, file:cpp.RawPointer<cpp.ConstCharStar>,
		line:cpp.Pointer<cpp.UInt32>):Void;

	@:native('libvlc_log_get_object')
	static function log_get_object(ctx:cpp.RawConstPointer<LibVLC_Log_T>, name:cpp.RawPointer<cpp.ConstCharStar>, header:cpp.RawPointer<cpp.ConstCharStar>,
		id:cpp.Pointer<cpp.UInt32>):Void;

	@:native('libvlc_log_unset')
	static function log_unset(p_instance:cpp.RawPointer<LibVLC_Instance_T>):Void;

	@:native('libvlc_log_set')
	static function log_set(p_instance:cpp.RawPointer<LibVLC_Instance_T>, cb:LibVLC_Log_CB, data:cpp.Pointer<cpp.Void>):Void;

	@:native('libvlc_log_set_file')
	static function log_set_file(p_instance:cpp.RawPointer<LibVLC_Instance_T>, stream:cpp.FILE):Void;

	@:native("libvlc_media_new_path")
	static function media_new_path(p_instance:cpp.RawPointer<LibVLC_Instance_T>, path:cpp.ConstCharStar):cpp.RawPointer<LibVLC_Media_T>;

	@:native("libvlc_media_new_location")
	static function media_new_location(p_instance:cpp.RawPointer<LibVLC_Instance_T>, psz_mrl:cpp.ConstCharStar):cpp.RawPointer<LibVLC_Media_T>;

	#if !windows
	@:native("libvlc_media_new_callbacks")
	static function media_new_callbacks(p_instance:cpp.RawPointer<LibVLC_Instance_T>, open_cb:LibVLC_Media_Open_CB, read_cb:LibVLC_Media_Read_CB, seek_cb:LibVLC_Media_Seek_CB, close_cb:LibVLC_Media_Close_CB, opaque:cpp.Pointer<cpp.Void>):cpp.RawPointer<LibVLC_Media_T>;
	#end

	@:native("libvlc_media_add_option")
	static function media_add_option(p_md:cpp.RawPointer<LibVLC_Media_T>, psz_options:cpp.ConstCharStar):Void;

	@:native("libvlc_media_add_option_flag")
	static function media_add_option_flag(p_md:cpp.RawPointer<LibVLC_Media_T>, psz_options:cpp.ConstCharStar, i_flags:cpp.UInt32):Void;

	@:native("libvlc_media_event_manager")
	static function media_event_manager(p_md:cpp.RawPointer<LibVLC_Media_T>):cpp.RawPointer<LibVLC_EventManager_T>;

	@:native("libvlc_media_get_duration")
	static function media_get_duration(p_md:cpp.RawPointer<LibVLC_Media_T>):cpp.Int64;

	@:native("libvlc_media_get_mrl")
	static function media_get_mrl(p_md:cpp.RawPointer<LibVLC_Media_T>):cpp.ConstCharStar;

	@:native("libvlc_media_release")
	static function media_release(p_md:cpp.RawPointer<LibVLC_Media_T>):Void;

	@:native("libvlc_media_retain")
	static function media_retain(p_md:cpp.RawPointer<LibVLC_Media_T>):Void;

	@:native("libvlc_media_parse")
	static function media_parse(p_md:cpp.RawPointer<LibVLC_Media_T>):Void;

	@:native("libvlc_media_parse_with_options")
	static function media_parse_with_options(p_md:cpp.RawPointer<LibVLC_Media_T>, parse_flag:LibVLC_Media_Parse_Flag, timeout:Int):Int;

	@:native("libvlc_media_parse_stop")
	static function media_parse_stop(p_md:cpp.RawPointer<LibVLC_Media_T>):Void;

	@:native("libvlc_media_get_parsed_status")
	static function media_get_parsed_status(p_md:cpp.RawPointer<LibVLC_Media_T>):LibVLC_Media_Parsed_Status;

	@:native("libvlc_media_player_play")
	static function media_player_play(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Int;

	@:native("libvlc_media_player_stop")
	static function media_player_stop(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Void;

	@:native("libvlc_media_player_pause")
	static function media_player_pause(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Void;

	@:native("libvlc_media_player_set_pause")
	static function media_player_set_pause(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>, do_pause:Int):Void;

	@:native("libvlc_media_player_is_playing")
	static function media_player_is_playing(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Bool;

	@:native("libvlc_media_player_is_seekable")
	static function media_player_is_seekable(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Bool;

	@:native("libvlc_media_player_can_pause")
	static function media_player_can_pause(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Bool;

	@:native("libvlc_media_player_release")
	static function media_player_release(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Void;

	@:native("libvlc_media_player_retain")
	static function media_player_retain(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Void;

	@:native("libvlc_media_player_event_manager")
	static function media_player_event_manager(mp:cpp.RawPointer<LibVLC_MediaPlayer_T>):cpp.RawPointer<LibVLC_EventManager_T>;

	@:native("libvlc_media_player_get_time")
	static function media_player_get_time(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):cpp.Int64;

	@:native("libvlc_media_player_set_time")
	static function media_player_set_time(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>, i_time:cpp.Int64):Int;

	@:native("libvlc_media_player_get_position")
	static function media_player_get_position(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Float;

	@:native("libvlc_media_player_set_position")
	static function media_player_set_position(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>, f_pos:Float):Int;

	@:native("libvlc_media_player_get_rate")
	static function media_player_get_rate(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Float;

	@:native("libvlc_media_player_set_rate")
	static function media_player_set_rate(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>, rate:Float):Int;

	@:native("libvlc_media_player_get_fps")
	static function media_player_get_fps(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Float;

	@:native("libvlc_media_player_get_length")
	static function media_player_get_length(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):cpp.Int64;

	@:native("libvlc_media_player_new_from_media")
	static function media_player_new_from_media(p_md:cpp.RawPointer<LibVLC_Media_T>):cpp.RawPointer<LibVLC_MediaPlayer_T>;

	@:native("libvlc_video_set_format_callbacks")
	static function video_set_format_callbacks(mp:cpp.RawPointer<LibVLC_MediaPlayer_T>, setup:LibVLC_Video_Format_CB, cleanup:LibVLC_Video_Cleanup_CB):Void;

	@:native("libvlc_video_set_callbacks")
	static function video_set_callbacks(mp:cpp.RawPointer<LibVLC_MediaPlayer_T>, lock:LibVLC_Video_Lock_CB, unlock:LibVLC_Video_Unlock_CB,
		display:LibVLC_Video_Display_CB, opaque:cpp.Pointer<cpp.Void>):Void;

	@:native("libvlc_video_get_size")
	static function video_get_size(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>, num:UInt, width:cpp.Pointer<cpp.UInt32>, height:cpp.Pointer<cpp.UInt32>):Int;
}

typedef LibVLC_Callback_T = cpp.Callable<(p_event:cpp.RawConstPointer<LibVLC_Event_T>, p_data:cpp.RawPointer<cpp.Void>) -> Void>;

typedef LibVLC_Log_CB = cpp.Callable<(data:cpp.RawPointer<cpp.Void>, level:Int, ctx:cpp.RawConstPointer<LibVLC_Log_T>, fmt:cpp.ConstCharStar,
		args:cpp.VarList) -> Void>;

typedef LibVLC_Video_Format_CB = cpp.Callable<(opaque:cpp.RawPointer<cpp.RawPointer<cpp.Void>>, chroma:cpp.CharStar, width:cpp.RawPointer<cpp.UInt32>,
		height:cpp.RawPointer<cpp.UInt32>, pitches:cpp.RawPointer<cpp.UInt32>, lines:cpp.RawPointer<cpp.UInt32>) -> cpp.UInt32>;

typedef LibVLC_Video_Cleanup_CB = cpp.Callable<(opaque:cpp.RawPointer<cpp.Void>) -> Void>;
typedef LibVLC_Video_Lock_CB = cpp.Callable<(data:cpp.RawPointer<cpp.Void>, p_pixels:cpp.RawPointer<cpp.RawPointer<cpp.Void>>) -> cpp.RawPointer<cpp.Void>>;
typedef LibVLC_Video_Unlock_CB = cpp.Callable<(data:cpp.RawPointer<cpp.Void>, id:cpp.RawPointer<cpp.Void>, p_pixels:cpp.VoidStarConstStar) -> Void>;
typedef LibVLC_Video_Display_CB = cpp.Callable<(opaque:cpp.RawPointer<cpp.Void>, picture:cpp.RawPointer<cpp.Void>) -> Void>;

#if !windows
typedef LibVLC_Media_Open_CB = cpp.Callable<(opaque:cpp.RawPointer<cpp.Void>, datap:cpp.RawPointer<cpp.RawPointer<cpp.Void>>, sizep:cpp.RawPointer<cpp.UInt64>) -> Int>;
typedef LibVLC_Media_Read_CB = cpp.Callable<(opaque:cpp.RawPointer<cpp.Void>, buf:cpp.RawPointer<cpp.UInt8>, len:cpp.SizeT) -> cpp.SSizeT>;
typedef LibVLC_Media_Seek_CB = cpp.Callable<(opaque:cpp.RawPointer<cpp.Void>, offset:cpp.UInt64) -> Int>;
typedef LibVLC_Media_Close_CB = cpp.Callable<(opaque:cpp.RawPointer<cpp.Void>) -> Void>;
#end

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:keep
@:native("libvlc_log_t")
extern class LibVLC_Log_T {}

enum abstract LibVLC_Log_Level(Int) from Int to Int
{
	final LIBVLC_DEBUG = 0; /* Debug message */
	final LIBVLC_NOTICE = 2; /* Important informational message */
	final LIBVLC_WARNING = 3; /* Warning (potential error) message */
	final LIBVLC_ERROR = 4; /* Error message */
}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:keep
@:native("libvlc_instance_t")
extern class LibVLC_Instance_T {}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:keep
@:native("libvlc_media_t")
extern class LibVLC_Media_T {}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:keep
@:native("libvlc_media_player_t")
extern class LibVLC_MediaPlayer_T {}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:keep
@:native("libvlc_event_manager_t")
extern class LibVLC_EventManager_T {}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:keep
@:native("libvlc_event_t")
extern class LibVLC_Event_T {}

/**
 * Event types
 */
enum abstract LibVLC_Event_Type(Int) from Int to Int
{
	/**
	 * Append new event types at the end of a category.
	 * Do not remove, insert or re-order any entry.
	 * Keep this in sync with lib/event.c:libvlc_event_type_name().
	 */
	final LibVLC_MediaMetaChanged = 0;
	final LibVLC_MediaSubItemAdded = 1;
	final LibVLC_MediaDurationChanged = 2;
	final LibVLC_MediaParsedChanged = 3;
	final LibVLC_MediaFreed = 4;
	final LibVLC_MediaStateChanged = 5;
	final LibVLC_MediaSubItemTreeAdded = 6;

	final LibVLC_MediaPlayerMediaChanged = 256;
	final LibVLC_MediaPlayerNothingSpecial = 257;
	final LibVLC_MediaPlayerOpening = 258;
	final LibVLC_MediaPlayerBuffering = 259;
	final LibVLC_MediaPlayerPlaying = 260;
	final LibVLC_MediaPlayerPaused = 261;
	final LibVLC_MediaPlayerStopped = 262;
	final LibVLC_MediaPlayerForward = 263;
	final LibVLC_MediaPlayerBackward = 264;
	final LibVLC_MediaPlayerEndReached = 265;
	final LibVLC_MediaPlayerEncounteredError = 266;
	final LibVLC_MediaPlayerTimeChanged = 267;
	final LibVLC_MediaPlayerPositionChanged = 268;
	final LibVLC_MediaPlayerSeekableChanged = 269;
	final LibVLC_MediaPlayerPausableChanged = 270;
	final LibVLC_MediaPlayerTitleChanged = 271;
	final LibVLC_MediaPlayerSnapshotTaken = 272;
	final LibVLC_MediaPlayerLengthChanged = 273;
	final LibVLC_MediaPlayerVout = 274;
	final LibVLC_MediaPlayerScrambledChanged = 275;
	final LibVLC_MediaPlayerESAdded = 276;
	final LibVLC_MediaPlayerESDeleted = 277;
	final LibVLC_MediaPlayerESSelected = 278;
	final LibVLC_MediaPlayerCorked = 279;
	final LibVLC_MediaPlayerUncorked = 280;
	final LibVLC_MediaPlayerMuted = 281;
	final LibVLC_MediaPlayerUnmuted = 282;
	final LibVLC_MediaPlayerAudioVolume = 283;
	final LibVLC_MediaPlayerAudioDevice = 284;
	final LibVLC_MediaPlayerChapterChanged = 285;

	final LibVLC_MediaListItemAdded = 512;
	final LibVLC_MediaListWillAddItem = 513;
	final LibVLC_MediaListItemDeleted = 514;
	final LibVLC_MediaListWillDeleteItem = 515;
	final LibVLC_MediaListEndReached = 516;

	final LibVLC_MediaListViewItemAdded = 768;
	final LibVLC_MediaListViewWillAddItem = 769;
	final LibVLC_MediaListViewItemDeleted = 770;
	final LibVLC_MediaListViewWillDeleteItem = 771;

	final LibVLC_MediaListPlayerPlayed = 1024;
	final LibVLC_MediaListPlayerNextItemSet = 1025;
	final LibVLC_MediaListPlayerStopped = 1026;

	/* @deprecated Useless event, it will be triggered only when calling libvlc_media_discoverer_start(). */
	final LibVLC_MediaDiscovererStarted = 1280;

	/* @deprecated Useless event, it will be triggered only when calling libvlc_media_discoverer_stop(). */
	final LibVLC_MediaDiscovererEnded = 1281;

	final LibVLC_RendererDiscovererItemAdded = 1282;
	final LibVLC_RendererDiscovererItemDeleted = 1283;

	final LibVLC_VlmMediaAdded = 1536;
	final LibVLC_VlmMediaRemoved = 1537;
	final LibVLC_VlmMediaChanged = 1538;
	final LibVLC_VlmMediaInstanceStarted = 1539;
	final LibVLC_VlmMediaInstanceStopped = 1540;
	final LibVLC_VlmMediaInstanceStatusInit = 1541;
	final LibVLC_VlmMediaInstanceStatusOpening = 1542;
	final LibVLC_VlmMediaInstanceStatusPlaying = 1543;
	final LibVLC_VlmMediaInstanceStatusPause = 1544;
	final LibVLC_VlmMediaInstanceStatusEnd = 1545;
	final LibVLC_VlmMediaInstanceStatusError = 1546;
}

/**
 * Internal type for media parse flags.
 */
@:include('vlc/vlc.h')
@:unreflective
@:native('libvlc_media_parse_flag_t')
extern class LibVLC_Media_Parse_Flag_T {}

/**
 * Parse flags used by libvlc_media_parse_request()
 */
abstract LibVLC_Media_Parse_Flag(Int) from Int to Int
{
	public inline function new(i:Int):Void
		this = i;

	/**
	 * Convert the field to its internal native type.
	 * @return A value of the internal type.
	 */
	@:to(LibVLC_Media_Parse_Flag_T)
	@:unreflective
	public inline function toNative():LibVLC_Media_Parse_Flag_T
		return untyped __cpp__('((libvlc_media_parse_flag_t)({0}))', this);

	/**
	 * Conver the internal native type to an enum.
	 * @param value A value of the native type.
	 * @return A value of the enum value.
	 */
	@:from(LibVLC_Media_Parse_Flag_T)
	@:unreflective
	public static inline function fromNative(value:LibVLC_Media_Parse_Flag_T):LibVLC_Media_Parse_Flag
		return new LibVLC_Media_Parse_Flag(untyped value);

	/**
	 * Parse media if it's a local file.
	 */
	public static var media_parse_local(default, null):Int = new LibVLC_Media_Parse_Flag(untyped __cpp__('libvlc_media_parse_local'));

	/**
	 * Parse media even if it's a network file.
	 */
	public static var media_parse_network(default, null):Int = new LibVLC_Media_Parse_Flag(untyped __cpp__('libvlc_media_parse_network'));

	/**
	 * Fetch meta and cover art using local resources.
	 */
	public static var media_fetch_local(default, null):Int = new LibVLC_Media_Parse_Flag(untyped __cpp__('libvlc_media_fetch_local'));

	/**
	 * Fetch meta and cover art using network resources.
	 */
	public static var media_fetch_network(default, null):Int = new LibVLC_Media_Parse_Flag(untyped __cpp__('libvlc_media_fetch_network'));
}

enum abstract LibVLC_Media_Parsed_Status(Int) from Int to Int
{
	final LibVLC_Media_Parsed_Status_Skipped = 1;
	final LibVLC_Media_Parsed_Status_Failed = 2;
	final LibVLC_Media_Parsed_Status_Timeout = 3;
	final LibVLC_Media_Parsed_Status_Done = 4;
}
