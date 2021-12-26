#ifndef VLC_ES_OUT_H
#define VLC_ES_OUT_H 1

enum es_out_query_e
{

    ES_OUT_SET_ES,
    ES_OUT_RESTART_ES,

    ES_OUT_SET_ES_DEFAULT,

    ES_OUT_SET_ES_STATE,
    ES_OUT_GET_ES_STATE,

    ES_OUT_SET_GROUP,

    ES_OUT_SET_PCR,
    ES_OUT_SET_GROUP_PCR,
    ES_OUT_RESET_PCR,

    ES_OUT_SET_ES_FMT,

    ES_OUT_SET_NEXT_DISPLAY_TIME,

    ES_OUT_SET_GROUP_META,

    ES_OUT_SET_GROUP_EPG,

    ES_OUT_DEL_GROUP,

    ES_OUT_SET_ES_SCRAMBLED_STATE,

    ES_OUT_GET_EMPTY,

    ES_OUT_SET_META,

    ES_OUT_GET_PCR_SYSTEM,
    ES_OUT_MODIFY_PCR_SYSTEM,

    ES_OUT_PRIVATE_START = 0x10000,
};

struct es_out_t
{
    es_out_id_t *(*pf_add)(es_out_t *, const es_format_t *);
    int (*pf_send)(es_out_t *, es_out_id_t *, block_t *);
    void (*pf_del)(es_out_t *, es_out_id_t *);
    int (*pf_control)(es_out_t *, int i_query, va_list);
    void (*pf_destroy)(es_out_t *);

    es_out_sys_t *p_sys;
};

VLC_USED
static inline es_out_id_t *es_out_Add(es_out_t *out, const es_format_t *fmt)
{
    return out->pf_add(out, fmt);
}

static inline void es_out_Del(es_out_t *out, es_out_id_t *id)
{
    out->pf_del(out, id);
}

static inline int es_out_Send(es_out_t *out, es_out_id_t *id,
                              block_t *p_block)
{
    return out->pf_send(out, id, p_block);
}

static inline int es_out_vaControl(es_out_t *out, int i_query, va_list args)
{
    return out->pf_control(out, i_query, args);
}

static inline int es_out_Control(es_out_t *out, int i_query, ...)
{
    va_list args;
    int i_result;

    va_start(args, i_query);
    i_result = es_out_vaControl(out, i_query, args);
    va_end(args);
    return i_result;
}

static inline void es_out_Delete(es_out_t *p_out)
{
    p_out->pf_destroy(p_out);
}

static inline int es_out_ControlSetMeta(es_out_t *out, const vlc_meta_t *p_meta)
{
    return es_out_Control(out, ES_OUT_SET_META, p_meta);
}

static inline int es_out_ControlGetPcrSystem(es_out_t *out, mtime_t *pi_system, mtime_t *pi_delay)
{
    return es_out_Control(out, ES_OUT_GET_PCR_SYSTEM, pi_system, pi_delay);
}
static inline int es_out_ControlModifyPcrSystem(es_out_t *out, bool b_absolute, mtime_t i_system)
{
    return es_out_Control(out, ES_OUT_MODIFY_PCR_SYSTEM, b_absolute, i_system);
}

#endif
