package hxcodec._internal;

#if !cpp
#error "This file is only meant to be used with the C++ target."
#end

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
 * This is used to represent a pointer to data of an unknown type and size.
 */
typedef VoidStar = cpp.Pointer<cpp.Void>;

typedef VoidStarStar = cpp.Pointer<VoidStar>;

/**
 * A `const char *` variable.
 * This is used to represent a pointer to a null-terminated string.
 */
typedef ConstCharStar = cpp.ConstPointer<cpp.Char>;

extern abstract CharStar(cpp.Pointer<cpp.Char>)
{
  inline function new(s:String)
  {
    this = untyped s.__s;
  }

  /**
   * Allocate a new `char *` of the given size.
   * @param size The size of the `char *` to allocate.
   * @return The resulting `CharStar`.
   */
  public static inline function allocate(size:Int):CharStar
  {
    return untyped __cpp__("new char[{0}]", size);
  }

  /**
   * Free a `char *` allocated with `allocate`.
   * @param ptr The `char *` to free.
   */
  public static inline function free(ptr:CharStar):Void
  {
    untyped __cpp__("delete[] {0}", ptr);
  }

  /**
   * Add implicit casting to string.
   * @return The resulting haxe `String`.
   */
  @:to
  public inline function toString():String
  {
    return new String(untyped this);
  }

  /**
   * Add implicit casting to pointer.
   * @return The resulting `cpp.Pointer<cpp.Char>`.
   */
  @:to
  public inline function toPointer():cpp.Pointer<cpp.Char>
  {
    return untyped this;
  }

  /**
   * Add implicit casting from string.
   * @param s The string to cast.
   * @return The resulting `CharStar`.
   */
  @:from
  public static inline function fromString(s:String):CharStar
  {
    return new CharStar(s);
  }
}

/**
 * A `char * *` variable.
 * This is used to represent a pointer to a pointer to a null-terminated string.
 */
typedef CharStarStar = cpp.Pointer<CharStar>;

/**
 * A `const char * *` variable.
 * This is used to represent a pointer to a pointer to a null-terminated string.
 */
typedef ConstCharStarStar = cpp.Pointer<ConstCharStar>;

typedef UInt64Star = cpp.Pointer<cpp.UInt64>;
typedef UInt32Star = cpp.Pointer<cpp.UInt32>;
typedef Int64Star = cpp.Pointer<cpp.Int64>;
typedef Int32Star = cpp.Pointer<cpp.Int32>;
typedef UnsignedStar = UInt32Star;

// Raw pointers used for callbacks

typedef RawUInt64Star = cpp.RawPointer<cpp.UInt64>;
typedef RawUInt32Star = cpp.RawPointer<cpp.UInt32>;
typedef RawInt64Star = cpp.RawPointer<cpp.Int64>;
typedef RawInt32Star = cpp.RawPointer<cpp.Int32>;
typedef RawUnsignedStar = RawUInt32Star;
typedef RawVoidStar = cpp.RawPointer<cpp.Void>;
typedef RawVoidStarStar = cpp.RawPointer<RawVoidStar>;
typedef RawConstCharStar = cpp.RawConstPointer<cpp.Char>;
typedef RawCharStar = cpp.RawPointer<cpp.Char>;
typedef RawCharStarStar = cpp.RawPointer<RawCharStar>;
typedef RawConstCharStarStar = cpp.RawPointer<RawConstCharStar>;

/**
 * A C++ `void * const *` type.
 * @note I'm gonna be honest, I have no idea what this is lol.
 */
@:native('void * const *')
extern class RawVoidStarConstStar {}

//
// CALLBACK TYPES
//

/**
 * callback to invoke when LibVLC wants to exit
 */
typedef LibVLC_Exit_Callback = cpp.Callable<(p_data:RawVoidStar) -> Void>;

/**
 * Callback function notification.
 * @param p_event	the event triggering the callback
 */
typedef LibVLC_Event_Callback = cpp.Callable<(p_event:cpp.ConstPointer<LibVLC_Event_T>, p_data:RawVoidStar) -> Void>;

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
typedef LibVLC_Media_Open_Callback = cpp.Callable<(opaque:RawVoidStar, datap:RawVoidStarStar, sizep:RawUInt64Star) -> Int>;

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
typedef LibVLC_Media_Read_Callback = cpp.Callable<(opaque:RawVoidStar, buf:RawCharStar, len:cpp.UInt32) -> cpp.Int64>;

