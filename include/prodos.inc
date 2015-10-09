;
;  ProDOS stuff
;
;  Copyright (c) 2015 Rob Greene
;

	.ifndef __PRODOS__

__PRODOS__ = 1

; MLI operation codes

mli_alloc_int	= $40		; ALLOCATE_INTERRUPT
mli_dealloc_int	= $41		; DEALLOCATE_INTERRUPT
mli_read_block	= $80		; READ_BLOCK
mli_write_block	= $81		; WRITE_BLOCK
mli_create	= $c0		; CREATE
mli_destroy	= $c1		; DESTROY
mli_rename	= $c2		; RENAME
mli_set_info	= $c3		; SET_FILE_INFO
mli_get_info	= $c4		; GET_FILE_INFO
mli_online	= $c5		; ONLINE
mli_set_prefix	= $c6		; SET_PREFIX
mli_get_prefix	= $c7		; GET_PREFIX
mli_open	= $c8		; OPEN
mli_newline	= $c9		; NEWLINE
mli_read 	= $ca		; READ
mli_write	= $cb		; WRITE
mli_close	= $cc		; CLOSE
mli_flush	= $cd		; FLUSH
mli_set_mark	= $ce		; SET_MARK
mli_get_mark	= $cf		; GET_MARK
mli_set_eof	= $d0		; SET_EOF
mli_get_eof	= $d1		; GET_EOF
mli_set_buf	= $d2		; SET_BUF
mli_get_buf	= $d3		; GET_BUF

; MLI locations

mli_entry	= $bf00		; MLI call entry point
mli_memtabl	= $bf58		; Memory map of lower 48K
mli_machid	= $bf98		; Machine identification
mli_iversion	= $bffd		; Version # of currently running interpreter
mli_kversion	= $bfff		; Version # of kernel

	.endif
