#ifndef VLC_VLM_H
#define VLC_VLM_H 1

#include <vlc_input.h>

typedef struct
{
    int64_t id;
    bool b_enabled;

    char *psz_name;

    int i_input;
    char **ppsz_input;

    int i_option;
    char **ppsz_option;

    char *psz_output;

    bool b_vod;
    struct
    {
        bool b_loop;
    } broadcast;
    struct
    {
        char *psz_mux;
    } vod;

} vlm_media_t;

typedef struct
{
    char *psz_name;

    int64_t i_time;
    int64_t i_length;
    double d_position;
    bool b_paused;
    int i_rate;
} vlm_media_instance_t;

#if 0
typedef struct
{

} vlm_schedule_t
#endif

enum vlm_event_type_e
{

    VLM_EVENT_MEDIA_ADDED = 0x100,
    VLM_EVENT_MEDIA_REMOVED,
    VLM_EVENT_MEDIA_CHANGED,

    VLM_EVENT_MEDIA_INSTANCE_STARTED = 0x200,
    VLM_EVENT_MEDIA_INSTANCE_STOPPED,
    VLM_EVENT_MEDIA_INSTANCE_STATE,
};

typedef struct
{
    int i_type;
    int64_t id;
    const char *psz_name;
    const char *psz_instance_name;
    input_state_e input_state;
} vlm_event_t;

enum vlm_query_e
{

    VLM_GET_MEDIAS,

    VLM_CLEAR_MEDIAS,

    VLM_ADD_MEDIA,

    VLM_DEL_MEDIA,

    VLM_CHANGE_MEDIA,

    VLM_GET_MEDIA,

    VLM_GET_MEDIA_ID,

    VLM_GET_MEDIA_INSTANCES,

    VLM_CLEAR_MEDIA_INSTANCES,

    VLM_START_MEDIA_BROADCAST_INSTANCE,

    VLM_START_MEDIA_VOD_INSTANCE,

    VLM_STOP_MEDIA_INSTANCE,

    VLM_PAUSE_MEDIA_INSTANCE,

    VLM_GET_MEDIA_INSTANCE_TIME,

    VLM_SET_MEDIA_INSTANCE_TIME,

    VLM_GET_MEDIA_INSTANCE_POSITION,

    VLM_SET_MEDIA_INSTANCE_POSITION,

    VLM_CLEAR_SCHEDULES,

};

struct vlm_message_t
{
    char *psz_name;
    char *psz_value;

    int i_child;
    vlm_message_t **child;
};

#ifdef __cplusplus
extern "C"
{
#endif

    VLC_API vlm_t *vlm_New(vlc_object_t *);
#define vlm_New(a) vlm_New(VLC_OBJECT(a))
    VLC_API void vlm_Delete(vlm_t *);
    VLC_API int vlm_ExecuteCommand(vlm_t *, const char *, vlm_message_t **);
    VLC_API int vlm_Control(vlm_t *p_vlm, int i_query, ...);

    VLC_API vlm_message_t *vlm_MessageSimpleNew(const char *);
    VLC_API vlm_message_t *vlm_MessageNew(const char *, const char *, ...) VLC_FORMAT(2, 3);
    VLC_API vlm_message_t *vlm_MessageAdd(vlm_message_t *, vlm_message_t *);
    VLC_API void vlm_MessageDelete(vlm_message_t *);

    static inline void vlm_media_Init(vlm_media_t *p_media)
    {
        memset(p_media, 0, sizeof(vlm_media_t));
        p_media->id = 0;
        p_media->psz_name = NULL;
        TAB_INIT(p_media->i_input, p_media->ppsz_input);
        TAB_INIT(p_media->i_option, p_media->ppsz_option);
        p_media->psz_output = NULL;
        p_media->b_vod = false;

        p_media->vod.psz_mux = NULL;
        p_media->broadcast.b_loop = false;
    }

    static inline void
#ifndef __cplusplus
    vlm_media_Copy(vlm_media_t *restrict p_dst, const vlm_media_t *restrict p_src)
#else
vlm_media_Copy(vlm_media_t *p_dst, const vlm_media_t *p_src)
#endif
    {
        int i;

        memset(p_dst, 0, sizeof(vlm_media_t));
        p_dst->id = p_src->id;
        p_dst->b_enabled = p_src->b_enabled;
        if (p_src->psz_name)
            p_dst->psz_name = strdup(p_src->psz_name);

        for (i = 0; i < p_src->i_input; i++)
            TAB_APPEND_CAST((char **), p_dst->i_input, p_dst->ppsz_input, strdup(p_src->ppsz_input[i]));
        for (i = 0; i < p_src->i_option; i++)
            TAB_APPEND_CAST((char **), p_dst->i_option, p_dst->ppsz_option, strdup(p_src->ppsz_option[i]));

        if (p_src->psz_output)
            p_dst->psz_output = strdup(p_src->psz_output);

        p_dst->b_vod = p_src->b_vod;
        if (p_src->b_vod)
        {
            if (p_src->vod.psz_mux)
                p_dst->vod.psz_mux = strdup(p_src->vod.psz_mux);
        }
        else
        {
            p_dst->broadcast.b_loop = p_src->broadcast.b_loop;
        }
    }

    static inline void vlm_media_Clean(vlm_media_t *p_media)
    {
        int i;
        free(p_media->psz_name);

        for (i = 0; i < p_media->i_input; i++)
            free(p_media->ppsz_input[i]);
        TAB_CLEAN(p_media->i_input, p_media->ppsz_input);

        for (i = 0; i < p_media->i_option; i++)
            free(p_media->ppsz_option[i]);
        TAB_CLEAN(p_media->i_option, p_media->ppsz_option);

        free(p_media->psz_output);
        if (p_media->b_vod)
            free(p_media->vod.psz_mux);
    }

    static inline vlm_media_t *vlm_media_New(void)
    {
        vlm_media_t *p_media = (vlm_media_t *)malloc(sizeof(vlm_media_t));
        if (p_media)
            vlm_media_Init(p_media);
        return p_media;
    }

    static inline void vlm_media_Delete(vlm_media_t *p_media)
    {
        vlm_media_Clean(p_media);
        free(p_media);
    }

    static inline vlm_media_t *vlm_media_Duplicate(vlm_media_t *p_src)
    {
        vlm_media_t *p_dst = vlm_media_New();
        if (p_dst)
            vlm_media_Copy(p_dst, p_src);
        return p_dst;
    }

    static inline void vlm_media_instance_Init(vlm_media_instance_t *p_instance)
    {
        memset(p_instance, 0, sizeof(vlm_media_instance_t));
        p_instance->psz_name = NULL;
        p_instance->i_time = 0;
        p_instance->i_length = 0;
        p_instance->d_position = 0.0;
        p_instance->b_paused = false;
        p_instance->i_rate = INPUT_RATE_DEFAULT;
    }

    static inline void vlm_media_instance_Clean(vlm_media_instance_t *p_instance)
    {
        free(p_instance->psz_name);
    }

    static inline vlm_media_instance_t *vlm_media_instance_New(void)
    {
        vlm_media_instance_t *p_instance = (vlm_media_instance_t *)malloc(sizeof(vlm_media_instance_t));
        if (p_instance)
            vlm_media_instance_Init(p_instance);
        return p_instance;
    }

    static inline void vlm_media_instance_Delete(vlm_media_instance_t *p_instance)
    {
        vlm_media_instance_Clean(p_instance);
        free(p_instance);
    }

#ifdef __cplusplus
}
#endif

#endif
