#ifndef VLC_UPDATE_H
#define VLC_UPDATE_H

#ifdef UPDATE_CHECK

struct update_release_t
{
    int i_major;
    int i_minor;
    int i_revision;
    int i_extra;
    char *psz_url;
    char *psz_desc;
};

#endif

typedef struct update_release_t update_release_t;

VLC_API update_t *update_New(vlc_object_t *);
#define update_New(a) update_New(VLC_OBJECT(a))
VLC_API void update_Delete(update_t *);
VLC_API void update_Check(update_t *, void (*callback)(void *, bool), void *);
VLC_API bool update_NeedUpgrade(update_t *);
VLC_API void update_Download(update_t *, const char *);
VLC_API update_release_t *update_GetRelease(update_t *);

#endif
