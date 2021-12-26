#ifndef VLC_SPU_H
#define VLC_SPU_H 1

#include <vlc_subpicture.h>

#ifdef __cplusplus
extern "C"
{
#endif

    typedef struct spu_private_t spu_private_t;

#define SPU_DEFAULT_CHANNEL (1)

    struct spu_t
    {
        VLC_COMMON_MEMBERS

        spu_private_t *p;
    };

    VLC_API spu_t *spu_Create(vlc_object_t *);
#define spu_Create(a) spu_Create(VLC_OBJECT(a))
    VLC_API void spu_Destroy(spu_t *);

    VLC_API void spu_PutSubpicture(spu_t *, subpicture_t *);

    VLC_API subpicture_t *spu_Render(spu_t *, const vlc_fourcc_t *p_chroma_list, const video_format_t *p_fmt_dst, const video_format_t *p_fmt_src, mtime_t render_subtitle_date, mtime_t render_osd_date, bool ignore_osd);

    VLC_API int spu_RegisterChannel(spu_t *);

    VLC_API void spu_ClearChannel(spu_t *, int);

    VLC_API void spu_ChangeSources(spu_t *, const char *);

    VLC_API void spu_ChangeFilters(spu_t *, const char *);

#ifdef __cplusplus
}
#endif

#endif
