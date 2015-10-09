;
;  online.asm
;
;  Copyright (c) 2015 Rob Greene
;

	.PC02   ; Enable 65C02 instructions

	.include "../include/basic-system.inc"
	.include "../include/monitor.inc"
	.include "../include/asciih.inc"
	.include "../include/prodos.inc"


; Setup the installer code ...

	.define CMDNAME "ONLINE"
	.define HOOKADDR nextcmd
	.include "../shared/bi-install.asm"


; Application code from here...

buffer	= bi_inbuf

	.code

_CodeBeginAddress:
entry:
	cld			; For BASIC.SYSTEM's happiness
	ldx #cmdlen
:	lda bi_inbuf-1,x
	cmp #$e0		; Force input to UPPERCASE for comparison
	bcc :+
	and #$df
:	cmp cmdtable-1,x
	bne notOurCommand
	dex
	bne :--

; Setup for BASIC.SYSTEM to parse
opts = bi_fnopt|bi_sd		; Filename is optional (due to glitch) and slot and drive
	lda #cmdlen-1
	sta bi_xlen
	lda #<online
	sta bi_xtrnaddr
	jsr bi_xreturn
	tsx
	lda $100,x		; Retrieve address from stack
	sta bi_xtrnaddr+1
	stz bi_xcnum
	lda #<opts
	sta bi_pbits
	lda #>opts
	sta bi_pbits+1
	clc
	rts

notOurCommand:
	sec
nextcmd:
	jmp $0000		; Filled in by installer

;
; Perform ONLINE command
; Note we use the input buffer address
;
; Buffer format is:
;   +000 DSSSLLLL    D=Drive, SSS=Slot, LLLL=Length
;   +001 CHAR1        Name... or error code
;    ...
;   +015 CHAR15
;
; Output:
; S7 D1 /HDD
; S6 D1 ERR=$28
; S5 D1 ERR=$57 (S7 D1)
;
online:
	lda bi_fbits+1
	and #>bi_sd
	beq @1			; Bit was NOT set; Acc = 0
	lda bi_vdriv		; 1 or 2, use 2nd bit to toggle drive (then drive 1 has bit off, drive 2 has bit on)
	and #%00000010
	asl
	asl
	ora bi_vslot
	asl
	asl
	asl
	asl
@1:	sta bi_sunitnum
	stz bi_sbufadr
	lda #>buffer
	sta bi_sbufadr+1
; Note: if we have a specific unit, the buffer will not be zero terminated -- fake it!
	stz buffer+16
	lda #mli_online
	jsr bi_gosystem

@continue:
	jsr mon_crout
	ldx #0
@loop:
	ldy buffer,x
	beq @exit
	jsr printsd
	jsr printspc
	tya
	and #$0f
	beq @deverr
	tay
	lda #'/'|$80
:	jsr mon_cout
	inx
	lda buffer,x
	ora #$80
	dey
	bpl :-
@adjust:
	jsr mon_crout
	txa
	and #$0f		; Check if we advanced past this buffer
	beq @loop
	txa
	and #$f0
	clc
	adc #$10
	tax
	bne @loop
@exit:
	jsr mon_crout
	clc
	rts
; A device error message
@deverr:
	ldy #0
:	lda msgERR,y
	beq :+
	jsr mon_cout
	iny
	bne :-
:	inx
	lda buffer,x
	tay			; short-term save
	jsr mon_prbyte
	tya
	cmp #$57		; duplicate volume error
	bne @adjust
	jsr printspc
	lda #'('|$80
	jsr mon_cout
	inx
	ldy buffer,x
	jsr printsd
	lda #')'|$80
	jsr mon_cout
	bra @adjust

printsd:
	lda #'S'|$80
	jsr mon_cout
	tya
	and #$70
	lsr
	lsr
	lsr
	lsr
	jsr mon_prhex
	lda #','|$80
	jsr mon_cout
	lda #'D'|$80
	jsr mon_cout
	tya
	and #$80
	asl			; Drive 2 will set carry...
	adc #'1'|$80		; ... making the '1' a '2'
	bra _cout		; Saving 1 byte

printspc:
	lda #' '|$80
_cout:
	jmp mon_cout

	.data

msgERR:
	asciizh "ERR=$"

cmdtable:
	asciih "ONLINE"
cmdlen = *-cmdtable

