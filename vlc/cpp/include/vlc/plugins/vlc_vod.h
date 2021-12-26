#ifndef VLC_VOD_H
#define VLC_VOD_H 1

struct vod_t
{
    VLC_COMMON_MEMBERS

    module_t *p_module;
    vod_sys_t *p_sys;

    vod_media_t *(*pf_media_new)(vod_t *, const char *, input_item_t *);
    void (*pf_media_del)(vod_t *, vod_media_t *);

    int (*pf_media_control)(void *, vod_media_t *, const char *, int, va_list);
    void *p_data;
};

static inline int vod_MediaControl(vod_t *p_vod, vod_media_t *p_media,
                                   const char *psz_id, int i_query, ...)
{
    va_list args;
    int i_result;

    if (!p_vod->pf_media_control)
        return VLC_EGENERIC;

    va_start(args, i_query);
    i_result = p_vod->pf_media_control(p_vod->p_data, p_media, psz_id,
                                       i_query, args);
    va_end(args);
    return i_result;
}

enum vod_query_e
{
    VOD_MEDIA_PLAY,
    VOD_MEDIA_PAUSE,
    VOD_MEDIA_STOP,
    VOD_MEDIA_SEEK,
    VOD_MEDIA_REWIND,
    VOD_MEDIA_FORWARD,
};

#endif
