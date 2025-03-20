# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		common.make
#		Purpose :	Common make
#		Date :		9th December 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

PYTHON = python3
#
#		Directories
#
ROOTDIR =  $(dir $(realpath $(lastword $(MAKEFILE_LIST))))../
BINDIR = $(ROOTDIR)bin/
BUILDDIR = $(ROOTDIR)/build_env/
SCRIPTDIR = $(ROOTDIR)scripts/
X16EMUDIR = /aux/builds/x16-emulator/
#
#		Make defaults
#
MAKE=make --no-print-directory
#
#		Uncommenting .SILENT will shut the whole build up.
#
ifndef VERBOSE
.SILENT:
endif
