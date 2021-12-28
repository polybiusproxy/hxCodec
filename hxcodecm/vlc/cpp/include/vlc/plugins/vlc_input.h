#ifndef VLC_INPUT_H
#define VLC_INPUT_H 1

#include <vlc_es.h>
#include <vlc_meta.h>
#include <vlc_epg.h>
#include <vlc_events.h>
#include <vlc_input_item.h>

#include <string.h>

struct seekpoint_t
{
    int64_t i_byte_offset;
    int64_t i_time_offset;
    char *psz_name;
};

static inline seekpoint_t *vlc_seekpoint_New(void)
{
    seekpoint_t *point = (seekpoint_t *)malloc(sizeof(seekpoint_t));
    point->i_byte_offset =
        point->i_time_offset = -1;
    point->psz_name = NULL;
    return point;
}

static inline void vlc_seekpoint_Delete(seekpoint_t *point)
{
    if (!point)
        return;
    free(point->psz_name);
    free(point);
}

static inline seekpoint_t *vlc_seekpoint_Duplicate(const seekpoint_t *src)
{
    seekpoint_t *point = vlc_seekpoint_New();
    if (src->psz_name)
        point->psz_name = strdup(src->psz_name);
    point->i_time_offset = src->i_time_offset;
    point->i_byte_offset = src->i_byte_offset;
    return point;
}

typedef struct
{
    char *psz_name;

    bool b_menu;

    int64_t i_length;
    int64_t i_size;

    int i_seekpoint;
    seekpoint_t **seekpoint;

} input_title_t;

static inline input_title_t *vlc_input_title_New(void)
{
    input_title_t *t = (input_title_t *)malloc(sizeof(input_title_t));

    t->psz_name = NULL;
    t->b_menu = false;
    t->i_length = 0;
    t->i_size = 0;
    t->i_seekpoint = 0;
    t->seekpoint = NULL;

    return t;
}

static inline void vlc_input_title_Delete(input_title_t *t)
{
    int i;
    if (t == NULL)
        return;

    free(t->psz_name);
    for (i = 0; i < t->i_seekpoint; i++)
    {
        free(t->seekpoint[i]->psz_name);
        free(t->seekpoint[i]);
    }
    free(t->seekpoint);
    free(t);
}

static inline input_title_t *vlc_input_title_Duplicate(const input_title_t *t)
{
    input_title_t *dup = vlc_input_title_New();
    int i;

    if (t->psz_name)
        dup->psz_name = strdup(t->psz_name);
    dup->b_menu = t->b_menu;
    dup->i_length = t->i_length;
    dup->i_size = t->i_size;
    dup->i_seekpoint = t->i_seekpoint;
    if (t->i_seekpoint > 0)
    {
        dup->seekpoint = (seekpoint_t **)calloc(t->i_seekpoint,
                                                sizeof(seekpoint_t *));

        for (i = 0; i < t->i_seekpoint; i++)
        {
            dup->seekpoint[i] = vlc_seekpoint_Duplicate(t->seekpoint[i]);
        }
    }

    return dup;
}

struct input_attachment_t
{
    char *psz_name;
    char *psz_mime;
    char *psz_description;

    int i_data;
    void *p_data;
};

static inline input_attachment_t *vlc_input_attachment_New(const char *psz_name,
                                                           const char *psz_mime,
                                                           const char *psz_description,
                                                           const void *p_data,
                                                           int i_data)
{
    input_attachment_t *a =
        (input_attachment_t *)malloc(sizeof(input_attachment_t));
    if (!a)
        return NULL;
    a->psz_name = strdup(psz_name ? psz_name : "");
    a->psz_mime = strdup(psz_mime ? psz_mime : "");
    a->psz_description = strdup(psz_description ? psz_description : "");
    a->i_data = i_data;
    a->p_data = NULL;
    if (i_data > 0)
    {
        a->p_data = malloc(i_data);
        if (a->p_data && p_data)
            memcpy(a->p_data, p_data, i_data);
    }
    return a;
}
static inline input_attachment_t *vlc_input_attachment_Duplicate(const input_attachment_t *a)
{
    return vlc_input_attachment_New(a->psz_name, a->psz_mime, a->psz_description,
                                    a->p_data, a->i_data);
}
static inline void vlc_input_attachment_Delete(input_attachment_t *a)
{
    if (!a)
        return;
    free(a->psz_name);
    free(a->psz_mime);
    free(a->psz_description);
    free(a->p_data);
    free(a);
}

