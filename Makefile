# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		Makefile
#		Purpose :	Check everything built
#		Date :		22nd March 2025
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

include build_env/common.make

.any:

all: .any
	#
	#		Rebuilds the data tables and constants.
	#
	$(MAKE) -B -C $(SCRIPTDIR) build
	#
	#		Build the single file and test it assembles.
	#
	$(MAKE) -B -C $(SOURCEDIR) test

