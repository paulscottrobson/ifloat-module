# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		Makefile
#		Purpose :	Very simple one off tests.
#		Date :		9th December 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

include ../../build_env/common.make

n1 = 12.3
n2 = 3.1

check:
	$(MAKE) -C $(SOURCEDIR) test

test:
	$(MAKE) -C $(SCRIPTDIR) build	
	rm -f dump*.bin
	$(PYTHON) $(SCRIPTDIR)generate_ifloat.py testdata1 $(n1) >__testdata.inc
	$(PYTHON) $(SCRIPTDIR)generate_ifloat.py testdata2 $(n2) >>__testdata.inc
	$(ASSEMBLER) $(ASMOPTIONS) start.asm $(ASMTARGETS)
	$(RUNEMULATOR)

show:
	$(PYTHON) $(SCRIPTDIR)show_ifloat.py dump.bin 0x20
	$(PYTHON) $(SCRIPTDIR)show_ifloat.py dump.bin 0x26

run: test show
