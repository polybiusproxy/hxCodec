#ifndef VLC_INTF_STRINGS_H
#define VLC_INTF_STRINGS_H 1

#if defined(_WIN32) || defined(__APPLE__)
#define I_DIR_OR_FOLDER(dir, folder) folder
#else
#define I_DIR_OR_FOLDER(dir, folder) dir
#endif

#define I_OP_OPF N_("&Open File...")
#define I_OP_ADVOP N_("&Advanced Open...")
#define I_OP_OPDIR I_DIR_OR_FOLDER(N_("Open D&irectory..."), \
                                   N_("Open &Folder..."))
#define I_OP_SEL_FILES N_("Select one or more files to open")
#define I_OP_SEL_DIR I_DIR_OR_FOLDER(N_("Select Directory"), N_("Select Folder"))

#define I_MENU_INFO N_("Media &Information")
#define I_MENU_CODECINFO N_("&Codec Information")
#define I_MENU_MSG N_("&Messages")
#define I_MENU_GOTOTIME N_("Jump to Specific &Time")
#define I_MENU_BOOKMARK N_("Custom &Bookmarks")
#define I_MENU_VLM N_("&VLM Configuration")

#define I_MENU_ABOUT N_("&About")

#define I_POP_PLAY N_("Play")
#define I_POP_DEL N_("Remove Selected")
#define I_POP_INFO N_("Information...")
#define I_POP_NEWFOLDER I_DIR_OR_FOLDER(N_("Create Directory..."), \
                                        N_("Create Folder..."))
#define I_POP_EXPLORE I_DIR_OR_FOLDER(N_("Show Containing Directory..."), \
                                      N_("Show Containing Folder..."))
#define I_POP_STREAM N_("Stream...")
#define I_POP_SAVE N_("Save...")

#define I_PL_LOOP N_("Repeat All")
#define I_PL_REPEAT N_("Repeat One")
#define I_PL_RANDOM N_("Random")
#define I_PL_NORANDOM N_("Random Off")
#define I_PL_ADDPL N_("Add to Playlist")

#define I_PL_ADDF N_("Add File...")
#define I_PL_ADDDIR I_DIR_OR_FOLDER(N_("Add Directory..."), \
                                    N_("Add Folder..."))

#define I_PL_SAVE N_("Save Playlist to &File...")

#define I_PL_SEARCH N_("Search")

#define I_WAVE N_("Waves")
#define I_LONGHELP N_("<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /></head><body>" \
    "<h2>Welcome to VLC media player Help</h2>" \
        "<h3>Documentation</h3>" \
            "<p>You can find VLC documentation on VideoLAN's <a href=\"http:
            "<p>If you are a newcomer to VLC media player, please read the<br><a href=\"http:
            "<p>You will find some information on how to use the player in the <br>\"<a href=\"http:
            "<p>For all the saving, converting, transcoding, encoding, muxing and streaming tasks, you should find useful information in the <a href=\"http:
            "<p>If you are unsure about terminology, please consult the <a href=\"http:
            "<p>To understand the main keyboard shortcuts, read the <a href=\"http:
        "<h3>Help</h3>" \
            "<p>Before asking any question, please refer yourself to the <a href=\"http:
            "<p>You might then get (and give) help on the <a href=\"http:
        "<h3>Contribute to the project</h3>" \
            "<p>You can help the VideoLAN project giving some of your time to help the community, to design skins, to translate the documentation, to test and to code. You can also give funds and material to help us. And of course, you can <b>promote</b> VLC media player.</p>" \
    "</body></html>")

#endif
