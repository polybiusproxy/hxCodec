#ifndef VLC_VOUT_H_
#define VLC_VOUT_H_ 1

#include <vlc_picture.h>
#include <vlc_filter.h>
#include <vlc_subpicture.h>

typedef struct
{
    vout_thread_t *vout;
    vlc_object_t *input;
    bool change_fmt;
    const video_format_t *fmt;
    unsigned dpb_size;
} vout_configuration_t;

typedef struct vout_thread_sys_t vout_thread_sys_t;

struct vout_thread_t
{
    VLC_COMMON_MEMBERS

    vout_thread_sys_t *p;
};

#define VOUT_ALIGN_LEFT 0x0001
#define VOUT_ALIGN_RIGHT 0x0002
#define VOUT_ALIGN_HMASK 0x0003
#define VOUT_ALIGN_TOP 0x0004
#define VOUT_ALIGN_BOTTOM 0x0008
#define VOUT_ALIGN_VMASK 0x000C

VLC_API vout_thread_t *vout_Request(vlc_object_t *object, const vout_configuration_t *cfg);
#define vout_Request(a, b) vout_Request(VLC_OBJECT(a), b)

VLC_API void vout_Close(vout_thread_t *p_vout);

static inline void vout_CloseAndRelease(vout_thread_t *p_vout)
{
    vout_Close(p_vout);
    vlc_object_release(p_vout);
}

VLC_API int vout_GetSnapshot(vout_thread_t *p_vout,
                             block_t **pp_image, picture_t **pp_picture,
                             video_format_t *p_fmt,
                             const char *psz_format, mtime_t i_timeout);

VLC_API picture_t *vout_GetPicture(vout_thread_t *);
VLC_API void vout_PutPicture(vout_thread_t *, picture_t *);

VLC_API void vout_HoldPicture(vout_thread_t *, picture_t *);
VLC_API void vout_ReleasePicture(vout_thread_t *, picture_t *);

VLC_API void vout_PutSubpicture(vout_thread_t *, subpicture_t *);
VLC_API int vout_RegisterSubpictureChannel(vout_thread_t *);
VLC_API void vout_FlushSubpictureChannel(vout_thread_t *, int);

VLC_API void vout_EnableFilter(vout_thread_t *, const char *, bool, bool);

#endif
