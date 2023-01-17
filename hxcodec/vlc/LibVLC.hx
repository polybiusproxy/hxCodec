/**
 * ...
 * @author: Datee
 * @additional coding: M.A. Jigsaw
 *
 * This contains some LibVLC externs which you can use in Haxe by using cpp target.
 */

package hxcodec.vlc;

#if !(desktop || android)
#error "The current target platform isn't supported by hxCodec. If you are targeting Windows/Mac/Linux/Android and you are getting this message, please contact us.";
#end
import cpp.RawPointer;
import cpp.RawConstPointer;
import cpp.Int64;
import cpp.UInt32;
import hxcodec.vlc.helpers.VoidStarConstStar;

typedef LibVLC_Instance = RawPointer<LibVLC_Instance_T>;
typedef LibVLC_AudioOutput = RawPointer<LibVLC_AudioOutput_T>;
typedef LibVLC_MediaPlayer = RawPointer<LibVLC_MediaPlayer_T>;
typedef LibVLC_Media = RawPointer<LibVLC_Media_T>;
typedef LibVLC_EventManager = RawPointer<LibVLC_EventManager_T>;

@:buildXml("<include name='${haxelib:hxCodec}/hxcodec/vlc/LibVLCBuild.xml' />")
@:include("vlc/vlc.h")
@:unreflective
@:keep
extern class LibVLC
{
	@:native("libvlc_new")
	static function init(argc:Int, argv:RawConstPointer<String>):LibVLC_Instance;

	@:native("libvlc_release")
	static function release(p_instance:LibVLC_Instance):Void;

	@:native("libvlc_retain")
	static function retain(p_instance:LibVLC_Instance):Void;

	@:native("libvlc_free")
	static function free(ptr:cpp.Star<cpp.Void>):Void;

	@:native("libvlc_errmsg")
	static function errmsg():String;

	@:native("libvlc_clearerr")
	static function clearerr():Void;

	@:native("libvlc_printerr")
	static function printerr(fmt:String):String;

	@:native("libvlc_get_version")
	static function get_version():String;

	@:native("libvlc_get_compiler")
	static function get_compiler():String;

	@:native("libvlc_get_changeset")
	static function get_changeset():String;

	@:native("libvlc_audio_output_list_get")
	static function audio_output_list_get(p_instance:LibVLC_Instance):LibVLC_AudioOutput;

	@:native("libvlc_audio_output_list_release")
	static function audio_output_list_release(p_list:LibVLC_AudioOutput):Void;

	@:native("libvlc_audio_output_set")
	static function audio_output_set(p_mi:LibVLC_MediaPlayer, deviceName:String):Void;

	@:native("libvlc_audio_get_delay")
	static function audio_get_delay(p_mi:LibVLC_MediaPlayer):Int64;

	@:native("libvlc_audio_set_delay")
	static function audio_set_delay(p_mi:LibVLC_MediaPlayer, i_delay:Int64):Int;

	@:native("libvlc_audio_get_volume")
	static function audio_get_volume(p_mi:LibVLC_MediaPlayer):Int;

	@:native("libvlc_audio_set_volume")
	static function audio_set_volume(p_mi:LibVLC_MediaPlayer, i_volume:Int):Int;

	@:native("libvlc_event_attach")
	static function event_attach(p_event_manager:LibVLC_EventManager, i_event_type:LibVLC_EventType, f_callback:LibVLC_Event_Callback,
		user_data:cpp.Star<cpp.Void>):Int;

	@:native("libvlc_event_detach")
	static function event_detach(p_event_manager:LibVLC_EventManager, i_event_type:LibVLC_EventType, f_callback:LibVLC_Event_Callback,
		user_data:cpp.Star<cpp.Void>):Int;

	@:native("libvlc_media_new_path")
	static function media_new_path(p_instance:LibVLC_Instance, path:String):LibVLC_Media;

	@:native("libvlc_media_new_location")
	static function media_new_location(p_instance:LibVLC_Instance, psz_mrl:String):LibVLC_Media;

	@:native("libvlc_media_add_option")
	static function media_add_option(p_md:LibVLC_Media, psz_options:String):Void;

	@:native("libvlc_media_add_option_flag")
	static function media_add_option_flag(p_md:LibVLC_Media, psz_options:String, i_flags:UInt32):Void;

	@:native("libvlc_media_get_duration")
	static function media_get_duration(p_md:LibVLC_Media):Int64;

	@:native("libvlc_media_get_mrl")
	static function media_get_mrl(p_md:LibVLC_Media):String;

	@:native("libvlc_media_release")
	static function media_release(p_md:LibVLC_Media):Void;

	@:native("libvlc_media_retain")
	static function media_retain(p_md:LibVLC_Media):Void;

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

	@:native("libvlc_media_player_is_seekable")
	static function media_player_is_seekable(p_mi:LibVLC_MediaPlayer):Bool;

	@:native("libvlc_media_player_can_pause")
	static function media_player_can_pause(p_mi:LibVLC_MediaPlayer):Bool;

	@:native("libvlc_media_player_release")
	static function media_player_release(p_mi:LibVLC_MediaPlayer):Void;

	@:native("libvlc_media_player_retain")
	static function media_player_retain(p_mi:LibVLC_MediaPlayer):Void;

	@:native("libvlc_media_player_event_manager")
	static function media_player_event_manager(mp:LibVLC_MediaPlayer):LibVLC_EventManager;

	@:native("libvlc_media_player_get_time")
	static function media_player_get_time(p_mi:LibVLC_MediaPlayer):Int64;

	@:native("libvlc_media_player_set_time")
	static function media_player_set_time(p_mi:LibVLC_MediaPlayer, i_time:Int64):Int;

	@:native("libvlc_media_player_get_position")
	static function media_player_get_position(p_mi:LibVLC_MediaPlayer):Float;

	@:native("libvlc_media_player_set_position")
	static function media_player_set_position(p_mi:LibVLC_MediaPlayer, f_pos:Float):Int;

	@:native("libvlc_media_player_get_rate")
	static function media_player_get_rate(p_mi:LibVLC_MediaPlayer):Float;

	@:native("libvlc_media_player_set_rate")
	static function media_player_set_rate(p_mi:LibVLC_MediaPlayer, rate:Float):Int;

	@:native("libvlc_media_player_get_fps")
	static function media_player_get_fps(p_mi:LibVLC_MediaPlayer):Float;

	@:native("libvlc_media_player_get_length")
	static function media_player_get_length(p_mi:LibVLC_MediaPlayer):Int64;

	@:native("libvlc_media_player_new_from_media")
	static function media_player_new_from_media(p_md:LibVLC_Media):LibVLC_MediaPlayer;

	@:native("libvlc_video_set_format_callbacks")
	static function video_set_format_callbacks(mp:LibVLC_MediaPlayer, setup:LibVLC_Video_Setup_Callback, cleanup:LibVLC_Video_Cleanup_Callback):Void;

	@:native("libvlc_video_set_callbacks")
	static function video_set_callbacks(mp:LibVLC_MediaPlayer, lock:LibVLC_Video_Lock_Callback, unlock:LibVLC_Video_Unlock_Callback,
		display:LibVLC_Video_Display_Callback, opaque:cpp.Star<cpp.Void>):Void;

	@:native("libvlc_video_get_size")
	static function video_get_size(p_mi:LibVLC_MediaPlayer, num:UInt, width:cpp.Star<UInt32>, height:cpp.Star<UInt32>):Int;
}

