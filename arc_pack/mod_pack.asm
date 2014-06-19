	.686
	.MMX
	.model flat, stdcall

	includelib import32.lib

@SYS_EXTERN = 0011111b	; dispstr,exit,size,seek,write,read,mem
@SYS_UNICODE = 1

	.code

extrn	ExitProcess:PROC
_ExitProcess = ExitProcess

	include ..\include\include.asm

public _mod_pack
_mod_pack PROC

@M0 macro p0
@@stk=@@stk+4
p0=dword ptr [ebp-@@stk]
endm
@@stk = 0
@M0 @@M
@M0 @@L0
@M0 @@L1
@M0 @@L2
@M0 @@N
@M0 @@D
PURGE @M0

	enter	@@stk, 0
	cmp	eax, 1+3
	jb	@@9a
	mov	esi, offset @@fmt
	xor	eax, eax
	jmp	@@2a
@@2:	lodsb
	test	al, al
	jne	@@2
	add	esi, 5
@@2a:	mov	edi, [ebp+0Ch]
	cmp	[esi], al
	je	@@9a
@@2b:	lodsb
	scasw
	jne	@@2
	test	al, al
	jne	@@2b
	mov	[@@L0], esi
	call	_BlkCreate, 4000h
	jc	@@9a
	mov	[@@M], eax
	xor	eax, eax
	lea	edx, [@@L1]
	mov	[@@N], eax
	mov	[@@L2], edx
	mov	[edx], eax
	call	_FindFile, offset @@3, dword ptr [ebp+10h]

	mov	ecx, [@@N]
	shl	ecx, 2
	add	ecx, 0Ch+8
	call	_BlkAlloc, [@@M], ecx
	jc	@@3a
	xchg	edi, eax
	mov	eax, [@@M]
	stosd
	stosd
	stosd
	mov	[@@L2], edi
	stosd
	mov	eax, [@@L1]
	stosd
	mov	esi, [@@L0]
	lodsb
	call	@@Filter, [@@L2], eax
	jc	@@9
	lodsd
	add	esi, eax

	call	_FileCreate, dword ptr [ebp+14h], FILE_OUTPUT+2
	jc	@@9
	mov	[@@D], eax
	mov	eax, [ebp+4]
	lea	edx, [ebp+18h]
	sub	eax, 4
	call	esi, [@@D], [@@L2], edx, eax
	add	esp, 10h
	call	_ArcLocalFree
	call	_FileClose, [@@D]
@@9:	call	_BlkDestroy, [@@M]
@@9a:	leave
	call	_ExitProcess, 0

@@3:	cmp	dword ptr [esp+4], 0
	je	@@3b
	mov	esi, [esp+8]
	mov	ebx, [esp+14h]
	sub	ebx, esi
	lea	eax, [ebx+24h+0Ch+4]
	shr	ebx, 1
	call	_BlkAlloc, [@@M], eax
	jc	@@3a
	mov	edi, [esp+0Ch]
	mov	edx, [esp+10h]
	sub	edx, edi
	shr	edx, 1
	mov	[eax], edx
	add	eax, 4
	mov	edx, [@@L2]
	mov	[@@L2], eax
	mov	[edx], eax
	inc	[@@N]
	xchg	edi, eax
	xchg	edx, eax
	xor	eax, eax
	sub	edx, esi
	lea	ecx, [eax+9]
	shr	edx, 1
	stosd
	lea	eax, [edi+2Ch+edx*2]
	stosd
	lea	eax, [ebx-1]
	sub	eax, edx
	stosd
	mov	eax, [esp+4]
	xchg	esi, eax
	rep	movsd
	xchg	esi, eax
	mov	ecx, ebx
	rep	movsw
@@3a:	xor	eax, eax
	inc	eax
	ret

@@3b:	mov	eax, [@@L2]
	inc	dword ptr [eax-2]
	jmp	@@3a

@@Filter PROC

@@S = dword ptr [ebp+14h]
@@F = byte ptr [ebp+18h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@S]
	push	dword ptr [edi-4]
	push	0
	push	0
	add	edi, 4
	mov	esi, edi
@@1:	mov	ebx, esi
@@2:	mov	esi, [esi]
	test	esi, esi
	je	@@3
	movzx	eax, word ptr [esi-2]
	test	byte ptr [esi+0Ch], 10h
	je	@@2a
	test	[@@F], 2
	jne	@@2f
	test	[@@F], 4
	je	@@2
	dec	eax
	js	@@2f
	jmp	@@2b

