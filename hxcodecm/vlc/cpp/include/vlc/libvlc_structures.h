#ifndef LIBVLC_STRUCTURES_H
#define LIBVLC_STRUCTURES_H 1

#include <stdint.h>

#ifdef __cplusplus
extern "C"
{
#endif

    typedef struct libvlc_instance_t libvlc_instance_t;

    typedef int64_t libvlc_time_t;

    typedef struct libvlc_log_iterator_t libvlc_log_iterator_t;

    typedef struct libvlc_log_message_t
    {
        int i_severity;
        const char *psz_type;
        const char *psz_name;
        const char *psz_header;
        const char *psz_message;
    } libvlc_log_message_t;

#ifdef __cplusplus
}
#endif

#endif
