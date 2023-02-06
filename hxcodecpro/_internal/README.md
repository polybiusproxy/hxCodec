# _internal

The LibVLC classes contain externs to all the functions of LibVLC (4.0.0-dev).

# Split functions into classes, one for each "namespace"
- [-] https://videolan.videolan.me/vlc/group__libvlc__audio.html
- [X] https://videolan.videolan.me/vlc/group__libvlc__core.html
- [ ] https://videolan.videolan.me/vlc/group__libvlc__dialog.html
- [X] https://videolan.videolan.me/vlc/group__libvlc__error.html
- [X] https://videolan.videolan.me/vlc/group__libvlc__event.html
- [ ] https://videolan.videolan.me/vlc/group__libvlc__log.html
- [-] https://videolan.videolan.me/vlc/group__libvlc__media.html
- [ ] https://videolan.videolan.me/vlc/group__libvlc__media__discoverer.html
- [ ] https://videolan.videolan.me/vlc/group__libvlc__media__list.html
- [ ] https://videolan.videolan.me/vlc/group__libvlc__media__list__player.html
- [-] https://videolan.videolan.me/vlc/group__libvlc__media__player.html
- [ ] https://videolan.videolan.me/vlc/group__libvlc__media__track.html
- [X] https://videolan.videolan.me/vlc/group__libvlc__clock.html
- [-] https://videolan.videolan.me/vlc/group__libvlc__video.html
- [ ] https://videolan.videolan.me/vlc/group__libvlc__media__player__watch__time.html
- [ ] https://videolan.videolan.me/vlc/group__libvlc__renderer__discoverer.html

## Migration Notes
- libVLC 2 to 3: https://github.com/videolan/vlc/blob/74e133ae0908b3cdf36a149d7cd5e247437220d1/include/vlc/deprecated.h
- libVLC 3 to 4: https://github.com/videolan/vlc/blob/master/include/vlc/deprecated.h
- https://videolan.videolan.me/vlc-3.0/deprecated.html
- https://github.com/caprica/vlcj/issues/681

- `libvlc_media_parse`: This function could block indefinitely.
    - Replaced with `libvlc_media_parse_with_options()`, which was later renamed to `libvlc_media_parse_request()` later.
    - `libvlc_media_parse_request()` is asynchronous, and an event marks whether it is complete.
- `libvlc_MediaPlayerEndReached`: Renamed to `libvlc_MediaPlayerStopping`
- `libvlc_media_player_get_fps`: This function could crash if the codec didn't explicitly define the frame rate.
    - Docs say to consider using `libvlc_media_tracks_get()` but that is also deprecated.
- `libvlc_media_tracks_get`: Tracks API was replaced with a different one in LibVLC 4.0
    - https://github.com/videolan/vlc/commit/6f4685bedb03c81b32ac8a49873d704a5983bfab