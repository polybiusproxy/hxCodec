package hxcodecpro._internal;

import cpp.RawPointer;
import cpp.RawConstPointer;
import cpp.Int64;
import cpp.UInt32;
import cpp.UInt64;

/**
 * This class contains type definitions for various types used by LibVLC.
 */
class LibVLCTypes
{
  // Stub class.
}

//
// C++ TYPES
//

/**
 * A `void *` variable.
 * This is used to represent a pointer to an unknown type.
 */
typedef VoidStar = cpp.Star<cpp.Void>;

/**
 * A `const char *` variable.
 * This is used to represent a pointer to a null-terminated string.
 */
typedef ConstCharPointer = cpp.ConstPointer<cpp.Char>;

//
// CALLBACK TYPES
//

/**
 * callback to invoke when LibVLC wants to exit
 */
typedef LibVLC_Exit_Callback = cpp.Callable<(p_data:VoidStar) -> Void>;

/**
 * Callback function notification.
 * @param p_event	the event triggering the callback
 */
typedef LibVLC_Event_Callback = cpp.Callable<(p_event:RawConstPointer<LibVLC_Event_T>, p_data:VoidStar) -> Void>;

/**
 * Callback prototype to open a custom bitstream input media.
 *
 * The same media item can be opened multiple times. Each time, this callback
 * is invoked. It should allocate and initialize any instance-specific
 * resources, then store them in *datap. The instance resources can be freed
 * in the @ref libvlc_media_close_cb callback.
 *
 * @param opaque private pointer as passed to @ref LibVLCMedia.new_callbacks()
 * @param datap storage space for a private data pointer [OUT]
 * @param sizep byte length of the bitstream or UINT64_MAX if unknown [OUT]
 *
 * @note For convenience, *datap is initially NULL and *sizep is initially 0.
 *
 * @return 0 on success, non-zero on error. In case of failure, the other
 * callbacks will not be invoked and any value stored in *datap and *sizep is
 * discarded.
 */
typedef LibVLC_Media_Open_Callback = cpp.Callable<(opaque:VoidStar, datap:cpp.Star<VoidStar>, sizep:cpp.Star<UInt64>) -> Int>;

/**
 * Callback prototype to read data from a custom bitstream input media.
 *
 * @param opaque private pointer as set by the @ref LibVLC_Media_Open_Callback callback
 * @param buf start address of the buffer to read data into
 * @param len bytes length of the buffer
 *
 * @return strictly positive number of bytes read, 0 on end-of-stream,
 *         or -1 on non-recoverable error
 *
 * @note If no data is immediately available, then the callback should sleep.
 * @warning The application is responsible for avoiding deadlock situations.
 */
typedef LibVLC_Media_Read_Callback = cpp.Callable<(opaque:VoidStar, buf:cpp.Star<cpp.Char>, len:UInt32) -> Int64>;

/**
 * Callback prototype to seek a custom bitstream input media.
 *
 * @param opaque private pointer as set by the @ref LibVLC_Media_Open_Callback callback
 * @param offset absolute byte offset to seek to
 * @return 0 on success, -1 on error.
 */
typedef LibVLC_Media_Seek_Callback = cpp.Callable<(opaque:VoidStar, offset:UInt64) -> Int>;

/**
 * Callback prototype to close a custom bitstream input media.
 *
 * @param opaque private pointer as set by the @ref LibVLC_Media_Open_Callback callback
 */
typedef LibVLC_Media_Close_Callback = cpp.Callable<(opaque:VoidStar) -> Void>;

/**
 * 	callback to select the video format (cannot be NULL) 
 */
typedef LibVLC_Video_Setup_Callback = cpp.Callable<(opaque:cpp.Star<VoidStar>, chroma:cpp.Star<cpp.Char>, width:cpp.Star<UInt32>, height:cpp.Star<UInt32>,
    pitches:cpp.Star<UInt32>, lines:cpp.Star<UInt32>) -> UInt32>;

/**
 * 	callback to release any allocated resources (or NULL) 
 */
typedef LibVLC_Video_Cleanup_Callback = cpp.Callable<(opaque:VoidStar) -> Void>;

/**
 * 	callback to lock video memory (must not be NULL) 
 */
typedef LibVLC_Video_Lock_Callback = cpp.Callable<(data:VoidStar, p_pixels:cpp.Star<VoidStar>) -> VoidStar>;

