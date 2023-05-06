/**
 * ...
 * @author: Datee
 * @additional coding: M.A. Jigsaw
 *
 * This contains some LibVLC externs which you can use in Haxe by using cpp target.
 */

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

	@:native("libvlc_audio_output_list_get")
	static function audio_output_list_get(p_instance:cpp.RawPointer<LibVLC_Instance_T>):cpp.RawPointer<LibVLC_AudioOutput_T>;

	@:native("libvlc_audio_output_list_release")
	static function audio_output_list_release(p_list:cpp.RawPointer<LibVLC_AudioOutput_T>):Void;

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
	static function event_attach(p_event_manager:cpp.RawPointer<LibVLC_EventManager_T>, i_event_type:LibVLC_EventType, f_callback:LibVLC_Event_Callback,
		user_data:cpp.Pointer<cpp.Void>):Int;

	@:native("libvlc_event_detach")
	static function event_detach(p_event_manager:cpp.RawPointer<LibVLC_EventManager_T>, i_event_type:LibVLC_EventType, f_callback:LibVLC_Event_Callback,
		user_data:cpp.Pointer<cpp.Void>):Int;

	@:native("libvlc_media_new_path")
	static function media_new_path(p_instance:cpp.RawPointer<LibVLC_Instance_T>, path:cpp.ConstCharStar):cpp.RawPointer<LibVLC_Media_T>;

	@:native("libvlc_media_new_location")
	static function media_new_location(p_instance:cpp.RawPointer<LibVLC_Instance_T>, psz_mrl:cpp.ConstCharStar):cpp.RawPointer<LibVLC_Media_T>;

	@:native("libvlc_media_add_option")
	static function media_add_option(p_md:cpp.RawPointer<LibVLC_Media_T>, psz_options:cpp.ConstCharStar):Void;

	@:native("libvlc_media_add_option_flag")
	static function media_add_option_flag(p_md:cpp.RawPointer<LibVLC_Media_T>, psz_options:cpp.ConstCharStar, i_flags:cpp.UInt32):Void;

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
	static function video_set_format_callbacks(mp:cpp.RawPointer<LibVLC_MediaPlayer_T>, setup:LibVLC_Video_Setup_Callback,
		cleanup:LibVLC_Video_Cleanup_Callback):Void;

	@:native("libvlc_video_set_callbacks")
	static function video_set_callbacks(mp:cpp.RawPointer<LibVLC_MediaPlayer_T>, lock:LibVLC_Video_Lock_Callback, unlock:LibVLC_Video_Unlock_Callback,
		display:LibVLC_Video_Display_Callback, opaque:cpp.Pointer<cpp.Void>):Void;

	@:native("libvlc_video_get_size")
	static function video_get_size(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>, num:UInt, width:cpp.Pointer<cpp.UInt32>, height:cpp.Pointer<cpp.UInt32>):Int;

	@:native('libvlc_log_get_context')
	static function log_get_context(ctx:cpp.RawConstPointer<LibVLC_Log_T>, module:cpp.RawPointer<cpp.ConstCharStar>, file:cpp.RawPointer<cpp.ConstCharStar>, line:cpp.Pointer<cpp.UInt32>):Void;

	@:native('libvlc_log_get_object')
	static function log_get_object(ctx:cpp.RawConstPointer<LibVLC_Log_T>, name:cpp.RawPointer<cpp.ConstCharStar>, header:cpp.RawPointer<cpp.ConstCharStar>, id:cpp.Pointer<cpp.UInt32>):Void;

	@:native('libvlc_log_unset')
	static function log_unset(p_instance:cpp.RawPointer<LibVLC_Instance_T>):Void;

	@:native('libvlc_log_set')
	static function log_set(p_instance:cpp.RawPointer<LibVLC_Instance_T>, cb:LibVLC_Log_CB, data:cpp.Pointer<cpp.Void>):Void;

	@:native('libvlc_log_set_file')
	static function log_set_file(p_instance:cpp.RawPointer<LibVLC_Instance_T>, stream:cpp.FILE):Void;
}

typedef LibVLC_Log_CB = cpp.Callable<(data:cpp.RawPointer<cpp.Void>, level:Int, ctx:cpp.RawConstPointer<LibVLC_Log_T>, fmt:cpp.ConstCharStar,
		args:cpp.VarList) -> Void>;

typedef LibVLC_Event_Callback = cpp.Callable<(p_event:cpp.RawConstPointer<LibVLC_Event_T>, p_data:cpp.RawPointer<cpp.Void>) -> Void>;

typedef LibVLC_Video_Setup_Callback = cpp.Callable<(opaque:cpp.RawPointer<cpp.RawPointer<cpp.Void>>, chroma:cpp.CharStar, width:cpp.RawPointer<cpp.UInt32>,
		height:cpp.RawPointer<cpp.UInt32>, pitches:cpp.RawPointer<cpp.UInt32>, lines:cpp.RawPointer<cpp.UInt32>) -> cpp.UInt32>;

