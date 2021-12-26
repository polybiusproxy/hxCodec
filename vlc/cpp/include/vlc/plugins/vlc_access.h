#ifndef VLC_ACCESS_H
#define VLC_ACCESS_H 1

#include <vlc_block.h>

enum access_query_e
{

    ACCESS_CAN_SEEK,
    ACCESS_CAN_FASTSEEK,
    ACCESS_CAN_PAUSE,
    ACCESS_CAN_CONTROL_PACE,

    ACCESS_GET_PTS_DELAY = 0x101,

    ACCESS_GET_TITLE_INFO,

    ACCESS_GET_META,

    ACCESS_GET_CONTENT_TYPE,

    ACCESS_GET_SIGNAL,

    ACCESS_SET_PAUSE_STATE = 0x200,

    ACCESS_SET_TITLE,
    ACCESS_SET_SEEKPOINT,

    ACCESS_SET_PRIVATE_ID_STATE = 0x1000,
    ACCESS_SET_PRIVATE_ID_CA,
    ACCESS_GET_PRIVATE_ID_STATE,
};

struct access_t
{
    VLC_COMMON_MEMBERS

    module_t *p_module;

    char *psz_access;
    char *psz_location;
    char *psz_filepath;

    char *psz_demux;

    ssize_t (*pf_read)(access_t *, uint8_t *, size_t);
    block_t *(*pf_block)(access_t *);

    int (*pf_seek)(access_t *, uint64_t);

    int (*pf_control)(access_t *, int i_query, va_list args);

    struct
    {
        unsigned int i_update;

        uint64_t i_size;
        uint64_t i_pos;
        bool b_eof;

        int i_title;
        int i_seekpoint;
    } info;
    access_sys_t *p_sys;

    input_thread_t *p_input;
};

static inline int access_vaControl(access_t *p_access, int i_query, va_list args)
{
    if (!p_access)
        return VLC_EGENERIC;
    return p_access->pf_control(p_access, i_query, args);
}

static inline int access_Control(access_t *p_access, int i_query, ...)
{
    va_list args;
    int i_result;

    va_start(args, i_query);
    i_result = access_vaControl(p_access, i_query, args);
    va_end(args);
    return i_result;
}

static inline void access_InitFields(access_t *p_a)
{
    p_a->info.i_update = 0;
    p_a->info.i_size = 0;
    p_a->info.i_pos = 0;
    p_a->info.b_eof = false;
    p_a->info.i_title = 0;
    p_a->info.i_seekpoint = 0;
}

VLC_API input_thread_t *access_GetParentInput(access_t *p_access) VLC_USED;

#define ACCESS_SET_CALLBACKS(read, block, control, seek) \
    do                                                   \
    {                                                    \
        p_access->pf_read = (read);                      \
        p_access->pf_block = (block);                    \
        p_access->pf_control = (control);                \
        p_access->pf_seek = (seek);                      \
    } while (0)

#define STANDARD_READ_ACCESS_INIT                                  \
    do                                                             \
    {                                                              \
        access_InitFields(p_access);                               \
        ACCESS_SET_CALLBACKS(Read, NULL, Control, Seek);           \
        p_sys = p_access->p_sys = calloc(1, sizeof(access_sys_t)); \
        if (!p_sys)                                                \
            return VLC_ENOMEM;                                     \
    } while (0);

#define STANDARD_BLOCK_ACCESS_INIT                                 \
    do                                                             \
    {                                                              \
        access_InitFields(p_access);                               \
        ACCESS_SET_CALLBACKS(NULL, Block, Control, Seek);          \
        p_sys = p_access->p_sys = calloc(1, sizeof(access_sys_t)); \
        if (!p_sys)                                                \
            return VLC_ENOMEM;                                     \
    } while (0);

#endif