/**
 * Callback prototype to seek a custom bitstream input media.
 *
 * @param opaque private pointer as set by the @ref LibVLC_Media_Open_Callback callback
 * @param offset absolute byte offset to seek to
 * @return 0 on success, -1 on error.
 */
typedef LibVLC_Media_Seek_Callback = cpp.Callable<(opaque:RawVoidStar, offset:cpp.UInt64) -> Int>;

/**
 * Callback prototype to close a custom bitstream input media.
 *
 * @param opaque private pointer as set by the @ref LibVLC_Media_Open_Callback callback
 */
typedef LibVLC_Media_Close_Callback = cpp.Callable<(opaque:RawVoidStar) -> Void>;

/**
 * 	callback to select the video format (cannot be NULL) 
 */
typedef LibVLC_Video_Setup_Callback = cpp.Callable<(opaque:RawVoidStarStar, chroma:RawCharStar, width:RawUInt32Star, height:RawUInt32Star,
    pitches:RawUInt32Star, lines:RawUInt32Star) -> cpp.UInt32>;

/**
 * 	callback to release any allocated resources (or NULL) 
 */
typedef LibVLC_Video_Cleanup_Callback = cpp.Callable<(opaque:RawVoidStar) -> Void>;

/**
 * 	callback to lock video memory (must not be NULL) 
 */
typedef LibVLC_Video_Lock_Callback = cpp.Callable<(data:RawVoidStar, p_pixels:RawVoidStarStar) -> RawVoidStar>;

/**
 * callback to unlock video memory (or NULL if not needed) 
 */
typedef LibVLC_Video_Unlock_Callback = cpp.Callable<(data:RawVoidStar, id:RawVoidStar, p_pixels:RawVoidStarConstStar) -> Void>;

/**
 * callback to display video (or NULL if not needed) 
 */
typedef LibVLC_Video_Display_Callback = cpp.Callable<(opaque:RawVoidStar, picture:RawVoidStar) -> Void>;

/**
 * Callback prototype for LibVLC log message handler.
 *
 * @param data data pointer as given to libvlc_log_set()
 * @param level message level (@ref libvlc_log_level)
 * @param ctx message context (meta-information about the message)
 * @param fmt printf() format string (as defined by ISO C11)
 * @param args variable argument list for the format
 * @note Log message handlers <b>must</b> be thread-safe.
 * @warning The message context pointer, the format string parameters and the
 *          variable arguments are only valid until the callback returns.
 */
typedef LibVLC_Log_Callback = cpp.Callable<(data:VoidStar, level:Int, ctx:LibVLC_Log, fmt:ConstCharStar, args:CharStar) -> Void>;

//
// STRUCT TYPES
//

/**
 * This structure is opaque.
 * It represents a libvlc instance
 * Pass this around to refer to a persistent session of LibVLC.
 */
typedef LibVLC_Instance = cpp.RawPointer<LibVLC_Instance_T>;

/**
 * Internal libvlc instance data structure.
 */
@:include('vlc/vlc.h')
@:keep
@:native('libvlc_instance_t')
extern class LibVLC_Instance_T {}

/**
 * Description of a module.
 */
typedef LibVLC_ModuleDescription = cpp.RawPointer<LibVLC_ModuleDescription_T>;

/**
 * Internal module description data structure.
 */
@:include('vlc/vlc.h')
@:keep
@:native('libvlc_module_description_t')
extern class LibVLC_ModuleDescription_T {}

/**
 * A `std::vector<char*>` instance.
 */
@:keep
@:unreflective
@:structAccess
@:include('vector')
@:native('std::vector<char*>')
extern class StdVectorChar
{
  @:native('std::vector<char*>')
  static function create():StdVectorChar;

  function at(index:Int):CharStar;
  function back():CharStar;
  function data():CharStarStar;
  function front():CharStar;
  function pop_back():Void;
  function push_back(value:CharStar):Void;
  function size():Int;
}

/**
 * A `std::vector<const char*>` instance.
 */
@:keep
@:unreflective
@:structAccess
@:include('vector')
@:native('std::vector<const char*>')
extern class StdVectorConstChar
{
  @:native('std::vector<const char*>')
  static function create():StdVectorChar;

  function at(index:Int):ConstCharStar;
  function back():ConstCharStar;
  function data():cpp.Pointer<ConstCharStar>;
  function front():ConstCharStar;
  function pop_back():Void;
  function push_back(value:ConstCharStar):Void;
  function size():Int;
}

