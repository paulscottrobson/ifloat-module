; *******************************************************************************************
; *******************************************************************************************
;
;       Name :      dispatch.asm
;       Purpose :   Dispatch commands
;       Date :      21st March 2025
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;       Execute a FP command. Command number in A. CS=> error. Some return a value in A
;
; *******************************************************************************************

FloatEntry:
        cmp     #FTCMD_COUNT                ; illegal command
        bcs     _FEExit                     ; exit with CS.

        phx                                 ; save registers, not A
        phy
        asl     a                           ; 4 bytes / entry in jump table
        asl     a
        tax
        jsr     _FECall                     ; so we can return using RTS, local on 65816
        ply                                 ; restore registers other than A
        plx
_FEExit:        
        FloatExit                           ; this is RTS or RTL

_FECall:                                    
        FloatJumpIX FloatVectorTable        ; differs on 6502/65816