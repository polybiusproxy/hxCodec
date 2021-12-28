#ifndef VLC_VOUT_OSD_H
#define VLC_VOUT_OSD_H 1

#include <vlc_spu.h>

#ifdef __cplusplus
extern "C"
{
#endif

    enum
    {

        OSD_PLAY_ICON = 1,
        OSD_PAUSE_ICON,
        OSD_SPEAKER_ICON,
        OSD_MUTE_ICON,

        OSD_HOR_SLIDER,
        OSD_VERT_SLIDER,
    };

    VLC_API int vout_OSDEpg(vout_thread_t *, input_item_t *);

    VLC_API void vout_OSDText(vout_thread_t *vout, int channel, int position, mtime_t duration, const char *text);

    VLC_API void vout_OSDMessage(vout_thread_t *, int, const char *, ...) VLC_FORMAT(3, 4);

    VLC_API void vout_OSDSlider(vout_thread_t *, int, int, short);

    VLC_API void vout_OSDIcon(vout_thread_t *, int, short);

#ifdef __cplusplus
}
#endif

#endif
