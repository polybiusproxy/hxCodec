#ifndef VLC_INTF_H_
#define VLC_INTF_H_

#ifdef __cplusplus
extern "C"
{
#endif

    typedef struct intf_dialog_args_t intf_dialog_args_t;

    typedef struct intf_sys_t intf_sys_t;

    typedef struct intf_thread_t
    {
        VLC_COMMON_MEMBERS

        struct intf_thread_t *p_next;

        intf_sys_t *p_sys;

        module_t *p_module;

        void (*pf_show_dialog)(struct intf_thread_t *, int, int,
                               intf_dialog_args_t *);

        config_chain_t *p_cfg;
    } intf_thread_t;

    struct intf_dialog_args_t
    {
        intf_thread_t *p_intf;
        char *psz_title;

        char **psz_results;
        int i_results;

        void (*pf_callback)(intf_dialog_args_t *);
        void *p_arg;

        char *psz_extensions;
        bool b_save;
        bool b_multiple;

        struct interaction_dialog_t *p_dialog;
    };

    VLC_API int intf_Create(vlc_object_t *, const char *);
#define intf_Create(a, b) intf_Create(VLC_OBJECT(a), b)

    VLC_API void libvlc_Quit(libvlc_int_t *);

    typedef void (*vlc_log_cb)(void *data, int type, const vlc_log_t *item,
                               const char *fmt, va_list args);

    VLC_API void vlc_LogSet(libvlc_int_t *, vlc_log_cb cb, void *data);

    typedef struct msg_subscription
    {
    } msg_subscription_t;
#define vlc_Subscribe(sub, cb, data) ((sub), (cb), (data))
#define vlc_Unsubscribe(sub) ((void)(sub))

#if defined(_WIN32) && !VLC_WINSTORE_APP
#define CONSOLE_INTRO_MSG                                                \
    if (!getenv("PWD"))                                                  \
    {                                                                    \
        AllocConsole();                                                  \
        freopen("CONOUT$", "w", stdout);                                 \
        freopen("CONOUT$", "w", stderr);                                 \
        freopen("CONIN$", "r", stdin);                                   \
    }                                                                    \
    msg_Info(p_intf, "VLC media player - %s", VERSION_MESSAGE);          \
    msg_Info(p_intf, "%s", COPYRIGHT_MESSAGE);                           \
    msg_Info(p_intf, _("\nWarning: if you cannot access the GUI "        \
                       "anymore, open a command-line window, go to the " \
                       "directory where you installed VLC and run "      \
                       "\"vlc -I qt\"\n"))
#else
#define CONSOLE_INTRO_MSG (void)0
#endif

    typedef enum vlc_dialog
    {
        INTF_DIALOG_FILE_SIMPLE = 1,
        INTF_DIALOG_FILE,
        INTF_DIALOG_DISC,
        INTF_DIALOG_NET,
        INTF_DIALOG_CAPTURE,
        INTF_DIALOG_SAT,
        INTF_DIALOG_DIRECTORY,

        INTF_DIALOG_STREAMWIZARD,
        INTF_DIALOG_WIZARD,

        INTF_DIALOG_PLAYLIST,
        INTF_DIALOG_MESSAGES,
        INTF_DIALOG_FILEINFO,
        INTF_DIALOG_PREFS,
        INTF_DIALOG_BOOKMARKS,
        INTF_DIALOG_EXTENDED,

        INTF_DIALOG_POPUPMENU = 20,
        INTF_DIALOG_AUDIOPOPUPMENU,
        INTF_DIALOG_VIDEOPOPUPMENU,
        INTF_DIALOG_MISCPOPUPMENU,

        INTF_DIALOG_FILE_GENERIC = 30,
        INTF_DIALOG_INTERACTION = 50,

        INTF_DIALOG_UPDATEVLC = 90,
        INTF_DIALOG_VLM,

        INTF_DIALOG_EXIT = 99
    } vlc_dialog_t;

#define INTF_ABOUT_MSG LICENSE_MSG

#define EXTENSIONS_AUDIO_CSV "3ga", "669", "a52", "aac", "ac3", "adt", "adts", "aif", "aifc", "aiff",             \
                             "amr", "aob", "ape", "awb", "caf", "dts", "flac", "it", "kar",                       \
                             "m4a", "m4p", "m5p", "mka", "mlp", "mod", "mpa", "mp1", "mp2", "mp3", "mpc", "mpga", \
                             "oga", "ogg", "oma", "opus", "qcp", "ra", "rmi", "s3m", "spx", "thd", "tta",         \
                             "voc", "vqf", "w64", "wav", "wma", "wv", "xa", "xm"

#define EXTENSIONS_VIDEO_CSV "3g2", "3gp", "3gp2", "3gpp", "amv", "asf", "avi", "divx", "drc", "dv",    \
                             "f4v", "flv", "gvi", "gxf", "iso",                                         \
                             "m1v", "m2v", "m2t", "m2ts", "m4v", "mkv", "mov",                          \
                             "mp2", "mp2v", "mp4", "mp4v", "mpe", "mpeg", "mpeg1",                      \
                             "mpeg2", "mpeg4", "mpg", "mpv2", "mts", "mtv", "mxf", "mxg", "nsv", "nuv", \
                             "ogg", "ogm", "ogv", "ogx", "ps",                                          \
                             "rec", "rm", "rmvb", "tod", "ts", "tts", "vob", "vro",                     \
                             "webm", "wm", "wmv", "wtv", "xesc"

#define EXTENSIONS_AUDIO \
    "*.3ga;"             \
    "*.669;"             \
    "*.a52;"             \
    "*.aac;"             \
    "*.ac3;"             \
    "*.adt;"             \
    "*.adts;"            \
    "*.aif;"             \
    "*.aifc;"            \
    "*.aiff;"            \
    "*.amr;"             \
    "*.aob;"             \
    "*.ape;"             \
    "*.awb;"             \
    "*.caf;"             \
    "*.dts;"             \
    "*.flac;"            \
    "*.it;"              \
    "*.kar;"             \
    "*.m4a;"             \
    "*.m4p;"             \
    "*.m5p;"             \
    "*.mid;"             \
    "*.mka;"             \
    "*.mlp;"             \
    "*.mod;"             \
    "*.mpa;"             \
    "*.mp1;"             \
    "*.mp2;"             \
    "*.mp3;"             \
    "*.mpc;"             \
    "*.mpga;"            \
    "*.oga;"             \
    "*.ogg;"             \
    "*.oma;"             \
    "*.opus;"            \
    "*.qcp;"             \
    "*.ra;"              \
    "*.rmi;"             \
    "*.s3m;"             \
    "*.spx;"             \
    "*.thd;"             \
    "*.tta;"             \
    "*.voc;"             \
    "*.vqf;"             \
    "*.w64;"             \
    "*.wav;"             \
    "*.wma;"             \
    "*.wv;"              \
    "*.xa;"              \
    "*.xm"

#define EXTENSIONS_VIDEO "*.3g2;*.3gp;*.3gp2;*.3gpp;*.amv;*.asf;*.avi;*.bin;*.divx;*.drc;*.dv;*f4v;*.flv;*.gvi;*.gxf;*.iso;*.m1v;*.m2v;" \
                         "*.m2t;*.m2ts;*.m4v;*.mkv;*.mov;*.mp2;*.mp2v;*.mp4;*.mp4v;*.mpe;*.mpeg;*.mpeg1;"                                \
                         "*.mpeg2;*.mpeg4;*.mpg;*.mpv2;*.mts;*.mtv;*.mxf;*.mxg;*.nsv;*.nuv;"                                             \
                         "*.ogg;*.ogm;*.ogv;*.ogx;*.ps;"                                                                                 \
                         "*.rec;*.rm;*.rmvb;*.tod;*.ts;*.tts;*.vob;*.vro;*.webm;*.wm;*.wmv;*.wtv;*.xesc"

#define EXTENSIONS_PLAYLIST "*.asx;*.b4s;*.cue;*.ifo;*.m3u;*.m3u8;*.pls;*.ram;*.rar;*.sdp;*.vlc;*.xspf;*.wvx;*.zip;*.conf"

#define EXTENSIONS_MEDIA EXTENSIONS_VIDEO ";" EXTENSIONS_AUDIO ";" EXTENSIONS_PLAYLIST

#define EXTENSIONS_SUBTITLE "*.cdg;*.idx;*.srt;"  \
                            "*.sub;*.utf;*.ass;"  \
                            "*.ssa;*.aqt;"        \
                            "*.jss;*.psb;"        \
                            "*.rt;*.smi;*.txt;"   \
                            "*.smil;*.stl;*.usf;" \
                            "*.dks;*.pjs;*.mpl2;*.mks"

    typedef struct interaction_dialog_t
    {
        int i_type;
        char *psz_title;
        char *psz_description;
        char *psz_default_button;
        char *psz_alternate_button;

        char *psz_other_button;

        char *psz_returned[1];

        vlc_value_t val;
        int i_timeToGo;
        bool b_cancelled;

        void *p_private;

        int i_status;
        int i_action;
        int i_flags;
        int i_return;

        vlc_object_t *p_parent;

        intf_thread_t *p_interface;
        vlc_mutex_t *p_lock;
    } interaction_dialog_t;

#define DIALOG_GOT_ANSWER 0x01
#define DIALOG_YES_NO_CANCEL 0x02
#define DIALOG_LOGIN_PW_OK_CANCEL 0x04
#define DIALOG_PSZ_INPUT_OK_CANCEL 0x08
#define DIALOG_BLOCKING_ERROR 0x10
#define DIALOG_NONBLOCKING_ERROR 0x20
#define DIALOG_USER_PROGRESS 0x80
#define DIALOG_INTF_PROGRESS 0x100

    enum
    {
        DIALOG_OK_YES,
        DIALOG_NO,
        DIALOG_CANCELLED
    };

    enum
    {
        ANSWERED_DIALOG,
        DESTROYED_DIALOG,
    };

    enum
    {
        INTERACT_NEW,
        INTERACT_UPDATE,
        INTERACT_HIDE,
        INTERACT_DESTROY
    };

#define intf_UserStringInput(a, b, c, d) (VLC_OBJECT(a), b, c, d, VLC_EGENERIC)
#define interaction_Register(t) (t, VLC_EGENERIC)
#define interaction_Unregister(t) (t, VLC_EGENERIC)

#ifdef __cplusplus
}
#endif
#endif
