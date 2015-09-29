;
; ilen-test.asm
;
; Semi automated unit test to verify calculated instruction length.
; This is paired with the AppleScript program to check for expected results.
;

	.PC02   ; Enable 65C02 instructions

	.code    

crout	=	$fd8e
cout	=	$fded
prbyte	=	$fdda

	.org $2000

.proc ilentest
	jsr $c300		; Assume we have an 80 column card available
	jsr crout
	jsr updnborder
	jsr updndividor
; Results --
	ldx #0
:	txa
	jsr prbyte
	lda #'|'|$80
	jsr cout
	ldy #16
:	txa
	jsr ilen
	jsr prbyte
	jsr spout
	inx
	dey
	bne :-
	lda #$88		; (backspace)
	jsr cout
	lda #'|'|$80
	jsr cout
	txa
	dec			; we're one past the last one
	jsr prbyte
	jsr crout
	cpx #0
	bne :--
	jsr updndividor

; <sp><sp><sp>XX<sp>...XX<cr>
updnborder:
	jsr spout
	jsr spout
	jsr spout
	ldy #0
:	tya
	jsr prbyte
	jsr spout
	iny
	cpy #$10
	bcc :-
	jmp crout

; <sp><sp><sp>--<sp>...--<cr>
updndividor:
	jsr spout
	jsr spout
	jsr spout
	ldy #0
:	lda #'-'|$80
	jsr cout
	jsr cout
	jsr spout
	iny
	cpy #$10
	bcc :-
	jmp crout

spout:
	lda #' '|$80
	jmp cout
.endproc

	.include "ilen.asm"