/**
 * callback to unlock video memory (or NULL if not needed) 
 */
typedef LibVLC_Video_Unlock_Callback = cpp.Callable<(data:VoidStar, id:VoidStar, p_pixels:VoidStarConstStar) -> Void>;

/**
 * callback to display video (or NULL if not needed) 
 */
typedef LibVLC_Video_Display_Callback = cpp.Callable<(opaque:VoidStar, picture:VoidStar) -> Void>;

//
// STRUCT TYPES
//

/**
 * This structure is opaque.
 * It represents a libvlc instance
 * Pass this around to refer to a persistent session of LibVLC.
 */
typedef LibVLC_Instance = RawPointer<LibVLC_Instance_T>;

@:include("vlc/vlc.h")
@:keep
@:native("libvlc_instance_t")
extern class LibVLC_Instance_T {}

/**
 * Description of a module.
 */
typedef LibVLC_ModuleDescription = RawPointer<LibVLC_ModuleDescription_T>;

@:include("vlc/vlc.h")
@:keep
@:native("libvlc_module_description_t")
extern class LibVLC_ModuleDescription_T {}

/**
 * Description for audio output.
 * It contains name, description and pointer to next record.
 */
typedef LibVLC_AudioOutput = RawPointer<LibVLC_AudioOutput_T>;

@:include("vlc/vlc.h")
@:keep
@:native("libvlc_audio_output_t")
extern class LibVLC_AudioOutput_T {}

/**
 * Description for audio output device.
 */
typedef LibVLC_AudioOutputDevice = RawPointer<LibVLC_AudioOutputDevice_T>;

@:include("vlc/vlc.h")
@:keep
@:native("libvlc_audio_output_device_t")
extern class LibVLC_AudioOutputDevice_T {}

typedef LibVLC_Media = RawPointer<LibVLC_Media_T>;

@:include("vlc/vlc.h")
@:keep
@:native("libvlc_media_t")
extern class LibVLC_Media_T {}

typedef LibVLC_MediaPlayer = RawPointer<LibVLC_MediaPlayer_T>;

@:include("vlc/vlc.h")
@:keep
@:native("libvlc_media_player_t")
extern class LibVLC_MediaPlayer_T {}

/**
 * Event manager that belongs to a libvlc object, and from whom events can be received. 
 */
typedef LibVLC_EventManager = RawPointer<LibVLC_EventManager_T>;

@:include("vlc/vlc.h")
@:keep
@:native("libvlc_event_manager_t")
extern class LibVLC_EventManager_T {}

/**
 * A LibVLC event. 
 */
typedef LibVLC_Event = RawPointer<LibVLC_Event_T>;

@:include("vlc/vlc.h")
@:structAccess
@:keep
@:native("libvlc_event_t")
extern class LibVLC_Event_T
{
  var type:LibVLC_EventType;
  var u:LibVLC_Event_U;
}

@:native("void *const *")
extern class VoidStarConstStar {}

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

//
// ENUM TYPES
//

/**
 * Type of a LibVLC event. 
 */
enum abstract LibVLC_EventType(Int) from Int to Int
{
  /**
   * Metadata of a LibVLC_Media changed
   */
  var MediaMetaChanged = 0;

  /**
   * Subitem was added to a LibVLC_Media
   * @see libvlc_media_subitems()
   */
  var MediaSubItemAdded = 1;

  /**
   * Duration of a LibVLC_Media changed
   * @see libvlc_media_get_duration()
   */
  var MediaDurationChanged = 2;

  /**
   * Parsing state of a LibVLC_Media changed
   * @see libvlc_media_parse_request(),
   *      libvlc_media_get_parsed_status(),
   *      libvlc_media_parse_stop()
   */
  var MediaParsedChanged = 3;

  // var MediaFreed = 4; // REMOVED
  // var MediaStateChanged = 5; // REMOVED

  /**
   * Subitem tree was added to a LibVLC_Media
   */
  var MediaSubItemTreeAdded = 6;

  /**
   * A thumbnail generation for this LibVLC_Media completed.
   * @see libvlc_media_thumbnail_request_by_time()
   * @see libvlc_media_thumbnail_request_by_pos()
   */
  var MediaThumbnailGenerated = 7;

