#ifndef VLC_LIBVLC_MEDIA_PLAYER_H
#define VLC_LIBVLC_MEDIA_PLAYER_H 1

#ifdef __cplusplus
extern "C"
{
#else
#include <stdbool.h>
#endif

    typedef struct libvlc_media_player_t libvlc_media_player_t;

    typedef struct libvlc_track_description_t
    {
        int i_id;
        char *psz_name;
        struct libvlc_track_description_t *p_next;

    } libvlc_track_description_t;

    typedef struct libvlc_audio_output_t
    {
        char *psz_name;
        char *psz_description;
        struct libvlc_audio_output_t *p_next;

    } libvlc_audio_output_t;

    typedef struct libvlc_audio_output_device_t
    {
        struct libvlc_audio_output_device_t *p_next;
        char *psz_device;
        char *psz_description;

    } libvlc_audio_output_device_t;

    typedef struct libvlc_rectangle_t
    {
        int top, left;
        int bottom, right;
    } libvlc_rectangle_t;

    typedef enum libvlc_video_marquee_option_t
    {
        libvlc_marquee_Enable = 0,
        libvlc_marquee_Text,
        libvlc_marquee_Color,
        libvlc_marquee_Opacity,
        libvlc_marquee_Position,
        libvlc_marquee_Refresh,
        libvlc_marquee_Size,
        libvlc_marquee_Timeout,
        libvlc_marquee_X,
        libvlc_marquee_Y
    } libvlc_video_marquee_option_t;

    typedef enum libvlc_navigate_mode_t
    {
        libvlc_navigate_activate = 0,
        libvlc_navigate_up,
        libvlc_navigate_down,
        libvlc_navigate_left,
        libvlc_navigate_right
    } libvlc_navigate_mode_t;

    typedef enum libvlc_position_t
    {
        libvlc_position_disable = -1,
        libvlc_position_center,
        libvlc_position_left,
        libvlc_position_right,
        libvlc_position_top,
        libvlc_position_top_left,
        libvlc_position_top_right,
        libvlc_position_bottom,
        libvlc_position_bottom_left,
        libvlc_position_bottom_right
    } libvlc_position_t;

    LIBVLC_API libvlc_media_player_t *libvlc_media_player_new(libvlc_instance_t *p_libvlc_instance);

    LIBVLC_API libvlc_media_player_t *libvlc_media_player_new_from_media(libvlc_media_t *p_md);

    LIBVLC_API void libvlc_media_player_release(libvlc_media_player_t *p_mi);

    LIBVLC_API void libvlc_media_player_retain(libvlc_media_player_t *p_mi);

    LIBVLC_API void libvlc_media_player_set_media(libvlc_media_player_t *p_mi,
                                                  libvlc_media_t *p_md);

    LIBVLC_API libvlc_media_t *libvlc_media_player_get_media(libvlc_media_player_t *p_mi);

    LIBVLC_API libvlc_event_manager_t *libvlc_media_player_event_manager(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_media_player_is_playing(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_media_player_play(libvlc_media_player_t *p_mi);

    LIBVLC_API void libvlc_media_player_set_pause(libvlc_media_player_t *mp,
                                                  int do_pause);

    LIBVLC_API void libvlc_media_player_pause(libvlc_media_player_t *p_mi);

    LIBVLC_API void libvlc_media_player_stop(libvlc_media_player_t *p_mi);

    typedef void *(*libvlc_video_lock_cb)(void *opaque, void **planes);

    typedef void (*libvlc_video_unlock_cb)(void *opaque, void *picture,
                                           void *const *planes);

    typedef void (*libvlc_video_display_cb)(void *opaque, void *picture);

    typedef unsigned (*libvlc_video_format_cb)(void **opaque, char *chroma,
                                               unsigned *width, unsigned *height,
                                               unsigned *pitches,
                                               unsigned *lines);

    typedef void (*libvlc_video_cleanup_cb)(void *opaque);

    LIBVLC_API
    void libvlc_video_set_callbacks(libvlc_media_player_t *mp,
                                    libvlc_video_lock_cb lock,
                                    libvlc_video_unlock_cb unlock,
                                    libvlc_video_display_cb display,
                                    void *opaque);

    LIBVLC_API
    void libvlc_video_set_format(libvlc_media_player_t *mp, const char *chroma,
                                 unsigned width, unsigned height,
                                 unsigned pitch);

    LIBVLC_API
    void libvlc_video_set_format_callbacks(libvlc_media_player_t *mp,
                                           libvlc_video_format_cb setup,
                                           libvlc_video_cleanup_cb cleanup);

    LIBVLC_API void libvlc_media_player_set_nsobject(libvlc_media_player_t *p_mi, void *drawable);

    LIBVLC_API void *libvlc_media_player_get_nsobject(libvlc_media_player_t *p_mi);

    LIBVLC_API void libvlc_media_player_set_agl(libvlc_media_player_t *p_mi, uint32_t drawable);

    LIBVLC_API uint32_t libvlc_media_player_get_agl(libvlc_media_player_t *p_mi);

    LIBVLC_API void libvlc_media_player_set_xwindow(libvlc_media_player_t *p_mi, uint32_t drawable);

    LIBVLC_API uint32_t libvlc_media_player_get_xwindow(libvlc_media_player_t *p_mi);

    LIBVLC_API void libvlc_media_player_set_hwnd(libvlc_media_player_t *p_mi, void *drawable);

    LIBVLC_API void *libvlc_media_player_get_hwnd(libvlc_media_player_t *p_mi);

    typedef void (*libvlc_audio_play_cb)(void *data, const void *samples,
                                         unsigned count, int64_t pts);

    typedef void (*libvlc_audio_pause_cb)(void *data, int64_t pts);

    typedef void (*libvlc_audio_resume_cb)(void *data, int64_t pts);

    typedef void (*libvlc_audio_flush_cb)(void *data, int64_t pts);

    typedef void (*libvlc_audio_drain_cb)(void *data);

    typedef void (*libvlc_audio_set_volume_cb)(void *data,
                                               float volume, bool mute);

    LIBVLC_API
    void libvlc_audio_set_callbacks(libvlc_media_player_t *mp,
                                    libvlc_audio_play_cb play,
                                    libvlc_audio_pause_cb pause,
                                    libvlc_audio_resume_cb resume,
                                    libvlc_audio_flush_cb flush,
                                    libvlc_audio_drain_cb drain,
                                    void *opaque);

    LIBVLC_API
    void libvlc_audio_set_volume_callback(libvlc_media_player_t *mp,
                                          libvlc_audio_set_volume_cb set_volume);

    typedef int (*libvlc_audio_setup_cb)(void **data, char *format, unsigned *rate,
                                         unsigned *channels);

    typedef void (*libvlc_audio_cleanup_cb)(void *data);

    LIBVLC_API
    void libvlc_audio_set_format_callbacks(libvlc_media_player_t *mp,
                                           libvlc_audio_setup_cb setup,
                                           libvlc_audio_cleanup_cb cleanup);

    LIBVLC_API
    void libvlc_audio_set_format(libvlc_media_player_t *mp, const char *format,
                                 unsigned rate, unsigned channels);

    LIBVLC_API libvlc_time_t libvlc_media_player_get_length(libvlc_media_player_t *p_mi);

    LIBVLC_API libvlc_time_t libvlc_media_player_get_time(libvlc_media_player_t *p_mi);

    LIBVLC_API void libvlc_media_player_set_time(libvlc_media_player_t *p_mi, libvlc_time_t i_time);

    LIBVLC_API float libvlc_media_player_get_position(libvlc_media_player_t *p_mi);

    LIBVLC_API void libvlc_media_player_set_position(libvlc_media_player_t *p_mi, float f_pos);

    LIBVLC_API void libvlc_media_player_set_chapter(libvlc_media_player_t *p_mi, int i_chapter);

    LIBVLC_API int libvlc_media_player_get_chapter(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_media_player_get_chapter_count(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_media_player_will_play(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_media_player_get_chapter_count_for_title(
        libvlc_media_player_t *p_mi, int i_title);

    LIBVLC_API void libvlc_media_player_set_title(libvlc_media_player_t *p_mi, int i_title);

    LIBVLC_API int libvlc_media_player_get_title(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_media_player_get_title_count(libvlc_media_player_t *p_mi);

    LIBVLC_API void libvlc_media_player_previous_chapter(libvlc_media_player_t *p_mi);

    LIBVLC_API void libvlc_media_player_next_chapter(libvlc_media_player_t *p_mi);

    LIBVLC_API float libvlc_media_player_get_rate(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_media_player_set_rate(libvlc_media_player_t *p_mi, float rate);

    LIBVLC_API libvlc_state_t libvlc_media_player_get_state(libvlc_media_player_t *p_mi);

    LIBVLC_API float libvlc_media_player_get_fps(libvlc_media_player_t *p_mi);

    LIBVLC_API unsigned libvlc_media_player_has_vout(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_media_player_is_seekable(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_media_player_can_pause(libvlc_media_player_t *p_mi);

    LIBVLC_API void libvlc_media_player_next_frame(libvlc_media_player_t *p_mi);

    LIBVLC_API void libvlc_media_player_navigate(libvlc_media_player_t *p_mi,
                                                 unsigned navigate);

    LIBVLC_API void libvlc_media_player_set_video_title_display(libvlc_media_player_t *p_mi, libvlc_position_t position, unsigned int timeout);

    LIBVLC_API void libvlc_track_description_list_release(libvlc_track_description_t *p_track_description);

    LIBVLC_DEPRECATED LIBVLC_API void libvlc_track_description_release(libvlc_track_description_t *p_track_description);

    LIBVLC_API void libvlc_toggle_fullscreen(libvlc_media_player_t *p_mi);

    LIBVLC_API void libvlc_set_fullscreen(libvlc_media_player_t *p_mi, int b_fullscreen);

    LIBVLC_API int libvlc_get_fullscreen(libvlc_media_player_t *p_mi);

    LIBVLC_API
    void libvlc_video_set_key_input(libvlc_media_player_t *p_mi, unsigned on);

    LIBVLC_API
    void libvlc_video_set_mouse_input(libvlc_media_player_t *p_mi, unsigned on);

    LIBVLC_API
    int libvlc_video_get_size(libvlc_media_player_t *p_mi, unsigned num,
                              unsigned *px, unsigned *py);

    LIBVLC_DEPRECATED LIBVLC_API int libvlc_video_get_height(libvlc_media_player_t *p_mi);

    LIBVLC_DEPRECATED LIBVLC_API int libvlc_video_get_width(libvlc_media_player_t *p_mi);

    LIBVLC_API
    int libvlc_video_get_cursor(libvlc_media_player_t *p_mi, unsigned num,
                                int *px, int *py);

    LIBVLC_API float libvlc_video_get_scale(libvlc_media_player_t *p_mi);

    LIBVLC_API void libvlc_video_set_scale(libvlc_media_player_t *p_mi, float f_factor);

    LIBVLC_API char *libvlc_video_get_aspect_ratio(libvlc_media_player_t *p_mi);

    LIBVLC_API void libvlc_video_set_aspect_ratio(libvlc_media_player_t *p_mi, const char *psz_aspect);

    LIBVLC_API int libvlc_video_get_spu(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_video_get_spu_count(libvlc_media_player_t *p_mi);

    LIBVLC_API libvlc_track_description_t *
    libvlc_video_get_spu_description(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_video_set_spu(libvlc_media_player_t *p_mi, int i_spu);

    LIBVLC_API int libvlc_video_set_subtitle_file(libvlc_media_player_t *p_mi, const char *psz_subtitle);

    LIBVLC_API int64_t libvlc_video_get_spu_delay(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_video_set_spu_delay(libvlc_media_player_t *p_mi, int64_t i_delay);

    LIBVLC_API libvlc_track_description_t *
    libvlc_video_get_title_description(libvlc_media_player_t *p_mi);

    LIBVLC_API libvlc_track_description_t *
    libvlc_video_get_chapter_description(libvlc_media_player_t *p_mi, int i_title);

    LIBVLC_API char *libvlc_video_get_crop_geometry(libvlc_media_player_t *p_mi);

    LIBVLC_API
    void libvlc_video_set_crop_geometry(libvlc_media_player_t *p_mi, const char *psz_geometry);

    LIBVLC_API int libvlc_video_get_teletext(libvlc_media_player_t *p_mi);

    LIBVLC_API void libvlc_video_set_teletext(libvlc_media_player_t *p_mi, int i_page);

    LIBVLC_API void libvlc_toggle_teletext(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_video_get_track_count(libvlc_media_player_t *p_mi);

    LIBVLC_API libvlc_track_description_t *
    libvlc_video_get_track_description(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_video_get_track(libvlc_media_player_t *p_mi);

    LIBVLC_API
    int libvlc_video_set_track(libvlc_media_player_t *p_mi, int i_track);

    LIBVLC_API
    int libvlc_video_take_snapshot(libvlc_media_player_t *p_mi, unsigned num,
                                   const char *psz_filepath, unsigned int i_width,
                                   unsigned int i_height);

    LIBVLC_API void libvlc_video_set_deinterlace(libvlc_media_player_t *p_mi,
                                                 const char *psz_mode);

    LIBVLC_API int libvlc_video_get_marquee_int(libvlc_media_player_t *p_mi,
                                                unsigned option);

    LIBVLC_API char *libvlc_video_get_marquee_string(libvlc_media_player_t *p_mi,
                                                     unsigned option);

    LIBVLC_API void libvlc_video_set_marquee_int(libvlc_media_player_t *p_mi,
                                                 unsigned option, int i_val);

    LIBVLC_API void libvlc_video_set_marquee_string(libvlc_media_player_t *p_mi,
                                                    unsigned option, const char *psz_text);

    enum libvlc_video_logo_option_t
    {
        libvlc_logo_enable,
        libvlc_logo_file,
        libvlc_logo_x,
        libvlc_logo_y,
        libvlc_logo_delay,
        libvlc_logo_repeat,
        libvlc_logo_opacity,
        libvlc_logo_position
    };

    LIBVLC_API int libvlc_video_get_logo_int(libvlc_media_player_t *p_mi,
                                             unsigned option);

    LIBVLC_API void libvlc_video_set_logo_int(libvlc_media_player_t *p_mi,
                                              unsigned option, int value);

    LIBVLC_API void libvlc_video_set_logo_string(libvlc_media_player_t *p_mi,
                                                 unsigned option, const char *psz_value);

    enum libvlc_video_adjust_option_t
    {
        libvlc_adjust_Enable = 0,
        libvlc_adjust_Contrast,
        libvlc_adjust_Brightness,
        libvlc_adjust_Hue,
        libvlc_adjust_Saturation,
        libvlc_adjust_Gamma
    };

    LIBVLC_API int libvlc_video_get_adjust_int(libvlc_media_player_t *p_mi,
                                               unsigned option);

    LIBVLC_API void libvlc_video_set_adjust_int(libvlc_media_player_t *p_mi,
                                                unsigned option, int value);

    LIBVLC_API float libvlc_video_get_adjust_float(libvlc_media_player_t *p_mi,
                                                   unsigned option);

    LIBVLC_API void libvlc_video_set_adjust_float(libvlc_media_player_t *p_mi,
                                                  unsigned option, float value);

    typedef enum libvlc_audio_output_device_types_t
    {
        libvlc_AudioOutputDevice_Error = -1,
        libvlc_AudioOutputDevice_Mono = 1,
        libvlc_AudioOutputDevice_Stereo = 2,
        libvlc_AudioOutputDevice_2F2R = 4,
        libvlc_AudioOutputDevice_3F2R = 5,
        libvlc_AudioOutputDevice_5_1 = 6,
        libvlc_AudioOutputDevice_6_1 = 7,
        libvlc_AudioOutputDevice_7_1 = 8,
        libvlc_AudioOutputDevice_SPDIF = 10
    } libvlc_audio_output_device_types_t;

    typedef enum libvlc_audio_output_channel_t
    {
        libvlc_AudioChannel_Error = -1,
        libvlc_AudioChannel_Stereo = 1,
        libvlc_AudioChannel_RStereo = 2,
        libvlc_AudioChannel_Left = 3,
        libvlc_AudioChannel_Right = 4,
        libvlc_AudioChannel_Dolbys = 5
    } libvlc_audio_output_channel_t;

    LIBVLC_API libvlc_audio_output_t *
    libvlc_audio_output_list_get(libvlc_instance_t *p_instance);

    LIBVLC_API
    void libvlc_audio_output_list_release(libvlc_audio_output_t *p_list);

    LIBVLC_API int libvlc_audio_output_set(libvlc_media_player_t *p_mi,
                                           const char *psz_name);

    LIBVLC_DEPRECATED LIBVLC_API int libvlc_audio_output_device_count(libvlc_instance_t *, const char *);

    LIBVLC_DEPRECATED LIBVLC_API char *libvlc_audio_output_device_longname(libvlc_instance_t *, const char *,
                                                                           int);

    LIBVLC_DEPRECATED LIBVLC_API char *libvlc_audio_output_device_id(libvlc_instance_t *, const char *, int);

    LIBVLC_API libvlc_audio_output_device_t *
    libvlc_audio_output_device_list_get(libvlc_instance_t *p_instance,
                                        const char *aout);

    LIBVLC_API void libvlc_audio_output_device_list_release(
        libvlc_audio_output_device_t *p_list);

    LIBVLC_API void libvlc_audio_output_device_set(libvlc_media_player_t *p_mi,
                                                   const char *psz_audio_output,
                                                   const char *psz_device_id);

    LIBVLC_DEPRECATED
    LIBVLC_API int libvlc_audio_output_get_device_type(libvlc_media_player_t *p_mi);

    LIBVLC_DEPRECATED
    LIBVLC_API void libvlc_audio_output_set_device_type(libvlc_media_player_t *,
                                                        int);

    LIBVLC_API void libvlc_audio_toggle_mute(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_audio_get_mute(libvlc_media_player_t *p_mi);

    LIBVLC_API void libvlc_audio_set_mute(libvlc_media_player_t *p_mi, int status);

    LIBVLC_API int libvlc_audio_get_volume(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_audio_set_volume(libvlc_media_player_t *p_mi, int i_volume);

    LIBVLC_API int libvlc_audio_get_track_count(libvlc_media_player_t *p_mi);

    LIBVLC_API libvlc_track_description_t *
    libvlc_audio_get_track_description(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_audio_get_track(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_audio_set_track(libvlc_media_player_t *p_mi, int i_track);

    LIBVLC_API int libvlc_audio_get_channel(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_audio_set_channel(libvlc_media_player_t *p_mi, int channel);

    LIBVLC_API int64_t libvlc_audio_get_delay(libvlc_media_player_t *p_mi);

    LIBVLC_API int libvlc_audio_set_delay(libvlc_media_player_t *p_mi, int64_t i_delay);

#ifdef __cplusplus
}
#endif

#endif