@@2a:	test	[@@F], 8
	jne	@@2c
	cmp	dword ptr [esi+28h], 0
	je	@@2c
@@2b:	add	[ebx-2], eax
	jmp	@@2

@@2f:	inc	dword ptr [ebp-0Ch]
@@2c:	test	[@@F], 4
	je	@@2d
	movzx	eax, word ptr [esi-4]
	sub	[esi+8], eax
	shl	eax, 1
	add	[esi+4], eax
@@2d:	test	[@@F], 1
	jne	@@2e
	call	@@932
	jc	@@9
@@2e:	mov	eax, [esi+8]
	add	[ebp-8], eax
@@3:	mov	[ebx], esi
	mov	[edi], esi
	add	edi, 4
	test	esi, esi
	jne	@@1
	mov	edx, [@@S]
	sub	edi, edx
	shr	edi, 2
	pop	dword ptr [edx-0Ch]
	lea	eax, [edi-2]
	pop	dword ptr [edx-8]
	mov	[edx], eax

	test	[@@F], 4
	je	@@4d
	mov	esi, [edx+4]
	test	esi, esi
	je	@@4d
@@4:	mov	edx, esi
	mov	esi, [esi]
	movzx	ecx, word ptr [edx-2]
	test	byte ptr [edx+0Ch], 10h
	je	@@4a
	push	edx
	sub	edx, 4
	mov	[edx], esi
@@4a:	test	ecx, ecx
	je	@@4c
@@4b:	and	dword ptr [edx], 0
	pop	edx
	dec	ecx
	jne	@@4b
	mov	[edx], esi
@@4c:	test	esi, esi
	jne	@@4
@@4d:	clc
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@932 PROC
	push	ebp
	mov	ebp, esp
	mov	ecx, [esi+8]
	lea	eax, [ecx+ecx+4]
	and	eax, -4
	sub	esp, eax
	call	_unicode_to_ansi, 932, dword ptr [esi+4], ecx, esp
	mov	[esi+8], eax
	inc	eax
	call	_BlkAlloc, dword ptr [ebp+10h], eax
	jc	@@9
	push	edi
	xchg	edi, eax
	mov	ecx, [esi+8]
	mov	[esi+4], edi
	inc	ecx
	lea	eax, [esp+4]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	pop	edi
;	clc
@@9:	leave
	ret
ENDP

ENDP

_ArcAddFile PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@C = dword ptr [ebp+1Ch]

	push	ebx
	push	esi
	push	edi
	enter	0FFCh, 0
	push	ecx
	xor	ecx, ecx
	mov	edi, esp
	push	ecx
	push	ecx
	call	_FileCreate, [@@S], FILE_INPUT
	jc	@@9
	xchg	esi, eax
	mov	ebx, 1000h
@@1:	call	_FileRead, esi, edi, ebx
	test	eax, eax
	je	@@2
	add	[edi-8], eax
	adc	dword ptr [edi-4], 0
	mov	edx, [@@C]
	push	eax
	push	eax
	test	edx, edx
	je	@@3
	push	ebp
	mov	ebp, [ebp]
	push	ebx
	push	esi
	push	edi
	mov	esi, edi
	xchg	ebx, eax
	call	edx
	pop	edi
	pop	esi
	pop	ebx
	pop	ebp
@@3:	call	_FileWrite, [@@D], edi
	pop	eax
	cmp	eax, ebx
	je	@@1
@@2:	call	_FileClose, esi
@@9:	pop	eax
	pop	edx
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

_ArcLoadFile PROC
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	xor	esi, esi
	xor	ebx, ebx
	xor	edi, edi
	mov	eax, [ebp+1Ch]
	add	eax, [ebp+20h]
	jc	@@9
	add	eax, [ebp+24h]
	jc	@@9
	call	_MemAlloc, eax
	jc	@@9
	xchg	edi, eax
	mov	esi, [ebp+1Ch]
	add	esi, edi
	call	_FileCreate, dword ptr [ebp+18h], FILE_INPUT
	jc	@@9
	xchg	edx, eax
	mov	ecx, [ebp+20h]
	push	edx
	test	ecx, ecx
	je	@@9a
	call	_FileRead, edx, esi, ecx
	xchg	ebx, eax
@@9a:	call	_FileClose
@@9:	mov	ecx, [ebp+14h]
	xchg	eax, ebx
	mov	edx, esi
	mov	[ecx], edi
	cmp	edx, 1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h
ENDP

_ArcPackFile PROC