/**
 * Description of a log message.
 */
typedef LibVLC_Log = cpp.RawPointer<LibVLC_Log_T>;

/**
 * Internal log message data structure.
 */
@:include('vlc/vlc.h')
@:keep
@:native('libvlc_log_t')
extern class LibVLC_Log_T {}

/**
 * Description for audio output.
 * It contains name, description and pointer to next record.
 */
typedef LibVLC_AudioOutput = cpp.RawPointer<LibVLC_AudioOutput_T>;

/**
 * Internal audio output data structure.
 */
@:include('vlc/vlc.h')
@:keep
@:native('libvlc_audio_output_t')
extern class LibVLC_AudioOutput_T {}

/**
 * Description for audio output device.
 */
typedef LibVLC_AudioOutputDevice = cpp.RawPointer<LibVLC_AudioOutputDevice_T>;

/**
 * Internal audio output device data structure.
 */
@:include('vlc/vlc.h')
@:keep
@:native('libvlc_audio_output_device_t')
extern class LibVLC_AudioOutputDevice_T {}

/**
 * A media item.
 */
typedef LibVLC_Media = cpp.RawPointer<LibVLC_Media_T>;

/**
 * Internal media item data structure.
 */
@:include('vlc/vlc.h')
@:keep
@:native('libvlc_media_t')
extern class LibVLC_Media_T {}

/**
 * A media track.
 */
typedef LibVLC_MediaTrack = cpp.RawPointer<LibVLC_MediaTrack_T>;

/**
 * Internal media track data structure.
 */
@:include('vlc/vlc.h')
@:keep
@:native('libvlc_media_track_t')
extern class LibVLC_MediaTrack_T {}

/**
 * Opaque struct containing a list of tracks. 
 */
typedef LibVLC_MediaTracklist = cpp.RawPointer<LibVLC_MediaTracklist_T>;

/**
 * Internal media track list data structure.
 */
@:include('vlc/vlc.h')
@:keep
@:native('libvlc_media_tracklist_t')
extern class LibVLC_MediaTracklist_T {}

/**
 * An audio track within a media.
 */
typedef LibVLC_AudioTrack = cpp.RawPointer<LibVLC_AudioTrack_T>;

/**
 * Internal audio track data structure.
 */
@:include('vlc/vlc.h')
@:keep
@:native('libvlc_audio_track_t')
extern class LibVLC_AudioTrack_T {}

/**
 * A video track within a media.
 */
typedef LibVLC_VideoTrack = cpp.RawPointer<LibVLC_VideoTrack_T>;

/**
 * Internal video track data structure.
 */
@:include('vlc/vlc.h')
@:keep
@:native('libvlc_video_track_t')
extern class LibVLC_VideoTrack_T {}

/**
 * A media player.
 */
typedef LibVLC_MediaPlayer = cpp.RawPointer<LibVLC_MediaPlayer_T>;

/**
 * Internal media player data structure.
 */
@:include('vlc/vlc.h')
@:keep
@:native('libvlc_media_player_t')
extern class LibVLC_MediaPlayer_T {}

/**
 * Event manager that belongs to a libvlc object, and from whom events can be received. 
 */
typedef LibVLC_EventManager = cpp.RawPointer<LibVLC_EventManager_T>;

/**
 * Internal event manager structure.
 */
@:include('vlc/vlc.h')
@:keep
@:native('libvlc_event_manager_t')
extern class LibVLC_EventManager_T {}

/**
 * A LibVLC event. 
 */
typedef LibVLC_Event = cpp.RawPointer<LibVLC_Event_T>;

/**
 * Internal event structure.
 */
@:include('vlc/vlc.h')
@:structAccess
@:keep
@:native('libvlc_event_t')
extern class LibVLC_Event_T
{
  var type:LibVLC_EventType;
  var u:LibVLC_Event_U;
}

/**
 * Internal event union.
 */
@:include('vlc/vlc.h')
@:structAccess
@:keep
@:native('libvlc_event_t::u')
extern class LibVLC_Event_U
{
  var media_player_position_changed:LibVLC_MediaPlayer_PositionChanged;
  var media_player_time_changed:LibVLC_MediaPlayer_TimeChanged;
  var media_player_length_changed:LibVLC_MediaPlayer_LengthChanged;
  var media_player_buffering:LibVLC_MediaPlayer_Buffering;
  var media_player_seekable_changed:LibVLC_MediaPlayer_SeekableChanged;
  var media_player_pausable_changed:LibVLC_MediaPlayer_PausableChanged;
}

