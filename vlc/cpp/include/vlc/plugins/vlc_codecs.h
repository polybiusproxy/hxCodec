#ifndef VLC_CODECS_H
#define VLC_CODECS_H 1

#include <vlc_fourcc.h>

#if !(defined _GUID_DEFINED || defined GUID_DEFINED)
#define GUID_DEFINED
typedef struct _GUID
{
    uint32_t Data1;
    uint16_t Data2;
    uint16_t Data3;
    uint8_t Data4[8];
} GUID, *REFGUID, *LPGUID;
#endif

typedef GUID guid_t;

#ifdef HAVE_ATTRIBUTE_PACKED
#define ATTR_PACKED __attribute__((__packed__))
#elif defined(__SUNPRO_C)
#pragma pack(1)
#define ATTR_PACKED
#elif defined(__APPLE__)
#pragma pack(push, 1)
#define ATTR_PACKED
#else
#error FIXME
#endif

#ifndef _WAVEFORMATEX_
#define _WAVEFORMATEX_
typedef struct
    ATTR_PACKED
        _WAVEFORMATEX
{
    uint16_t wFormatTag;
    uint16_t nChannels;
    uint32_t nSamplesPerSec;
    uint32_t nAvgBytesPerSec;
    uint16_t nBlockAlign;
    uint16_t wBitsPerSample;
    uint16_t cbSize;
} WAVEFORMATEX, *PWAVEFORMATEX, *NPWAVEFORMATEX, *LPWAVEFORMATEX;
#endif

#ifndef _WAVEFORMATEXTENSIBLE_
#define _WAVEFORMATEXTENSIBLE_
typedef struct
    ATTR_PACKED
        _WAVEFORMATEXTENSIBLE
{
    WAVEFORMATEX Format;
    union
    {
        uint16_t wValidBitsPerSample;
        uint16_t wSamplesPerBlock;
        uint16_t wReserved;
    } Samples;
    uint32_t dwChannelMask;
    GUID SubFormat;
} WAVEFORMATEXTENSIBLE, *PWAVEFORMATEXTENSIBLE;
#endif

#ifndef _WAVEHEADER_
#define _WAVEHEADER_
typedef struct
    ATTR_PACKED
        _WAVEHEADER
{
    uint32_t MainChunkID;
    uint32_t Length;
    uint32_t ChunkTypeID;
    uint32_t SubChunkID;
    uint32_t SubChunkLength;
    uint16_t Format;
    uint16_t Modus;
    uint32_t SampleFreq;
    uint32_t BytesPerSec;
    uint16_t BytesPerSample;
    uint16_t BitsPerSample;
    uint32_t DataChunkID;
    uint32_t DataLength;
} WAVEHEADER;
#endif

#ifndef _VLC_BITMAPINFOHEADER_
#define _VLC_BITMAPINFOHEADER_

typedef struct
    ATTR_PACKED
{
    uint32_t biSize;
    uint32_t biWidth;
    uint32_t biHeight;
    uint16_t biPlanes;
    uint16_t biBitCount;
    uint32_t biCompression;
    uint32_t biSizeImage;
    uint32_t biXPelsPerMeter;
    uint32_t biYPelsPerMeter;
    uint32_t biClrUsed;
    uint32_t biClrImportant;
} VLC_BITMAPINFOHEADER, *VLC_PBITMAPINFOHEADER, *VLC_LPBITMAPINFOHEADER;

typedef struct
    ATTR_PACKED
{
    VLC_BITMAPINFOHEADER bmiHeader;
    int bmiColors[1];
} VLC_BITMAPINFO, *VLC_LPBITMAPINFO;
#endif

#ifndef _RECT32_
#define _RECT32_
typedef struct
    ATTR_PACKED
{
    int left, top, right, bottom;
} RECT32;
#endif

#ifndef _REFERENCE_TIME_
#define _REFERENCE_TIME_
typedef int64_t REFERENCE_TIME;
#endif

#ifndef _VIDEOINFOHEADER_
#define _VIDEOINFOHEADER_
typedef struct
    ATTR_PACKED
{
    RECT32 rcSource;
    RECT32 rcTarget;
    uint32_t dwBitRate;
    uint32_t dwBitErrorRate;
    REFERENCE_TIME AvgTimePerFrame;
    VLC_BITMAPINFOHEADER bmiHeader;
} VIDEOINFOHEADER;
#endif

