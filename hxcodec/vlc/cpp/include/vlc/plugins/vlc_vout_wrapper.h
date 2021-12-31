#ifndef VLC_VOUT_WRAPPER_H
#define VLC_VOUT_WRAPPER_H 1

#include <vlc_vout_display.h>

static inline picture_pool_t *vout_display_Pool(vout_display_t *vd, unsigned count)
{
    return vd->pool(vd, count);
}

static inline void vout_display_Prepare(vout_display_t *vd,
                                        picture_t *picture,
                                        subpicture_t *subpicture)
{
    if (vd->prepare)
        vd->prepare(vd, picture, subpicture);
}

static inline void vout_display_Display(vout_display_t *vd,
                                        picture_t *picture,
                                        subpicture_t *subpicture)
{
    vd->display(vd, picture, subpicture);
}

typedef struct
{
    vout_display_cfg_t cfg;
    unsigned wm_state;
    struct
    {
        int num;
        int den;
    } sar;
} vout_display_state_t;

VLC_API vout_display_t *vout_NewDisplay(vout_thread_t *, const video_format_t *, const vout_display_state_t *, const char *psz_module, mtime_t i_double_click_timeout, mtime_t i_hide_timeout);

VLC_API void vout_DeleteDisplay(vout_display_t *, vout_display_state_t *);

VLC_API bool vout_IsDisplayFiltered(vout_display_t *);
VLC_API picture_t *vout_FilterDisplay(vout_display_t *, picture_t *);
VLC_API bool vout_AreDisplayPicturesInvalid(vout_display_t *);

VLC_API bool vout_ManageDisplay(vout_display_t *, bool allow_reset_pictures);

VLC_API void vout_SetDisplayFullscreen(vout_display_t *, bool is_fullscreen);
VLC_API void vout_SetDisplayFilled(vout_display_t *, bool is_filled);
VLC_API void vout_SetDisplayZoom(vout_display_t *, int num, int den);
VLC_API void vout_SetWindowState(vout_display_t *, unsigned state);
VLC_API void vout_SetDisplayAspect(vout_display_t *, unsigned dar_num, unsigned dar_den);
VLC_API void vout_SetDisplayCrop(vout_display_t *, unsigned crop_num, unsigned crop_den, unsigned left, unsigned top, int right, int bottom);

struct vlc_gl_t;
VLC_API struct vlc_gl_t *vout_GetDisplayOpengl(vout_display_t *);

#endif
