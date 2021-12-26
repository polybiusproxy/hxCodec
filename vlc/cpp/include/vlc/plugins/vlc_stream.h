#ifndef VLC_STREAM_H
#define VLC_STREAM_H 1

#include <vlc_block.h>

#ifdef __cplusplus
extern "C"
{
#endif

    typedef struct stream_text_t stream_text_t;

    struct stream_t
    {
        VLC_COMMON_MEMBERS
        bool b_error;

        module_t *p_module;

        char *psz_access;

        char *psz_path;

        stream_t *p_source;

        int (*pf_read)(stream_t *, void *p_read, unsigned int i_read);
        int (*pf_peek)(stream_t *, const uint8_t **pp_peek, unsigned int i_peek);
        int (*pf_control)(stream_t *, int i_query, va_list);

        void (*pf_destroy)(stream_t *);

        stream_sys_t *p_sys;

        stream_text_t *p_text;

        input_thread_t *p_input;
    };

    enum stream_query_e
    {

        STREAM_CAN_SEEK,
        STREAM_CAN_FASTSEEK,
        STREAM_CAN_PAUSE,
        STREAM_CAN_CONTROL_PACE,

        STREAM_SET_POSITION,
        STREAM_GET_POSITION,

        STREAM_GET_SIZE,

        STREAM_CONTROL_ACCESS,

        STREAM_UPDATE_SIZE,

        STREAM_GET_TITLE_INFO = 0x102,
        STREAM_GET_META,
        STREAM_GET_CONTENT_TYPE,
        STREAM_GET_SIGNAL,

        STREAM_SET_PAUSE_STATE = 0x200,
        STREAM_SET_TITLE,
        STREAM_SET_SEEKPOINT,

        STREAM_SET_RECORD_STATE,
    };

    VLC_API int stream_Read(stream_t *s, void *p_read, int i_read);
    VLC_API int stream_Peek(stream_t *s, const uint8_t **pp_peek, int i_peek);
    VLC_API int stream_vaControl(stream_t *s, int i_query, va_list args);
    VLC_API void stream_Delete(stream_t *s);
    VLC_API int stream_Control(stream_t *s, int i_query, ...);
    VLC_API block_t *stream_Block(stream_t *s, int i_size);
    VLC_API block_t *stream_BlockRemaining(stream_t *s, int i_max_size);
    VLC_API char *stream_ReadLine(stream_t *);

    static inline int64_t stream_Tell(stream_t *s)
    {
        uint64_t i_pos;
        stream_Control(s, STREAM_GET_POSITION, &i_pos);
        if (i_pos >> 62)
            return (int64_t)1 << 62;
        return i_pos;
    }

    static inline int64_t stream_Size(stream_t *s)
    {
        uint64_t i_pos;
        stream_Control(s, STREAM_GET_SIZE, &i_pos);
        if (i_pos >> 62)
            return (int64_t)1 << 62;
        return i_pos;
    }

    static inline int stream_Seek(stream_t *s, uint64_t i_pos)
    {
        return stream_Control(s, STREAM_SET_POSITION, i_pos);
    }

    static inline char *stream_ContentType(stream_t *s)
    {
        char *res;
        if (stream_Control(s, STREAM_GET_CONTENT_TYPE, &res))
            return NULL;
        return res;
    }

    VLC_API stream_t *stream_DemuxNew(demux_t *p_demux, const char *psz_demux, es_out_t *out);

    VLC_API void stream_DemuxSend(stream_t *s, block_t *p_block);

    VLC_API int stream_DemuxControlVa(stream_t *s, int, va_list);

    static inline int stream_DemuxControl(stream_t *s, int query, ...)
    {
        va_list ap;
        int ret;

        va_start(ap, query);
        ret = stream_DemuxControlVa(s, query, ap);
        va_end(ap);
        return ret;
    }

    VLC_API stream_t *stream_MemoryNew(vlc_object_t *p_obj, uint8_t *p_buffer, uint64_t i_size, bool b_preserve_memory);
#define stream_MemoryNew(a, b, c, d) stream_MemoryNew(VLC_OBJECT(a), b, c, d)

    VLC_API stream_t *stream_UrlNew(vlc_object_t *p_this, const char *psz_url);
#define stream_UrlNew(a, b) stream_UrlNew(VLC_OBJECT(a), b)

    VLC_API stream_t *stream_FilterNew(stream_t *p_source, const char *psz_stream_filter);

#ifdef __cplusplus
}
#endif

#endif
