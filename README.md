This is a savedata exploit for Nintendo 3DS "Paper Mario: Sticker Star". This triggers when you select the savefile via A which has the exploit installed.

The original PoC for this was done on June 16, 2016.

Due to how the savedata is normally formatted, and due to lack of space, during installation savedata has to be formatted so that the payload can actually be installed basically. Hence, when you install this, **you will lose all of your save-files**. When you first launch the game after installation, the game will create blank save-files for the other save-files which don't exist. If you don't want to lose your savedata, back it up with whatever save manager tool you want **before installation**. **After installation**, you can restore your save-files for the non-hax-savefiles.

USA works fine. Building for EUR, JPN, and CHNTWN are disabled since the ropincludes need updated due to missing FS_MountSavedata. JPN and KOR all crash the same way @ ROP_VTABLEFUNCPTR_x10_CALL_R5OBJ+4 since the ROPBUF for those regions are wrong. The CHNTWN build is broken, target stackframe size seems different(doesn't even crash).

# Building
"make clean ROPKIT_PATH={path to yellows8github/3ds_ropkit} && make ROPKIT_PATH={path to yellows8github/3ds_ropkit}"

The contents of the finaloutput_romfs directory can then be copied into the romfs directory used for building [sploit_installer](https://github.com/smealum/sploit_installer), with exploitlist_config being appended to the end of the sploit_installer/romfs/exploitlist_config file.

# Credits
* Shakey for all non-USA region ropinclude addrs for .text, and for testing those regions.
* profi200 for dumping heap data needed for locating the correct ROPBUF address with EUR-region, and for testing.

