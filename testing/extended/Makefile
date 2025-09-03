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

n1 = 1345
n2 = 3.1

check:
	$(MAKE) -C $(SOURCEDIR) test

go:
	$(RUNEMULATOR)
	
test: assemble
	$(RUNEMULATOR)

assemble:
	$(MAKE) -C $(SCRIPTDIR) build	
	cp $(SCRIPTDIR)__ifloat_copy.py .
	cp $(SCRIPTDIR)__fpconsts.py .
	rm -f dump*.bin
	$(PYTHON) create.py >__testdata.inc
	echo "Built new test"
	$(ASSEMBLER) $(ASMOPTIONS) start.asm $(ASMTARGETS)

show:
	$(PYTHON) viewer.py

run: test show

data:
	$(MAKE) -B -C $(SCRIPTDIR)
