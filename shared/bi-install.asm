;
;  bi-install.asm
;
;  BASIC.SYSTEM installation program. 
;  * All installation code is placed into either RCODE or RDATA and placed into the first memory location.
;  * All application code is placed into either CODE or DATA and relocated into location supplied by BI.
;
;  Copyright (c) 2015 Rob Greene
;

; Application stuff:

cptr		= $0c		; Code pointer
dptr		= $0e		; Data pointer

	.ifp02
	.error "Installer requires 65C02 instructions."
	.endif

	.include "../include/asciizh.inc"
	.include "../include/basic-system.inc"
	.include "../include/monitor.inc"

	.import __CODE_LOAD__, __CODE_START__, __CODE_SIZE__
	.import __INIT_LAST__

.macro bi_install hookaddr

	.if .paramcount <> 1
	.error "Must include hook address in bi-install macro."
	.endif

install:

; Requires 65C02 or later:
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
:	lda __INIT_LAST__,y
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
	ldy #<hookaddr+1
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
	asciizh "ONLINE COMMAND INSTALLED"
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

.endmacro

