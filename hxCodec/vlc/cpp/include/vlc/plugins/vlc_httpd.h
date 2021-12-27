#ifndef VLC_HTTPD_H
#define VLC_HTTPD_H 1

enum
{
    HTTPD_MSG_NONE,

    HTTPD_MSG_ANSWER,

    HTTPD_MSG_GET,
    HTTPD_MSG_HEAD,
    HTTPD_MSG_POST,

    HTTPD_MSG_OPTIONS,
    HTTPD_MSG_DESCRIBE,
    HTTPD_MSG_SETUP,
    HTTPD_MSG_PLAY,
    HTTPD_MSG_PAUSE,
    HTTPD_MSG_GETPARAMETER,
    HTTPD_MSG_TEARDOWN,

    HTTPD_MSG_MAX
};

enum
{
    HTTPD_PROTO_NONE,
    HTTPD_PROTO_HTTP,
    HTTPD_PROTO_RTSP,
    HTTPD_PROTO_HTTP0,
};

typedef struct httpd_host_t httpd_host_t;
typedef struct httpd_client_t httpd_client_t;

VLC_API httpd_host_t *vlc_http_HostNew(vlc_object_t *) VLC_USED;
VLC_API httpd_host_t *vlc_https_HostNew(vlc_object_t *) VLC_USED;
VLC_API httpd_host_t *vlc_rtsp_HostNew(vlc_object_t *) VLC_USED;

VLC_API void httpd_HostDelete(httpd_host_t *);

typedef struct httpd_message_t
{
    httpd_client_t *cl;

    uint8_t i_type;
    uint8_t i_proto;
    uint8_t i_version;

    int i_status;

    char *psz_url;

    uint8_t *psz_args;

    int i_name;
    char **name;
    int i_value;
    char **value;

    int64_t i_body_offset;
    int i_body;
    uint8_t *p_body;

} httpd_message_t;

typedef struct httpd_url_t httpd_url_t;
typedef struct httpd_callback_sys_t httpd_callback_sys_t;
typedef int (*httpd_callback_t)(httpd_callback_sys_t *, httpd_client_t *, httpd_message_t *answer, const httpd_message_t *query);

VLC_API httpd_url_t *httpd_UrlNew(httpd_host_t *, const char *psz_url, const char *psz_user, const char *psz_password) VLC_USED;

VLC_API int httpd_UrlCatch(httpd_url_t *, int i_msg, httpd_callback_t, httpd_callback_sys_t *);

VLC_API void httpd_UrlDelete(httpd_url_t *);

VLC_API char *httpd_ClientIP(const httpd_client_t *cl, char *, int *);
VLC_API char *httpd_ServerIP(const httpd_client_t *cl, char *, int *);

typedef struct httpd_file_t httpd_file_t;
typedef struct httpd_file_sys_t httpd_file_sys_t;
typedef int (*httpd_file_callback_t)(httpd_file_sys_t *, httpd_file_t *, uint8_t *psz_request, uint8_t **pp_data, int *pi_data);
VLC_API httpd_file_t *httpd_FileNew(httpd_host_t *, const char *psz_url, const char *psz_mime, const char *psz_user, const char *psz_password, httpd_file_callback_t pf_fill, httpd_file_sys_t *) VLC_USED;
VLC_API httpd_file_sys_t *httpd_FileDelete(httpd_file_t *);

typedef struct httpd_handler_t httpd_handler_t;
typedef struct httpd_handler_sys_t httpd_handler_sys_t;
typedef int (*httpd_handler_callback_t)(httpd_handler_sys_t *, httpd_handler_t *, char *psz_url, uint8_t *psz_request, int i_type, uint8_t *p_in, int i_in, char *psz_remote_addr, char *psz_remote_host, uint8_t **pp_data, int *pi_data);
VLC_API httpd_handler_t *httpd_HandlerNew(httpd_host_t *, const char *psz_url, const char *psz_user, const char *psz_password, httpd_handler_callback_t pf_fill, httpd_handler_sys_t *) VLC_USED;
VLC_API httpd_handler_sys_t *httpd_HandlerDelete(httpd_handler_t *);

typedef struct httpd_redirect_t httpd_redirect_t;
VLC_API httpd_redirect_t *httpd_RedirectNew(httpd_host_t *, const char *psz_url_dst, const char *psz_url_src) VLC_USED;
VLC_API void httpd_RedirectDelete(httpd_redirect_t *);

typedef struct httpd_stream_t httpd_stream_t;
VLC_API httpd_stream_t *httpd_StreamNew(httpd_host_t *, const char *psz_url, const char *psz_mime, const char *psz_user, const char *psz_password) VLC_USED;
VLC_API void httpd_StreamDelete(httpd_stream_t *);
VLC_API int httpd_StreamHeader(httpd_stream_t *, uint8_t *p_data, int i_data);
VLC_API int httpd_StreamSend(httpd_stream_t *, uint8_t *p_data, int i_data);

VLC_API void httpd_MsgAdd(httpd_message_t *, const char *psz_name, const char *psz_value, ...) VLC_FORMAT(3, 4);

VLC_API const char *httpd_MsgGet(const httpd_message_t *, const char *psz_name);

#endif