  /**
   * One or more embedded thumbnails were found during the media preparsing
   * The user can hold these picture(s) using libvlc_picture_retain if they
   * wish to use them
   */
  var MediaAttachedThumbnailsFound = 8;

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
  var MediaPlayerStopping = 265;
  var MediaPlayerEncounteredError = 266;
  var MediaPlayerTimeChanged = 267;
  var MediaPlayerPositionChanged = 268;
  var MediaPlayerSeekableChanged = 269;
  var MediaPlayerPausableChanged = 270;
  // var MediaPlayerTitleChanged = 271; // REMOVED
  var MediaPlayerSnapshotTaken = 272;
  var MediaPlayerLengthChanged = 273;
  var MediaPlayerVout = 274;
  // var MediaPlayerScrambledChanged = 275; // REMOVED

  /**
   * A track was added, cf. media_player_es_changed in @ref libvlc_event_t.u
   * to get the id of the new track.
   */
  var MediaPlayerESAdded = 276;

  /** A track was removed, cf. media_player_es_changed in @ref
   * libvlc_event_t.u to get the id of the removed track. */
  var MediaPlayerESDeleted = 277;

  /** Tracks were selected or unselected, cf.
   * media_player_es_selection_changed in @ref libvlc_event_t.u to get the
   * unselected and/or the selected track ids. */
  var MediaPlayerESSelected = 278;

  var MediaPlayerCorked = 279;
  var MediaPlayerUncorked = 280;
  var MediaPlayerMuted = 281;
  var MediaPlayerUnmuted = 282;
  var MediaPlayerAudioVolume = 283;
  var MediaPlayerAudioDevice = 284;

  /** A track was updated, cf. media_player_es_changed in @ref
   * libvlc_event_t.u to get the id of the updated track. */
  var MediaPlayerESUpdated = 285;

  var MediaPlayerProgramAdded = 286;
  var MediaPlayerProgramDeleted = 287;
  var MediaPlayerProgramSelected = 288;
  var MediaPlayerProgramUpdated = 289;

  /**
   * The title list changed, call
   * libvlc_media_player_get_full_title_descriptions() to get the new list.
   */
  var MediaPlayerTitleListChanged = 290;

  /**
   * The title selection changed, cf media_player_title_selection_changed in
   * @ref libvlc_event_t.u
   */
  var MediaPlayerTitleSelectionChanged = 291;

  var MediaPlayerChapterChanged = 292;
  var MediaPlayerRecordChanged = 293;

  /**
   * A @link #libvlc_media_t media item@endlink was added to a
   * @link #libvlc_media_list_t media list@endlink.
   */
  var MediaListItemAdded = 512;

  /**
   * A @link #libvlc_media_t media item@endlink is about to get
   * added to a @link #libvlc_media_list_t media list@endlink.
   */
  var MediaListWillAddItem = 513;

  /**
   * A @link #libvlc_media_t media item@endlink was deleted from
   * a @link #libvlc_media_list_t media list@endlink.
   */
  var MediaListItemDeleted = 514;

  /**
   * A @link #libvlc_media_t media item@endlink is about to get
   * deleted from a @link #libvlc_media_list_t media list@endlink.
   */
  var MediaListWillDeleteItem = 515;

  /**
   * A @link #libvlc_media_list_t media list@endlink has reached the
   * end.
   * All @link #libvlc_media_t items@endlink were either added (in
   * case of a @ref libvlc_media_discoverer_t) or parsed (preparser).
   */
  var MediaListEndReached = 516;

  /**
   * @deprecated No longer used.
   * This belonged to the removed libvlc_media_list_view_t
   */
  var MediaListViewItemAdded = 768;

  /**
   * @deprecated No longer used.
   * This belonged to the removed libvlc_media_list_view_t
   */
  var MediaListViewWillAddItem = 769;

  /**
   * @deprecated No longer used.
   * This belonged to the removed libvlc_media_list_view_t
   */
  var MediaListViewItemDeleted = 770;

  /**
   * @deprecated No longer used.
   * This belonged to the removed libvlc_media_list_view_t
   */
  var MediaListViewWillDeleteItem = 771;

  /**
   * Playback of a @link libvlc_media_list_player_t has started.
   */
  var MediaListPlayerPlayed = 1024;

  /**
   * The current @link libvlc_media_t of a @link libvlc_media_list_player_t
   * has changed to a different item.
   */
  var MediaListPlayerNextItemSet = 1025;

  /**
   * Playback of a @link libvlc_media_list_player_t has stopped.
   */
  var MediaListPlayerStopped = 1026;

