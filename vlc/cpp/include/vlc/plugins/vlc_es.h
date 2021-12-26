#ifndef VLC_ES_H
#define VLC_ES_H 1

#include <vlc_fourcc.h>

struct video_palette_t
{
    int i_entries;
    uint8_t palette[256][4];
};

#define AUDIO_REPLAY_GAIN_MAX (2)
#define AUDIO_REPLAY_GAIN_TRACK (0)
#define AUDIO_REPLAY_GAIN_ALBUM (1)
typedef struct
{

    bool pb_peak[AUDIO_REPLAY_GAIN_MAX];

    float pf_peak[AUDIO_REPLAY_GAIN_MAX];

    bool pb_gain[AUDIO_REPLAY_GAIN_MAX];

    float pf_gain[AUDIO_REPLAY_GAIN_MAX];
} audio_replay_gain_t;

struct audio_format_t
{
    vlc_fourcc_t i_format;
    unsigned int i_rate;

    uint16_t i_physical_channels;

    uint32_t i_original_channels;

    unsigned int i_bytes_per_frame;

    unsigned int i_frame_length;

    unsigned i_bitspersample;
    unsigned i_blockalign;
    uint8_t i_channels;
};

#define AOUT_CHAN_CENTER 0x1
#define AOUT_CHAN_LEFT 0x2
#define AOUT_CHAN_RIGHT 0x4
#define AOUT_CHAN_REARCENTER 0x10
#define AOUT_CHAN_REARLEFT 0x20
#define AOUT_CHAN_REARRIGHT 0x40
#define AOUT_CHAN_MIDDLELEFT 0x100
#define AOUT_CHAN_MIDDLERIGHT 0x200
#define AOUT_CHAN_LFE 0x1000

#define AOUT_CHANS_FRONT (AOUT_CHAN_LEFT | AOUT_CHAN_RIGHT)
#define AOUT_CHANS_MIDDLE (AOUT_CHAN_MIDDLELEFT | AOUT_CHAN_MIDDLERIGHT)
#define AOUT_CHANS_REAR (AOUT_CHAN_REARLEFT | AOUT_CHAN_REARRIGHT)
#define AOUT_CHANS_CENTER (AOUT_CHAN_CENTER | AOUT_CHAN_REARCENTER)

#define AOUT_CHANS_STEREO AOUT_CHANS_2_0
#define AOUT_CHANS_2_0 (AOUT_CHANS_FRONT)
#define AOUT_CHANS_2_1 (AOUT_CHANS_FRONT | AOUT_CHAN_LFE)
#define AOUT_CHANS_3_0 (AOUT_CHANS_FRONT | AOUT_CHAN_CENTER)
#define AOUT_CHANS_3_1 (AOUT_CHANS_3_0 | AOUT_CHAN_LFE)
#define AOUT_CHANS_4_0 (AOUT_CHANS_FRONT | AOUT_CHANS_REAR)
#define AOUT_CHANS_4_1 (AOUT_CHANS_4_0 | AOUT_CHAN_LFE)
#define AOUT_CHANS_5_0 (AOUT_CHANS_4_0 | AOUT_CHAN_CENTER)
#define AOUT_CHANS_5_1 (AOUT_CHANS_5_0 | AOUT_CHAN_LFE)
#define AOUT_CHANS_6_0 (AOUT_CHANS_4_0 | AOUT_CHANS_MIDDLE)
#define AOUT_CHANS_7_0 (AOUT_CHANS_6_0 | AOUT_CHAN_CENTER)
#define AOUT_CHANS_7_1 (AOUT_CHANS_5_1 | AOUT_CHANS_MIDDLE)
#define AOUT_CHANS_8_1 (AOUT_CHANS_7_1 | AOUT_CHAN_REARCENTER)

#define AOUT_CHANS_4_0_MIDDLE (AOUT_CHANS_FRONT | AOUT_CHANS_MIDDLE)
#define AOUT_CHANS_4_CENTER_REAR (AOUT_CHANS_FRONT | AOUT_CHANS_CENTER)
#define AOUT_CHANS_5_0_MIDDLE (AOUT_CHANS_4_0_MIDDLE | AOUT_CHAN_CENTER)
#define AOUT_CHANS_6_1_MIDDLE (AOUT_CHANS_5_0_MIDDLE | AOUT_CHAN_REARCENTER | AOUT_CHAN_LFE)

#define AOUT_CHAN_DOLBYSTEREO 0x10000
#define AOUT_CHAN_DUALMONO 0x20000
#define AOUT_CHAN_REVERSESTEREO 0x40000

#define AOUT_CHAN_PHYSMASK 0xFFFF
#define AOUT_CHAN_MAX 9

