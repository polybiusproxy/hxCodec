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
	/*
	 * Create and initialize a libvlc instance.
	 */
	@:native("libvlc_new")
	static function New(argc:Int, argv:String):LibVLC_Instance_p;

	/*
	 * Create a media for a certain file path.
	 */
	@:native("libvlc_media_new_path")
	static function mediaNewPath(p_instance:LibVLC_Instance_p, path:String):LibVLC_Media_p;

	/*
	 * Create a Media Player object from a Media.
	 */
	@:native("libvlc_media_player_new_from_media")
	static function mediaPlayerNewFromMedia(p_md:LibVLC_Media_p):LibVLC_MediaPlayer_p;

	/*
	 * ...
	 */
	@:native("libvlc_audio_output_list_get")
	static function getAudioOutputList(vlcInst:LibVLC_Instance_p):LibVLC_AudioOutput_p;

	/*
	 * ...
	 */
	@:native("libvlc_audio_output_set")
	static function setAudioOutput(p_mi:LibVLC_MediaPlayer_p, deviceName:String):Void;

	/*
	 * Play
	 */
	@:native("libvlc_media_player_play")
	static function mediaPlayerPlay(p_mi:LibVLC_MediaPlayer_p):Void;

	/*
	 * Stop
	 */
	@:native("libvlc_media_player_stop")
	static function mediaPlayerStop(p_mi:LibVLC_MediaPlayer_p):Void;

	/*
	 * Pause or resume (no effect if there is no media)
	 *
	 * Parameters
	 * mp	the Media Player
	 * do_pause	play/resume if zero, pause if non-zero
	 */
	@:native("libvlc_media_player_set_pause")
	static function mediaPlayerSetPause(p_mi:LibVLC_MediaPlayer_p, do_pause:Int):Void;

	/*
	 * IsPlaying
	 */
	@:native("libvlc_media_player_is_playing")
	static function mediaPlayerIsPlaying(p_mi:LibVLC_MediaPlayer_p):Bool;

	/*
	 * Release a media_player after use Decrement the reference count of a media player object.
	 */
	@:native("libvlc_media_player_release")
	static function mediaPlayerRelease(p_mi:LibVLC_MediaPlayer_p):Void;

	/*
	 * Decrement the reference count of a libvlc instance, and destroy it if it reaches zero.
	 */
	@:native("libvlc_release")
	static function release(p_instance:LibVLC_Instance_p):Void;

	/*
	 * Increments the reference count of a libvlc instance.
	 */
	@:native("libvlc_retain")
	static function retain(p_instance:LibVLC_Instance_p):Void;

	/*
	 * Get current software audio volume.
	 */
	@:native("libvlc_audio_get_volume")
	static function audioGetVolume(p_mi:LibVLC_MediaPlayer_p):Int;

	/*
	 * Set current software audio volume.
	 */
	@:native("libvlc_audio_set_volume")
	static function audioSetVolume(p_mi:LibVLC_MediaPlayer_p, i_volume:Int):Int;

	/*
	 * Decrement the reference count of a media descriptor object.
	 */
	@:native("libvlc_media_release")
	static function mediaRelease(p_md:LibVLC_Media_p):Void;

	/*
	 * Parse flags used by LibVLC_media_parse_with_options()
	 */
	@:native("libvlc_media_parse")
	static function mediaParse(p_md:LibVLC_Media_p):Void;

	/*
	 * Set decoded video chroma and dimensions.
	 * LibVLC_video_set_format_callbacks (LibVLC_media_player_t *mp, LibVLC_video_format_cb setup, LibVLC_video_cleanup_cb cleanup)
	 */
	@:native("libvlc_video_set_format_callbacks")
	static function setFormatCallbacks(mp:LibVLC_MediaPlayer_p, setup:LibVLC_Video_Format_CB, cleanup:LibVLC_Video_Cleanup_CB):Void;

	/*
	 * Set callbacks and private data to render decoded video to a custom area in memory.
	 * LibVLC_video_set_callbacks (LibVLC_media_player_t *mp, LibVLC_video_lock_cb lock, LibVLC_video_unlock_cb unlock, LibVLC_video_display_cb display, void *opaque)
	 */
	@:native("libvlc_video_set_callbacks")
	static function setCallbacks(mp:LibVLC_MediaPlayer_p, lock:LibVLC_Video_Lock_CB, unlock:LibVLC_Video_Unlock_CB,
		display:LibVLC_Video_Display_CB, opaque:cpp.Star<cpp.Void>):Void;

	/*
	 * Get the Event Manager from which the media player send event.
	 * LibVLC_API LibVLC_event_manager_t* LibVLC_media_player_event_manager	(LibVLC_media_player_t*	p_mi)
	 */
	@:native("libvlc_media_player_event_manager")
	static function setEventmanager(mp:LibVLC_MediaPlayer_p):LibVLC_EventManager_p;

	/*
	 * Register for an event notification
	 */
	@:native("libvlc_event_attach")
	static function eventAttach(p_event_manager:LibVLC_EventManager_p, i_event_type:LibVLC_EventType, f_callback:LibVLC_Callback,
		user_data:cpp.Star<cpp.Void>):Int;

	/*
	 * UnRegister for an event notification
	 */
	@:native("libvlc_event_detach")
	static function eventDetach(p_event_manager:LibVLC_EventManager_p, i_event_type:LibVLC_EventType, f_callback:LibVLC_Callback,
		user_data:cpp.Star<cpp.Void>):Int;

	/*
	 * Registers a callback for the LibVLC exit event
	 */
	@:native("libvlc_set_exit_handler")
	static function setExitHandler(p_instance:LibVLC_Instance_p, cb:cpp.Star<cpp.Void>, opaque:cpp.Star<cpp.Void>):Void;

	/*
	 * Get duration (in ms) of media descriptor object item.
	 *
	 * Note, you need to call LibVLC_media_parse_with_options() or play the media at least once before calling this function. Not doing this will result in an undefined result.
	 * See also
	 * LibVLC_media_parse_with_options
	 * Parameters
	 * p_md	media descriptor object
	 * Returns
	 * duration of media item or -1 on error
	 *
	 */
	@:native("libvlc_media_get_duration")
	static function mediaPlayerGetDuration(p_md:LibVLC_Media_p):LibVLC_Time_t;

	/*
	 * Get the current movie time (in ms).
	 */
	@:native("libvlc_media_player_get_time")
	static function mediaPlayerGetTime(p_mi:LibVLC_MediaPlayer_p):LibVLC_Time_t;

	/**
	 * Set the movie time (in ms). This has no effect if no media is being played. Not all formats and protocols support this.
	 *
	 * Parameters
	 * p_mi	the Media Player
	 * b_fast	prefer fast seeking or precise seeking
	 * i_time	the movie time (in ms).
	 * Returns
	 * 0 on success, -1 on error
	 */
	@:native("libvlc_media_player_set_time")
	static function mediaPlayerSetTime(p_mi:LibVLC_MediaPlayer_p, i_time:LibVLC_Time_t):Int;

	/**
	 * Get the pixel dimensions of a video.
	 *
	 * \param p_mi media player
	 * \param num number of the video (starting from, and most commonly 0)
	 * \param px pointer to get the pixel width [OUT]
	 * \param py pointer to get the pixel height [OUT]
	 * \return 0 on success, -1 if the specified video does not exist
	 */
	@:native("libvlc_video_get_size")
	static function videoGetSize(p_mi:LibVLC_MediaPlayer_p, num:UInt, width:cpp.Star<cpp.UInt32>, height:cpp.Star<cpp.UInt32>):Int;

	/**
	 * Add an option to the media.
	 *
	 * This option will be used to determine how the media_player will read the media. This allows to use VLC's advanced reading/streaming options on a per-media basis.
	 *
	 * Note
	 * The options are listed in 'vlc –longhelp' from the command line, e.g. "--sout-all". Keep in mind that available options and their semantics vary across LibVLC versions and builds.
	 * Warning
	 * Not all options affects LibVLC_media_t objects: Specifically, due to architectural issues most audio and video options, such as text renderer options, have no effects on an individual media. These options must be set through LibVLC_new() instead.
	 * arameters
	 * p_md	the media descriptor
	 * psz_options	the options (as a string)
	 */
	@:native("libvlc_media_add_option")
	static function mediaAddOption(p_md:LibVLC_Media_p, psz_options:String):Void;
}

typedef LibVLC_Instance_p = cpp.Star<LibVLC_Instance>;
typedef LibVLC_AudioOutput_p = cpp.Star<LibVLC_AudioOutput>;
typedef LibVLC_MediaPlayer_p = cpp.Star<LibVLC_MediaPlayer>;
typedef LibVLC_Media_p = cpp.Star<LibVLC_Media>;
typedef LibVLC_EventManager_p = cpp.Star<LibVLC_EventManager>;
typedef LibVLC_Event_p = cpp.Star<LibVLC_Event>;
typedef LibVLC_Event_const_p = cpp.ConstStar<LibVLC_Event>;
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

typedef LibVLC_PixelBuffer_p = cpp.Star<LibVLC_PixelBuffer_t>;
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
