#ifndef VLC_MEMORY_H
#define VLC_MEMORY_H 1

#include <stdlib.h>

static inline void *realloc_or_free(void *p, size_t sz)
{
    void *n = realloc(p, sz);
    if (!n)
        free(p);
    return n;
}

#endif
