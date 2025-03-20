# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		build.make
#		Purpose :	Common make building stuff
#		Date :		9th December 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

#
#		Assembler directives (ACME)
#
ACME_COMMON = acme -l $(BINDIR)build.lbl -r $(BINDIR)build.lst
#
#		X16 stuff
#
PROGNAME_X16 = $(BINDIR)x16app.prg
ACME_X16 = $(ACME_COMMON) -f cbm --cpu 65C02  -o $(PROGNAME_X16) __build.tmp
RUN_X16 = $(X16EMUDIR)/x16emu -debug -scale 2 -dump R 

asmx16: prelim builder
	echo "Assembling 65C02 code"
	$(ACME_X16)

runx16: asmx16
	rm -f dump*.bin
	$(RUN_X16) -c02 -prg $(PROGNAME_X16) -run


modules:
	$(MAKE) -C $(ROOTDIR)source

builder:
	echo "Building module script" 
	rm -f __build.tmp
	$(PYTHON) $(SCRIPTDIR)builder.py --root=$(ROOTDIR)source $(BUILDOPTIONS) $(MODULES) >__build.tmp

