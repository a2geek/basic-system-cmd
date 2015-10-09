;
;  BASIC.SYSTEM stuff
;
;  Copyright (c) 2015 Rob Greene

	.ifndef __BASIC_SYSTEM__

__BASIC_SYSTEM__ = 1

; BASIC.SYSTEM locations:

bi_inbuf	= $0200
bi_extrncmd	= $be06		; External command JMP vector
bi_errout	= $be09		; Handles ONERR or prints error
bi_printerr	= $be0c		; Prints error message; number is in accumulator
bi_xtrnaddr	= $be50		; Execution address of external command
bi_xlen		= $be52		; Length of command string-1
bi_xcnum	= $be53		; BASIC cmd number (external command = 0)
bi_pbits	= $be54		; Parameter bits allowed (2 bytes)
bi_fbits	= $be56		; Parameter bits found (2 bytes)
bi_vslot	= $be61		; Parameter value for 'S'
bi_vdriv	= $be62		; Parameter value for 'D'
bi_vpath1	= $be6c		; Pathname 1 buffer
bi_vpath2	= $be6e		; Pathname 2 buffer
bi_gosystem	= $be70		; BI MLI call routine
bi_badcall	= $be8b		; Convert MLI erorrs into BASIC.SYSTEM error equivalents
bi_xreturn	= $be9e		; Guaranteed RTS instruction
bi_ssgprfx	= $beac		; SET/GET_PREFIX parameter table
bi_ssgprfx_buf	= $bead		; .. pathname (SET_PREFIX) / data_buffer (GET_PREFIX)
bi_sonline	= $bec6		; ONLINE parameter table
bi_sunitnum	= $bec7		; .. SDDD0000 unit number
bi_sbufadr	= $bec8		; .. LO HI buffer address
bi_getbufr	= $bef5		; Allocate buffer space; Acc. in = pages; Acc. out = start page

; Parameter bits flags (note setup for two bytes and for lo/hi usage)

bi_pfix		= $0080		; Prefix needs fetching, pathname optional
bi_slot		= $0040		; No parameters to be processed
bi_rrun		= $0020		; Command only valid during program
bi_fnopt	= $0010		; Filename is optional
bi_crflg	= $0008		; CREATE allowed
bi_t		= $0004		; File type
bi_fn2		= $0002		; Filename #2 for RENAME
bi_fn1		= $0001		; Filename expected

bi_ad		= $8000		; Address
bi_b		= $4000		; Byte
bi_e		= $2000		; End address
bi_l		= $1000		; Length
bi_line		= $0800		; '@' line number
bi_sd		= $0400		; Slot and drive numbers
bi_f		= $0200		; Field
bi_r		= $0100		; Record
bi_v		= $0000		; Volume number ignored

	.endif
