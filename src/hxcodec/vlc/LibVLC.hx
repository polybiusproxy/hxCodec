package hxcodec.vlc;

#if (!(desktop || android) && macro)
#error "The current target platform isn't supported by hxCodec. If you're targeting Windows/Mac/Linux/Android and getting this message, please contact us."
#end

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:unreflective
extern class LibVLC
{
	@:native("libvlc_new")
	static function create(argc:Int, argv:cpp.ConstCharStarConstStar):cpp.RawPointer<LibVLC_Instance_T>;

	@:native("libvlc_release")
	static function release(p_instance:cpp.RawPointer<LibVLC_Instance_T>):Void;

	@:native("libvlc_get_version")
	static function get_version():cpp.ConstCharStar;

	@:native("libvlc_get_compiler")
	static function get_compiler():cpp.ConstCharStar;

	@:native("libvlc_event_attach")
	static function event_attach(p_event_manager:cpp.RawPointer<LibVLC_EventManager_T>, i_event_type:LibVLC_Event_Type, f_callback:LibVLC_Callback_T,
		user_data:cpp.Pointer<cpp.Void>):Int;

	@:native("libvlc_event_detach")
	static function event_detach(p_event_manager:cpp.RawPointer<LibVLC_EventManager_T>, i_event_type:LibVLC_Event_Type, f_callback:LibVLC_Callback_T,
		user_data:cpp.Pointer<cpp.Void>):Void;

	@:native('libvlc_log_unset')
	static function log_unset(p_instance:cpp.RawPointer<LibVLC_Instance_T>):Void;

	@:native('libvlc_log_set')
	static function log_set(p_instance:cpp.RawPointer<LibVLC_Instance_T>, cb:LibVLC_Log_CB, data:cpp.Pointer<cpp.Void>):Void;

	@:native("libvlc_media_new_path")
	static function media_new_path(p_instance:cpp.RawPointer<LibVLC_Instance_T>, path:cpp.ConstCharStar):cpp.RawPointer<LibVLC_Media_T>;

	@:native("libvlc_media_new_location")
	static function media_new_location(p_instance:cpp.RawPointer<LibVLC_Instance_T>, psz_mrl:cpp.ConstCharStar):cpp.RawPointer<LibVLC_Media_T>;

	@:native("libvlc_media_add_option")
	static function media_add_option(p_md:cpp.RawPointer<LibVLC_Media_T>, psz_options:cpp.ConstCharStar):Void;

	@:native("libvlc_media_add_option_flag")
	static function media_add_option_flag(p_md:cpp.RawPointer<LibVLC_Media_T>, psz_options:cpp.ConstCharStar, i_flags:UInt):Void;

	@:native("libvlc_media_release")
	static function media_release(p_md:cpp.RawPointer<LibVLC_Media_T>):Void;

	@:native("libvlc_media_event_manager")
	static function media_event_manager(p_md:cpp.RawPointer<LibVLC_Media_T>):cpp.RawPointer<LibVLC_EventManager_T>;

	@:native("libvlc_media_get_duration")
	static function media_get_duration(p_md:cpp.RawPointer<LibVLC_Media_T>):cpp.Int64;

	@:native("libvlc_media_get_mrl")
	static function media_get_mrl(p_md:cpp.RawPointer<LibVLC_Media_T>):cpp.ConstCharStar;

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

	@:native("libvlc_media_player_event_manager")
	static function media_player_event_manager(mp:cpp.RawPointer<LibVLC_MediaPlayer_T>):cpp.RawPointer<LibVLC_EventManager_T>;

	@:native("libvlc_media_player_get_time")
	static function media_player_get_time(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):cpp.Int64;

	@:native("libvlc_media_player_set_time")
	static function media_player_set_time(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>, i_time:cpp.Int64):Int;

	@:native("libvlc_media_player_get_position")
	static function media_player_get_position(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Single;

	@:native("libvlc_media_player_set_position")
	static function media_player_set_position(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>, f_pos:Single):Int;

	@:native("libvlc_media_player_get_rate")
	static function media_player_get_rate(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Single;

	@:native("libvlc_media_player_set_rate")
	static function media_player_set_rate(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>, rate:Single):Int;

	@:native("libvlc_media_player_get_role")
	static function media_player_get_role(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Int;

	@:native("libvlc_media_player_set_role")
	static function media_player_set_role(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>, role:UInt):Int;

	@:native("libvlc_media_player_get_length")
	static function media_player_get_length(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):cpp.Int64;

	@:native("libvlc_media_player_new_from_media")
	static function media_player_new_from_media(p_md:cpp.RawPointer<LibVLC_Media_T>):cpp.RawPointer<LibVLC_MediaPlayer_T>;

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

	@:native("libvlc_audio_get_channel")
	static function audio_get_channel(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>):Int;

	@:native("libvlc_audio_set_channel")
	static function audio_set_channel(p_mi:cpp.RawPointer<LibVLC_MediaPlayer_T>, channel:Int):Int;

	@:native("libvlc_video_set_format_callbacks")
	static function video_set_format_callbacks(mp:cpp.RawPointer<LibVLC_MediaPlayer_T>, setup:LibVLC_Video_Format_CB, cleanup:LibVLC_Video_Cleanup_CB):Void;

	@:native("libvlc_video_set_callbacks")
	static function video_set_callbacks(mp:cpp.RawPointer<LibVLC_MediaPlayer_T>, lock:LibVLC_Video_Lock_CB, unlock:LibVLC_Video_Unlock_CB,
		display:LibVLC_Video_Display_CB, opaque:cpp.Pointer<cpp.Void>):Void;
}

typedef LibVLC_Callback_T = cpp.Callable<(p_event:cpp.RawConstPointer<LibVLC_Event_T>, p_data:cpp.RawPointer<cpp.Void>) -> Void>;

typedef LibVLC_Log_CB = cpp.Callable<(data:cpp.RawPointer<cpp.Void>, level:Int, ctx:cpp.RawConstPointer<LibVLC_Log_T>, fmt:cpp.ConstCharStar,
		args:cpp.VarList) -> Void>;

typedef LibVLC_Video_Format_CB = cpp.Callable<(opaque:cpp.RawPointer<cpp.RawPointer<cpp.Void>>, chroma:cpp.CharStar, width:cpp.RawPointer<UInt>,
		height:cpp.RawPointer<UInt>, pitches:cpp.RawPointer<UInt>, lines:cpp.RawPointer<UInt>) -> UInt>;

typedef LibVLC_Video_Cleanup_CB = cpp.Callable<(opaque:cpp.RawPointer<cpp.Void>) -> Void>;
typedef LibVLC_Video_Lock_CB = cpp.Callable<(data:cpp.RawPointer<cpp.Void>, p_pixels:cpp.RawPointer<cpp.RawPointer<cpp.Void>>) -> cpp.RawPointer<cpp.Void>>;
typedef LibVLC_Video_Unlock_CB = cpp.Callable<(data:cpp.RawPointer<cpp.Void>, id:cpp.RawPointer<cpp.Void>, p_pixels:cpp.VoidStarConstStar) -> Void>;
typedef LibVLC_Video_Display_CB = cpp.Callable<(opaque:cpp.RawPointer<cpp.Void>, picture:cpp.RawPointer<cpp.Void>) -> Void>;

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
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
@:native("libvlc_instance_t")
extern class LibVLC_Instance_T {}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:native("libvlc_media_t")
extern class LibVLC_Media_T {}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:native("libvlc_media_player_t")
extern class LibVLC_MediaPlayer_T {}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:native("libvlc_event_manager_t")
extern class LibVLC_EventManager_T {}

@:buildXml('<include name="${haxelib:hxCodec}/project/Build.xml" />')
@:include("vlc/vlc.h")
@:native("libvlc_event_t")
extern class LibVLC_Event_T {}

/**
 * Event types.
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
 * Audio channels.
 */
enum abstract LibVLC_Audio_Output_Channel(Int) from Int to Int
{
	final LibVLC_AudioChannel_Error = -1;
	final LibVLC_AudioChannel_Stereo = 1;
	final LibVLC_AudioChannel_RStereo = 2;
	final LibVLC_AudioChannel_Left = 3;
	final LibVLC_AudioChannel_Right = 4;
	final LibVLC_AudioChannel_Dolbys = 5;
}

/**
 * Media player roles.
 */
enum abstract LibVLC_Media_Player_Role(Int) from Int to Int
{
	final LibVLC_Role_None = 0; /* Don't use a media player role */
	final LibVLC_Role_Music = 1; /* Music (or radio) playback */
	final LibVLC_Role_Video = 2; /* Video playback */
	final LibVLC_Role_Communication = 3; /* Speech, real-time communication */
	final LibVLC_Role_Game = 4; /* Video game */
	final LibVLC_Role_Notification = 5; /* User interaction feedback */
	final LibVLC_Role_Animation = 6; /* Embedded animation (e.g. in web page) */
	final LibVLC_Role_Production = 7; /* Audio editting/production */
	final LibVLC_Role_Accessibility = 8; /* Accessibility */
	final LibVLC_Role_Test = 9; /* Testing */
}
