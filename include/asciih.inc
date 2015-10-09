;
;  asciih macro
;
;  Copyright (c) 2015 Rob Greene
;

	.if .not .definedmacro(asciih)

; ASCII string with high-bit set
.macro asciih string
	.repeat .strlen(string),i
	.byte .strat(string,i) | $80
	.endrep
.endmacro

	.endif

