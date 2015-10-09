;
;  asciizh macro
;
;  Copyright (c) 2015 Rob Greene
;

	.ifndef asciizh

; ASCII string with high-bit set, terminated by a zero
.macro asciizh string
	.repeat .strlen(string),i
	.byte .strat(string,i) | $80
	.endrep
	.byte 0
.endmacro

	.endif
