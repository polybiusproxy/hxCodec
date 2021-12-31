#ifndef LIBVLC_DEPRECATED_H
#define LIBVLC_DEPRECATED_H 1

#ifdef __cplusplus
extern "C"
{
#endif

    LIBVLC_DEPRECATED LIBVLC_API void libvlc_playlist_play(libvlc_instance_t *p_instance, int i_id,
                                                           int i_options, char **ppsz_options);

#ifdef __cplusplus
}
#endif

#endif