#ifndef _RGBQUAD_
#define _RGBQUAD_
typedef struct
    ATTR_PACKED
{
    uint8_t rgbBlue;
    uint8_t rgbGreen;
    uint8_t rgbRed;
    uint8_t rgbReserved;
} RGBQUAD1;
#endif

#ifndef _TRUECOLORINFO_
#define _TRUECOLORINFO_
typedef struct
    ATTR_PACKED
{
    uint32_t dwBitMasks[3];
    RGBQUAD1 bmiColors[256];
} TRUECOLORINFO;
#endif

#ifndef _VIDEOINFO_
#define _VIDEOINFO_
typedef struct
    ATTR_PACKED
{
    RECT32 rcSource;
    RECT32 rcTarget;
    uint32_t dwBitRate;
    uint32_t dwBitErrorRate;
    REFERENCE_TIME AvgTimePerFrame;
    VLC_BITMAPINFOHEADER bmiHeader;

    union
    {
        RGBQUAD1 bmiColors[256];
        uint32_t dwBitMasks[3];
        TRUECOLORINFO TrueColorInfo;
    };

} VIDEOINFO;
#endif

#if defined(__SUNPRO_C)
#pragma pack()
#elif defined(__APPLE__) && !HAVE_ATTRIBUTE_PACKED
#pragma pack(pop)
#endif

#define WAVE_FORMAT_UNKNOWN 0x0000
#define WAVE_FORMAT_PCM 0x0001
#define WAVE_FORMAT_ADPCM 0x0002
#define WAVE_FORMAT_IEEE_FLOAT 0x0003
#define WAVE_FORMAT_ALAW 0x0006
#define WAVE_FORMAT_MULAW 0x0007
#define WAVE_FORMAT_DTS_MS 0x0008
#define WAVE_FORMAT_WMAS 0x000a
#define WAVE_FORMAT_IMA_ADPCM 0x0011
#define WAVE_FORMAT_YAMAHA_ADPCM 0x0020
#define WAVE_FORMAT_TRUESPEECH 0x0022
#define WAVE_FORMAT_GSM610 0x0031
#define WAVE_FORMAT_MSNAUDIO 0x0032
#define WAVE_FORMAT_MSG723 0x0042
#define WAVE_FORMAT_G726 0x0045
#define WAVE_FORMAT_MPEG 0x0050
#define WAVE_FORMAT_MPEGLAYER3 0x0055
#define WAVE_FORMAT_AMR_NB 0x0057
#define WAVE_FORMAT_AMR_WB 0x0058
#define WAVE_FORMAT_DOLBY_AC3_SPDIF 0x0092

#define WAVE_FORMAT_AAC 0x00FF
#define WAVE_FORMAT_AAC_MS 0xa106
#define WAVE_FORMAT_SIPRO 0x0130

#define WAVE_FORMAT_WMA1 0x0160
#define WAVE_FORMAT_WMA2 0x0161
#define WAVE_FORMAT_WMAP 0x0162
#define WAVE_FORMAT_WMAL 0x0163

#define WAVE_FORMAT_ULEAD_DV_AUDIO_NTSC 0x0215
#define WAVE_FORMAT_ULEAD_DV_AUDIO_PAL 0x0216

#define WAVE_FORMAT_ATRAC3 0x0270
#define WAVE_FORMAT_SONY_ATRAC3 0x0272

#define WAVE_FORMAT_INDEO_AUDIO 0x0402

#define WAVE_FORMAT_AAC_2 0x1601
#define WAVE_FORMAT_AAC_LATM 0x1602

#define WAVE_FORMAT_A52 0x2000
#define WAVE_FORMAT_DTS 0x2001
#define WAVE_FORMAT_FFMPEG_AAC 0x706D
#define WAVE_FORMAT_DIVIO_AAC 0x4143

#define WAVE_FORMAT_GSM_AMR_FIXED 0x7A21
#define WAVE_FORMAT_GSM_AMR 0x7A22

#define WAVE_FORMAT_DK3 0x0061
#define WAVE_FORMAT_DK4 0x0062

#define WAVE_FORMAT_VORBIS 0x566f

#define WAVE_FORMAT_VORB_1 0x674f
#define WAVE_FORMAT_VORB_2 0x6750
#define WAVE_FORMAT_VORB_3 0x6751
#define WAVE_FORMAT_VORB_1PLUS 0x676f
#define WAVE_FORMAT_VORB_2PLUS 0x6770
#define WAVE_FORMAT_VORB_3PLUS 0x6771

#define WAVE_FORMAT_G723_1 0xa100