typedef LibVLC_Video_Cleanup_Callback = cpp.Callable<(opaque:cpp.RawPointer<cpp.Void>) -> Void>;

typedef LibVLC_Video_Lock_Callback = cpp.Callable<(data:cpp.RawPointer<cpp.Void>,
		p_pixels:cpp.RawPointer<cpp.RawPointer<cpp.Void>>) -> cpp.RawPointer<cpp.Void>>;

typedef LibVLC_Video_Unlock_Callback = cpp.Callable<(data:cpp.RawPointer<cpp.Void>, id:cpp.RawPointer<cpp.Void>, p_pixels:VoidStarConstStar) -> Void>;
typedef LibVLC_Video_Display_Callback = cpp.Callable<(opaque:cpp.RawPointer<cpp.Void>, picture:cpp.RawPointer<cpp.Void>) -> Void>;

@:native("void *const *")
extern class VoidStarConstStar {}

@:buildXml('<include name="${haxelib:hxvlc}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:keep
@:native("libvlc_log_t")
extern class LibVLC_Log_T {}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:keep
@:native("libvlc_instance_t")
extern class LibVLC_Instance_T {}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:keep
@:native("libvlc_audio_output_t")
extern class LibVLC_AudioOutput_T {}

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
@:structAccess
@:keep
@:native("libvlc_event_t")
extern class LibVLC_Event_T
{
	var type:LibVLC_EventType;
	var u:LibVLC_Event_U;
}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
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

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("media_player_position_changed")
extern class LibVLC_MediaPlayer_PositionChanged
{
	var new_position:Float;
}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("media_player_time_changed")
extern class LibVLC_MediaPlayer_TimeChanged
{
	var new_time:cpp.Int64;
}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("media_player_length_changed")
extern class LibVLC_MediaPlayer_LengthChanged
{
	var new_length:cpp.Int64;
}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("media_player_buffering")
extern class LibVLC_MediaPlayer_Buffering
{
	var new_cache:Float;
}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("media_player_seekable_changed")
extern class LibVLC_MediaPlayer_SeekableChanged
{
	var new_seekable:Bool;
}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("media_player_pausable_changed")
extern class LibVLC_MediaPlayer_PausableChanged
{
	var new_pausable:Bool;
}

enum abstract LibVLC_Log_Level(Int) from Int to Int
{
	final LIBVLC_DEBUG = 0; /* Debug message */
	final LIBVLC_NOTICE = 2; /* Important informational message */
	final LIBVLC_WARNING = 3; /* Warning (potential error) message */
	final LIBVLC_ERROR = 4; /* Error message */
}

enum abstract LibVLC_EventType(Int) from Int to Int
{
	final MediaMetaChanged = 0;
	final MediaSubItemAdded = 1;
	final MediaDurationChanged = 2;
	final MediaParsedChanged = 3;
	final MediaFreed = 4;
	final MediaStateChanged = 5;
	final MediaSubItemTreeAdded = 6;
	final MediaPlayerMediaChanged = 256;
	final MediaPlayerNothingSpecial = 257;
	final MediaPlayerOpening = 258;
	final MediaPlayerBuffering = 259;
	final MediaPlayerPlaying = 260;
	final MediaPlayerPaused = 261;
	final MediaPlayerStopped = 262;
	final MediaPlayerForward = 263;
	final MediaPlayerBackward = 264;
	final MediaPlayerEndReached = 265;
	final MediaPlayerEncounteredError = 266;
	final MediaPlayerTimeChanged = 267;
	final MediaPlayerPositionChanged = 268;
	final MediaPlayerSeekableChanged = 269;
	final MediaPlayerPausableChanged = 270;
	final MediaPlayerTitleChanged = 271;
	final MediaPlayerSnapshotTaken = 272;
	final MediaPlayerLengthChanged = 273;
	final MediaPlayerVout = 274;
	final MediaPlayerScrambledChanged = 275;
	final MediaPlayerCorked = 279;
	final MediaPlayerUncorked = 280;
	final MediaPlayerMuted = 281;
	final MediaPlayerUnmuted = 282;
	final MediaPlayerAudioVolume = 283;
	final MediaListItemAdded = 512;
	final MediaListWillAddItem = 513;
	final MediaListItemDeleted = 514;
	final MediaListWillDeleteItem = 515;
	final MediaListViewItemAdded = 768;
	final MediaListViewWillAddItem = 769;
	final MediaListViewItemDeleted = 770;
	final MediaListViewWillDeleteItem = 771;
	final MediaListPlayerPlayed = 1024;
	final MediaListPlayerNextItemSet = 1025;
	final MediaListPlayerStopped = 1026;
}
