#ifndef VLC_DEMUX_H
#define VLC_DEMUX_H 1

#include <vlc_es.h>
#include <vlc_stream.h>
#include <vlc_es_out.h>

struct demux_t
{
    VLC_COMMON_MEMBERS

    module_t *p_module;

    char *psz_access;
    char *psz_demux;
    char *psz_location;
    char *psz_file;

    stream_t *s;

    es_out_t *out;

    int (*pf_demux)(demux_t *);
    int (*pf_control)(demux_t *, int i_query, va_list args);

    struct
    {
        unsigned int i_update;

        int i_title;
        int i_seekpoint;
    } info;
    demux_sys_t *p_sys;

    input_thread_t *p_input;
};

typedef struct demux_meta_t
{
    VLC_COMMON_MEMBERS
    demux_t *p_demux;
    input_item_t *p_item;

    vlc_meta_t *p_meta;

    int i_attachments;
    input_attachment_t **attachments;
} demux_meta_t;

enum demux_query_e
{

    DEMUX_GET_POSITION,
    DEMUX_SET_POSITION,

    DEMUX_GET_LENGTH,
    DEMUX_GET_TIME,
    DEMUX_SET_TIME,

    DEMUX_GET_TITLE_INFO,

    DEMUX_SET_TITLE,
    DEMUX_SET_SEEKPOINT,

    DEMUX_SET_GROUP,

    DEMUX_SET_NEXT_DEMUX_TIME,

    DEMUX_GET_FPS,

    DEMUX_GET_META,
    DEMUX_HAS_UNSUPPORTED_META,

    DEMUX_GET_ATTACHMENTS,

    DEMUX_CAN_RECORD,
    DEMUX_SET_RECORD_STATE,

    DEMUX_CAN_PAUSE = 0x1000,
    DEMUX_SET_PAUSE_STATE,

    DEMUX_GET_PTS_DELAY,

    DEMUX_CAN_CONTROL_PACE,

    DEMUX_CAN_CONTROL_RATE,

    DEMUX_SET_RATE,

    DEMUX_CAN_SEEK,

    DEMUX_NAV_ACTIVATE,
    DEMUX_NAV_UP,
    DEMUX_NAV_DOWN,
    DEMUX_NAV_LEFT,
    DEMUX_NAV_RIGHT,
};

VLC_API int demux_vaControlHelper(stream_t *, int64_t i_start, int64_t i_end, int64_t i_bitrate, int i_align, int i_query, va_list args);

VLC_USED
static inline bool demux_IsPathExtension(demux_t *p_demux, const char *psz_extension)
{
    const char *name = (p_demux->psz_file != NULL) ? p_demux->psz_file
                                                   : p_demux->psz_location;
    const char *psz_ext = strrchr(name, '.');
    if (!psz_ext || strcasecmp(psz_ext, psz_extension))
        return false;
    return true;
}

VLC_USED
static inline bool demux_IsForced(demux_t *p_demux, const char *psz_name)
{
    if (!p_demux->psz_demux || strcmp(p_demux->psz_demux, psz_name))
        return false;
    return true;
}

VLC_API decoder_t *demux_PacketizerNew(demux_t *p_demux, es_format_t *p_fmt, const char *psz_msg) VLC_USED;

VLC_API void demux_PacketizerDestroy(decoder_t *p_packetizer);

VLC_API input_thread_t *demux_GetParentInput(demux_t *p_demux) VLC_USED;

#define DEMUX_INIT_COMMON()                              \
    do                                                   \
    {                                                    \
        p_demux->pf_control = Control;                   \
        p_demux->pf_demux = Demux;                       \
        p_demux->p_sys = calloc(1, sizeof(demux_sys_t)); \
        if (!p_demux->p_sys)                             \
            return VLC_ENOMEM;                           \
    } while (0)

#endif
