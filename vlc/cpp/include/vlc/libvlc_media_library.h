#ifndef VLC_LIBVLC_MEDIA_LIBRARY_H
#define VLC_LIBVLC_MEDIA_LIBRARY_H 1

#ifdef __cplusplus
extern "C"
{
#endif

    typedef struct libvlc_media_library_t libvlc_media_library_t;

    LIBVLC_API libvlc_media_library_t *
    libvlc_media_library_new(libvlc_instance_t *p_instance);

    LIBVLC_API void
    libvlc_media_library_release(libvlc_media_library_t *p_mlib);

    LIBVLC_API void
    libvlc_media_library_retain(libvlc_media_library_t *p_mlib);

    LIBVLC_API int
    libvlc_media_library_load(libvlc_media_library_t *p_mlib);

    LIBVLC_API libvlc_media_list_t *
    libvlc_media_library_media_list(libvlc_media_library_t *p_mlib);

#ifdef __cplusplus
}
#endif

#endif