/**
 * Internal type for media player position changed event.
 */
@:include('vlc/vlc.h')
@:structAccess
@:keep
@:native('media_player_position_changed')
extern class LibVLC_MediaPlayer_PositionChanged
{
  var new_position:Float;
}

/**
 * Internal type for media player time changed event.
 */
@:include('vlc/vlc.h')
@:structAccess
@:keep
@:native('media_player_time_changed')
extern class LibVLC_MediaPlayer_TimeChanged
{
  var new_time:cpp.Int64;
}

/**
 * Internal type for media player length change event.
 */
@:include('vlc/vlc.h')
@:structAccess
@:keep
@:native('media_player_length_changed')
extern class LibVLC_MediaPlayer_LengthChanged
{
  var new_length:cpp.Int64;
}

/**
 * Internal type for media player buffering event.
 */
@:include('vlc/vlc.h')
@:structAccess
@:keep
@:native('media_player_buffering')
extern class LibVLC_MediaPlayer_Buffering
{
  var new_cache:Float;
}

/**
 * Internal type for media player seekable changed event.
 */
@:include('vlc/vlc.h')
@:structAccess
@:keep
@:native('media_player_seekable_changed')
extern class LibVLC_MediaPlayer_SeekableChanged
{
  var new_seekable:Bool;
}

/**
 * Internal type for media player pauseable changed event.
 */