#define INPUT_UPDATE_TITLE 0x0010
#define INPUT_UPDATE_SEEKPOINT 0x0020
#define INPUT_UPDATE_META 0x0040
#define INPUT_UPDATE_SIGNAL 0x0080
#define INPUT_UPDATE_TITLE_LIST 0x0100

typedef struct input_thread_private_t input_thread_private_t;

typedef struct input_resource_t input_resource_t;

struct input_thread_t
{
    VLC_COMMON_MEMBERS

    bool b_error;
    bool b_eof;
    bool b_preparsing;
    bool b_dead;

    input_thread_private_t *p;
};

#define INPUT_RECORD_PREFIX "vlc-record-%Y-%m-%d-%Hh%Mm%Ss-$ N-$ p"

typedef enum input_state_e
{
    INIT_S = 0,
    OPENING_S,
    PLAYING_S,
    PAUSE_S,
    END_S,
    ERROR_S,
} input_state_e;

#define INPUT_RATE_DEFAULT 1000

#define INPUT_RATE_MIN 32

#define INPUT_RATE_MAX 32000

typedef enum input_event_type_e
{

    INPUT_EVENT_STATE,

    INPUT_EVENT_DEAD,

    INPUT_EVENT_ABORT,

    INPUT_EVENT_RATE,

    INPUT_EVENT_POSITION,

    INPUT_EVENT_LENGTH,

    INPUT_EVENT_TITLE,

    INPUT_EVENT_CHAPTER,

    INPUT_EVENT_PROGRAM,

    INPUT_EVENT_ES,

    INPUT_EVENT_TELETEXT,

    INPUT_EVENT_RECORD,

    INPUT_EVENT_ITEM_META,

    INPUT_EVENT_ITEM_INFO,

    INPUT_EVENT_ITEM_NAME,

    INPUT_EVENT_ITEM_EPG,

    INPUT_EVENT_STATISTICS,

    INPUT_EVENT_SIGNAL,

    INPUT_EVENT_AUDIO_DELAY,

    INPUT_EVENT_SUBTITLE_DELAY,

    INPUT_EVENT_BOOKMARK,

    INPUT_EVENT_CACHE,

    INPUT_EVENT_AOUT,

    INPUT_EVENT_VOUT,

} input_event_type_e;

enum input_query_e
{

    INPUT_GET_POSITION,
    INPUT_SET_POSITION,

    INPUT_GET_LENGTH,

    INPUT_GET_TIME,
    INPUT_SET_TIME,

    INPUT_GET_RATE,
    INPUT_SET_RATE,

    INPUT_GET_STATE,
    INPUT_SET_STATE,

    INPUT_GET_AUDIO_DELAY,
    INPUT_SET_AUDIO_DELAY,
    INPUT_GET_SPU_DELAY,
    INPUT_SET_SPU_DELAY,

    INPUT_NAV_ACTIVATE,
    INPUT_NAV_UP,
    INPUT_NAV_DOWN,
    INPUT_NAV_LEFT,
    INPUT_NAV_RIGHT,

    INPUT_ADD_INFO,
    INPUT_REPLACE_INFOS,
    INPUT_MERGE_INFOS,
    INPUT_GET_INFO,
    INPUT_DEL_INFO,
    INPUT_SET_NAME,

    INPUT_GET_VIDEO_FPS,

    INPUT_GET_BOOKMARK,
    INPUT_GET_BOOKMARKS,
    INPUT_CLEAR_BOOKMARKS,
    INPUT_ADD_BOOKMARK,
    INPUT_CHANGE_BOOKMARK,
    INPUT_DEL_BOOKMARK,
    INPUT_SET_BOOKMARK,

    INPUT_GET_TITLE_INFO,

    INPUT_GET_ATTACHMENTS,
    INPUT_GET_ATTACHMENT,

    INPUT_ADD_SLAVE,
    INPUT_ADD_SUBTITLE,

    INPUT_SET_RECORD_STATE,
    INPUT_GET_RECORD_STATE,

