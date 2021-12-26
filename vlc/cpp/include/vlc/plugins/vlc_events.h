#ifndef VLC_EVENTS_H
#define VLC_EVENTS_H

#include <vlc_arrays.h>
#include <vlc_meta.h>

struct vlc_event_listeners_group_t;

typedef struct vlc_event_manager_t
{
    void *p_obj;
    vlc_mutex_t object_lock;
    vlc_mutex_t event_sending_lock;
    DECL_ARRAY(struct vlc_event_listeners_group_t *)
    listeners_groups;
} vlc_event_manager_t;

typedef enum vlc_event_type_t
{

    vlc_InputStateChanged,
    vlc_InputSelectedStreamChanged,

    vlc_InputItemMetaChanged,
    vlc_InputItemSubItemAdded,
    vlc_InputItemSubItemTreeAdded,
    vlc_InputItemDurationChanged,
    vlc_InputItemPreparsedChanged,
    vlc_InputItemNameChanged,
    vlc_InputItemInfoChanged,
    vlc_InputItemErrorWhenReadingChanged,

    vlc_ServicesDiscoveryItemAdded,
    vlc_ServicesDiscoveryItemRemoved,
    vlc_ServicesDiscoveryItemRemoveAll,
    vlc_ServicesDiscoveryStarted,
    vlc_ServicesDiscoveryEnded
} vlc_event_type_t;

typedef struct vlc_event_t
{
    vlc_event_type_t type;
    void *p_obj;
    union vlc_event_type_specific
    {

        struct vlc_input_state_changed
        {
            int new_state;
        } input_state_changed;
        struct vlc_input_selected_stream_changed
        {
            void *unused;
        } input_selected_stream_changed;

        struct vlc_input_item_meta_changed
        {
            vlc_meta_type_t meta_type;
        } input_item_meta_changed;
        struct vlc_input_item_subitem_added
        {
            input_item_t *p_new_child;
        } input_item_subitem_added;
        struct vlc_input_item_subitem_tree_added
        {
            input_item_node_t *p_root;
        } input_item_subitem_tree_added;
        struct vlc_input_item_duration_changed
        {
            mtime_t new_duration;
        } input_item_duration_changed;
        struct vlc_input_item_preparsed_changed
        {
            int new_status;
        } input_item_preparsed_changed;
        struct vlc_input_item_name_changed
        {
            const char *new_name;
        } input_item_name_changed;
        struct vlc_input_item_info_changed
        {
            void *unused;
        } input_item_info_changed;
        struct input_item_error_when_reading_changed
        {
            bool new_value;
        } input_item_error_when_reading_changed;

        struct vlc_services_discovery_item_added
        {
            input_item_t *p_new_item;
            const char *psz_category;
        } services_discovery_item_added;
        struct vlc_services_discovery_item_removed
        {
            input_item_t *p_item;
        } services_discovery_item_removed;
        struct vlc_services_discovery_started
        {
            void *unused;
        } services_discovery_started;
        struct vlc_services_discovery_ended
        {
            void *unused;
        } services_discovery_ended;

    } u;
} vlc_event_t;

typedef void (*vlc_event_callback_t)(const vlc_event_t *, void *);

VLC_API int vlc_event_manager_init(vlc_event_manager_t *p_em, void *p_obj);

VLC_API void vlc_event_manager_fini(vlc_event_manager_t *p_em);

VLC_API int vlc_event_manager_register_event_type(vlc_event_manager_t *p_em,
                                                  vlc_event_type_t);

VLC_API void vlc_event_send(vlc_event_manager_t *p_em, vlc_event_t *);

VLC_API int vlc_event_attach(vlc_event_manager_t *p_event_manager,
                             vlc_event_type_t event_type,
                             vlc_event_callback_t pf_callback,
                             void *p_user_data);

VLC_API void vlc_event_detach(vlc_event_manager_t *p_event_manager,
                              vlc_event_type_t event_type,
                              vlc_event_callback_t pf_callback,
                              void *p_user_data);

#endif
