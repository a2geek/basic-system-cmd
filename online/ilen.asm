;
;  ilen.asm
;

    .PC02   ; Enable 65C02 instructions

    .code    

.ifdef TESTILEN

crout	=	$fd8e
cout	=	$fded
prbyte	=	$fdda

    .org $2000

.proc ilentest
	jsr $c300	; Assume we have an 80 column card available
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
	lda #$88	; (backspace)
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
; Top line --
	ldy #0
:	tya
	jsr prbyte
	jsr spout
	iny
	cpy #$10
	bcc :-
	jmp crout

updndividor:
	jsr spout
	jsr spout
	jsr spout
	ldy #0
; Hypens
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
.endif

;
; Calculate Instruction Length
; Based on observations in 65C02 data sheet:
; * Generally, length is based on LOW nibble
; * There are a few special cases (including X9 column)
; Input: Acc. = instruction
; Output: Acc. = length
.proc ilen
	bit #$0f
	bne @normal
@column0:
	bit #%10010000	; Normal instructions have at least one of these bits set
	beq @notnormal	; None are set
@normal:			; "Normal" values for ALL columns 0-F
	asl
	asl
	asl
@column9:
	cmp #$C8		; xxx11001<<3 (special case for $X9 column)
	beq @three
	cmp #$48		; xxx01001<<3 (special case for $X9 column)
	beq @two
;@morenormal:
	asl
	bpl @two		; xxxx0xxx<<4
	asl
	bpl @one		; xxxx10xx<<5
					; fall through for xxxx11xx<<5
@three:
	lda #3
	rts
	
@notnormal:
	cmp #$20		; JSR ($20)
	beq @three
					; fall through for BRK ($00) / RTI ($40) / RTS ($60)
@one:
	lda #1
	rts
@two:
	lda #2
	rts
.endproc


