#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

TOPDIR ?= $(CURDIR)
include $(DEVKITARM)/base_rules

.PHONY: clean all build_savedata

BUILDPREFIX	:=	
ROPINC_PATH	:=	ropinclude

all:	
	@mkdir -p finaloutput
	@mkdir -p build

	@for path in $(ROPINC_PATH)/*; do echo Building $$(basename "$$path")... && make build_savedata --no-print-directory BUILDPREFIX=$$(basename "$$path"); done

clean:
	@rm -R -f finaloutput
	@rm -R -f build

build_savedata:	build/$(BUILDPREFIX).bin
	@mkdir -p finaloutput/$(BUILDPREFIX)/
	@cp $< finaloutput/$(BUILDPREFIX)/pm4_0.bin
	@cp $< finaloutput/$(BUILDPREFIX)/pm4_1.bin
	@cp $< finaloutput/$(BUILDPREFIX)/pm4_2.bin

build/$(BUILDPREFIX).bin:	build/$(BUILDPREFIX).elf
	@$(OBJCOPY) -O binary $< $@

build/$(BUILDPREFIX).elf:	stickerhax.s
	@$(CC) -x assembler-with-cpp -nostartfiles -nostdlib -include $(ROPINC_PATH)/$(BUILDPREFIX) $< -o $@