@@D = dword ptr [ebp+14h]
@@F = dword ptr [ebp+18h]
@@SC = dword ptr [ebp+1Ch]
@@DC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp+24h]
@@P = dword ptr [ebp+28h]
@@E = dword ptr [ebp+2Ch]

@@M = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	xor	ebx, ebx
	mov	edi, [@@DC]
	push	ecx
	mov	eax, esp
	call	_ArcLoadFile, eax, [@@F], ebx, [@@SC], edi
	jc	@@9
	xchg	ebx, eax
	mov	esi, [@@M]
	test	edi, edi
	je	@@2
	lea	eax, [esi+ebx]
	call	[@@P], eax, edi, esi, ebx
	cmp	[@@L0], 0
	jne	@@1
	cmp	eax, ebx
	jae	@@2
	inc	[@@L0]
@@1:	add	esi, ebx
	xchg	ebx, eax
	test	ebx, ebx
	je	@@9
@@2:	mov	edx, [@@E]
	test	edx, edx
	je	@@3
	push	ebp
	mov	ebp, [ebp]
	push	ebx
	push	esi
	push	edi
	mov	edi, esi
	call	edx
	pop	edi
	pop	esi
	pop	ebx
	pop	ebp
@@3:	call	_FileWrite, [@@D], esi, ebx
	xchg	ebx, eax
@@9:	call	_MemFree, [@@M]
	mov	ecx, [@@L0]
	xchg	eax, ebx
	neg	ecx
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	1Ch
ENDP

_string_copy_ansi PROC
	push	esi
	push	edi
	mov	edi, [esp+0Ch]
	mov	ecx, [esp+10h]
	mov	esi, [esp+14h]
	xor	eax, eax
	test	ecx, ecx
	mov	edx, ecx
	je	@@2
@@1:	lodsb
	test	al, al
	je	@@2
	stosb
	dec	ecx
	jne	@@1
@@2:	sub	edx, ecx
	rep	stosb
	xchg	eax, edx
	pop	edi
	pop	esi
	ret	0Ch
ENDP

_string_copy_unicode PROC
	push	esi
	push	edi
	mov	edi, [esp+0Ch]
	mov	ecx, [esp+10h]
	mov	esi, [esp+14h]
	xor	eax, eax
	test	ecx, ecx
	mov	edx, ecx
	je	@@2
@@1:	lodsw
	test	eax, eax
	je	@@2
	stosw
	dec	ecx
	jne	@@1
@@2:	sub	edx, ecx
	rep	stosw
	xchg	eax, edx
	pop	edi
	pop	esi
	ret	0Ch
ENDP

_sjis_slash PROC
	mov	edx, [esp+4]
@@1:	mov	al, [edx]
	call	_sjis_test
	jc	@@1a
	inc	edx
	mov	al, [edx]
	jmp	@@1b
@@1a:	cmp	al, 5Ch
	jne	@@1b
	mov	byte ptr [edx], 2Fh
@@1b:	inc	edx
	test	al, al
	jne	@@1
	ret	4
ENDP

_unicode_slash PROC
	mov	edx, [esp+4]
@@1:	movzx	eax, word ptr [edx]
	cmp	eax, 5Ch
	jne	@@1a
	mov	byte ptr [edx], 2Fh
@@1a:	inc	edx
	inc	edx
	test	eax, eax
	jne	@@1
	ret	4
ENDP

_filelist_sort PROC

@@S = dword ptr [ebp+14h]

@@N = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@S]
	lodsd
	mov	[@@S], esi
	push	eax
	test	eax, eax
	je	@@9

	xor	ebx, ebx
	jmp	@@4

@@1:	push	esi
	mov	edi, [esi]
	mov	esi, [esi-4]
	mov	edi, [edi+4]
	mov	esi, [esi+4]
	call	dword ptr [ebp+18h]
	pop	esi
	je	@@4
	sbb	eax, eax
	xor	eax, [ebp+1Ch]
	jne	@@4
	mov	eax, [esi-4]
	mov	edx, [esi]
	mov	[esi], eax
	mov	[esi-4], edx
	sub	esi, 4
	cmp	esi, [@@S]
	jne	@@1
@@4:	mov	esi, [@@S]
	inc	ebx
	lea	esi, [esi+ebx*4]
	cmp	ebx, [@@N]
	jb	@@1

	mov	esi, [@@S]
	mov	edi, esi
@@5:	lodsd
	mov	[edi], eax
	xchg	edi, eax
	dec	ebx
	jne	@@5
	mov	[edi], ebx
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