@:include('vlc/vlc.h')
@:structAccess
@:keep
@:native('media_player_pausable_changed')
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
  public var MediaMetaChanged = 0;

  /**
   * Subitem was added to a LibVLC_Media
   * @see libvlc_media_subitems()
   */
  public var MediaSubItemAdded = 1;

  /**
   * Duration of a LibVLC_Media changed
   * @see libvlc_media_get_duration()
   */
  public var MediaDurationChanged = 2;

  /**
   * Parsing state of a LibVLC_Media changed
   * @see libvlc_media_parse_request(),
   *      libvlc_media_get_parsed_status(),
   *      libvlc_media_parse_stop()
   */
  public var MediaParsedChanged = 3;

  // MediaFreed: 4 // REMOVED
  // MediaStateChanged: 5 // REMOVED

  /**
   * Subitem tree was added to a LibVLC_Media
   */
  public var MediaSubItemTreeAdded = 6;

  /**
   * A thumbnail generation for this LibVLC_Media completed.
   * @see libvlc_media_thumbnail_request_by_time()
   * @see libvlc_media_thumbnail_request_by_pos()
   */
  public var MediaThumbnailGenerated = 7;

  /**
   * One or more embedded thumbnails were found during the media preparsing
   * The user can hold these picture(s) using libvlc_picture_retain if they
   * wish to use them
   */
  public var MediaAttachedThumbnailsFound = 8;

  /**
   * Played media changed.
   */
  public var MediaPlayerMediaChanged = 256;

  /**
   * ??? Unknown
   */
  public var MediaPlayerNothingSpecial = 257;

  /**
   * Opening media with media player.
   */
  public var MediaPlayerOpening = 258;

  /**
   * Media player: media item is buffering
   */
  public var MediaPlayerBuffering = 259;

  /**
   * Media player is playing.
   */
  public var MediaPlayerPlaying = 260;

  /**
   * Media player is paused.
   */
  public var MediaPlayerPaused = 261;

  /**
   * Media player is stopped.
   */
  public var MediaPlayerStopped = 262;

  /**
   * Media player skipped forward.
   */
  public var MediaPlayerForward = 263;

  /**
   * Media player skipped backward.
   */
  public var MediaPlayerBackward = 264;

  /**
   * Media player reached end of media.
   */
  public var MediaPlayerEndReached = 265;

  /**
   * Media player currently stopping.
   */
  public var MediaPlayerStopping = 265;

  /**
   * Media player encountered an error.
   */
  public var MediaPlayerEncounteredError = 266;

  /**
   * Media player time changed.
   */
  public var MediaPlayerTimeChanged = 267;

  /**
   * Media player position changed.
   */
  public var MediaPlayerPositionChanged = 268;

  /**
   * Media player seekable status changed.
   */
  public var MediaPlayerSeekableChanged = 269;

  /**
   * Media player pausable status changed.
   */
  public var MediaPlayerPausableChanged = 270;

  // MediaPlayerTitleChanged: 271 // REMOVED

  /**
   * Media player snapshot taken.
   */
  public var MediaPlayerSnapshotTaken = 272;

  /**
   * Media player media item length changed.
   */
  public var MediaPlayerLengthChanged = 273;

  /**
   * Media player vout???
   */
  public var MediaPlayerVout = 274;

  /**
   * Media player scrambled status changed.
   */
  // MediaPlayerScrambledChanged: 275 // REMOVED

  /**
   * A track was added, cf. media_player_es_changed in @ref libvlc_event_t.u
   * to get the id of the new track.
   */
  public var MediaPlayerESAdded = 276;

  /**
   * A track was removed, cf. media_player_es_changed in @ref
   * libvlc_event_t.u to get the id of the removed track.
   */
  public var MediaPlayerESDeleted = 277;

  /**
   * Tracks were selected or unselected, cf.
   * media_player_es_selection_changed in @ref libvlc_event_t.u to get the
   * unselected and/or the selected track ids.
   */
  public var MediaPlayerESSelected = 278;

  /**
   * Audio policy corked?
   */
  public var MediaPlayerCorked = 279;

  /**
   * Audio policy uncorked?
   */
  public var MediaPlayerUncorked = 280;

  /**
   * Media player muted.
   */
  public var MediaPlayerMuted = 281;

  /**
   * Media player unmuted.
   */
  public var MediaPlayerUnmuted = 282;

  /**
   * Media player audio volume changed.
   */
  public var MediaPlayerAudioVolume = 283;

  /**
   * Media player audio device changed.
   */
  public var MediaPlayerAudioDevice = 284;

  /**
   * A track was updated, cf. media_player_es_changed in @ref
   * libvlc_event_t.u to get the id of the updated track.
   */
  public var MediaPlayerESUpdated = 285;

  /**
   * Media player program added.
   */
  public var MediaPlayerProgramAdded = 286;

  /**
   * Media player program deleted.
   */
  public var MediaPlayerProgramDeleted = 287;

  /**
   * Media player program selected.
   */
  public var MediaPlayerProgramSelected = 288;

  /**
   * Media player program updated.
   */
  public var MediaPlayerProgramUpdated = 289;

  /**
   * The title list changed, call
   * libvlc_media_player_get_full_title_descriptions() to get the new list.
   */
  public var MediaPlayerTitleListChanged = 290;

  /**
   * The title selection changed, cf media_player_title_selection_changed in
   * @ref libvlc_event_t.u
   */
  public var MediaPlayerTitleSelectionChanged = 291;

  /**
   * Chapter of media changed
   */
  public var MediaPlayerChapterChanged = 292;

  /**
   * Recording status changed???
   */
  public var MediaPlayerRecordChanged = 293;

  /**
   * A @link #libvlc_media_t media item@endlink was added to a
   * @link #libvlc_media_list_t media list@endlink.
   */
  public var MediaListItemAdded = 512;

  /**
   * A @link #libvlc_media_t media item@endlink is about to get
   * added to a @link #libvlc_media_list_t media list@endlink.
   */
  public var MediaListWillAddItem = 513;

  /**
   * A @link #libvlc_media_t media item@endlink was deleted from
   * a @link #libvlc_media_list_t media list@endlink.
   */
  public var MediaListItemDeleted = 514;

  /**
   * A @link #libvlc_media_t media item@endlink is about to get
   * deleted from a @link #libvlc_media_list_t media list@endlink.
   */
  public var MediaListWillDeleteItem = 515;

  /**
   * A @link #libvlc_media_list_t media list@endlink has reached the
   * end.
   * All @link #libvlc_media_t items@endlink were either added (in
   * case of a @ref libvlc_media_discoverer_t) or parsed (preparser).
   */
  public var MediaListEndReached = 516;

  /**
   * @deprecated No longer used.
   * This belonged to the removed libvlc_media_list_view_t
   */
  public var MediaListViewItemAdded = 768;

  /**
   * @deprecated No longer used.
   * This belonged to the removed libvlc_media_list_view_t
   */
  public var MediaListViewWillAddItem = 769;

  /**
   * @deprecated No longer used.
   * This belonged to the removed libvlc_media_list_view_t
   */
  public var MediaListViewItemDeleted = 770;

  /**
   * @deprecated No longer used.
   * This belonged to the removed libvlc_media_list_view_t
   */
  public var MediaListViewWillDeleteItem = 771;

  /**
   * Playback of a @link libvlc_media_list_player_t has started.
   */
  public var MediaListPlayerPlayed = 1024;

  /**
   * The current @link libvlc_media_t of a @link libvlc_media_list_player_t
   * has changed to a different item.
   */
  public var MediaListPlayerNextItemSet = 1025;

  /**
   * Playback of a @link libvlc_media_list_player_t has stopped.
   */
  public var MediaListPlayerStopped = 1026;

  /**
   * A new @link libvlc_renderer_item_t was found by a @link libvlc_renderer_discoverer_t .
   * The renderer item is valid until deleted.
   */
  public var RendererDiscovererItemAdded = 1282;

  /**
   * A previously discovered @link libvlc_renderer_item_t was deleted by a @link libvlc_renderer_discoverer_t .
   * The renderer item is no longer valid.
   */
  public var RendererDiscovererItemDeleted = 1283;
}