    INPUT_RESTART_ES,

    INPUT_GET_AOUT,
    INPUT_GET_VOUTS,
    INPUT_GET_ES_OBJECTS,

    INPUT_GET_PCR_SYSTEM,
    INPUT_MODIFY_PCR_SYSTEM,
};

VLC_API input_thread_t *input_Create(vlc_object_t *p_parent, input_item_t *, const char *psz_log, input_resource_t *) VLC_USED;
#define input_Create(a, b, c, d) input_Create(VLC_OBJECT(a), b, c, d)

VLC_API input_thread_t *input_CreateAndStart(vlc_object_t *p_parent, input_item_t *, const char *psz_log) VLC_USED;
#define input_CreateAndStart(a, b, c) input_CreateAndStart(VLC_OBJECT(a), b, c)

VLC_API int input_Start(input_thread_t *);

VLC_API void input_Stop(input_thread_t *, bool b_abort);

VLC_API int input_Read(vlc_object_t *, input_item_t *);
#define input_Read(a, b) input_Read(VLC_OBJECT(a), b)

VLC_API int input_vaControl(input_thread_t *, int i_query, va_list);

VLC_API int input_Control(input_thread_t *, int i_query, ...);

VLC_API void input_Close(input_thread_t *);
void input_Join(input_thread_t *);
void input_Release(input_thread_t *);

VLC_API input_item_t *input_GetItem(input_thread_t *) VLC_USED;

static inline input_state_e input_GetState(input_thread_t *p_input)
{
    input_state_e state = INIT_S;
    input_Control(p_input, INPUT_GET_STATE, &state);
    return state;
}

static inline int input_AddSubtitle(input_thread_t *p_input, const char *psz_url, bool b_check_extension)
{
    return input_Control(p_input, INPUT_ADD_SUBTITLE, psz_url, b_check_extension);
}

static inline vout_thread_t *input_GetVout(input_thread_t *p_input)
{
    vout_thread_t **pp_vout, *p_vout;
    size_t i_vout;

    if (input_Control(p_input, INPUT_GET_VOUTS, &pp_vout, &i_vout))
        return NULL;

    for (size_t i = 1; i < i_vout; i++)
        vlc_object_release((vlc_object_t *)(pp_vout[i]));

    p_vout = (i_vout >= 1) ? pp_vout[0] : NULL;
    free(pp_vout);
    return p_vout;
}

static inline audio_output_t *input_GetAout(input_thread_t *p_input)
{
    audio_output_t *p_aout;
    return input_Control(p_input, INPUT_GET_AOUT, &p_aout) ? NULL : p_aout;
}

static inline int input_GetEsObjects(input_thread_t *p_input, int i_id,
                                     vlc_object_t **pp_decoder,
                                     vout_thread_t **pp_vout, audio_output_t **pp_aout)
{
    return input_Control(p_input, INPUT_GET_ES_OBJECTS, i_id,
                         pp_decoder, pp_vout, pp_aout);
}

static inline int input_GetPcrSystem(input_thread_t *p_input, mtime_t *pi_system, mtime_t *pi_delay)
{
    return input_Control(p_input, INPUT_GET_PCR_SYSTEM, pi_system, pi_delay);
}

static inline int input_ModifyPcrSystem(input_thread_t *p_input, bool b_absolute, mtime_t i_system)
{
    return input_Control(p_input, INPUT_MODIFY_PCR_SYSTEM, b_absolute, i_system);
}

VLC_API decoder_t *input_DecoderCreate(vlc_object_t *, es_format_t *, input_resource_t *) VLC_USED;
VLC_API void input_DecoderDelete(decoder_t *);
VLC_API void input_DecoderDecode(decoder_t *, block_t *, bool b_do_pace);

VLC_API char *input_CreateFilename(vlc_object_t *, const char *psz_path, const char *psz_prefix, const char *psz_extension) VLC_USED;

VLC_API input_resource_t *input_resource_New(vlc_object_t *) VLC_USED;

VLC_API void input_resource_Release(input_resource_t *);

VLC_API void input_resource_TerminateVout(input_resource_t *);

VLC_API void input_resource_Terminate(input_resource_t *);

VLC_API audio_output_t *input_resource_HoldAout(input_resource_t *);

#endif
