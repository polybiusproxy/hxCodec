#ifndef LIBVLC_VLM_H
#define LIBVLC_VLM_H 1

#ifdef __cplusplus
extern "C"
{
#endif

    LIBVLC_API void libvlc_vlm_release(libvlc_instance_t *p_instance);

    LIBVLC_API int libvlc_vlm_add_broadcast(libvlc_instance_t *p_instance,
                                            const char *psz_name, const char *psz_input,
                                            const char *psz_output, int i_options,
                                            const char *const *ppsz_options,
                                            int b_enabled, int b_loop);

    LIBVLC_API int libvlc_vlm_add_vod(libvlc_instance_t *p_instance,
                                      const char *psz_name, const char *psz_input,
                                      int i_options, const char *const *ppsz_options,
                                      int b_enabled, const char *psz_mux);

    LIBVLC_API int libvlc_vlm_del_media(libvlc_instance_t *p_instance,
                                        const char *psz_name);

    LIBVLC_API int libvlc_vlm_set_enabled(libvlc_instance_t *p_instance,
                                          const char *psz_name, int b_enabled);

    LIBVLC_API int libvlc_vlm_set_output(libvlc_instance_t *p_instance,
                                         const char *psz_name,
                                         const char *psz_output);

    LIBVLC_API int libvlc_vlm_set_input(libvlc_instance_t *p_instance,
                                        const char *psz_name,
                                        const char *psz_input);

    LIBVLC_API int libvlc_vlm_add_input(libvlc_instance_t *p_instance,
                                        const char *psz_name,
                                        const char *psz_input);

    LIBVLC_API int libvlc_vlm_set_loop(libvlc_instance_t *p_instance,
                                       const char *psz_name,
                                       int b_loop);

    LIBVLC_API int libvlc_vlm_set_mux(libvlc_instance_t *p_instance,
                                      const char *psz_name,
                                      const char *psz_mux);

    LIBVLC_API int libvlc_vlm_change_media(libvlc_instance_t *p_instance,
                                           const char *psz_name, const char *psz_input,
                                           const char *psz_output, int i_options,
                                           const char *const *ppsz_options,
                                           int b_enabled, int b_loop);

    LIBVLC_API int libvlc_vlm_play_media(libvlc_instance_t *p_instance,
                                         const char *psz_name);

    LIBVLC_API int libvlc_vlm_stop_media(libvlc_instance_t *p_instance,
                                         const char *psz_name);

    LIBVLC_API int libvlc_vlm_pause_media(libvlc_instance_t *p_instance,
                                          const char *psz_name);

    LIBVLC_API int libvlc_vlm_seek_media(libvlc_instance_t *p_instance,
                                         const char *psz_name,
                                         float f_percentage);

    LIBVLC_API const char *libvlc_vlm_show_media(libvlc_instance_t *p_instance,
                                                 const char *psz_name);

    LIBVLC_API float libvlc_vlm_get_media_instance_position(libvlc_instance_t *p_instance,
                                                            const char *psz_name,
                                                            int i_instance);

    LIBVLC_API int libvlc_vlm_get_media_instance_time(libvlc_instance_t *p_instance,
                                                      const char *psz_name,
                                                      int i_instance);

    LIBVLC_API int libvlc_vlm_get_media_instance_length(libvlc_instance_t *p_instance,
                                                        const char *psz_name,
                                                        int i_instance);

    LIBVLC_API int libvlc_vlm_get_media_instance_rate(libvlc_instance_t *p_instance,
                                                      const char *psz_name,
                                                      int i_instance);
#if 0

LIBVLC_API int libvlc_vlm_get_media_instance_title( libvlc_instance_t *,
                                                        const char *, int );


LIBVLC_API int libvlc_vlm_get_media_instance_chapter( libvlc_instance_t *,
                                                          const char *, int );


LIBVLC_API int libvlc_vlm_get_media_instance_seekable( libvlc_instance_t *,
                                                           const char *, int );
#endif

    LIBVLC_API libvlc_event_manager_t *
    libvlc_vlm_get_event_manager(libvlc_instance_t *p_instance);

#ifdef __cplusplus
}
#endif

#endif
