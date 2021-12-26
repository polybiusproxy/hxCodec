#ifndef VLC_AVCODEC_H
#define VLC_AVCODEC_H 1

static inline void vlc_avcodec_lock(void)
{
    vlc_global_lock(VLC_AVCODEC_MUTEX);
}

static inline void vlc_avcodec_unlock(void)
{
    vlc_global_unlock(VLC_AVCODEC_MUTEX);
}

#endif
