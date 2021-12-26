#ifndef VLC_MEDIA_LIBRARY_H
#define VLC_MEDIA_LIBRARY_H

#ifdef __cplusplus
extern "C"
{
#endif

#define ML_PERSON_ARTIST "Artist"
#define ML_PERSON_ALBUM_ARTIST "Album Artist"
#define ML_PERSON_ENCODER "Encoder"
#define ML_PERSON_PUBLISHER "Publisher"

    typedef enum
    {
        ML_ALBUM = 1,
        ML_ALBUM_ID,
        ML_ALBUM_COVER,

        ML_ARTIST,
        ML_ARTIST_ID,
        ML_COMMENT,
        ML_COUNT_MEDIA,
        ML_COUNT_ALBUM,
        ML_COUNT_PEOPLE,
        ML_COVER,
        ML_DURATION,
        ML_DISC_NUMBER,
        ML_EXTRA,
        ML_FIRST_PLAYED,
        ML_FILESIZE,
        ML_GENRE,
        ML_ID,
        ML_IMPORT_TIME,
        ML_LANGUAGE,
        ML_LAST_PLAYED,
        ML_LAST_SKIPPED,
        ML_ORIGINAL_TITLE,
        ML_PEOPLE,
        ML_PEOPLE_ID,
        ML_PEOPLE_ROLE,
        ML_PLAYED_COUNT,
        ML_PREVIEW,
        ML_SKIPPED_COUNT,
        ML_SCORE,
        ML_TITLE,
        ML_TRACK_NUMBER,
        ML_TYPE,
        ML_URI,
        ML_VOTE,
        ML_YEAR,
        ML_DIRECTORY,
        ML_MEDIA,
        ML_MEDIA_SPARSE,
        ML_MEDIA_EXTRA,

        ML_LIMIT = -1,
        ML_SORT_DESC = -2,
        ML_SORT_ASC = -3,
        ML_DISTINCT = -4,
        ML_END = -42
    } ml_select_e;

    typedef enum
    {
        ML_UNKNOWN = 0,
        ML_AUDIO = 1 << 0,
        ML_VIDEO = 1 << 1,
        ML_STREAM = 1 << 2,
        ML_NODE = 1 << 3,
        ML_REMOVABLE = 1 << 4,
    } ml_type_e;

    typedef enum
    {
        ML_TYPE_INT,
        ML_TYPE_PSZ,
        ML_TYPE_TIME,
        ML_TYPE_MEDIA,
    } ml_result_type_e;

#ifdef __cplusplus
}
#endif

#endif
