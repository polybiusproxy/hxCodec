#ifndef VLC_FS_H
#define VLC_FS_H 1

#include <sys/types.h>
#include <dirent.h>

VLC_API int vlc_open(const char *filename, int flags, ...) VLC_USED;
VLC_API FILE *vlc_fopen(const char *filename, const char *mode) VLC_USED;
VLC_API int vlc_openat(int fd, const char *filename, int flags, ...) VLC_USED;

VLC_API DIR *vlc_opendir(const char *dirname) VLC_USED;
VLC_API char *vlc_readdir(DIR *dir) VLC_USED;
VLC_API int vlc_loaddir(DIR *dir, char ***namelist, int (*select)(const char *), int (*compar)(const char **, const char **));
VLC_API int vlc_scandir(const char *dirname, char ***namelist, int (*select)(const char *), int (*compar)(const char **, const char **));
VLC_API int vlc_mkdir(const char *filename, mode_t mode);

VLC_API int vlc_unlink(const char *filename);
VLC_API int vlc_rename(const char *oldpath, const char *newpath);
VLC_API char *vlc_getcwd(void) VLC_USED;

#if defined(_WIN32)
static inline int vlc_closedir(DIR *dir)
{
    _WDIR *wdir = *(_WDIR **)dir;
    free(dir);
    return wdir ? _wclosedir(wdir) : 0;
}
#undef closedir
#define closedir vlc_closedir

static inline void vlc_rewinddir(DIR *dir)
{
    _WDIR *wdir = *(_WDIR **)dir;

    _wrewinddir(wdir);
}
#undef rewinddir
#define rewinddir vlc_rewinddir

#include <sys/stat.h>
#ifndef stat
#define stat _stati64
#endif
#ifndef fstat
#define fstat _fstati64
#endif
#undef lseek
#define lseek _lseeki64
#endif

#ifdef __ANDROID__
#define lseek lseek64
#endif

struct stat;

VLC_API int vlc_stat(const char *filename, struct stat *buf);
VLC_API int vlc_lstat(const char *filename, struct stat *buf);

VLC_API int vlc_mkstemp(char *);

VLC_API int vlc_dup(int);
VLC_API int vlc_pipe(int[2]);
#endif
