	.686
	.model flat, stdcall

	includelib import32.lib

@SYS_EXTERN = 0011111b	; dispstr,exit,size,seek,write,read,mem
@SYS_UNICODE = 1

	.code

extrn	ExitProcess:PROC
_ExitProcess = ExitProcess

	include ..\include\include.asm

public _mod_select
_mod_select PROC
	pop	ebx
	pop	edx
	pop	edx
	sub	ebx, 2
	jb	@@9
	mov	esi, offset @@fmt
	xor	eax, eax
	jmp	@@2a
@@2:	lodsb
	test	al, al
	jne	@@2
	add	esi, 4
@@2a:	mov	edi, edx
	cmp	[esi], al
	je	@@9
@@2b:	lodsb
	scasw
	jne	@@2
	test	al, al
	jne	@@2b
	lodsd
	add	esi, eax
	push	ebx
	xchg	eax, ebx
	call	esi
@@9:	call	_ExitProcess, 0

@M1 macro p1
db '&p1',0
dd _mod_&p1-($+4)
endm

@@fmt:	@M1 textenc
	@M1 texteol
	@M1 xor
	@M1 tga
	@M1 mask
	@M1 mskn
	@M1 compose
	@M1 pngmeta

	@M1 wip		; Will
	@M1 filecat
	@M1 ssdc43	; LittleWitch
	@M1 is256
	@M1 wcg		; Liar
	@M1 lim		; Liar
	@M1 lwg		; Liar
	@M1 cv2		; Tasofro
	@M1 epa		; gamedat
	@M1 agf		; SofthouseChara
	@M1 g00		; RealLive
	@M1 ikura	; ikura
	@M1 fontdesc
	@M1 fontdlg
	@M1 ffd_rsf	; LittleWitch
	@M1 baldr_fnt
	@M1 ai6_rmt	; Elf
	@M1 azsys	; AZSystem
	@M1 exhibit	; ExHIBIT
	@M1 warcscan	; RioShiina
	@M1 mjoscan	; Majiro
	@M1 rctfix	; Majiro
	@M1 nsa_alpha	; NScripter

	; last
	@M1 ain		; AliceSoft
	@M1 light
	@M1 kimiaru
	@M1 dx3dec
	@M1 xp3list
	@M1 promia
	db 0

PURGE @M1
ENDP

	include BmFile.asm
	include InitGDI32.asm

@M0 macro p0,p1
ifb <p1>
@@stk=@@stk+4
else
@@stk=@@stk+p1
endif
p0=dword ptr [ebp-@@stk]
endm

	include FileEnum.asm

	include mod_ain.asm
	include mod_light.asm
	include mod_kimiaru.asm
	include mod_dx3dec.asm
	include mod_xp3list.asm
	include mod_promia.asm

	include mod_xor.asm
	include mod_tga.asm
	include mod_mask.asm
	include mod_wip.asm
	include mod_filecat.asm
	include mod_textenc.asm
	include mod_texteol.asm
	include mod_ssdc43.asm
	include mod_is256.asm
	include mod_wcg.asm
	include mod_lwg.asm
	include mod_cv2.asm
	include mod_epa.asm
	include mod_agf.asm
	include mod_g00.asm
	include mod_ikura.asm
	include mod_fontdesc.asm
	include mod_ffd_rsf.asm
	include mod_baldr_fnt.asm
	include mod_ai6_rmt.asm
	include mod_azsys.asm
	include mod_exhibit.asm
	include mod_warcscan.asm
	include mod_mjoscan.asm
	include mod_rctfix.asm
	include mod_nsa_alpha.asm
	include mod_compose.asm
	include mod_pngmeta.asm

	end
