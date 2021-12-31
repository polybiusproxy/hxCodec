#ifndef VLC_AOUT_MIXER_H
#define VLC_AOUT_MIXER_H 1

#ifdef __cplusplus
extern "C"
{
#endif

    typedef struct audio_volume audio_volume_t;

    struct audio_volume
    {
        VLC_COMMON_MEMBERS

        vlc_fourcc_t format;
        void (*amplify)(audio_volume_t *, block_t *, float);
    };

#ifdef __cplusplus
}
#endif

#endif