/**
 * Audio mix modes.
 */
enum abstract LibVLC_AudioOutputMixMode(Int) from Int to Int
{
  /**
   * Unset
   */
  public var AudioMixMode_Unset = 0;

  /**
   * Stereo
   */
  public var AudioMixMode_Stereo = 1;

  /**
   * Binaural
   */
  public var AudioMixMode_Binaural = 2;

  /**
   * 4.0 Surround
   */
  public var AudioMixMode_4_0 = 3;

  /**
   * 5.1 Surround
   */
  public var AudioMixMode_5_1 = 4;

  /**
   * 7.1 Surround
   */
  public var AudioMixMode_7_1 = 5;
}

/**
 * Audio stereo modes.
 */
enum abstract LibVLC_AudioOutputStereoMode(Int) from Int to Int
{
  /**
   * Unset
   */
  public var AudioStereoMode_Unset = 0;

  /**
   * Stereo
   */
  public var AudioStereoMode_Stereo = 1;

  /**
   * RStereo
   */
  public var AudioStereoMode_RStereo = 2;

  /**
   * Left
   */
  public var AudioStereoMode_Left = 3;

  /**
   * Right
   */
  public var AudioStereoMode_Right = 4;

  /**
   * Dolbys
   */
  public var AudioStereoMode_Dolbys = 5;

  /**
   * Mono
   */
  public var AudioStereoMode_Mono = 7;
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
  /**
   * Don't use a media player role
   */
  public var None = 0;

  /**
   * Music (or radio) playback
   */
  public var Music = 1;

  /**
   * Video playback
   */
  public var Video = 2;

  /**
   * Speech, real-time communication
   */
  public var Communication = 3;

  /**
   * Video game
   */
  public var Game = 4;

  /**
   * User interaction feedback
   */
  public var Notification = 5;

  /**
   * Embedded animation (e.g. in web page)
   */
  public var Animation = 6;

  /**
   * Audio editing/production
   */
  public var Production = 7;

  /**
   * Accessibility
   */
  public var Accessibility = 8;

  /**
   * Testing
   */
  // Test: 9;
}

/**
 * Internal type for media parse flags.
 */
@:include('vlc/vlc.h')
@:unreflective
@:native('libvlc_media_parse_flag_t')
extern class LibVLC_MediaParseFlag_T {}

/**
 * Parse flags used by libvlc_media_parse_request()
 */
