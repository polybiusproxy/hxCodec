package hxcodecpro._internal;

import cpp.Int64;

#if (!(desktop || android) && macro)
#error "LibVLC only supports the Windows, Mac, Linux, and Android target platforms."
#end

/**
 * @see https://videolan.videolan.me/vlc/group__libvlc__media__track.html
 */
@:buildXml("<include name='${haxelib:hxcodecpro}/project/Build.xml' />") // Link static/dynamic libraries for VLC
@:include("vlc/vlc.h") // Include VLC functions and types
@:keep // Fix issues with DCE
@:unreflective // TODO: Write down why this is needed
extern class LibVLCMediaTrack
{
  /**
   * Hold a single track reference
   *
   * @version LibVLC 4.0.0 and later.
   *
   * This function can be used to hold a track from a tracklist. In that case,
   * the track can outlive its tracklist.
   *
   * @param track valid track
   * @return the same track, need to be released with libvlc_media_track_release()
   */
  @:native("libvlc_media_track_hold")
  static function hold(track:LibVLC_MediaTrack):LibVLC_MediaTrack;

  /**
   * Release a single track
   *
   * @version LibVLC 4.0.0 and later.
   *
   * @warning Tracks from a tracklist are released alongside the list with
   * libvlc_media_tracklist_delete().
   *
   * @note You only need to release tracks previously held with
   * LibVLCMediaTrack.track_hold() or returned by
   * libvlc_media_player_get_selected_track() and
   * libvlc_media_player_get_track_from_id()
   *
   * @param track valid track
   */
  @:native("libvlc_media_track_release")
  static function release(track:LibVLC_MediaTrack):Void;
}

class LibVLCMediaTrackHelper
{
  /**
   * Retrieves the video track information from a media track.
   * 
   * @param track The media track.
   * @return The video track information.
   */
  @:functionCode('
    if (track->i_type != libvlc_track_video) return NULL;

    return track->video;
  ')
  public static function getVideoTrack(track:LibVLC_MediaTrack):LibVLC_VideoTrack
  {
    throw 'functionCode';
  }

  /**
   * Retrieves the audio track information from a media track.
   * 
   * @param track The media track.
   * @return The audio track information.
   */
  @:functionCode('
    if (track->i_type != libvlc_track_audio) return NULL;

    return track->audio;
  ')
  public static function getAudioTrack(track:LibVLC_MediaTrack):LibVLC_AudioTrack
  {
    throw 'functionCode';
  }

  /**
   * Calculates the frame rate of a video track.
   * 
   * @param track The video track.
   * @return The frame rate in frames per second.
   */
  @:functionCode('
    if (track == NULL) return NULL;

    return track->i_frame_rate_num / track->i_frame_rate_den;
  ')
  public static function getFPS(track:LibVLC_VideoTrack):Float
  {
    throw 'functionCode';
  }
}
