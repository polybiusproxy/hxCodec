#ifndef VLC_LIBVLC_MEDIA_DISCOVERER_H
#define VLC_LIBVLC_MEDIA_DISCOVERER_H 1

#ifdef __cplusplus
extern "C"
{
#endif

        typedef struct libvlc_media_discoverer_t libvlc_media_discoverer_t;

        LIBVLC_API libvlc_media_discoverer_t *
        libvlc_media_discoverer_new_from_name(libvlc_instance_t *p_inst,
                                              const char *psz_name);

        LIBVLC_API void libvlc_media_discoverer_release(libvlc_media_discoverer_t *p_mdis);

        LIBVLC_API char *libvlc_media_discoverer_localized_name(libvlc_media_discoverer_t *p_mdis);

        LIBVLC_API libvlc_media_list_t *libvlc_media_discoverer_media_list(libvlc_media_discoverer_t *p_mdis);

        LIBVLC_API libvlc_event_manager_t *
        libvlc_media_discoverer_event_manager(libvlc_media_discoverer_t *p_mdis);

        LIBVLC_API int
        libvlc_media_discoverer_is_running(libvlc_media_discoverer_t *p_mdis);

#ifdef __cplusplus
}
#endif

#endif
