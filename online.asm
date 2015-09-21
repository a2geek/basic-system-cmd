;
;  online.asm
;
;  Copyright (c) 2015 Rob Greene. All rights reserved.
;

    .PC02   ; Enable 65C02 instructions

; ASCII string with high-bit set, terminated by a zero
.macro asciizh string
    .repeat .strlen(string),i
    .byte .strat(string,i) | $80
    .endrep
    .byte 0
.endmacro

; ASCII string with high-bit set
.macro asciih string
    .repeat .strlen(string),i
    .byte .strat(string,i) | $80
    .endrep
.endmacro

; Dextral (right-most) Character Inverted
.macro dci string
    .repeat .strlen(string),i
    .if .strlen(string) = i
    .byte .strat(string,i) | $80
    .else
    .byte .strat(string,i) & $7f
    .endif
    .endrep
.endmacro

; BASIC.SYSTEM locations:

inbuf       = $0200
extrncmd    = $be06    ; External command JMP vector
xtrnaddr    = $be50    ; Execution address of external command
xlen        = $be52    ; Length of command string-1
xcnum       = $be53    ; BASIC cmd number (external command = 0)
pbits       = $be54    ; Parameter bits
vslot       = $be61
vdriv       = $be62
gosystem    = $be70
sonline     = $bec6    ; BASIC.SYSTEM ONLINE parameter table
sunitnum    = $bec7
sbufadr     = $bec8
getbufr     = $bef5

; MONITOR locations:

crout       = $fd8e
prbyte      = $fdda
cout        = $fded

; Application stuff:

buffer      = $6800


    .org $2000

install:

; Requires 65C02 or later:
    sed
    lda #$99
    clc
    adc #$01
    cld
    bmi @6502

; Move code to destination address:
; TODO: Get address from BASIC.SYSTEM and move there, relocate code
    ldy #0
:   lda _CodeStartAddress,y
    sta _CodeBeginAddress,y
    iny
    cpy #(_CodeEndAddress-_CodeBeginAddress)
    bne :-

; Setup BASIC.SYSTEM hooks:
; 1. Save EXTRNCMD
    lda extrncmd+2
    sta nextcmd+1
    lda extrncmd+1
    sta nextcmd
; 2. Place our hook into EXTRNCMD
    lda #>entry
    sta extrncmd+2
    lda #<entry
    sta extrncmd+1

; Notify user:
    ldy #0
:   lda msgInstalled,y
    beq :+
    jsr cout
    iny
    bne :-
:   rts

@6502:
    ldy #0
:   lda err6502,y
    beq :+
    jsr cout
    iny
    bne :-
:   rts

err6502:
    asciizh "ERR: MUST HAVE ENHANCED //E, //C, OR IIGS"
msgInstalled:
    asciizh "ONLINE COMMAND INSTALLED"

_CodeStartAddress:
    .org $6000

_CodeBeginAddress:
entry:
    ldx #0
:   lda inbuf,x
    cmp #$e0		; Force input to UPPERCASE for comparison
    bcc :+
    and #$df
:   cmp cmdtable,x
    bne notOurCommand
    inx
    cpx #cmdlen
    bne :--

    lda #cmdlen-1
    sta xlen
    lda #<online
    sta xtrnaddr
    lda #>online
    sta xtrnaddr+1
    stz xcnum
    lda #$10		; Filename is optional
    sta pbits
    lda #$04		; Slot and drive numbers
    sta pbits+1
    stz vslot
    stz vdriv
    clc
    rts

notOurCommand:
    sec
    jmp (nextcmd)

nextcmd: .word 0

cmdtable:
    asciih "ONLINE"
cmdlen = *-cmdtable

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
    lda vdriv
    asl
    asl
    asl
    ora vslot
    asl
    asl
    asl
    asl
    sta sunitnum
    stz sbufadr
    lda #>buffer
    sta sbufadr+1
    lda #$C5	  ; ONLINE system command
    jsr gosystem
    bcc @continue
    rts

@continue:
    ldx #0
@loop:
    ldy buffer,x
    beq @exit
    jsr printsd
    lda #' '|$80
    jsr cout
    tya
    and #$0f
    beq @deverr
    tay
    lda #'/'|$80
:   jsr cout
    inx
    lda buffer,x
    ora #$80
    dey
    bpl :-
@adjust:
    jsr crout
    txa
    and #$0f	; Check if we advanced past this buffer
    beq @loop
    txa
    and #$f0
    clc
    adc #$10
    tax
    bne @loop
@exit:
    jmp crout
; A device error message
@deverr:
    lda #'E'|$80
    jsr cout
    lda #'R'|$80
    jsr cout
    jsr cout
    lda #'='|$80
    jsr cout
    inx
    lda buffer,x
    tay             ; short-term save
    jsr prbyte
    tya
    cmp #$57        ; duplicate volume error
    bne @adjust
    lda #' '|$80
    jsr cout
    lda #'('|$80
    jsr cout
    inx
    ldy buffer,x
    jsr printsd
    lda #')'|$80
    jsr cout
    bra @adjust

printsd:
    lda #'S'|$80
    jsr cout
    tya
    and #$70
    lsr
    lsr
    lsr
    lsr
    ora #'0'|$80
    jsr cout
    lda #','|$80
    jsr cout
    lda #'D'|$80
    jsr cout
    tya
    and #$80
    asl			; Drive 2 will set carry...
    adc #'1'|$80	; ... making the '1' a '2'
    jmp cout

_CodeEndAddress:

