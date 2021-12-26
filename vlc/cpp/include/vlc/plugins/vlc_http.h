#ifndef VLC_HTTP_H
#define VLC_HTTP_H 1

typedef struct http_auth_t
{
  char *psz_realm;
  char *psz_domain;
  char *psz_nonce;
  char *psz_opaque;
  char *psz_stale;
  char *psz_algorithm;
  char *psz_qop;
  int i_nonce;
  char *psz_cnonce;
  char *psz_HA1;
} http_auth_t;

VLC_API void http_auth_Init(http_auth_t *);
VLC_API void http_auth_Reset(http_auth_t *);
VLC_API void http_auth_ParseWwwAuthenticateHeader(vlc_object_t *, http_auth_t *,
                                                  const char *);
VLC_API int http_auth_ParseAuthenticationInfoHeader(vlc_object_t *, http_auth_t *,
                                                    const char *, const char *,
                                                    const char *, const char *,
                                                    const char *);
VLC_API char *http_auth_FormatAuthorizationHeader(vlc_object_t *, http_auth_t *,
                                                  const char *, const char *,
                                                  const char *, const char *) VLC_USED;

#endif