#define WAVE_FORMAT_SPEEX 0xa109
#define WAVE_FORMAT_FLAC 0xf1ac

#if !defined(WAVE_FORMAT_EXTENSIBLE)
#define WAVE_FORMAT_EXTENSIBLE 0xFFFE
#endif

#ifndef _KSDATAFORMAT_SUBTYPE_PCM_
#define _KSDATAFORMAT_SUBTYPE_PCM_                                                     \
    {                                                                                  \
        0x00000001, 0x0000, 0x0010, { 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71 } \
    }
static const GUID VLC_KSDATAFORMAT_SUBTYPE_PCM = {0xE923AABF, 0xCB58, 0x4471, {0xA1, 0x19, 0xFF, 0xFA, 0x01, 0xE4, 0xCE, 0x62}};
#define KSDATAFORMAT_SUBTYPE_PCM VLC_KSDATAFORMAT_SUBTYPE_PCM
#endif

#ifndef _KSDATAFORMAT_SUBTYPE_IEEE_FLOAT_
#define _KSDATAFORMAT_SUBTYPE_IEEE_FLOAT_                                              \
    {                                                                                  \
        0x00000003, 0x0000, 0x0010, { 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71 } \
    }
static const GUID VLC_KSDATAFORMAT_SUBTYPE_IEEE_FLOAT = {0x00000003, 0x0000, 0x0010, {0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}};
#define KSDATAFORMAT_SUBTYPE_IEEE_FLOAT VLC_KSDATAFORMAT_SUBTYPE_PCM
#endif

#ifndef _KSDATAFORMAT_SUBTYPE_UNKNOWN_
#define _KSDATAFORMAT_SUBTYPE_UNKNOWN_                                                 \
    {                                                                                  \
        0x00000000, 0x0000, 0x0000, { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 } \
    }
static const GUID VLC_KSDATAFORMAT_SUBTYPE_UNKNOWN = {0x00000000, 0x0000, 0x0000, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}};
#define KSDATAFORMAT_SUBTYPE_UNKNOWN VLC_KSDATAFORMAT_SUBTYPE_UNKNOWN
#endif

#define WAVE_SPEAKER_FRONT_LEFT 0x1
#define WAVE_SPEAKER_FRONT_RIGHT 0x2
#define WAVE_SPEAKER_FRONT_CENTER 0x4
#define WAVE_SPEAKER_LOW_FREQUENCY 0x8
#define WAVE_SPEAKER_BACK_LEFT 0x10
#define WAVE_SPEAKER_BACK_RIGHT 0x20
#define WAVE_SPEAKER_FRONT_LEFT_OF_CENTER 0x40
#define WAVE_SPEAKER_FRONT_RIGHT_OF_CENTER 0x80
#define WAVE_SPEAKER_BACK_CENTER 0x100
#define WAVE_SPEAKER_SIDE_LEFT 0x200
#define WAVE_SPEAKER_SIDE_RIGHT 0x400
#define WAVE_SPEAKER_TOP_CENTER 0x800
#define WAVE_SPEAKER_TOP_FRONT_LEFT 0x1000
#define WAVE_SPEAKER_TOP_FRONT_CENTER 0x2000
#define WAVE_SPEAKER_TOP_FRONT_RIGHT 0x4000
#define WAVE_SPEAKER_TOP_BACK_LEFT 0x8000
#define WAVE_SPEAKER_TOP_BACK_CENTER 0x10000
#define WAVE_SPEAKER_TOP_BACK_RIGHT 0x20000
#define WAVE_SPEAKER_RESERVED 0x80000000

