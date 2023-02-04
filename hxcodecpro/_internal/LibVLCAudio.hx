package hxcodecpro._internal;

import cpp.Int64;

#if (!(desktop || android) && macro)
#error "LibVLC only supports the Windows, Mac, Linux, and Android target platforms."
#end

/**
 * @see https://videolan.videolan.me/vlc/group__libvlc__audio.html
 */
@:buildXml("<include name='${haxelib:hxcodecpro}/project/Build.xml' />") // Link static/dynamic libraries for VLC
@:include("vlc/vlc.h") // Include VLC functions and types
@:keep // Fix issues with DCE
@:unreflective // TODO: Write down why this is needed
extern class LibVLCAudio
{
  /**
   * Gets the list of available audio output modules.
   *
   * @param p_instance libvlc instance
   * @return list of available audio outputs. It must be freed with
   *          @see `LibVLCAudio.output_list_release()`
   *          @see `LibVLC_AudioOutput`
   *          In case of error, NULL is returned.
   */
  @:native("libvlc_audio_output_list_get")
  static function output_list_get(p_instance:LibVLC_Instance):LibVLC_AudioOutput;

  /**
   * Frees the list of available audio output modules.
   *
   * @param p_list list with audio outputs for release
   */
  @:native("libvlc_audio_output_list_release")
  static function output_list_release(p_list:LibVLC_AudioOutput):Void;

  /**
   * Selects an audio output module.
   * @note Any change will take be effect only after playback is stopped and
   * restarted. Audio output cannot be changed while playing.
   *
   * @param p_mi media player
   * @param psz_name name of audio output,
   *               use psz_name of @see `LibVLC_AudioOutput`
   * @return 0 if function succeeded, -1 on error
   */
  @:native("libvlc_audio_output_set")
  static function output_set(p_mi:LibVLC_MediaPlayer, psz_name:String):Int;

  /**
   * Gets a list of potential audio output devices.
   *
   * See also `LibVLCAudio.output_device_set()`
   *
   * @note Not all audio outputs support enumerating devices.
   * The audio output may be functional even if the list is empty (NULL).
   *
   * @note The list may not be exhaustive.
   *
   * @warning Some audio output devices in the list might not actually work in
   * some circumstances. By default, it is recommended to not specify any
   * explicit audio device.
   *
   * @param mp media player
   * @return A NULL-terminated linked list of potential audio output devices.
   * It must be freed with `LibVLCAudio.output_device_list_release()`
   * @version LibVLC 2.2.0 or later.
   */
  @:native("libvlc_audio_output_device_enum")
  static function output_device_enum(mp:LibVLC_MediaPlayer):LibVLC_AudioOutputDevice;

  @:native("libvlc_audio_output_device_list_get")
  static function output_device_list_get(p_instance:LibVLC_Instance, aout:String):LibVLC_AudioOutputDevice;

  /**
   * Frees a list of available audio output devices.
   *
   * @param p_list list with audio outputs for release
   * @version LibVLC 2.1.0 or later.
   */
  @:native("libvlc_audio_output_device_list_release")
  static function output_device_list_release(p_list:LibVLC_AudioOutputDevice):Void;

  /**
   * Configures an explicit audio output device.
   *
   * A list of adequate potential device strings can be obtained with
   * `LibVLCAudio.output_device_enum()`.
   *
   * @note This function does not select the specified audio output plugin.
   * `LibVLCAudio.output_set()` is used for that purpose.
   *
   * @warning The syntax for the device parameter depends on the audio output.
   *
   * Some audio output modules require further parameters (e.g. a channels map
   * in the case of ALSA).
   *
   * @version This function originally expected three parameters.
   * The middle parameter was removed from LibVLC 4.0 onward.
   *
   * @param mp media player
   * @param device_id device identifier string
   *               (see @ref libvlc_audio_output_device_t::psz_device)
   *
   * @return If the change of device was requested succesfully, zero is returned
   * (the actual change is asynchronous and not guaranteed to succeed).
   * On error, a non-zero value is returned.
   */
  @:native("libvlc_audio_output_device_set")
  static function output_device_set(mp:LibVLC_MediaPlayer, device_id:String):Int;

  /**
   * Get current software audio volume.
   *
   * \param p_mi media player
   * \return the software volume in percents
   * (0 = mute, 100 = nominal / 0dB)
   */
  @:native("libvlc_audio_get_volume")
  static function get_volume(p_mi:LibVLC_MediaPlayer):Int;

  /**
   * Set current software audio volume.
   *
   * \param p_mi media player
   * \param i_volume the volume in percents (0 = mute, 100 = 0dB)
   * \return 0 if the volume was set, -1 if it was out of range
   */
  @:native("libvlc_audio_set_volume")
  static function set_volume(p_mi:LibVLC_MediaPlayer, i_volume:Int):Int;

  /**
   * Get current audio delay.
   *
   * \param p_mi media player
   * \return the audio delay (microseconds)
   * \version LibVLC 1.1.1 or later
   */
  @:native("libvlc_audio_get_delay")
  static function get_delay(p_mi:LibVLC_MediaPlayer):cpp.Int64;

  /**
   * Set current audio delay. The audio delay will be reset to zero each time the media changes.
   *
   * \param p_mi media player
   * \param i_delay the audio delay (microseconds)
   * \return 0 on success, -1 on error
   * \version LibVLC 1.1.1 or later
   */
  @:native("libvlc_audio_set_delay")
  static function set_delay(p_mi:LibVLC_MediaPlayer, i_delay:cpp.Int64):Int;
}