_fncmp_unicode_lower PROC
@@1:	movzx	eax, word ptr [esi]
	movzx	ecx, word ptr [edi]
	add	esi, 2
	add	edi, 2
	lea	edx, [eax-41h]
	cmp	edx, 1Ah
	sbb	edx, edx
	and	edx, 20h
	add	eax, edx
	lea	edx, [ecx-41h]
	cmp	edx, 1Ah
	sbb	edx, edx
	and	edx, 20h
	add	ecx, edx
	cmp	eax, ecx
	jne	@@2
	test	eax, eax
	jne	@@1
@@2:	ret
ENDP

_fncmp_ansi_upper PROC
@@1:	movzx	eax, byte ptr [esi]
	movzx	ecx, byte ptr [edi]
	inc	esi
	inc	edi
	lea	edx, [eax-61h]
	cmp	edx, 1Ah
	sbb	edx, edx
	and	edx, -20h
	add	eax, edx
	lea	edx, [ecx-61h]
	cmp	edx, 1Ah
	sbb	edx, edx
	and	edx, -20h
	add	ecx, edx
	cmp	eax, ecx
	jne	@@2
	test	eax, eax
	jne	@@1
@@2:	ret
ENDP

@M1 macro p1,p2
db '&p1',0
db p2
dd _arc_&p1-($+4)
endm

; 1 - unicode
; 2 - dirs
; 4 - tree
; 8 - over4gb

@@fmt:	@M1 repipack, 0
	@M1 dx3, 6
	@M1 xfl, 0
	@M1 hypack, 0
	@M1 adpack32, 0
	@M1 ikura, 0
	@M1 sgs1, 0
	@M1 xp3, 1
	@M1 tasofro, 0
	@M1 warc, 0
	@M1 ypf, 0
	@M1 sm2mpx10, 0
	@M1 pac4, 0
	@M1 arcx, 0
	@M1 aoimy, 1
	@M1 vfs101, 0
	@M1 vfs200, 1
	@M1 majiro, 0
	@M1 minori, 0
	@M1 illusion, 0
	@M1 escude, 0
	@M1 eac, 0
	@M1 ai6, 0
	@M1 ai5_dk4, 0
	@M1 npa1, 2
	@M1 ald, 0
	@M1 afa, 0
	@M1 will, 0
	@M1 ciel, 0
	@M1 arc12, 0
	@M1 vivid, 1
	@M1 glnk, 0
	@M1 ego, 0
	@M1 ddp, 0
	@M1 lcse, 0
	@M1 rlseen, 0
	@M1 mbl, 0
	@M1 nitro_pak, 0
	@M1 nsa, 0
	@M1 sysadv, 0
	@M1 gamedat, 0
	@M1 gsp, 0
	@M1 ism, 0
	@M1 foris, 1
	@M1 n3pk, 0
	@M1 qlie, 0
	@M1 list, 8
	@M1 tree, 0Fh
	db 0

PURGE @M1
ENDP

@M0 macro p0,p1
ifb <p1>
@@stk=@@stk+4
else
@@stk=@@stk+p1
endif
p0=dword ptr [ebp-@@stk]
endm

	include arc_repipack.asm
	include arc_dx3.asm
	include arc_xfl.asm
	include arc_hypack.asm
	include arc_adpack32.asm
	include arc_ikura.asm
	include arc_sgs1.asm
	include arc_xp3.asm
	include arc_tasofro.asm
	include arc_warc.asm
	include arc_ypf.asm
	include arc_sm2mpx10.asm
	include arc_pac4.asm
	include arc_arcx.asm
	include arc_vfs.asm
	include arc_majiro.asm
	include arc_minori.asm
	include arc_illusion.asm
	include arc_escude.asm
	include arc_eac.asm
	include arc_ai6.asm
	include arc_ai5_dk4.asm
	include arc_npa1.asm
	include arc_ald.asm
	include arc_afa.asm
	include arc_will.asm
	include arc_ciel.asm
	include arc_arc12.asm
	include arc_vivid.asm
	include arc_glnk.asm
	include arc_ego.asm
	include arc_ddp.asm
	include arc_lcse.asm
	include arc_rlseen.asm
	include arc_mbl.asm
	include arc_nitro_pak.asm
	include arc_nsa.asm
	include arc_sysadv.asm
	include arc_gamedat.asm
	include arc_gsp.asm
	include arc_ism.asm
	include arc_foris.asm
	include arc_n3pk.asm
	include arc_qlie.asm
	include arc_list.asm

	end