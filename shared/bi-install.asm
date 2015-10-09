;
;  bi-install.asm
;
;  BASIC.SYSTEM installation program. 
;  * All installation code is placed into either RCODE or RDATA and placed into the first memory location.
;  * All application code is placed into either CODE or DATA and relocated into location supplied by BI.
;
;  Copyright (c) 2015 Rob Greene
;

; Check required attributes or parameters

	.ifp02
	.error "Installer requires 65C02 instructions."
	.endif

	.if .strlen(CMDNAME) = 0
	.error "Please define CMDNAME with the name of the command (used in installation message)."
	.endif

	;.ifndef HOOKADDR
	;.error "Please define HOOKADDR with the location where extern command needs to be placed (assumed to be JMP instruction)."
	;.endif

; Zero page

cptr		= $0c		; Code pointer
dptr		= $0e		; Data pointer

	.include "../include/asciih.inc"
	.include "../include/asciizh.inc"
	.include "../include/basic-system.inc"
	.include "../include/monitor.inc"

	.import __CODE_LOAD__, __CODE_SIZE__

install:

	.segment "RCODE"

; Requires 65C02 or later - detect bug in decimal mode:
	sed
	lda #$99
	clc
	adc #$01
	cld
	bpl @not6502
	
@6502:
	jsr printz
	asciizh "ERR: MUST HAVE ENHANCED //E, //C, OR IIGS"
	rts

; Get address from BASIC.SYSTEM:
@not6502:
	lda #1
	jsr bi_getbufr
	bcc @gotmem
    
@nomem:
	jsr printz
	asciizh "UNABLE TO ALLOCATE MEMORY"
	rts
    
@gotmem:
	sta cptr+1
	stz cptr

; Move code to destination address:
	ldy #0
:	lda _ApplicationStartsHere_,y
	sta (cptr),y
	iny
	bne :-

; Patch code for new location - ASSUMES 1 PAGE ONLY!
	ldy #0
@copy:
	lda (cptr),y
	jsr ilen		; calculate instruction length
	tax
	cpx #3
	bne :+
	iny			; Skip instruction
	dex
	iny			; Skip low byte
	dex
	lda (cptr),y
	cmp #>__CODE_LOAD__
	bne :+
	lda cptr+1
	sta (cptr),y
:	iny			; Skip rest of instruction
	dex
	bne :-
	cpy #<__CODE_SIZE__
	bcc @copy

; Setup BASIC.SYSTEM hooks:
; 1. Save EXTRNCMD
	lda bi_extrncmd+2
	ldy #<HOOKADDR+2
	sta (cptr),y
	lda bi_extrncmd+1
	dey
	sta (cptr),y
; 2. Place our hook into EXTRNCMD
	lda cptr+1
	sta bi_extrncmd+2
	stz bi_extrncmd+1

; Notify user:
	jsr printz
	asciih CMDNAME
	asciizh " COMMAND INSTALLED"
	rts

printz:
	pla
	sta dptr
	pla
	sta dptr+1
@L:	inc dptr
	bne :+
	inc dptr+1
:	lda (dptr)
	beq @X
	jsr mon_cout
	bra @L
@X:	lda dptr+1
	pha
	lda dptr
	pha
	rts

	.include "../shared/ilen.asm"

_ApplicationStartsHere_:

