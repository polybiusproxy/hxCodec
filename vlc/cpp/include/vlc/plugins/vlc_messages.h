#ifndef VLC_MESSAGES_H_
#define VLC_MESSAGES_H_

#include <stdarg.h>

enum vlc_log_type
{
    VLC_MSG_INFO = 0,
    VLC_MSG_ERR,
    VLC_MSG_WARN,
    VLC_MSG_DBG,
};

typedef struct vlc_log_t
{
    uintptr_t i_object_id;
    const char *psz_object_type;
    const char *psz_module;
    const char *psz_header;
} vlc_log_t;

VLC_API void vlc_Log(vlc_object_t *, int,
                     const char *, const char *, ...) VLC_FORMAT(4, 5);
VLC_API void vlc_vaLog(vlc_object_t *, int,
                       const char *, const char *, va_list);
#define msg_GenericVa(a, b, c, d, e) vlc_vaLog(VLC_OBJECT(a), b, c, d, e)

#define msg_Info(p_this, ...) \
    vlc_Log(VLC_OBJECT(p_this), VLC_MSG_INFO, MODULE_STRING, __VA_ARGS__)
#define msg_Err(p_this, ...) \
    vlc_Log(VLC_OBJECT(p_this), VLC_MSG_ERR, MODULE_STRING, __VA_ARGS__)
#define msg_Warn(p_this, ...) \
    vlc_Log(VLC_OBJECT(p_this), VLC_MSG_WARN, MODULE_STRING, __VA_ARGS__)
#define msg_Dbg(p_this, ...) \
    vlc_Log(VLC_OBJECT(p_this), VLC_MSG_DBG, MODULE_STRING, __VA_ARGS__)

#endif
