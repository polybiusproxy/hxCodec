#include <errno.h>

#ifdef LIBVLC_USE_PTHREAD

GCRY_THREAD_OPTION_PTHREAD_IMPL;
#define gcry_threads_vlc gcry_threads_pthread
#else

static int gcry_vlc_mutex_init(void **p_sys)
{
    vlc_mutex_t *p_lock = (vlc_mutex_t *)malloc(sizeof(vlc_mutex_t));
    if (p_lock == NULL)
        return ENOMEM;

    vlc_mutex_init(p_lock);
    *p_sys = p_lock;
    return VLC_SUCCESS;
}

static int gcry_vlc_mutex_destroy(void **p_sys)
{
    vlc_mutex_t *p_lock = (vlc_mutex_t *)*p_sys;
    vlc_mutex_destroy(p_lock);
    free(p_lock);
    return VLC_SUCCESS;
}

static int gcry_vlc_mutex_lock(void **p_sys)
{
    vlc_mutex_lock((vlc_mutex_t *)*p_sys);
    return VLC_SUCCESS;
}

static int gcry_vlc_mutex_unlock(void **lock)
{
    vlc_mutex_unlock((vlc_mutex_t *)*lock);
    return VLC_SUCCESS;
}

static const struct gcry_thread_cbs gcry_threads_vlc =
    {
        GCRY_THREAD_OPTION_USER,
        NULL,
        gcry_vlc_mutex_init,
        gcry_vlc_mutex_destroy,
        gcry_vlc_mutex_lock,
        gcry_vlc_mutex_unlock,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL};
#endif

static inline void vlc_gcrypt_init(void)
{

    static bool done = false;

    vlc_global_lock(VLC_GCRYPT_MUTEX);
    if (!done)
    {
        gcry_control(GCRYCTL_SET_THREAD_CBS, &gcry_threads_vlc);
        done = true;
    }
    vlc_global_unlock(VLC_GCRYPT_MUTEX);
}
