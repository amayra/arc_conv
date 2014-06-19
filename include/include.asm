
include ..\include\warc_include.asm

extrn	_CmdLineArg:PROC
extrn	_BlkAlloc:PROC
extrn	_BlkCreate:PROC
extrn	_BlkDestroy:PROC
extrn	_FindFile:PROC
extrn	_GetOpenDirName:PROC
extrn	_CheckPeHdr:PROC
extrn	_RVAToFile:PROC
extrn	_comdlg32:PROC

extrn	_FileSeek64:PROC
extrn	_FileTimeToDosDateTime:PROC

extrn	_unicode_to_ansi:PROC
extrn	_ansi_to_unicode:PROC
extrn	_string_num:PROC
extrn	_string_num64:PROC
extrn	_ansi_select:PROC
extrn	_string_select:PROC
extrn	_filename_select:PROC
extrn	_sjis_test:PROC
extrn	_sjis_upper:PROC
extrn	_sjis_lower:PROC
extrn	_ansi_ext:PROC
extrn	_unicode_ext:PROC
extrn	_sjis_name:PROC
extrn	_unicode_name:PROC
extrn	_stack_alloc:PROC
extrn	_stack_sjis:PROC
extrn	_stack_sjis_esc:PROC

extrn	_null_pack:PROC
extrn	_null_unpack:PROC
extrn	_lzss_unpack:PROC
extrn	_zlib_raw_unpack:PROC
extrn	_zlib_unpack:PROC
extrn	_lzss_pack:PROC
extrn	_zlib_raw_pack:PROC
extrn	_zlib_pack:PROC
extrn	_tga_optimize:PROC
extrn	_tga_alpha_mode:PROC

extrn	_crc32@12:PROC
extrn	_adler32@12:PROC
extrn	_md5_transform@8:PROC
extrn	_sha1_transform@8:PROC
extrn	_sha512_transform@8:PROC
@arc4_size = 104h
extrn	_arc4_set_key@12:PROC
extrn	_arc4_crypt@12:PROC
@blowfish_size = 1048h
extrn	_blowfish_set_key@12:PROC
extrn	_blowfish_encrypt:PROC
extrn	_blowfish_decrypt:PROC
extrn	_des_swap@4:PROC
extrn	_des_init@4:PROC
extrn	_des_set_key@8:PROC
extrn	_des_crypt@8:PROC

@md5_size = 58h
extrn	_md5_fast@12:PROC
extrn	_md5_init@4:PROC
extrn	_md5_update@12:PROC
extrn	_md5_final@8:PROC
@sha512_size = 0C8h
extrn	_sha1_fast@12:PROC
extrn	_sha512_init@4:PROC
extrn	_sha512_update@12:PROC
extrn	_sha512_final@8:PROC

extrn	_ArcLocal:PROC
extrn	_ArcLocalFree:PROC
extrn	_ArcLocalMem:PROC
extrn	_LoadTable:PROC
extrn	_LocalFileCreate:PROC
extrn	_FileCreateExt:PROC

extrn	_hex32_upper:PROC
extrn	_escude_crypt:PROC
extrn	_arc12_lzss_crypt:PROC
extrn	_marble_check:PROC
extrn	_marble_crypt:PROC
extrn	_exhibit_crypt:PROC
extrn	_exhibit_scan:PROC
extrn	_png_title:PROC
extrn	_xp3_arc_load:PROC
extrn	_xp3_next:PROC
extrn	_exe_size:PROC
extrn	_xp3_findsign:PROC
extrn	_aoimy_crypt:PROC
extrn	_aoimy_sign:DWORD
extrn	_nitro_pak_checksum:PROC
extrn	_n3pk_xor:PROC
extrn	_n3pk_init:PROC
extrn	_qlie_checksum:PROC
extrn	_epa_dist:PROC

extrn	_rlseen_xor:PROC
extrn	_reallive_pack:PROC

extrn	_repipack_table:PROC
extrn	_repipack_md5:PROC
extrn	_ypf_crypt:PROC
extrn	_th123_crypt_init:PROC
extrn	_th123_crypt:PROC
extrn	_twister_init:PROC
extrn	_twister_next:PROC
extrn	_twister_one:PROC
extrn	_exe_timestamp:PROC
extrn	_warc_init:PROC
extrn	_warc_scan:PROC
extrn	_warc_readkey:PROC
extrn	_warc_crypt:PROC
extrn	_pp_select:PROC
extrn	_pp_crypt:PROC
extrn	_minori_select:PROC
extrn	_minori_test:PROC
extrn	_minori_crypt:PROC
extrn	_minori_table:PROC
extrn	_npa1_select:PROC
extrn	_npa1_crypt_names:PROC
extrn	_npa1_crypt_init:PROC
extrn	_xp3_select:PROC
extrn	_xp3_crypt:PROC
extrn	_majiro_arc_load:PROC
extrn	_majiro_mjo_decrypt:PROC
extrn	_glib2_tab:PROC

; IFNDEF @SYS_EXTERN
; @SYS_EXTERN = 11111b	; size,seek,write,read,mem
; ENDIF
IFDEF @SYS_EXTERN
IF (@SYS_EXTERN AND 1)		; memory
extrn	_MemAlloc:PROC
extrn	_MemFree:PROC
ENDIF
IF (@SYS_EXTERN AND 2)		; file read
extrn	_FileRead:PROC
ENDIF
IF (@SYS_EXTERN AND 4)		; file write
extrn	_FileWrite:PROC
ENDIF
IF (@SYS_EXTERN AND 8)		; file seek
extrn	_FileSeek:PROC
ENDIF
IF (@SYS_EXTERN AND 10h)	; file size
extrn	_FileGetSize:PROC
ENDIF
IF (@SYS_EXTERN AND 1Eh)	; file create, file close

; WRITE = 1, READ = 2, SH_READ = 4, SH_WRITE = 8

; CREATE_NEW		= 1
; CREATE_ALWAYS		= 2
; OPEN_EXISTING		= 3
; OPEN_ALWAYS		= 4
; TRUNCATE_EXISTING	= 5

FILE_INPUT = 36h	; READ+SH_READ+OPEN_EXISTING*16
FILE_OUTPUT = 21h	; WRITE+CREATE_ALWAYS*16
FILE_ADD = 45h		; WRITE+SH_READ+OPEN_ALWAYS*16
FILE_PATCH = 37h	; WRITE+READ+SH_READ+OPEN_EXISTING*16

extrn	_FileCreate:PROC
extrn	_FileClose:PROC
ENDIF
IF (@SYS_EXTERN AND 20h)	; exit
extrn	_ExitProcess:PROC
ENDIF
IF (@SYS_EXTERN AND 40h)	; dispstr
extrn	_DispStr:PROC
ENDIF
ENDIF	; @SYS_EXTERN
