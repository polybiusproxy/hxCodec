#ifndef VLC_PICTURE_H
#define VLC_PICTURE_H 1

#include <vlc_es.h>
#include <vlc_atomic.h>

typedef struct plane_t
{
    uint8_t *p_pixels;

    int i_lines;
    int i_pitch;

    int i_pixel_pitch;

    int i_visible_lines;
    int i_visible_pitch;

} plane_t;

#define PICTURE_PLANE_MAX (VOUT_MAX_PLANES)

typedef struct picture_gc_sys_t picture_gc_sys_t;

struct picture_t
{

    video_frame_format_t format;

    plane_t p[PICTURE_PLANE_MAX];
    int i_planes;

    mtime_t date;
    bool b_force;

    bool b_progressive;
    bool b_top_field_first;
    unsigned int i_nb_fields;

    picture_sys_t *p_sys;

    struct
    {
        vlc_atomic_t refcount;
        void (*pf_destroy)(picture_t *);
        picture_gc_sys_t *p_sys;
    } gc;

    struct picture_t *p_next;
};

VLC_API picture_t *picture_New(vlc_fourcc_t i_chroma, int i_width, int i_height, int i_sar_num, int i_sar_den) VLC_USED;

VLC_API picture_t *picture_NewFromFormat(const video_format_t *p_fmt) VLC_USED;

typedef struct
{
    picture_sys_t *p_sys;

    struct
    {
        uint8_t *p_pixels;
        int i_lines;
        int i_pitch;
    } p[PICTURE_PLANE_MAX];

} picture_resource_t;

VLC_API picture_t *picture_NewFromResource(const video_format_t *, const picture_resource_t *) VLC_USED;

VLC_API picture_t *picture_Hold(picture_t *p_picture);

VLC_API void picture_Release(picture_t *p_picture);

VLC_API bool picture_IsReferenced(picture_t *p_picture);

VLC_API void picture_CopyProperties(picture_t *p_dst, const picture_t *p_src);

VLC_API void picture_Reset(picture_t *);

VLC_API void picture_CopyPixels(picture_t *p_dst, const picture_t *p_src);
VLC_API void plane_CopyPixels(plane_t *p_dst, const plane_t *p_src);

VLC_API void picture_Copy(picture_t *p_dst, const picture_t *p_src);

VLC_API int picture_Export(vlc_object_t *p_obj, block_t **pp_image, video_format_t *p_fmt, picture_t *p_picture, vlc_fourcc_t i_format, int i_override_width, int i_override_height);

VLC_API int picture_Setup(picture_t *, vlc_fourcc_t i_chroma, int i_width, int i_height, int i_sar_num, int i_sar_den);

VLC_API void picture_BlendSubpicture(picture_t *, filter_t *p_blend, subpicture_t *);

enum
{
    Y_PLANE = 0,
    U_PLANE = 1,
    V_PLANE = 2,
    A_PLANE = 3,
};

#define Y_PIXELS p[Y_PLANE].p_pixels
#define Y_PITCH p[Y_PLANE].i_pitch
#define U_PIXELS p[U_PLANE].p_pixels
#define U_PITCH p[U_PLANE].i_pitch
#define V_PIXELS p[V_PLANE].p_pixels
#define V_PITCH p[V_PLANE].i_pitch
#define A_PIXELS p[A_PLANE].p_pixels
#define A_PITCH p[A_PLANE].i_pitch

#endif