abstract LibVLC_MediaParseFlag(Int) from Int to Int
{
  public inline function new(i:Int)
  {
    this = i;
  }

  /**
   * Convert the field to its internal native type.
   * @return A value of the internal type.
   */
  @:to(LibVLC_MediaParseFlag_T)
  @:unreflective
  public inline function toNative():LibVLC_MediaParseFlag_T
  {
    return untyped __cpp__('((libvlc_media_parse_flag_t)({0}))', this);
  }

  /**
   * Conver the internal native type to an enum.
   * @param value A value of the native type.
   * @return A value of the enum value.
   */
  @:from(LibVLC_MediaParseFlag_T)
  @:unreflective
  public static inline function fromNative(value:LibVLC_MediaParseFlag_T):LibVLC_MediaParseFlag
  {
    return new LibVLC_MediaParseFlag(untyped value);
  }

  /**
   * Parse media if it's a local file. 
   */
  public static var media_parse_local(default, null):Int = new LibVLC_MediaParseFlag(untyped __cpp__('libvlc_media_parse_local'));

  /**
   * Parse media even if it's a network file. 
   */
  public static var media_parse_network(default, null):Int = new LibVLC_MediaParseFlag(untyped __cpp__('media_parse_network'));

  /**
   * Fetch meta and cover art using local resources. 
   */
  public static var media_fetch_local(default, null):Int = new LibVLC_MediaParseFlag(untyped __cpp__('media_fetch_local'));

  /**
   * Fetch meta and cover art using network resources. 
   */
  public static var media_fetch_network(default, null):Int = new LibVLC_MediaParseFlag(untyped __cpp__('media_fetch_network'));

  /**
   * Interact with the user (via libvlc_dialog_cbs) when preparsing this item (and not its sub items).
   * Set this flag in order to receive a callback when the input is asking for credentials. 
   */
  public static var media_do_interact(default, null):Int = new LibVLC_MediaParseFlag(untyped __cpp__('media_do_interact'));

  /**
   * Force parsing the media even if it would be skipped. 
   */
  public static var media_no_skip(default, null):Int = new LibVLC_MediaParseFlag(untyped __cpp__('media_no_skip'));
}

/**
 * Internal type for media track types.
 */
@:include('vlc/vlc.h')
@:unreflective
@:native('libvlc_track_type_t')
extern class LibVLC_MediaTrackType_T {}

/**
 * Media track types.
 */
abstract LibVLC_MediaTrackType(Int) from Int to Int
{
  public inline function new(i:Int)
  {
    this = i;
  }

  /**
   * Convert the field to its internal native type.
   * @return A value of the internal type.
   */
  @:to(LibVLC_MediaTrackType_T)
  @:unreflective
  public inline function toNative():LibVLC_MediaTrackType_T
  {
    return untyped __cpp__('((libvlc_track_type_t)({0}))', this);
  }

  /**
   * Conver the internal native type to an enum.
   * @param value A value of the native type.
   * @return A value of the enum value.
   */
  @:from(LibVLC_MediaTrackType_T)
  @:unreflective
  public static inline function fromNative(value:LibVLC_MediaTrackType_T):LibVLC_MediaTrackType
  {
    return new LibVLC_MediaTrackType(untyped value);
  }

  /**
   * An unknown track (possibly data)
   */
  public static var libvlc_track_unknown(default, null):Int = new LibVLC_MediaTrackType(untyped __cpp__('libvlc_track_unknown'));

  /**
   * An audio track
   */
  public static var libvlc_track_audio(default, null):Int = new LibVLC_MediaTrackType(untyped __cpp__('libvlc_track_audio'));

  /**
   * A video track
   */
  public static var libvlc_track_video(default, null):Int = new LibVLC_MediaTrackType(untyped __cpp__('libvlc_track_video'));

  /**
   * A text track (used for subtitles, captions, etc.)
   */
  public static var libvlc_track_text(default, null):Int = new LibVLC_MediaTrackType(untyped __cpp__('libvlc_track_text'));
}

/**
 * Parse status used sent by `LibVLCMedia.parse_request()` or returned by `LibVLCMedia.get_parsed_status()`
 */
enum abstract LibVLC_MediaParsedStatus(Int) from Int to Int
{
  /**
   * None
   */
  public var media_parsed_status_none = 0;

  /**
   * Pending
   */
  public var media_parsed_status_pending = 1;

  /**
   * Skipped
   */
  public var media_parsed_status_skipped = 2;

  /**
   * Failed
   */
  public var media_parsed_status_failed = 3;

  /**
   * Timeout
   */
  public var media_parsed_status_timeout = 4;

  /**
   * Done
   */
  public var media_parsed_status_done = 5;
}

/**
 * Logging message level.
 */
enum abstract LibVLC_LogLevel(Int) from Int to Int
{
  /**
   * Debug message
   */
  public var LIBVLC_DEBUG = 0;

  /**
   * Important informational message
   */
  public var LIBVLC_NOTICE = 2;

  /**
   * Warning (potential error) message
   */
  public var LIBVLC_WARNING = 3;

  /**
   * Error message
   */
  public var LIBVLC_ERROR = 4;
}
