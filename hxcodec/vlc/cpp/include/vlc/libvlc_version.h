#ifndef LIBVLC_VERSION_H
#define LIBVLC_VERSION_H 1

#define LIBVLC_VERSION_MAJOR (@VERSION_MAJOR @)

#define LIBVLC_VERSION_MINOR (@VERSION_MINOR @)

#define LIBVLC_VERSION_REVISION (@VERSION_REVISION @)

#define LIBVLC_VERSION_EXTRA (0)

#define LIBVLC_VERSION(maj, min, rev, extra) \
    ((maj << 24) | (min << 16) | (rev << 8) | (extra))

#define LIBVLC_VERSION_INT                                     \
    LIBVLC_VERSION(LIBVLC_VERSION_MAJOR, LIBVLC_VERSION_MINOR, \
                   LIBVLC_VERSION_REVISION, LIBVLC_VERSION_EXTRA)

#endif