typedef enum video_orientation_t
{
    ORIENT_TOP_LEFT = 0,
    ORIENT_TOP_RIGHT,
    ORIENT_BOTTOM_LEFT,
    ORIENT_BOTTOM_RIGHT,
    ORIENT_LEFT_TOP,
    ORIENT_LEFT_BOTTOM,
    ORIENT_RIGHT_TOP,
    ORIENT_RIGHT_BOTTOM,

    ORIENT_NORMAL = ORIENT_TOP_LEFT,
    ORIENT_HFLIPPED = ORIENT_TOP_RIGHT,
    ORIENT_VFLIPPED = ORIENT_BOTTOM_LEFT,
    ORIENT_ROTATED_180 = ORIENT_BOTTOM_RIGHT,
    ORIENT_ROTATED_270 = ORIENT_LEFT_BOTTOM,
    ORIENT_ROTATED_90 = ORIENT_RIGHT_TOP,
} video_orientation_t;

#define ORIENT_FROM_EXIF(exif) ((0x01324675U >> (4 * ((exif)-1))) & 7)

#define ORIENT_TO_EXIF(orient) ((0x12435867U >> (4 * (orient))) & 15)

#define ORIENT_IS_MIRROR(orient) parity(orient)

#define ORIENT_IS_SWAP(orient) (((orient)&4) != 0)

#define ORIENT_HFLIP(orient) ((orient) ^ 1)

#define ORIENT_VFLIP(orient) ((orient) ^ 2)

#define ORIENT_ROTATE_180(orient) ((orient) ^ 3)

struct video_format_t
{
    vlc_fourcc_t i_chroma;

    unsigned int i_width;
    unsigned int i_height;
    unsigned int i_x_offset;
    unsigned int i_y_offset;
    unsigned int i_visible_width;
    unsigned int i_visible_height;

    unsigned int i_bits_per_pixel;

    unsigned int i_sar_num;
    unsigned int i_sar_den;

    unsigned int i_frame_rate;
    unsigned int i_frame_rate_base;

    uint32_t i_rmask, i_gmask, i_bmask;
    int i_rrshift, i_lrshift;
    int i_rgshift, i_lgshift;
    int i_rbshift, i_lbshift;
    video_palette_t *p_palette;
    video_orientation_t orientation;
};

static inline void video_format_Init(video_format_t *p_src, vlc_fourcc_t i_chroma)
{
    memset(p_src, 0, sizeof(video_format_t));
    p_src->i_chroma = i_chroma;
    p_src->i_sar_num = p_src->i_sar_den = 1;
    p_src->p_palette = NULL;
}

static inline int video_format_Copy(video_format_t *p_dst, const video_format_t *p_src)
{
    memcpy(p_dst, p_src, sizeof(*p_dst));
    if (p_src->p_palette)
    {
        p_dst->p_palette = (video_palette_t *)malloc(sizeof(video_palette_t));
        if (!p_dst->p_palette)
            return VLC_ENOMEM;
        memcpy(p_dst->p_palette, p_src->p_palette, sizeof(*p_dst->p_palette));
    }
    return VLC_SUCCESS;
}

static inline void video_format_Clean(video_format_t *p_src)
{
    free(p_src->p_palette);
    memset(p_src, 0, sizeof(video_format_t));
    p_src->p_palette = NULL;
}

VLC_API void video_format_Setup(video_format_t *, vlc_fourcc_t i_chroma, int i_width, int i_height, int i_sar_num, int i_sar_den);

VLC_API void video_format_CopyCrop(video_format_t *, const video_format_t *);

VLC_API void video_format_ScaleCropAr(video_format_t *, const video_format_t *);

VLC_API bool video_format_IsSimilar(const video_format_t *, const video_format_t *);

VLC_API void video_format_Print(vlc_object_t *, const char *, const video_format_t *);

struct subs_format_t
{

    char *psz_encoding;

    int i_x_origin;
    int i_y_origin;

    struct
    {

        uint32_t palette[16 + 1];

        int i_original_frame_width;

        int i_original_frame_height;
    } spu;

    struct
    {
        int i_id;
    } dvb;
    struct
    {
        int i_magazine;
        int i_page;
    } teletext;
};

typedef struct extra_languages_t
{
    char *psz_language;
    char *psz_description;
} extra_languages_t;

struct es_format_t
{
    int i_cat;
    vlc_fourcc_t i_codec;
    vlc_fourcc_t i_original_fourcc;

    int i_id;
    int i_group;
    int i_priority;

    char *psz_language;
    char *psz_description;
    int i_extra_languages;
    extra_languages_t *p_extra_languages;

    audio_format_t audio;
    audio_replay_gain_t audio_replay_gain;
    video_format_t video;
    subs_format_t subs;

    unsigned int i_bitrate;
    int i_profile;
    int i_level;

    bool b_packetized;
    int i_extra;
    void *p_extra;
};

enum es_format_category_e
{
    UNKNOWN_ES = 0x00,
    VIDEO_ES = 0x01,
    AUDIO_ES = 0x02,
    SPU_ES = 0x03,
    NAV_ES = 0x04,
};

VLC_API void video_format_FixRgb(video_format_t *);

VLC_API void es_format_Init(es_format_t *, int i_cat, vlc_fourcc_t i_codec);

VLC_API void es_format_InitFromVideo(es_format_t *, const video_format_t *);

VLC_API int es_format_Copy(es_format_t *p_dst, const es_format_t *p_src);

VLC_API void es_format_Clean(es_format_t *fmt);

VLC_API bool es_format_IsSimilar(const es_format_t *, const es_format_t *);

#endif
