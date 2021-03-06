This is a savedata exploit for Nintendo 3DS "Paper Mario: Sticker Star". This triggers when you select the savefile via A which has the exploit installed, around when the save-select sound finishes playing. All currently available versions of this game are supported as of July 29, 2016(exploit release): gamecard/eShop-install are supported, Nintendo Selects version is also supported.

The original PoC for this was done on June 16, 2016.

Due to how the savedata is normally formatted by the game, and due to lack of space, during installation savedata has to be formatted so that the payload can actually be installed basically. Hence, when you install this, **you will lose all of your save-files**. When you first launch the game after installation, the game will create blank save-files for the other save-files which don't exist. If you don't want to lose your savedata, back it up with whatever save manager homebrew you want **before installation**. **After installation**, you can restore your save-files for the non-hax-savefiles.

USA, EUR, JPN, and KOR work fine. CHNTWN isn't *properly* supported yet.

To install, use 'sploit_installer-stickerhax' now included with the homebrew [starter-kit](https://smealum.github.io/3ds/). This requires [another](https://www.3dbrew.org/wiki/Homebrew_Exploits) way to run homebrew. With the starter-kit updated on August 20, 2016, this contains support for USA, EUR, JPN, and KOR. Gamecard save-images for powersaves are not available as of July 29, 2016, due to the newer save-crypto this game uses.

# Building
"make clean ROPKIT_PATH={path to yellows8github/3ds_ropkit} && make ROPKIT_PATH={path to yellows8github/3ds_ropkit}"

The contents of the finaloutput_romfs directory can then be copied into the romfs directory used for building [sploit_installer](https://github.com/smealum/sploit_installer), with exploitlist_config being appended to the end of the sploit_installer/romfs/exploitlist_config file.

# Exploitation/development
1. *Finally* dumped savedata for the first time with this game.
2. Tried modifying savedata to check whether any CRC/checksum is used, which there isn't.
3. Overwrote the entire savefile starting at offset 0xc, with random data. Then selected the savefile in-game by pressing A.
4. From the exception-dump *followed* by code-RE, the game crashed while running strcpy(stackptr, ptr_in_heap_savebuf), due to trying to write to read-only sharedmem(it wrote beyond the stacktop).
5. The saved regs for "pop {r4, r5, pc}" get overwritten by this strcpy, so exploitation was attempted with r4=r5={addr in the savebuf}, with pc set to the stack-pivot addr.
6. That didn't work initially because after doing the strcpy, it also converts the string on stack to lowercase. The heap addr used here had some byte(s) converted.
7. Eventually after figuring out *exactly* what byte values would trigger conversion, the r4/r5 addr was updated so that the addr wouldn't be modified.
8. Successful stack-pivot, this is the PoC mentioned above.
9. Eventually 3ds_ropkit was implemented and tested using stickerhax, with oot3dhax support for 3ds_ropkit being added later. Initially SD was used for payload loading due to issues with storing the payload in savedata.
10. {Attempts at supporting non-USA ...} Later to support other regions, the pc-addr used with the initial pop mentioned above was updated to call a vtable funcptr instead(which then jumped to stack-pivot), to avoid triggering lowercase-conversion.
11. Loading the payload from savedata was finally implemented successfully.

# Credits
* Shakey for all non-USA region ropinclude addrs for .text, and for testing those regions. Also for dumping heap data required for locating the correct ROPBUF address for non-{USA/EUR}.
* profi200 for dumping heap data needed for locating the correct ROPBUF address with EUR-region, and for testing. Also for running the scripts used for generating the ropinclude again, to support savedata payload loading.

