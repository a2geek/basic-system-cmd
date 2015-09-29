;
; ilen.asm
;

    .PC02   ; Enable 65C02 instructions

;
; Calculate Instruction Length
; Based on observations in 65C02 data sheet:
; * Generally, length is based on LOW nibble
; * There are a few special cases (including X9 column)
; Input: Acc. = instruction
; Output: Acc. = length
;
.proc ilen
	bit #$0f
	bne @notcol0
@column0:
	bit #%10010000		; Normal instructions have at least one of these bits set
	beq @notnormal		; None are set
@notcol0:			; "Normal" values for ALL columns 0-F
	asl
	asl
	asl
@column9:
	cmp #$C8		; xxx11001<<3 (special case for $X9 column)
	beq @three
	cmp #$48		; xxx01001<<3 (special case for $X9 column)
	beq @two
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


