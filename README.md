This is a savedata exploit for Nintendo 3DS "Paper Mario: Sticker Star". This triggers when you select the savefile via A which has the exploit installed.

The original PoC for this was done on June 16, 2016.

Currently this loads the payload from SD(exheader patch required), hence this is not usable from userland-only currently.

Getting the \*hax payload stored in savedata is rather difficult: the max files allowed by the FS(with the default formatting used by this game) is exactly 3, which matches the total number of save-files. If any of the save-files are missing, the game will automatically re-create them at entering the save-select screen. And if any of the save-files have a larger filesize than expected, the game will reset all of the save-files.

USA works fine. EUR, JPN, and KOR, all crash the same way @ ROP_VTABLEFUNCPTR_x10_CALL_R5OBJ+4 since the ROPBUF for those regions are wrong. The CHNTWN build is broken, target stackframe size seems different(doesn't even crash).

# Building
"make clean ROPKIT_PATH={path to yellows8github/3ds_ropkit} && make ROPKIT_PATH={path to yellows8github/3ds_ropkit}"

The contents of the finaloutput_romfs directory can then be copied into the romfs directory used for building https://github.com/smealum/sploit_installer, with exploitlist_config being appended to the end of the sploit_installer/romfs file.

# Credits
* Shakey for all non-USA region support, and for testing those regions.

