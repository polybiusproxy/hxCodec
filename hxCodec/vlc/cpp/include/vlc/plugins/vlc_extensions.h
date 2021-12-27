#ifndef VLC_EXTENSIONS_H
#define VLC_EXTENSIONS_H

#include "vlc_common.h"
#include "vlc_arrays.h"

typedef struct extensions_manager_sys_t extensions_manager_sys_t;
typedef struct extensions_manager_t extensions_manager_t;
typedef struct extension_sys_t extension_sys_t;

typedef struct extension_t
{

    char *psz_name;

    char *psz_title;
    char *psz_author;
    char *psz_version;
    char *psz_url;
    char *psz_description;
    char *psz_shortdescription;
    char *p_icondata;
    int i_icondata_size;

    extension_sys_t *p_sys;
} extension_t;

struct extensions_manager_t
{
    VLC_COMMON_MEMBERS

    module_t *p_module;
    extensions_manager_sys_t *p_sys;

    DECL_ARRAY(extension_t *)
    extensions;
    vlc_mutex_t lock;

    int (*pf_control)(extensions_manager_t *, int, va_list);
};

enum
{

    EXTENSION_ACTIVATE,
    EXTENSION_DEACTIVATE,
    EXTENSION_IS_ACTIVATED,
    EXTENSION_HAS_MENU,
    EXTENSION_GET_MENU,
    EXTENSION_TRIGGER_ONLY,
    EXTENSION_TRIGGER,
    EXTENSION_TRIGGER_MENU,
    EXTENSION_SET_INPUT,
    EXTENSION_PLAYING_CHANGED,
    EXTENSION_META_CHANGED,
};

static inline int extension_Control(extensions_manager_t *p_mgr,
                                    int i_control, ...)
{
    va_list args;
    va_start(args, i_control);
    int i_ret = p_mgr->pf_control(p_mgr, i_control, args);
    va_end(args);
    return i_ret;
}

static inline bool __extension_GetBool(extensions_manager_t *p_mgr,
                                       extension_t *p_ext,
                                       int i_flag,
                                       bool b_default)
{
    bool b = b_default;
    int i_ret = extension_Control(p_mgr, i_flag, p_ext, &b);
    if (i_ret != VLC_SUCCESS)
        return b_default;
    else
        return b;
}

#define extension_Activate(mgr, ext) \
    extension_Control(mgr, EXTENSION_ACTIVATE, ext)

#define extension_Trigger(mgr, ext) \
    extension_Control(mgr, EXTENSION_TRIGGER, ext)

#define extension_Deactivate(mgr, ext) \
    extension_Control(mgr, EXTENSION_DEACTIVATE, ext)

#define extension_IsActivated(mgr, ext) \
    __extension_GetBool(mgr, ext, EXTENSION_IS_ACTIVATED, false)

#define extension_HasMenu(mgr, ext) \
    __extension_GetBool(mgr, ext, EXTENSION_HAS_MENU, false)

static inline int extension_GetMenu(extensions_manager_t *p_mgr,
                                    extension_t *p_ext,
                                    char ***pppsz,
                                    uint16_t **ppi)
{
    return extension_Control(p_mgr, EXTENSION_GET_MENU, p_ext, pppsz, ppi);
}

static inline int extension_TriggerMenu(extensions_manager_t *p_mgr,
                                        extension_t *p_ext,
                                        uint16_t i)
{
    return extension_Control(p_mgr, EXTENSION_TRIGGER_MENU, p_ext, i);
}

static inline int extension_SetInput(extensions_manager_t *p_mgr,
                                     extension_t *p_ext,
                                     struct input_thread_t *p_input)
{
    return extension_Control(p_mgr, EXTENSION_SET_INPUT, p_ext, p_input);
}

static inline int extension_PlayingChanged(extensions_manager_t *p_mgr,
                                           extension_t *p_ext,
                                           int state)
{
    return extension_Control(p_mgr, EXTENSION_PLAYING_CHANGED, p_ext, state);
}

static inline int extension_MetaChanged(extensions_manager_t *p_mgr,
                                        extension_t *p_ext)
{
    return extension_Control(p_mgr, EXTENSION_META_CHANGED, p_ext);
}

#define extension_TriggerOnly(mgr, ext) \
    __extension_GetBool(mgr, ext, EXTENSION_TRIGGER_ONLY, false)

typedef struct extension_dialog_t extension_dialog_t;
typedef struct extension_widget_t extension_widget_t;

typedef enum
{
    EXTENSION_EVENT_CLICK,
    EXTENSION_EVENT_CLOSE,
} extension_dialog_event_e;

typedef struct
{
    extension_dialog_t *p_dlg;
    extension_dialog_event_e event;
    void *p_data;
} extension_dialog_command_t;

struct extension_dialog_t
{
    vlc_object_t *p_object;

    char *psz_title;
    int i_width;
    int i_height;

    DECL_ARRAY(extension_widget_t *)
    widgets;

    bool b_hide;
    bool b_kill;

    void *p_sys;
    void *p_sys_intf;
    vlc_mutex_t lock;
    vlc_cond_t cond;
};

static inline int extension_DialogCommand(extension_dialog_t *p_dialog,
                                          extension_dialog_event_e event,
                                          void *data)
{
    extension_dialog_command_t command;
    command.p_dlg = p_dialog;
    command.event = event;
    command.p_data = data;
    var_SetAddress(p_dialog->p_object, "dialog-event", &command);
    return VLC_SUCCESS;
}

#define extension_DialogClosed(dlg) \
    extension_DialogCommand(dlg, EXTENSION_EVENT_CLOSE, NULL)

#define extension_WidgetClicked(dlg, wdg) \
    extension_DialogCommand(dlg, EXTENSION_EVENT_CLICK, wdg)

typedef enum
{
    EXTENSION_WIDGET_LABEL,
    EXTENSION_WIDGET_BUTTON,
    EXTENSION_WIDGET_IMAGE,
    EXTENSION_WIDGET_HTML,
    EXTENSION_WIDGET_TEXT_FIELD,
    EXTENSION_WIDGET_PASSWORD,
    EXTENSION_WIDGET_DROPDOWN,
    EXTENSION_WIDGET_LIST,
    EXTENSION_WIDGET_CHECK_BOX,
    EXTENSION_WIDGET_SPIN_ICON,
} extension_widget_type_e;

struct extension_widget_t
{

    extension_widget_type_e type;
    char *psz_text;

    struct extension_widget_value_t
    {
        int i_id;

        char *psz_text;
        bool b_selected;
        struct extension_widget_value_t *p_next;
    } * p_values;

    bool b_checked;

    int i_row;
    int i_column;
    int i_horiz_span;
    int i_vert_span;
    int i_width;
    int i_height;
    bool b_hide;

    int i_spin_loops;

    bool b_kill;
    bool b_update;

    void *p_sys;
    void *p_sys_intf;

    extension_dialog_t *p_dialog;
};

VLC_API int dialog_ExtensionUpdate(vlc_object_t *, extension_dialog_t *);
#define dialog_ExtensionUpdate(o, d) dialog_ExtensionUpdate(VLC_OBJECT(o), d)

#endif