static const struct
{
    uint16_t i_tag;
    vlc_fourcc_t i_fourcc;
    const char *psz_name;
} wave_format_tag_to_fourcc[] =
    {
        {WAVE_FORMAT_PCM, VLC_FOURCC('a', 'r', 'a', 'w'), "Raw audio"},
        {WAVE_FORMAT_PCM, VLC_CODEC_S8, "PCM S8 audio"},
        {WAVE_FORMAT_PCM, VLC_CODEC_S16L, "PCM S16L audio"},
        {WAVE_FORMAT_PCM, VLC_CODEC_S24L, "PCM S24L audio"},
        {WAVE_FORMAT_PCM, VLC_CODEC_S32L, "PCM S32L audio"},
        {WAVE_FORMAT_ADPCM, VLC_CODEC_ADPCM_MS, "ADPCM"},
        {WAVE_FORMAT_IEEE_FLOAT, VLC_FOURCC('a', 'f', 'l', 't'), "IEEE Float audio"},
        {WAVE_FORMAT_IEEE_FLOAT, VLC_CODEC_F32L, "PCM 32 (Float) audio"},
        {WAVE_FORMAT_IEEE_FLOAT, VLC_CODEC_F64L, "PCM 64 (Float) audio"},
        {WAVE_FORMAT_ALAW, VLC_CODEC_ALAW, "A-Law"},
        {WAVE_FORMAT_MULAW, VLC_CODEC_MULAW, "Mu-Law"},
        {WAVE_FORMAT_IMA_ADPCM, VLC_CODEC_ADPCM_IMA_WAV, "Ima-ADPCM"},
        {WAVE_FORMAT_YAMAHA_ADPCM, VLC_CODEC_ADPCM_YAMAHA, "Yamaha ADPCM"},
        {WAVE_FORMAT_TRUESPEECH, VLC_CODEC_TRUESPEECH, "Truespeech"},
        {WAVE_FORMAT_GSM610, VLC_CODEC_GSM_MS, "Microsoft WAV GSM"},
        {WAVE_FORMAT_G726, VLC_CODEC_ADPCM_G726, "G.726 ADPCM"},
        {WAVE_FORMAT_G723_1, VLC_CODEC_G723_1, "G.723.1"},
        {WAVE_FORMAT_MSG723, VLC_CODEC_G723_1, "Microsoft G.723 [G723.1]"},
        {WAVE_FORMAT_MPEGLAYER3, VLC_CODEC_MPGA, "Mpeg Audio"},
        {WAVE_FORMAT_MPEG, VLC_CODEC_MPGA, "Mpeg Audio"},
        {WAVE_FORMAT_AMR_NB, VLC_CODEC_AMR_NB, "AMR NB"},
        {WAVE_FORMAT_AMR_WB, VLC_CODEC_AMR_WB, "AMR Wideband"},
        {WAVE_FORMAT_SIPRO, VLC_CODEC_SIPR, "Sipr Audio"},
        {WAVE_FORMAT_A52, VLC_CODEC_A52, "A/52"},
        {WAVE_FORMAT_WMA1, VLC_CODEC_WMA1, "Window Media Audio v1"},
        {WAVE_FORMAT_WMA2, VLC_CODEC_WMA2, "Window Media Audio v2"},
        {WAVE_FORMAT_WMAP, VLC_CODEC_WMAP, "Window Media Audio 9 Professional"},
        {WAVE_FORMAT_WMAL, VLC_CODEC_WMAL, "Window Media Audio 9 Lossless"},
        {WAVE_FORMAT_WMAS, VLC_CODEC_WMAS, "Window Media Audio 9 Speech"},
        {WAVE_FORMAT_ATRAC3, VLC_CODEC_ATRAC3, "Sony Atrac3"},
        {WAVE_FORMAT_SONY_ATRAC3, VLC_CODEC_ATRAC3, "Sony Atrac3"},
        {WAVE_FORMAT_DK3, VLC_FOURCC('m', 's', 0x00, 0x61), "Duck DK3"},
        {WAVE_FORMAT_DK4, VLC_FOURCC('m', 's', 0x00, 0x62), "Duck DK4"},
        {WAVE_FORMAT_DTS, VLC_CODEC_DTS, "DTS Coherent Acoustics"},
        {WAVE_FORMAT_DTS_MS, VLC_CODEC_DTS, "DTS Coherent Acoustics"},
        {WAVE_FORMAT_DIVIO_AAC, VLC_CODEC_MP4A, "MPEG-4 Audio (Divio)"},
        {WAVE_FORMAT_AAC, VLC_CODEC_MP4A, "MPEG-4 Audio"},
        {WAVE_FORMAT_AAC_2, VLC_CODEC_MP4A, "MPEG-4 Audio"},
        {WAVE_FORMAT_AAC_LATM, VLC_CODEC_MP4A, "MPEG-4 Audio"},
        {WAVE_FORMAT_FFMPEG_AAC, VLC_CODEC_MP4A, "MPEG-4 Audio"},
        {WAVE_FORMAT_AAC_MS, VLC_CODEC_MP4A, "MPEG-4 Audio"},
        {WAVE_FORMAT_VORBIS, VLC_CODEC_VORBIS, "Vorbis Audio"},
        {WAVE_FORMAT_VORB_1, VLC_FOURCC('v', 'o', 'r', '1'), "Vorbis 1 Audio"},
        {WAVE_FORMAT_VORB_1PLUS, VLC_FOURCC('v', 'o', '1', '+'), "Vorbis 1+ Audio"},
        {WAVE_FORMAT_VORB_2, VLC_FOURCC('v', 'o', 'r', '2'), "Vorbis 2 Audio"},
        {WAVE_FORMAT_VORB_2PLUS, VLC_FOURCC('v', 'o', '2', '+'), "Vorbis 2+ Audio"},
        {WAVE_FORMAT_VORB_3, VLC_FOURCC('v', 'o', 'r', '3'), "Vorbis 3 Audio"},
        {WAVE_FORMAT_VORB_3PLUS, VLC_FOURCC('v', 'o', '3', '+'), "Vorbis 3+ Audio"},
        {WAVE_FORMAT_SPEEX, VLC_CODEC_SPEEX, "Speex Audio"},
        {WAVE_FORMAT_FLAC, VLC_CODEC_FLAC, "FLAC Audio"},
        {WAVE_FORMAT_GSM_AMR_FIXED, VLC_CODEC_AMR_NB, "GSM-AMR Audio CBR, no SID"},
        {WAVE_FORMAT_GSM_AMR, VLC_CODEC_AMR_NB, "GSM-AMR Audio VBR, SID"},
        {WAVE_FORMAT_ULEAD_DV_AUDIO_NTSC, VLC_CODEC_ULEAD_DV_AUDIO_NTSC, "Ulead DV audio NTSC"},
        {WAVE_FORMAT_ULEAD_DV_AUDIO_PAL, VLC_CODEC_ULEAD_DV_AUDIO_PAL, "Ulead DV audio PAL"},
        {WAVE_FORMAT_INDEO_AUDIO, VLC_CODEC_INDEO_AUDIO, "Indeo Audio Coder"},
        {WAVE_FORMAT_UNKNOWN, VLC_FOURCC('u', 'n', 'd', 'f'), "Unknown"}};

