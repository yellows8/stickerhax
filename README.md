This is a savedata exploit for Nintendo 3DS "Paper Mario: Sticker Star". This triggers when you select the savefile via A which has the exploit installed.

The original PoC for this was done on June 16, 2016.

# Building
"make clean ROPKIT_PATH={path to yellows8github/3ds_ropkit} && make ROPKIT_PATH={path to yellows8github/3ds_ropkit}"

The contents of the finaloutput_romfs directory can then be copied into the romfs directory used for building https://github.com/smealum/sploit_installer, with exploitlist_config being appended to the end of the sploit_installer/romfs file.

# Credits
* Shakey for all non-USA region support, and for testing those regions(only JPN tested among those so far, which worked fine).