typedef LibVLC_Event_Callback = cpp.Callable<(p_event:RawConstPointer<LibVLC_Event_T>, p_data:cpp.Star<cpp.Void>) -> Void>;
typedef LibVLC_Video_Setup_Callback = cpp.Callable<(opaque:cpp.Star<cpp.Star<cpp.Void>>, chroma:cpp.Star<cpp.Char>, width:cpp.Star<UInt32>, height:cpp.Star<UInt32>, pitches:cpp.Star<UInt32>, lines:cpp.Star<UInt32>) -> UInt32>;
typedef LibVLC_Video_Cleanup_Callback = cpp.Callable<(opaque:cpp.Star<cpp.Void>) -> Void>;
typedef LibVLC_Video_Lock_Callback = cpp.Callable<(data:cpp.Star<cpp.Void>, p_pixels:cpp.Star<cpp.Star<cpp.Void>>) -> cpp.Star<cpp.Void>>;
typedef LibVLC_Video_Unlock_Callback = cpp.Callable<(data:cpp.Star<cpp.Void>, id:cpp.Star<cpp.Void>, p_pixels:VoidStarConstStar) -> Void>;
typedef LibVLC_Video_Display_Callback = cpp.Callable<(opaque:cpp.Star<cpp.Void>, picture:cpp.Star<cpp.Void>) -> Void>;

@:include("vlc/vlc.h")
@:keep
@:native("libvlc_instance_t")
extern class LibVLC_Instance_T {}

@:include("vlc/vlc.h")
@:keep
@:native("libvlc_audio_output_t")
extern class LibVLC_AudioOutput_T {}

@:include("vlc/vlc.h")
@:keep
@:native("libvlc_media_t")
extern class LibVLC_Media_T {}

@:include("vlc/vlc.h")
@:keep
@:native("libvlc_media_player_t")
extern class LibVLC_MediaPlayer_T {}

@:include("vlc/vlc.h")
@:keep
@:native("libvlc_event_manager_t")
extern class LibVLC_EventManager_T {}

@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("libvlc_event_t")
extern class LibVLC_Event_T
{
	var type:LibVLC_EventType;
	var u:LibVLC_Event_U;
}

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

@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("media_player_position_changed")
extern class LibVLC_MediaPlayer_PositionChanged
{
	var new_position:Float;
}

@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("media_player_time_changed")
extern class LibVLC_MediaPlayer_TimeChanged
{
	var new_time:Int64;
}

@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("media_player_length_changed")
extern class LibVLC_MediaPlayer_LengthChanged
{
	var new_length:Int64;
}

@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("media_player_buffering")
extern class LibVLC_MediaPlayer_Buffering
{
	var new_cache:Float;
}

@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("media_player_seekable_changed")
extern class LibVLC_MediaPlayer_SeekableChanged
{
	var new_seekable:Bool;
}

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
