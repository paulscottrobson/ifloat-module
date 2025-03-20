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
BUILDDIR = $(ROOTDIR)/build/
SOURCEDIR = $(ROOTDIR)source/
SCRIPTDIR = $(SOURCEDIR)scripts/
X16EMUDIR = /aux/builds/x16-emulator/

ASSEMBLER = 64tass
ASMOPTIONS = -c -q -f --cbm-prg
ASMTARGETS = -l $(BUILDDIR)float.lbl -L $(BUILDDIR)float.lst -o $(BUILDDIR)float.prg
RUNEMULATOR = $(X16EMUDIR)x16emu -debug -dump R -scale 2 -zeroram -prg $(BUILDDIR)float.prg,1000 -run
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
