#ifndef VLC_PICTURE_POOL_H
#define VLC_PICTURE_POOL_H 1

#include <vlc_picture.h>

typedef struct picture_pool_t picture_pool_t;

typedef struct
{
    int picture_count;
    picture_t **picture;

    int (*lock)(picture_t *);
    void (*unlock)(picture_t *);
} picture_pool_configuration_t;

VLC_API picture_pool_t *picture_pool_NewExtended(const picture_pool_configuration_t *) VLC_USED;

VLC_API picture_pool_t *picture_pool_New(int picture_count, picture_t *picture[]) VLC_USED;

VLC_API picture_pool_t *picture_pool_NewFromFormat(const video_format_t *, int picture_count) VLC_USED;

VLC_API void picture_pool_Delete(picture_pool_t *);

VLC_API picture_t *picture_pool_Get(picture_pool_t *) VLC_USED;

VLC_API void picture_pool_NonEmpty(picture_pool_t *, bool reset);

VLC_API picture_pool_t *picture_pool_Reserve(picture_pool_t *, int picture_count) VLC_USED;

VLC_API int picture_pool_GetSize(picture_pool_t *);

#endif
