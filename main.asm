;
;  main.s
;  cd-online-basic-system-integration
;
;  Created by Rob Greene on 9/14/15.
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


    .org $2000

install:
    lda extrncmd+1
    sta nextcmd+1
    lda extrncmd
    sta nextcmd

    lda #>entry
    sta extrncmd
    lda #<entry
    sta extrncmd
    rts

    .org $6000

entry:
    ldx #0
@again:
    ldy #0
:   lda cmdtable,x
    beq ourcommand
    cmp inbuf,y
    bne @nextcmd
    inx
    iny
    bra :-
@nextcmd:
    inx
    lda cmdtable,x
    bne @nextcmd
    inx         ; Skip jumps
    inx
    lda cmdtable,x
    bne @again

notOurCommand:
    sec
    jmp (nextcmd)

nextcmd: .word 0

ourcommand:
    stx xlen
    lda cmdtable,x
    sta xtrnaddr
    lda cmdtable+1,x
    sta xtrnaddr+1
    stz xcnum
    lda #$10
    sta pbits
    lda #$04
    sta pbits+1
    stz vslot
    stz vdriv
    clc
    rts

cmdtable:
    asciizh "CD"
    .addr   cd
    asciizh "ONLINE"
    .addr   online

;
; Perform CD command
;
cd:
    rts

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
; S6 D1 Err=$28
; S5 D1 Err=$57 (S7 D1)
;
online:
    stz sunitnum
    stz sbufadr
    lda #>inbuf
    sta sbufadr+1
    lda #$C5	  ; ONLINE system command
    jsr gosystem
    bcc @continue
    rts
@exit:
    jmp crout

@continue:
    ldx #0
@loop:
    lda inbuf,x
    beq @exit
    jsr printsd     ; Side-effect is to move Acc. to Y-Reg.
    tya
    and #$0f
    beq @deverr
;    pha
    tay
:   inx
    lda inbuf,x
    jsr cout
    dey
    bne :-
;    pla
;    cmp #$0f        ; If string length was 15, already at next entry
;    beq @loop
@adjust:
    jsr crout
    txa
    clc
    adc #$10
    and #$f0
    bra @loop
; A device error message
@deverr:
    lda #'E'|$80
    jsr cout
    lda #'r'|$80
    jsr cout
    jsr cout
    lda #'='|$80
    jsr cout
    inx
    lda inbuf,x
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
    lda inbuf,x
    jsr printsd
    lda #')'|$80
    jsr cout
    bra @adjust

printsd:
    tay
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
    lda #' '|$80
    jsr cout
    lda #'D'|$80
    jsr cout
    tya
    and #$80
    asl
    rol
    ora #'0'|$80
    jmp cout


