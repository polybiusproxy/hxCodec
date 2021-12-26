#ifndef VLC_VIDEO_SPLITTER_H
#define VLC_VIDEO_SPLITTER_H 1

#include <vlc_es.h>
#include <vlc_picture.h>
#include <vlc_mouse.h>

typedef struct video_splitter_t video_splitter_t;
typedef struct video_splitter_sys_t video_splitter_sys_t;
typedef struct video_splitter_owner_t video_splitter_owner_t;

typedef struct
{

    video_format_t fmt;

    struct
    {

        int i_x;
        int i_y;

        int i_align;
    } window;

    char *psz_module;

} video_splitter_output_t;

struct video_splitter_t
{
    VLC_COMMON_MEMBERS

    module_t *p_module;

    config_chain_t *p_cfg;

    video_format_t fmt;

    int i_output;
    video_splitter_output_t *p_output;

    int (*pf_filter)(video_splitter_t *, picture_t *pp_dst[],
                     picture_t *p_src);
    int (*pf_mouse)(video_splitter_t *, vlc_mouse_t *,
                    int i_index,
                    const vlc_mouse_t *p_old, const vlc_mouse_t *p_new);

    video_splitter_sys_t *p_sys;

    int (*pf_picture_new)(video_splitter_t *, picture_t *pp_picture[]);
    void (*pf_picture_del)(video_splitter_t *, picture_t *pp_picture[]);
    video_splitter_owner_t *p_owner;
};

static inline int video_splitter_NewPicture(video_splitter_t *p_splitter,
                                            picture_t *pp_picture[])
{
    int i_ret = p_splitter->pf_picture_new(p_splitter, pp_picture);
    if (i_ret)
        msg_Warn(p_splitter, "can't get output pictures");
    return i_ret;
}

static inline void video_splitter_DeletePicture(video_splitter_t *p_splitter,
                                                picture_t *pp_picture[])
{
    p_splitter->pf_picture_del(p_splitter, pp_picture);
}

VLC_API video_splitter_t *video_splitter_New(vlc_object_t *, const char *psz_name, const video_format_t *);
VLC_API void video_splitter_Delete(video_splitter_t *);

static inline int video_splitter_Filter(video_splitter_t *p_splitter,
                                        picture_t *pp_dst[], picture_t *p_src)
{
    return p_splitter->pf_filter(p_splitter, pp_dst, p_src);
}
static inline int video_splitter_Mouse(video_splitter_t *p_splitter,
                                       vlc_mouse_t *p_mouse,
                                       int i_index,
                                       const vlc_mouse_t *p_old, const vlc_mouse_t *p_new)
{
    if (!p_splitter->pf_mouse)
    {
        *p_mouse = *p_new;
        return VLC_SUCCESS;
    }
    return p_splitter->pf_mouse(p_splitter, p_mouse, i_index, p_old, p_new);
}

#endif
