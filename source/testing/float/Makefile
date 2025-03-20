# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		Makefile
#		Purpose :	Make test file
#		Date :		9th December 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

include ../../../build_env/common.make
include $(BUILDDIR)build.make

MODULES = platform.x16.config common platform.x16.boot cpu.6502 ifloat.base ifloat.polynomial.enable testing.float

all: asm8

prelim:
	cp $(ROOTDIR)documents/ifloat-reference/ifloat.py $(SCRIPTDIR)/_ifloat_copy.py
	$(PYTHON) $(SCRIPTDIR)generate_ifloat.py test_float 32.75 12 >_testdata.asm

show:
	$(PYTHON) $(SCRIPTDIR)show_ifloat.py dump.bin 0x22
	$(PYTHON) $(SCRIPTDIR)show_ifloat.py dump.bin 0x28
	$(PYTHON) $(SCRIPTDIR)show_string.py dump.bin 0x400
	$(PYTHON) $(SCRIPTDIR)test_app.py
