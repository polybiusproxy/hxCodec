#ifndef VLC_FILTER_H
#define VLC_FILTER_H 1

#include <vlc_es.h>
#include <vlc_picture.h>
#include <vlc_subpicture.h>
#include <vlc_mouse.h>

typedef struct filter_owner_sys_t filter_owner_sys_t;

struct filter_t
{
    VLC_COMMON_MEMBERS

    module_t *p_module;
    filter_sys_t *p_sys;

    es_format_t fmt_in;

    es_format_t fmt_out;
    bool b_allow_fmt_out_change;

    config_chain_t *p_cfg;

    union
    {
        struct
        {
            picture_t *(*pf_filter)(filter_t *, picture_t *);
            void (*pf_flush)(filter_t *);
            picture_t *(*pf_buffer_new)(filter_t *);
            void (*pf_buffer_del)(filter_t *, picture_t *);

            int (*pf_mouse)(filter_t *, vlc_mouse_t *,
                            const vlc_mouse_t *p_old,
                            const vlc_mouse_t *p_new);
        } video;
#define pf_video_filter u.video.pf_filter
#define pf_video_flush u.video.pf_flush
#define pf_video_mouse u.video.pf_mouse
#define pf_video_buffer_new u.video.pf_buffer_new
#define pf_video_buffer_del u.video.pf_buffer_del

        struct
        {
            block_t *(*pf_filter)(filter_t *, block_t *);
        } audio;
#define pf_audio_filter u.audio.pf_filter

        struct
        {
            void (*pf_blend)(filter_t *, picture_t *,
                             const picture_t *, int, int, int);
        } blend;
#define pf_video_blend u.blend.pf_blend

        struct
        {
            subpicture_t *(*pf_source)(filter_t *, mtime_t);
            subpicture_t *(*pf_buffer_new)(filter_t *);
            void (*pf_buffer_del)(filter_t *, subpicture_t *);
            int (*pf_mouse)(filter_t *,
                            const vlc_mouse_t *p_old,
                            const vlc_mouse_t *p_new,
                            const video_format_t *);
        } sub;
#define pf_sub_source u.sub.pf_source
#define pf_sub_buffer_new u.sub.pf_buffer_new
#define pf_sub_buffer_del u.sub.pf_buffer_del
#define pf_sub_mouse u.sub.pf_mouse

        struct
        {
            subpicture_t *(*pf_filter)(filter_t *, subpicture_t *);
        } subf;
#define pf_sub_filter u.subf.pf_filter

        struct
        {
            int (*pf_text)(filter_t *, subpicture_region_t *,
                           subpicture_region_t *,
                           const vlc_fourcc_t *);
            int (*pf_html)(filter_t *, subpicture_region_t *,
                           subpicture_region_t *,
                           const vlc_fourcc_t *);
        } render;
#define pf_render_text u.render.pf_text
#define pf_render_html u.render.pf_html

    } u;

    int (*pf_get_attachments)(filter_t *, input_attachment_t ***, int *);

    filter_owner_sys_t *p_owner;
};

static inline picture_t *filter_NewPicture(filter_t *p_filter)
{
    picture_t *p_picture = p_filter->pf_video_buffer_new(p_filter);
    if (!p_picture)
        msg_Warn(p_filter, "can't get output picture");
    return p_picture;
}

static inline void filter_DeletePicture(filter_t *p_filter, picture_t *p_picture)
{
    p_filter->pf_video_buffer_del(p_filter, p_picture);
}

static inline void filter_FlushPictures(filter_t *p_filter)
{
    if (p_filter->pf_video_flush)
        p_filter->pf_video_flush(p_filter);
}

static inline subpicture_t *filter_NewSubpicture(filter_t *p_filter)
{
    subpicture_t *p_subpicture = p_filter->pf_sub_buffer_new(p_filter);
    if (!p_subpicture)
        msg_Warn(p_filter, "can't get output subpicture");
    return p_subpicture;
}

static inline void filter_DeleteSubpicture(filter_t *p_filter, subpicture_t *p_subpicture)
{
    p_filter->pf_sub_buffer_del(p_filter, p_subpicture);
}

static inline int filter_GetInputAttachments(filter_t *p_filter,
                                             input_attachment_t ***ppp_attachment,
                                             int *pi_attachment)
{
    if (!p_filter->pf_get_attachments)
        return VLC_EGENERIC;
    return p_filter->pf_get_attachments(p_filter,
                                        ppp_attachment, pi_attachment);
}

VLC_API filter_t *filter_NewBlend(vlc_object_t *, const video_format_t *p_dst_chroma) VLC_USED;

VLC_API int filter_ConfigureBlend(filter_t *, int i_dst_width, int i_dst_height, const video_format_t *p_src);

VLC_API int filter_Blend(filter_t *, picture_t *p_dst, int i_dst_x, int i_dst_y, const picture_t *p_src, int i_alpha);

VLC_API void filter_DeleteBlend(filter_t *);

#define VIDEO_FILTER_WRAPPER(name)                         \
    static picture_t *name##_Filter(filter_t *p_filter,    \
                                    picture_t *p_pic)      \
    {                                                      \
        picture_t *p_outpic = filter_NewPicture(p_filter); \
        if (p_outpic)                                      \
        {                                                  \
            name(p_filter, p_pic, p_outpic);               \
            picture_CopyProperties(p_outpic, p_pic);       \
        }                                                  \
        picture_Release(p_pic);                            \
        return p_outpic;                                   \
    }

typedef struct filter_chain_t filter_chain_t;

VLC_API filter_chain_t *filter_chain_New(vlc_object_t *, const char *, bool, int (*)(filter_t *, void *), void (*)(filter_t *), void *) VLC_USED;
#define filter_chain_New(a, b, c, d, e, f) filter_chain_New(VLC_OBJECT(a), b, c, d, e, f)

VLC_API void filter_chain_Delete(filter_chain_t *);

VLC_API void filter_chain_Reset(filter_chain_t *, const es_format_t *, const es_format_t *);

VLC_API filter_t *filter_chain_AppendFilter(filter_chain_t *, const char *, config_chain_t *, const es_format_t *, const es_format_t *);

VLC_API int filter_chain_AppendFromString(filter_chain_t *, const char *);

VLC_API int filter_chain_DeleteFilter(filter_chain_t *, filter_t *);

VLC_API int filter_chain_GetLength(filter_chain_t *);

VLC_API const es_format_t *filter_chain_GetFmtOut(filter_chain_t *);

VLC_API picture_t *filter_chain_VideoFilter(filter_chain_t *, picture_t *);

VLC_API void filter_chain_VideoFlush(filter_chain_t *);

VLC_API block_t *filter_chain_AudioFilter(filter_chain_t *, block_t *);

VLC_API void filter_chain_SubSource(filter_chain_t *, mtime_t);

VLC_API subpicture_t *filter_chain_SubFilter(filter_chain_t *, subpicture_t *);

VLC_API int filter_chain_MouseFilter(filter_chain_t *, vlc_mouse_t *, const vlc_mouse_t *);

VLC_API int filter_chain_MouseEvent(filter_chain_t *, const vlc_mouse_t *, const video_format_t *);

#endif