  /**
   * A new @link libvlc_renderer_item_t was found by a @link libvlc_renderer_discoverer_t .
   * The renderer item is valid until deleted.
   */
  var RendererDiscovererItemAdded = 1282;

  /**
   * A previously discovered @link libvlc_renderer_item_t was deleted by a @link libvlc_renderer_discoverer_t .
   * The renderer item is no longer valid.
   */
  var RendererDiscovererItemDeleted = 1283;
}

/**
 * Audio mix modes.
 */
enum abstract LibVLC_AudioOutputMixMode(Int) from Int to Int
{
  var AudioMixMode_Unset = 0;
  var AudioMixMode_Stereo = 1;
  var AudioMixMode_Binaural = 2;
  var AudioMixMode_4_0 = 3;
  var AudioMixMode_5_1 = 4;
  var AudioMixMode_7_1 = 5;
}

/**
 * Audio stereo modes.
 */
enum abstract LibVLC_AudioOutputStereoMode(Int) from Int to Int
{
  var AudioStereoMode_Unset = 0;
  var AudioStereoMode_Stereo = 1;
  var AudioStereoMode_RStereo = 2;
  var AudioStereoMode_Left = 3;
  var AudioStereoMode_Right = 4;
  var AudioStereoMode_Dolbys = 5;
  var AudioStereoMode_Mono = 7;
}

/**
 * Media player roles.
 *
 * @version LibVLC 3.0.0 and later.
 *
 * See @ref libvlc_media_player_set_role()
 */
enum abstract LibVLC_MediaPlayerRole(Int) from Int to Int
{
  /** Don't use a media player role */
  var None = 0;

  /** Music (or radio) playback */
  var Music = 1;

  /** Video playback */
  var Video = 2;

  /** Speech, real-time communication */
  var Communication = 3;

  /** Video game */
  var Game = 4;

  /** User interaction feedback */
  var Notification = 5;

  /** Embedded animation (e.g. in web page) */
  var Animation = 6;

  /** Audio editing/production */
  var Production = 7;

  /** Accessibility */
  var Accessibility = 8;

  /** Testing */
  // var Test = 9;
}

@:include("vlc/vlc.h")
@:unreflective
@:native("libvlc_media_parse_flag_t")
extern class LibVLC_MediaParseFlag_T {}

/**
 * Parse flags used by libvlc_media_parse_request()
 */
abstract LibVLC_MediaParseFlag(Int) from Int to Int
{
  inline public function new(i:Int)
  {
    this = i;
  }

  @:to(LibVLC_MediaParseFlag_T)
  @:unreflective
  public inline function toNative()
  {
    return untyped __cpp__("((libvlc_media_parse_flag_t)({0}))", this);
  }

  @:from(LibVLC_MediaParseFlag_T)
  @:unreflective
  public static inline function fromNative(value:LibVLC_MediaParseFlag_T):LibVLC_MediaParseFlag
  {
    return new LibVLC_MediaParseFlag(untyped value);
  }

  public static var media_parse_local(default, null) = new LibVLC_MediaParseFlag(untyped __cpp__("libvlc_media_parse_local"));
  public static var media_parse_network(default, null) = new LibVLC_MediaParseFlag(untyped __cpp__("media_parse_network"));
  public static var media_fetch_local(default, null) = new LibVLC_MediaParseFlag(untyped __cpp__("media_fetch_local"));
  public static var media_fetch_network(default, null) = new LibVLC_MediaParseFlag(untyped __cpp__("media_fetch_network"));
  public static var media_do_interact(default, null) = new LibVLC_MediaParseFlag(untyped __cpp__("media_do_interact"));
  public static var media_no_skip(default, null) = new LibVLC_MediaParseFlag(untyped __cpp__("media_no_skip"));
}

/**
 * Parse status used sent by `LibVLCMedia.parse_request()` or returned by `LibVLCMedia.get_parsed_status()`
 */
enum abstract LibVLC_MediaParsedStatus(Int) from Int to Int
{
  /**
   * None
   */
  var media_parsed_status_none = 0;

  /**
   * Pending
   */
  var media_parsed_status_pending = 1;

  /**
   * Skipped
   */
  var media_parsed_status_skipped = 2;

  /**
   * Failed
   */
  var media_parsed_status_failed = 3;

  /**
   * Timeout
   */
  var media_parsed_status_timeout = 4;

  /**
   * Done
   */
  var media_parsed_status_done = 5;
}
