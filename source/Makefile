# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		Makefile
#		Purpose :	Build module
#		Date :		20th March 2025
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

include ../build_env/common.make

#
#		This just test it builds, nothing else.
#
test: single
	$(ASSEMBLER) $(ASMOPTIONS) fwrapper.asm $(ASMTARGETS)
	echo "Multi file Assembles correctly"
	$(ASSEMBLER) $(ASMOPTIONS) fwrapper2.asm $(ASMTARGETS)
	echo "Single file Assembles correctly"

#
#		Build the single file version
#	
single:
	$(PYTHON) $(SCRIPTDIR)builder.py >$(BUILDDIR)ifloat.library
	echo "Build single file library"