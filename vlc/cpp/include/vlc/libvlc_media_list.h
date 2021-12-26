#ifndef LIBVLC_MEDIA_LIST_H
#define LIBVLC_MEDIA_LIST_H 1

#ifdef __cplusplus
extern "C"
{
#endif

    typedef struct libvlc_media_list_t libvlc_media_list_t;

    LIBVLC_API libvlc_media_list_t *
    libvlc_media_list_new(libvlc_instance_t *p_instance);

    LIBVLC_API void
    libvlc_media_list_release(libvlc_media_list_t *p_ml);

    LIBVLC_API void
    libvlc_media_list_retain(libvlc_media_list_t *p_ml);

    LIBVLC_DEPRECATED int
    libvlc_media_list_add_file_content(libvlc_media_list_t *p_ml,
                                       const char *psz_uri);

    LIBVLC_API void
    libvlc_media_list_set_media(libvlc_media_list_t *p_ml, libvlc_media_t *p_md);

    LIBVLC_API libvlc_media_t *
    libvlc_media_list_media(libvlc_media_list_t *p_ml);

    LIBVLC_API int
    libvlc_media_list_add_media(libvlc_media_list_t *p_ml, libvlc_media_t *p_md);

    LIBVLC_API int
    libvlc_media_list_insert_media(libvlc_media_list_t *p_ml,
                                   libvlc_media_t *p_md, int i_pos);

    LIBVLC_API int
    libvlc_media_list_remove_index(libvlc_media_list_t *p_ml, int i_pos);

    LIBVLC_API int
    libvlc_media_list_count(libvlc_media_list_t *p_ml);

    LIBVLC_API libvlc_media_t *
    libvlc_media_list_item_at_index(libvlc_media_list_t *p_ml, int i_pos);

    LIBVLC_API int
    libvlc_media_list_index_of_item(libvlc_media_list_t *p_ml,
                                    libvlc_media_t *p_md);

    LIBVLC_API int
    libvlc_media_list_is_readonly(libvlc_media_list_t *p_ml);

    LIBVLC_API void
    libvlc_media_list_lock(libvlc_media_list_t *p_ml);

    LIBVLC_API void
    libvlc_media_list_unlock(libvlc_media_list_t *p_ml);

    LIBVLC_API libvlc_event_manager_t *
    libvlc_media_list_event_manager(libvlc_media_list_t *p_ml);

#ifdef __cplusplus
}
#endif

#endif
