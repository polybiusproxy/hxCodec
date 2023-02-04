package hxcodecpro._internal;

import cpp.Int64;

#if (!(desktop || android) && macro)
#error "LibVLC only supports the Windows, Mac, Linux, and Android target platforms."
#end

/**
 * @see https://videolan.videolan.me/vlc/group__libvlc__media__player.html
 */
@:buildXml("<include name='${haxelib:hxcodecpro}/project/Build.xml' />") // Link static/dynamic libraries for VLC
@:include("vlc/vlc.h") // Include VLC functions and types
@:keep // Fix issues with DCE
@:unreflective // TODO: Write down why this is needed
extern class LibVLCMediaPlayer
{
  /**
   * Create a Media Player object from a Media
   *
   * @param inst LibVLC instance to create a media player with
   * @param p_md the media. Afterwards the p_md can be safely
   *        destroyed.
   * @return a new media player object, or NULL on error.
   * It must be released by libvlc_media_player_release().
   */
  @:native("libvlc_media_player_new_from_media")
  static function new_from_media(inst:LibVLC_Instance, p_md:LibVLC_Media):LibVLC_MediaPlayer;

  /**
   * Get the Event Manager from which the media player send event.
   *
   * @param p_mi the Media Player
   * @return the event manager associated with p_mi
   */
  @:native("libvlc_media_player_event_manager")
  static function event_manager(p_mi:LibVLC_MediaPlayer):LibVLC_EventManager;

  /**
   * is_playing
   *
   * @param p_mi the Media Player
   * @retval true media player is playing
   * @retval false media player is not playing
   */
  @:native("libvlc_media_player_is_playing")
  static function is_playing(p_mi:LibVLC_MediaPlayer):Bool;

  /**
   * Play
   *
   * @param p_mi the Media Player
   * @return 0 if playback started (and was already started), or -1 on error.
   */
  @:native("libvlc_media_player_play")
  static function play(p_mi:LibVLC_MediaPlayer):Int;

  /**
   * Pause or resume (no effect if there is no media)
   *
   * @param mp the Media Player
   * @param do_pause play/resume if zero, pause if non-zero
   * @version LibVLC 1.1.1 or later
   */
  @:native("libvlc_media_player_set_pause")
  static function set_pause(mp:LibVLC_MediaPlayer, do_pause:Int):Void;

  /**
   * Toggle pause (no effect if there is no media)
   *
   * @param p_mi the Media Player
   */
  @:native("libvlc_media_player_pause")
  static function pause(p_mi:LibVLC_MediaPlayer):Void;

  /**
   * Get the requested movie play rate.
   * @warning Depending on the underlying media, the requested rate may be
   * different from the real playback rate.
   *
   * @param p_mi the Media Player
   * @return movie play rate
   */
  @:native("libvlc_media_player_get_rate")
  static function get_rate(p_mi:LibVLC_MediaPlayer):Float;

  /**
   * Set movie play rate
   *
   * @param p_mi the Media Player
   * @param rate movie play rate to set
   * @return -1 if an error was detected, 0 otherwise (but even then, it might
   * not actually work depending on the underlying media protocol)
   */
  @:native("libvlc_media_player_set_rate")
  static function set_rate(p_mi:LibVLC_MediaPlayer, rate:Float):Int;

  /**
   * Get movie position as percentage between 0.0 and 1.0.
   *
   * @param p_mi the Media Player
   * @return movie position, or -1. in case of error
   */
  @:native("libvlc_media_player_get_position")
  static function get_position(p_mi:LibVLC_MediaPlayer):Float;

  /**
   * Set movie position as percentage between 0.0 and 1.0.
   * This has no effect if playback is not enabled.
   * This might not work depending on the underlying input format and protocol.
   *
   * @param p_mi the Media Player
   * @param b_fast prefer fast seeking or precise seeking
   * @param f_pos the position
   * @return 0 on success, -1 on error
   */
  @:native("libvlc_media_player_set_position")
  static function set_position(p_mi:LibVLC_MediaPlayer, f_pos:Float, b_fast:Bool):Int;

  /**
   * Get the current movie length (in ms).
   *
   * @param p_mi the Media Player
   * @return the movie length (in ms), or -1 if there is no media.
   */
  @:native("libvlc_media_player_get_length")
  static function get_length(p_mi:LibVLC_MediaPlayer):cpp.Int64;

  /**
   * Get the current movie time (in ms).
   *
   * @param p_mi the Media Player
   * @return the movie time (in ms), or -1 if there is no media.
   */
  @:native("libvlc_media_player_get_time")
  static function get_time(p_mi:LibVLC_MediaPlayer):cpp.Int64;

  /**
   * Set the movie time (in ms). This has no effect if no media is being played.
   * Not all formats and protocols support this.
   *
   * \param p_mi the Media Player
   * \param b_fast prefer fast seeking or precise seeking
   * \param i_time the movie time (in ms).
   * \return 0 on success, -1 on error
   */
  @:native("libvlc_media_player_set_time")
  static function set_time(p_mi:LibVLC_MediaPlayer, i_time:cpp.Int64, b_fast:Bool):Void;

  /**
   * Is this media player seekable?
   *
   * \param p_mi the media player
   * \retval true media player can seek
   * \retval false media player cannot seek
   */
  @:native("libvlc_media_player_is_seekable")
  static function is_seekable(p_mi:LibVLC_MediaPlayer):Bool;

  /**
   * Can this media player be paused?
   *
   * \param p_mi the media player
   * \retval true media player can be paused
   * \retval false media player cannot be paused
   */
  @:native("libvlc_media_player_can_pause")
  static function can_pause(p_mi:LibVLC_MediaPlayer):Bool;
}
