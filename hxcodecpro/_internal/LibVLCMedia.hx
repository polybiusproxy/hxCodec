package hxcodecpro._internal;

import cpp.Int64;

#if (!(desktop || android) && macro)
#error "LibVLC only supports the Windows, Mac, Linux, and Android target platforms."
#end

/**
 * @see https://videolan.videolan.me/vlc/group__libvlc__media.html
 */
@:buildXml("<include name='${haxelib:hxcodecpro}/project/Build.xml' />") // Link static/dynamic libraries for VLC
@:include("vlc/vlc.h") // Include VLC functions and types
@:keep // Fix issues with DCE
@:unreflective // TODO: Write down why this is needed
extern class LibVLCMedia
{
  /**
   * Create a media with a certain given media resource location,
   * for instance a valid URL.
   *
   * @note To refer to a local file with this function,
   * the file://... URI syntax <b>must</b> be used (see IETF RFC3986).
   * We recommend using libvlc_media_new_path() instead when dealing with
   * local files.
   *
   * @see libvlc_media_release
   *
   * @param psz_mrl the media location
   * @return the newly created media or NULL on error
   */
  @:native("libvlc_media_new_location")
  static function new_location(psz_mrl:String):LibVLC_Media;

  /**
   * Create a media for a certain file path.
   *
   * @see libvlc_media_release
   *
   * @param path local filesystem path
   * @return the newly created media or NULL on error
   */
  @:native("libvlc_media_new_path")
  static function new_path(path:String):LibVLC_Media;

  /**
   * Create a media with custom callbacks to read the data from.
   *
   * @param open_cb callback to open the custom bitstream input media
   * @param read_cb callback to read data (must not be NULL)
   * @param seek_cb callback to seek, or NULL if seeking is not supported
   * @param close_cb callback to close the media, or NULL if unnecessary
   * @param opaque data pointer for the open callback
   *
   * @return the newly created media or NULL on error
   *
   * @note If open_cb is NULL, the opaque pointer will be passed to read_cb,
   * seek_cb and close_cb, and the stream size will be treated as unknown.
   *
   * @note The callbacks may be called asynchronously (from another thread).
   * A single stream instance need not be reentrant. However the open_cb needs to
   * be reentrant if the media is used by multiple player instances.
   *
   * @warning The callbacks may be used until all or any player instances
   * that were supplied the media item are stopped.
   *
   * @see libvlc_media_release
   *
   * @version LibVLC 3.0.0 and later.
   */
  @:native("libvlc_media_new_callbacks")
  static function new_callbacks(open_cb:LibVLC_Media_Open_Callback, read_cb:LibVLC_Media_Read_Callback, seek_cb:LibVLC_Media_Seek_Callback,
    close_cb:LibVLC_Media_Close_Callback, opaque:VoidStar):LibVLC_Media;

  /**
   * Parse the media asynchronously with options.
   *
   * This fetches (local or network) art, meta data and/or tracks information.
   *
   * To track when this is over you can listen to MediaParsedChanged
   * event. However if this functions returns an error, you will not receive any
   * events.
   *
   * It uses a flag to specify parse options (see libvlc_media_parse_flag_t). All
   * these flags can be combined. By default, media is parsed if it's a local
   * file.
   *
   * @note Parsing can be aborted with libvlc_media_parse_stop().
   *
   * @see libvlc_MediaParsedChanged
   * @see libvlc_media_get_meta
   * @see libvlc_media_get_tracklist
   * @see libvlc_media_get_parsed_status
   * @see libvlc_media_parse_flag_t
   *
   * @param inst LibVLC instance that is to parse the media
   * @param p_md media descriptor object
   * @param parse_flag parse options:
   * @param timeout maximum time allowed to preparse the media. If -1, the
   * default "preparse-timeout" option will be used as a timeout. If 0, it will
   * wait indefinitely. If > 0, the timeout will be used (in milliseconds).
   * @return -1 in case of error, 0 otherwise
   * @version LibVLC 4.0.0 or later
   */
  @:native("libvlc_media_parse_request")
  static function parse_request(inst:LibVLC_Instance, p_md:LibVLC_Media, parse_flag:LibVLC_MediaParseFlag_T, timeout:Int):Int;

  /**
   * Stop the parsing of the media
   *
   * When the media parsing is stopped, the LibVLC_EventType.MediaParsedChanged event will
   * be sent with the libvlc_media_parsed_status_timeout status.
   *
   * @see LibVLCMedia.parse_request()
   *
   * @param inst LibVLC instance that is to cease or give up parsing the media
   * @param p_md media descriptor object
   * @version LibVLC 3.0.0 or later
   */
  @:native("libvlc_media_parse_stop")
  static function parse_stop(inst:LibVLC_Instance, p_md:LibVLC_Media):Void;

  /**
   * Get Parsed status for media descriptor object.
   *
   * @see LibVLC_EventType.MediaParsedChanged
   * @see LibVLC_MediaParsedStatus
   * @see LibVLCMedia.parse_request()
   *
   * @param p_md media descriptor object
   * @return a value of the LibVLC_MediaParsedStatus enum
   * @version LibVLC 3.0.0 or later
   */
  @:native("libvlc_media_get_parsed_status")
  static function get_parsed_status(p_md:LibVLC_Media):LibVLC_MediaParsedStatus;

  /**
   * Retain a reference to a media descriptor object (LibVLC_Media). Use
   * LibVLCMedia.release() to decrement the reference count of a
   * media descriptor object.
   *
   * @param p_md the media descriptor
   */
  @:native("libvlc_media_retain")
  static function retain(p_md:LibVLC_Media):Void;

  /**
   * Decrement the reference count of a media descriptor object. If the
   * reference count is 0, then LibVLCMedia.release() will release the
   * media descriptor object. If the media descriptor object has been released it
   * should not be used again.
   *
   * @param p_md the media descriptor
   */
  @:native("libvlc_media_release")
  static function release(p_md:LibVLC_Media):Void;

  /**
   * Add an option to the media.
   *
   * This option will be used to determine how the media_player will
   * read the media. This allows to use VLC's advanced
   * reading/streaming options on a per-media basis.
   *
   * @note The options are listed in 'vlc --longhelp' from the command line,
   * e.g. "--sout-all". Keep in mind that available options and their semantics
   * vary across LibVLC versions and builds.
   * @warning Not all options affects libvlc_media_t objects:
   * Specifically, due to architectural issues most audio and video options,
   * such as text renderer options, have no effects on an individual media.
   * These options must be set through libvlc_new() instead.
   *
   * @param p_md the media descriptor
   * @param psz_options the options (as a string)
   */
  @:native("libvlc_media_add_option")
  static function add_option(p_md:LibVLC_Media, psz_options:String):Void;

  /**
   * Add an option to the media with configurable flags.
   *
   * This option will be used to determine how the media_player will
   * read the media. This allows to use VLC's advanced
   * reading/streaming options on a per-media basis.
   *
   * The options are detailed in vlc --longhelp, for instance
   * "--sout-all". Note that all options are not usable on medias:
   * specifically, due to architectural issues, video-related options
   * such as text renderer options cannot be set on a single media. They
   * must be set on the whole libvlc instance instead.
   *
   * @param p_md the media descriptor
   * @param psz_options the options (as a string)
   * @param i_flags the flags for this option
   */
  @:native("libvlc_media_add_option_flag")
  static function add_option_flag(p_md:LibVLC_Media, psz_options:String, i_flags:Int):Void;

  /**
   * Get event manager from media descriptor object.
   * NOTE: this function doesn't increment reference counting.
   *
   * @param p_md a media descriptor object
   * @return event manager object
   */
  @:native("libvlc_media_event_manager")
  static function event_manager(p_md:LibVLC_Media):LibVLC_EventManager;

  /**
   * Get duration (in ms) of media descriptor object item.
   *
   * Note, you need to call libvlc_media_parse_request() or play the media
   * at least once before calling this function.
   * Not doing this will result in an undefined result.
   *
   * @param p_md media descriptor object
   * @return duration of media item or -1 on error
   */
  @:native("libvlc_media_get_duration")
  static function get_duration(p_md:LibVLC_Media):cpp.Int64;

  /**
   * Get the media resource locator (mrl) from a media descriptor object
   *
   * @param p_md a media descriptor object
   * @return string with mrl of media descriptor object
   */
  @:native("libvlc_media_get_mrl")
  static function get_mrl(p_md:LibVLC_Media):String;
}
