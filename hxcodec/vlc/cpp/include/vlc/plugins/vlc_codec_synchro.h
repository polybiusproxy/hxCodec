#define I_CODING_TYPE 1
#define P_CODING_TYPE 2
#define B_CODING_TYPE 3
#define D_CODING_TYPE 4

VLC_API decoder_synchro_t *decoder_SynchroInit(decoder_t *, int) VLC_USED;
VLC_API void decoder_SynchroRelease(decoder_synchro_t *);
VLC_API void decoder_SynchroReset(decoder_synchro_t *);
VLC_API bool decoder_SynchroChoose(decoder_synchro_t *, int, int, bool);
VLC_API void decoder_SynchroTrash(decoder_synchro_t *);
VLC_API void decoder_SynchroDecode(decoder_synchro_t *);
VLC_API void decoder_SynchroEnd(decoder_synchro_t *, int, bool);
VLC_API mtime_t decoder_SynchroDate(decoder_synchro_t *) VLC_USED;
VLC_API void decoder_SynchroNewPicture(decoder_synchro_t *, int, int, mtime_t, mtime_t, bool);
