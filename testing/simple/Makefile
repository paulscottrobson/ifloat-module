# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		Makefile
#		Purpose :	Very simple one off tests.
#		Date :		20th March 2025
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

include ../../build_env/common.make

n1 = 12.375
n2 = 3.1

check:
	$(MAKE) -C $(SOURCEDIR) test

test: assemble
	$(RUNEMULATOR)

assemble:
	$(MAKE) -C $(SCRIPTDIR) build	
	rm -f dump*.bin
	$(PYTHON) $(SCRIPTDIR)generate_ifloat.py testdata1 $(n1) >__testdata.inc
	$(PYTHON) $(SCRIPTDIR)generate_ifloat.py testdata2 $(n2) >>__testdata.inc
	$(ASSEMBLER) $(ASMOPTIONS) start.asm $(ASMTARGETS)

show:
	$(PYTHON) $(SCRIPTDIR)show_ifloat.py dump.bin 0x20
	$(PYTHON) $(SCRIPTDIR)show_ifloat.py dump.bin 0x26
	$(PYTHON) $(SCRIPTDIR)show_string.py dump.bin 0x400

run: test show

data:
	$(MAKE) -B -C $(SCRIPTDIR)
