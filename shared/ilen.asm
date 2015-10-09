;
; ilen.asm
;
; Copyright (c) 2015 Rob Greene
;

;
; Calculate Instruction Length
; Based on observations in 65C02 data sheet:
; * Generally, length is based on LOW nibble:
;   - X0..X7 = 2 bytes
;   - X8..XB = 1 byte
;   - XC..XF = 3 bytes
; * There are a few special cases (including X0 and X9 columns)
; Input: Acc. = instruction
; Output: Acc. = length
;
ilen:
	bit #%10011111		; Normal instructions have at least one of these bits set
	beq @column0		; None are set, column 0 special cases ($00 / $20 / $40 / $60)
@normal:			; "Normal" values for ALL columns 0-F
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
	
@column0:			; Only special cases
	cmp #$20		; JSR ($20)
	beq @three
				; fall through for BRK ($00) / RTI ($40) / RTS ($60)
@one:
	lda #1
	rts
@two:
	lda #2
	rts


