#ifndef VLC_LIBVLC_H
#define VLC_LIBVLC_H 1

#if defined(_WIN32) && defined(DLL_EXPORT)
#define LIBVLC_API __declspec(dllexport)
#elif defined(__GNUC__) && (__GNUC__ >= 4)
#define LIBVLC_API __attribute__((visibility("default")))
#else
#define LIBVLC_API
#endif

#ifdef __LIBVLC__

#define LIBVLC_DEPRECATED
#elif defined(__GNUC__) && \
    (__GNUC__ > 3 || __GNUC__ == 3 && __GNUC_MINOR__ > 0)
#define LIBVLC_DEPRECATED __attribute__((deprecated))
#else
#define LIBVLC_DEPRECATED
#endif

#include <stdio.h>
#include <stdarg.h>

#ifdef __cplusplus
extern "C"
{
#endif

#include <vlc/libvlc_structures.h>

    LIBVLC_API const char *libvlc_errmsg(void);

    LIBVLC_API void libvlc_clearerr(void);

    LIBVLC_API const char *libvlc_vprinterr(const char *fmt, va_list ap);

    LIBVLC_API const char *libvlc_printerr(const char *fmt, ...);

    LIBVLC_API libvlc_instance_t *
    libvlc_new(int argc, const char *const *argv);

    LIBVLC_API void libvlc_release(libvlc_instance_t *p_instance);

    LIBVLC_API void libvlc_retain(libvlc_instance_t *p_instance);

    LIBVLC_API
    int libvlc_add_intf(libvlc_instance_t *p_instance, const char *name);

    LIBVLC_API
    void libvlc_set_exit_handler(libvlc_instance_t *p_instance,
                                 void (*cb)(void *), void *opaque);

    LIBVLC_DEPRECATED LIBVLC_API void libvlc_wait(libvlc_instance_t *p_instance);

    LIBVLC_API
    void libvlc_set_user_agent(libvlc_instance_t *p_instance,
                               const char *name, const char *http);

    LIBVLC_API
    void libvlc_set_app_id(libvlc_instance_t *p_instance, const char *id,
                           const char *version, const char *icon);

    LIBVLC_API const char *libvlc_get_version(void);

    LIBVLC_API const char *libvlc_get_compiler(void);

    LIBVLC_API const char *libvlc_get_changeset(void);

    LIBVLC_API void libvlc_free(void *ptr);

    typedef struct libvlc_event_manager_t libvlc_event_manager_t;

    struct libvlc_event_t;

    typedef int libvlc_event_type_t;

    typedef void (*libvlc_callback_t)(const struct libvlc_event_t *, void *);

    LIBVLC_API int libvlc_event_attach(libvlc_event_manager_t *p_event_manager,
                                       libvlc_event_type_t i_event_type,
                                       libvlc_callback_t f_callback,
                                       void *user_data);

    LIBVLC_API void libvlc_event_detach(libvlc_event_manager_t *p_event_manager,
                                        libvlc_event_type_t i_event_type,
                                        libvlc_callback_t f_callback,
                                        void *p_user_data);

    LIBVLC_API const char *libvlc_event_type_name(libvlc_event_type_t event_type);

    enum libvlc_log_level
    {
        LIBVLC_DEBUG = 0,
        LIBVLC_NOTICE = 2,
        LIBVLC_WARNING = 3,
        LIBVLC_ERROR = 4
    };

    typedef struct vlc_log_t libvlc_log_t;

    LIBVLC_API void libvlc_log_get_context(const libvlc_log_t *ctx,
                                           const char **module, const char **file, unsigned *line);

    LIBVLC_API void libvlc_log_get_object(const libvlc_log_t *ctx,
                                          const char **name, const char **header, uintptr_t *id);

    typedef void (*libvlc_log_cb)(void *data, int level, const libvlc_log_t *ctx,
                                  const char *fmt, va_list args);

    LIBVLC_API void libvlc_log_unset(libvlc_instance_t *);

    LIBVLC_API void libvlc_log_set(libvlc_instance_t *,
                                   libvlc_log_cb cb, void *data);

    LIBVLC_API void libvlc_log_set_file(libvlc_instance_t *, FILE *stream);

    LIBVLC_DEPRECATED LIBVLC_API unsigned libvlc_get_log_verbosity(const libvlc_instance_t *p_instance);

    LIBVLC_DEPRECATED LIBVLC_API void libvlc_set_log_verbosity(libvlc_instance_t *p_instance, unsigned level);

    LIBVLC_DEPRECATED LIBVLC_API
        libvlc_log_t *
        libvlc_log_open(libvlc_instance_t *p_instance);

    LIBVLC_DEPRECATED LIBVLC_API void libvlc_log_close(libvlc_log_t *p_log);

    LIBVLC_DEPRECATED LIBVLC_API unsigned libvlc_log_count(const libvlc_log_t *p_log);

    LIBVLC_DEPRECATED LIBVLC_API void libvlc_log_clear(libvlc_log_t *p_log);

    LIBVLC_DEPRECATED LIBVLC_API
        libvlc_log_iterator_t *
        libvlc_log_get_iterator(const libvlc_log_t *p_log);

    LIBVLC_DEPRECATED LIBVLC_API void libvlc_log_iterator_free(libvlc_log_iterator_t *p_iter);

    LIBVLC_DEPRECATED LIBVLC_API int libvlc_log_iterator_has_next(const libvlc_log_iterator_t *p_iter);

    LIBVLC_DEPRECATED LIBVLC_API
        libvlc_log_message_t *
        libvlc_log_iterator_next(libvlc_log_iterator_t *p_iter,
                                 libvlc_log_message_t *p_buf);

    typedef struct libvlc_module_description_t
    {
        char *psz_name;
        char *psz_shortname;
        char *psz_longname;
        char *psz_help;
        struct libvlc_module_description_t *p_next;
    } libvlc_module_description_t;

    LIBVLC_API
    void libvlc_module_description_list_release(libvlc_module_description_t *p_list);

    LIBVLC_API
    libvlc_module_description_t *libvlc_audio_filter_list_get(libvlc_instance_t *p_instance);

    LIBVLC_API
    libvlc_module_description_t *libvlc_video_filter_list_get(libvlc_instance_t *p_instance);

    LIBVLC_API
    int64_t libvlc_clock(void);

    static inline int64_t libvlc_delay(int64_t pts)
    {
        return pts - libvlc_clock();
    }

#ifdef __cplusplus
}
#endif

#endif
