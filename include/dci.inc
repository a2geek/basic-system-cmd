;
;  dci macro
;
;  Copyright (c) 2015 Rob Greene
;

	.ifndef dci

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

	.endif
