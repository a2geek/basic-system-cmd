;
;  Monitor entry points
;
;  Copyright (c) 2015 Rob Greene
;

	.ifndef __MONITOR__

__MONITOR__ = 1

; MONITOR locations:

mon_crout	= $fd8e
mon_prbyte	= $fdda
mon_prhex	= $fde3
mon_cout	= $fded

	.endif
