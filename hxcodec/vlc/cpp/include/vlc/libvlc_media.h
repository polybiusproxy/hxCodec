#ifndef VLC_LIBVLC_MEDIA_H
#define VLC_LIBVLC_MEDIA_H 1

#ifdef __cplusplus
extern "C"
{
#endif

    typedef struct libvlc_media_t libvlc_media_t;

    typedef enum libvlc_meta_t
    {
        libvlc_meta_Title,
        libvlc_meta_Artist,
        libvlc_meta_Genre,
        libvlc_meta_Copyright,
        libvlc_meta_Album,
        libvlc_meta_TrackNumber,
        libvlc_meta_Description,
        libvlc_meta_Rating,
        libvlc_meta_Date,
        libvlc_meta_Setting,
        libvlc_meta_URL,
        libvlc_meta_Language,
        libvlc_meta_NowPlaying,
        libvlc_meta_Publisher,
        libvlc_meta_EncodedBy,
        libvlc_meta_ArtworkURL,
        libvlc_meta_TrackID

    } libvlc_meta_t;

    typedef enum libvlc_state_t
    {
        libvlc_NothingSpecial = 0,
        libvlc_Opening,
        libvlc_Buffering,
        libvlc_Playing,
        libvlc_Paused,
        libvlc_Stopped,
        libvlc_Ended,
        libvlc_Error
    } libvlc_state_t;

    enum
    {
        libvlc_media_option_trusted = 0x2,
        libvlc_media_option_unique = 0x100
    };

    typedef enum libvlc_track_type_t
    {
        libvlc_track_unknown = -1,
        libvlc_track_audio = 0,
        libvlc_track_video = 1,
        libvlc_track_text = 2
    } libvlc_track_type_t;

    typedef struct libvlc_media_stats_t
    {

        int i_read_bytes;
        float f_input_bitrate;

        int i_demux_read_bytes;
        float f_demux_bitrate;
        int i_demux_corrupted;
        int i_demux_discontinuity;

        int i_decoded_video;
        int i_decoded_audio;

        int i_displayed_pictures;
        int i_lost_pictures;

        int i_played_abuffers;
        int i_lost_abuffers;

        int i_sent_packets;
        int i_sent_bytes;
        float f_send_bitrate;
    } libvlc_media_stats_t;

    typedef struct libvlc_media_track_info_t
    {

        uint32_t i_codec;
        int i_id;
        libvlc_track_type_t i_type;

        int i_profile;
        int i_level;

        union
        {
            struct
            {

                unsigned i_channels;
                unsigned i_rate;
            } audio;
            struct
            {

                unsigned i_height;
                unsigned i_width;
            } video;
        } u;

    } libvlc_media_track_info_t;

    typedef struct libvlc_audio_track_t
    {
        unsigned i_channels;
        unsigned i_rate;
    } libvlc_audio_track_t;

    typedef struct libvlc_video_track_t
    {
        unsigned i_height;
        unsigned i_width;
        unsigned i_sar_num;
        unsigned i_sar_den;
        unsigned i_frame_rate_num;
        unsigned i_frame_rate_den;
    } libvlc_video_track_t;

    typedef struct libvlc_subtitle_track_t
    {
        char *psz_encoding;
    } libvlc_subtitle_track_t;

    typedef struct libvlc_media_track_t
    {

        uint32_t i_codec;
        uint32_t i_original_fourcc;
        int i_id;
        libvlc_track_type_t i_type;

        int i_profile;
        int i_level;

        union
        {
            libvlc_audio_track_t *audio;
            libvlc_video_track_t *video;
            libvlc_subtitle_track_t *subtitle;
        };

        unsigned int i_bitrate;
        char *psz_language;
        char *psz_description;

    } libvlc_media_track_t;

    LIBVLC_API libvlc_media_t *libvlc_media_new_location(
        libvlc_instance_t *p_instance,
        const char *psz_mrl);

    LIBVLC_API libvlc_media_t *libvlc_media_new_path(
        libvlc_instance_t *p_instance,
        const char *path);

    LIBVLC_API libvlc_media_t *libvlc_media_new_fd(
        libvlc_instance_t *p_instance,
        int fd);

    LIBVLC_API libvlc_media_t *libvlc_media_new_as_node(
        libvlc_instance_t *p_instance,
        const char *psz_name);

    LIBVLC_API void libvlc_media_add_option(
        libvlc_media_t *p_md,
        const char *psz_options);

    LIBVLC_API void libvlc_media_add_option_flag(
        libvlc_media_t *p_md,
        const char *psz_options,
        unsigned i_flags);

    LIBVLC_API void libvlc_media_retain(libvlc_media_t *p_md);

    LIBVLC_API void libvlc_media_release(libvlc_media_t *p_md);

    LIBVLC_API char *libvlc_media_get_mrl(libvlc_media_t *p_md);

    LIBVLC_API libvlc_media_t *libvlc_media_duplicate(libvlc_media_t *p_md);

    LIBVLC_API char *libvlc_media_get_meta(libvlc_media_t *p_md,
                                           libvlc_meta_t e_meta);

    LIBVLC_API void libvlc_media_set_meta(libvlc_media_t *p_md,
                                          libvlc_meta_t e_meta,
                                          const char *psz_value);

    LIBVLC_API int libvlc_media_save_meta(libvlc_media_t *p_md);

    LIBVLC_API libvlc_state_t libvlc_media_get_state(
        libvlc_media_t *p_md);

    LIBVLC_API int libvlc_media_get_stats(libvlc_media_t *p_md,
                                          libvlc_media_stats_t *p_stats);

#define VLC_FORWARD_DECLARE_OBJECT(a) struct a

    LIBVLC_API VLC_FORWARD_DECLARE_OBJECT(libvlc_media_list_t *)
        libvlc_media_subitems(libvlc_media_t *p_md);

    LIBVLC_API libvlc_event_manager_t *
    libvlc_media_event_manager(libvlc_media_t *p_md);

    LIBVLC_API libvlc_time_t
    libvlc_media_get_duration(libvlc_media_t *p_md);

    LIBVLC_API void
    libvlc_media_parse(libvlc_media_t *p_md);

    LIBVLC_API void
    libvlc_media_parse_async(libvlc_media_t *p_md);

    LIBVLC_API int
    libvlc_media_is_parsed(libvlc_media_t *p_md);

    LIBVLC_API void
    libvlc_media_set_user_data(libvlc_media_t *p_md, void *p_new_user_data);

    LIBVLC_API void *libvlc_media_get_user_data(libvlc_media_t *p_md);

    LIBVLC_DEPRECATED LIBVLC_API int libvlc_media_get_tracks_info(libvlc_media_t *p_md,
                                                                  libvlc_media_track_info_t **tracks);

    LIBVLC_API
    unsigned libvlc_media_tracks_get(libvlc_media_t *p_md,
                                     libvlc_media_track_t ***tracks);

    LIBVLC_API
    void libvlc_media_tracks_release(libvlc_media_track_t **p_tracks,
                                     unsigned i_count);

#ifdef __cplusplus
}
#endif

#endif
