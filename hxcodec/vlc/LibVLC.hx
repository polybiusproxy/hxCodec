/**
 * ...
 * @author: Datee
 * @additional coding: M.A. Jigsaw
 *
 * This contains some LibVLC externs which you can use in Haxe by using cpp target.
 */

package hxcodec.vlc;

#if (!(desktop || android) && macro)
#error "The current target platform isn't supported by hxCodec. If you are targeting Windows/Mac/Linux/Android and you are getting this message, please contact us.";
#end

@:buildXml("<include name='${haxelib:hxCodec}/project/Build.xml' />")
@:include("vlc/vlc.h")
@:unreflective
@:keep
extern class LibVLC
{
	@:native("libvlc_new")
	static function init(argc:Int, argv:cpp.RawConstPointer<cpp.ConstCharStar>):cpp.RawPointer<LibVLC_Instance_T>;

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
	static function media_player_play(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Void;

	@:native("libvlc_media_player_stop")
	static function media_player_stop(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Void;

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
	static function media_player_new_from_media(p_md:LibVLC_Media):cpp.RawPointer<LibVLC_MediaPlayer_T>;

	@:native("libvlc_video_set_format_callbacks")
	static function video_set_format_callbacks(mp:cpp.RawPointer<LibVLC_MediaPlayer_T>, setup:LibVLC_Video_Setup_Callback, cleanup:LibVLC_Video_Cleanup_Callback):Void;

	@:native("libvlc_video_set_callbacks")
	static function video_set_callbacks(mp:cpp.RawPointer<LibVLC_MediaPlayer_T>, lock:LibVLC_Video_Lock_Callback, unlock:LibVLC_Video_Unlock_Callback,
		display:LibVLC_Video_Display_Callback, opaque:cpp.Pointer<cpp.Void>):Void;

	@:native("libvlc_video_get_size")
	static function video_get_size(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>, num:UInt, width:cpp.Pointer<cpp.UInt32>, height:cpp.Pointer<cpp.UInt32>):Int;
}

typedef LibVLC_Event_Callback = cpp.Callable<(p_event:cpp.RawConstPointer<LibVLC_Event_T>, p_data:cpp.Pointer<cpp.Void>) -> Void>;
typedef LibVLC_Video_Setup_Callback = cpp.Callable<(opaque:cpp.Pointer<cpp.Pointer<cpp.Void>>, chroma:cpp.Pointer<cpp.Char>, width:cpp.Pointer<cpp.UInt32>, height:cpp.Pointer<cpp.UInt32>, pitches:cpp.Pointer<cpp.UInt32>, lines:cpp.Pointer<cpp.UInt32>) -> cpp.UInt32>;
typedef LibVLC_Video_Cleanup_Callback = cpp.Callable<(opaque:cpp.Pointer<cpp.Void>) -> Void>;
typedef LibVLC_Video_Lock_Callback = cpp.Callable<(data:cpp.Pointer<cpp.Void>, p_pixels:cpp.Pointer<cpp.Pointer<cpp.Void>>) -> cpp.Pointer<cpp.Void>>;
typedef LibVLC_Video_Unlock_Callback = cpp.Callable<(data:cpp.Pointer<cpp.Void>, id:cpp.Pointer<cpp.Void>, p_pixels:hxcodec.vlc.helpers.VoidStarConstStar) -> Void>;
typedef LibVLC_Video_Display_Callback = cpp.Callable<(opaque:cpp.Pointer<cpp.Void>, picture:cpp.Pointer<cpp.Void>) -> Void>;

@:buildXml("<include name='${haxelib:hxCodec}/project/Build.xml' />")
@:include("vlc/vlc.h")
@:keep
@:native("libvlc_instance_t")
extern class LibVLC_Instance_T {}

@:buildXml("<include name='${haxelib:hxCodec}/project/Build.xml' />")
@:include("vlc/vlc.h")
@:keep
@:native("libvlc_audio_output_t")
extern class LibVLC_AudioOutput_T {}

@:buildXml("<include name='${haxelib:hxCodec}/project/Build.xml' />")
@:include("vlc/vlc.h")
@:keep
@:native("libvlc_media_t")
extern class LibVLC_Media_T {}

@:buildXml("<include name='${haxelib:hxCodec}/project/Build.xml' />")
@:include("vlc/vlc.h")
@:keep
@:native("libvlc_media_player_t")
extern class LibVLC_MediaPlayer_T {}

@:buildXml("<include name='${haxelib:hxCodec}/project/Build.xml' />")
@:include("vlc/vlc.h")
@:keep
@:native("libvlc_event_manager_t")
extern class LibVLC_EventManager_T {}

@:buildXml("<include name='${haxelib:hxCodec}/project/Build.xml' />")
@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("libvlc_event_t")
extern class LibVLC_Event_T
{
	var type:LibVLC_EventType;
	var u:LibVLC_Event_U;
}

@:buildXml("<include name='${haxelib:hxCodec}/project/Build.xml' />")
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

@:buildXml("<include name='${haxelib:hxCodec}/project/Build.xml' />")
@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("media_player_position_changed")
extern class LibVLC_MediaPlayer_PositionChanged
{
	var new_position:Float;
}

@:buildXml("<include name='${haxelib:hxCodec}/project/Build.xml' />")
@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("media_player_time_changed")
extern class LibVLC_MediaPlayer_TimeChanged
{
	var new_time:cpp.Int64;
}

@:buildXml("<include name='${haxelib:hxCodec}/project/Build.xml' />")
@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("media_player_length_changed")
extern class LibVLC_MediaPlayer_LengthChanged
{
	var new_length:cpp.Int64;
}

@:buildXml("<include name='${haxelib:hxCodec}/project/Build.xml' />")
@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("media_player_buffering")
extern class LibVLC_MediaPlayer_Buffering
{
	var new_cache:Float;
}

@:buildXml("<include name='${haxelib:hxCodec}/project/Build.xml' />")
@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("media_player_seekable_changed")
extern class LibVLC_MediaPlayer_SeekableChanged
{
	var new_seekable:Bool;
}

@:buildXml("<include name='${haxelib:hxCodec}/project/Build.xml' />")
@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("media_player_pausable_changed")
extern class LibVLC_MediaPlayer_PausableChanged
{
	var new_pausable:Bool;
}

enum abstract LibVLC_EventType(Int) from Int to Int
{
	var MediaMetaChanged = 0;
	var MediaSubItemAdded = 1;
	var MediaDurationChanged = 2;
	var MediaParsedChanged = 3;
	var MediaFreed = 4;
	var MediaStateChanged = 5;
	var MediaSubItemTreeAdded = 6;
	var MediaPlayerMediaChanged = 256;
	var MediaPlayerNothingSpecial = 257;
	var MediaPlayerOpening = 258;
	var MediaPlayerBuffering = 259;
	var MediaPlayerPlaying = 260;
	var MediaPlayerPaused = 261;
	var MediaPlayerStopped = 262;
	var MediaPlayerForward = 263;
	var MediaPlayerBackward = 264;
	var MediaPlayerEndReached = 265;
	var MediaPlayerEncounteredError = 266;
	var MediaPlayerTimeChanged = 267;
	var MediaPlayerPositionChanged = 268;
	var MediaPlayerSeekableChanged = 269;
	var MediaPlayerPausableChanged = 270;
	var MediaPlayerTitleChanged = 271;
	var MediaPlayerSnapshotTaken = 272;
	var MediaPlayerLengthChanged = 273;
	var MediaPlayerVout = 274;
	var MediaPlayerScrambledChanged = 275;
	var MediaPlayerCorked = 279;
	var MediaPlayerUncorked = 280;
	var MediaPlayerMuted = 281;
	var MediaPlayerUnmuted = 282;
	var MediaPlayerAudioVolume = 283;
	var MediaListItemAdded = 512;
	var MediaListWillAddItem = 513;
	var MediaListItemDeleted = 514;
	var MediaListWillDeleteItem = 515;
	var MediaListViewItemAdded = 768;
	var MediaListViewWillAddItem = 769;
	var MediaListViewItemDeleted = 770;
	var MediaListViewWillDeleteItem = 771;
	var MediaListPlayerPlayed = 1024;
	var MediaListPlayerNextItemSet = 1025;
	var MediaListPlayerStopped = 1026;
}