static inline void wf_tag_to_fourcc(uint16_t i_tag, vlc_fourcc_t *fcc,
                                    const char **ppsz_name)
{
    int i;
    for (i = 0; wave_format_tag_to_fourcc[i].i_tag != 0; i++)
    {
        if (wave_format_tag_to_fourcc[i].i_tag == i_tag)
            break;
    }
    if (fcc)
        *fcc = wave_format_tag_to_fourcc[i].i_fourcc;
    if (ppsz_name)
        *ppsz_name = wave_format_tag_to_fourcc[i].psz_name;
}

static inline void fourcc_to_wf_tag(vlc_fourcc_t fcc, uint16_t *pi_tag)
{
    int i;
    for (i = 0; wave_format_tag_to_fourcc[i].i_tag != 0; i++)
    {
        if (wave_format_tag_to_fourcc[i].i_fourcc == fcc)
            break;
    }
    if (pi_tag)
        *pi_tag = wave_format_tag_to_fourcc[i].i_tag;
}

static const struct
{
    GUID guid_tag;
    vlc_fourcc_t i_fourcc;
    const char *psz_name;
} sub_format_tag_to_fourcc[] =
    {
        {_KSDATAFORMAT_SUBTYPE_PCM_, VLC_FOURCC('a', 'r', 'a', 'w'), "PCM"},
        {_KSDATAFORMAT_SUBTYPE_IEEE_FLOAT_, VLC_FOURCC('a', 'f', 'l', 't'), "Float PCM"},
        {_KSDATAFORMAT_SUBTYPE_UNKNOWN_, VLC_FOURCC('u', 'n', 'd', 'f'), "Unknown"}};

static inline int guidcmp(const GUID *s1, const GUID *s2)
{
    return (s1->Data1 == s2->Data1 && s1->Data2 == s2->Data2 &&
            s1->Data3 == s2->Data3 && !memcmp(s1->Data4, s2->Data4, 8));
}

static inline void sf_tag_to_fourcc(GUID *guid_tag,
                                    vlc_fourcc_t *fcc, const char **ppsz_name)
{
    int i;

    for (i = 0; !guidcmp(&sub_format_tag_to_fourcc[i].guid_tag,
                         &KSDATAFORMAT_SUBTYPE_UNKNOWN);
         i++)
    {
        if (guidcmp(&sub_format_tag_to_fourcc[i].guid_tag, guid_tag))
            break;
    }
    if (fcc)
        *fcc = sub_format_tag_to_fourcc[i].i_fourcc;
    if (ppsz_name)
        *ppsz_name = sub_format_tag_to_fourcc[i].psz_name;
}

#endif
