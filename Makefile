#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

ifeq ($(strip $(ROPKIT_PATH)),)
$(error "ROPKIT_PATH is not set.")
endif

TOPDIR ?= $(CURDIR)
include $(DEVKITARM)/3ds_rules

.PHONY: clean all build_savedata

BUILDPREFIX	:=	
ROPINC_PATH	:=	ropinclude

ICON	:=	sploit_installer_stickerhax.png

APP_TITLE	:=	sploit_installer-stickerhax
APP_DESCRIPTION	:=	Install stickerhax. Requires Paper Mario: Sticker Star. https://github.com/yellows8/stickerhax
APP_AUTHOR	:=	smea and yellows8

all	:	sploit_installer_stickerhax.smdh
	@mkdir -p finaloutput_romfs/stickerhax
	@mkdir -p build
	@echo -n "stickerhax Sticker-Star 0x4" > finaloutput_romfs/exploitlist_config
	@for path in $(ROPINC_PATH)/*; do echo Building for title $$(basename "$$path")... && make build_savedata --no-print-directory TID=$$(basename "$$path"); done
	@echo "" >> finaloutput_romfs/exploitlist_config

sploit_installer_stickerhax.smdh:

clean:
	@rm -R -f finaloutput_romfs
	@rm -R -f build

build_savedata:	
	@mkdir -p finaloutput_romfs/stickerhax/$(TID)/v1.0/common/save
	@echo "[remaster_versions]\n0000=romfs:/stickerhax/$(TID)/v1.0@v1.0" > finaloutput_romfs/stickerhax/$(TID)/config.ini
	@echo -n " $(TID)" >> finaloutput_romfs/exploitlist_config
	@for path in $(ROPINC_PATH)/$(TID)/*; do echo Building $$(basename "$$path")... && make build_title_savedata --no-print-directory BUILDPREFIX=$$(basename "$$path"); done

build_title_savedata:	build/$(BUILDPREFIX).bin
	@echo "save/$(BUILDPREFIX).bin=/pm4_@!d1.bin" > finaloutput_romfs/stickerhax/$(TID)/v1.0/common/config.ini
	@cp $< finaloutput_romfs/stickerhax/$(TID)/v1.0/common/save/$(BUILDPREFIX).bin

build/$(BUILDPREFIX).bin:	build/$(BUILDPREFIX).elf
	@$(OBJCOPY) -O binary $< $@

build/$(BUILDPREFIX).elf:	stickerhax.s
	@$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -I$(ROPKIT_PATH) -include $(ROPINC_PATH)/$(TID)/$(BUILDPREFIX) $< -o $@

