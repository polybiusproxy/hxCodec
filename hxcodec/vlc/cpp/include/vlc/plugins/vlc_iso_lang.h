struct iso639_lang_t
{
    const char *psz_eng_name;
    const char psz_iso639_1[3];
    const char psz_iso639_2T[4];
    const char psz_iso639_2B[4];
};

#if defined(__cplusplus)
extern "C"
{
#endif
    VLC_API const iso639_lang_t *GetLang_1(const char *);
    VLC_API const iso639_lang_t *GetLang_2T(const char *);
    VLC_API const iso639_lang_t *GetLang_2B(const char *);
#if defined(__cplusplus)
}
#endif
