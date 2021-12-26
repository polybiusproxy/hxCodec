#ifndef LIBVLC_MEDIA_LIST_PLAYER_H
#define LIBVLC_MEDIA_LIST_PLAYER_H 1

#ifdef __cplusplus
extern "C"
{
#endif

    typedef struct libvlc_media_list_player_t libvlc_media_list_player_t;

    typedef enum libvlc_playback_mode_t
    {
        libvlc_playback_mode_default,
        libvlc_playback_mode_loop,
        libvlc_playback_mode_repeat
    } libvlc_playback_mode_t;

    LIBVLC_API libvlc_media_list_player_t *
    libvlc_media_list_player_new(libvlc_instance_t *p_instance);

    LIBVLC_API void
    libvlc_media_list_player_release(libvlc_media_list_player_t *p_mlp);

    LIBVLC_API void
    libvlc_media_list_player_retain(libvlc_media_list_player_t *p_mlp);

    LIBVLC_API libvlc_event_manager_t *
    libvlc_media_list_player_event_manager(libvlc_media_list_player_t *p_mlp);

    LIBVLC_API void
    libvlc_media_list_player_set_media_player(
        libvlc_media_list_player_t *p_mlp,
        libvlc_media_player_t *p_mi);

    LIBVLC_API void
    libvlc_media_list_player_set_media_list(
        libvlc_media_list_player_t *p_mlp,
        libvlc_media_list_t *p_mlist);

    LIBVLC_API
    void libvlc_media_list_player_play(libvlc_media_list_player_t *p_mlp);

    LIBVLC_API
    void libvlc_media_list_player_pause(libvlc_media_list_player_t *p_mlp);

    LIBVLC_API int
    libvlc_media_list_player_is_playing(libvlc_media_list_player_t *p_mlp);

    LIBVLC_API libvlc_state_t
    libvlc_media_list_player_get_state(libvlc_media_list_player_t *p_mlp);

    LIBVLC_API
    int libvlc_media_list_player_play_item_at_index(libvlc_media_list_player_t *p_mlp,
                                                    int i_index);

    LIBVLC_API
    int libvlc_media_list_player_play_item(libvlc_media_list_player_t *p_mlp,
                                           libvlc_media_t *p_md);

    LIBVLC_API void
    libvlc_media_list_player_stop(libvlc_media_list_player_t *p_mlp);

    LIBVLC_API
    int libvlc_media_list_player_next(libvlc_media_list_player_t *p_mlp);

    LIBVLC_API
    int libvlc_media_list_player_previous(libvlc_media_list_player_t *p_mlp);

    LIBVLC_API
    void libvlc_media_list_player_set_playback_mode(libvlc_media_list_player_t *p_mlp,
                                                    libvlc_playback_mode_t e_mode);

#ifdef __cplusplus
}
#endif

#endif
