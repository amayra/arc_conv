
; "RealKanojo" data\rk??.pp
; RealKanojo.exe
; 005B2170 decode1
; 005B393A file_read
; 00448DD0
; 0040197F key

	dw 0
_arc_illusion PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1

	enter	@@stk+8, 0
	mov	esi, esp

	call	_ArcParam
	db 'pp', 0
	call	_pp_select, eax
	jc	@@9a
	dec	eax
	je	_mod_illusion_sb3
	mov	[@@L0], eax

	call	_FileRead, [@@S], esi, 5
	jc	@@9a
	pop	ecx
	pop	edx
	cmp	[@@L0], 4	; 0x03 ^ 0x34
	sbb	eax, eax
	lea	eax, [eax+eax+37h]
	xor	eax, ecx
	xchg	al, dl
	mov	edi, 0DE022C34h
	ror	eax, 8
	movzx	edx, dl
	xor	eax, edi
	mov	[@@N], eax
	imul	ebx, eax, 10Ch
	dec	eax
	shr	eax, 14h
	lea	ecx, [ebx+5]
	or	eax, edx
	jne	@@9a
	call	_FileSeek, [@@S], ecx, 0
	jc	@@1a
	lea	ecx, [@@L1]
	call	_FileRead, [@@S], ecx, 4
	xor	edi, [@@L1]
	sub	edi, 9
	cmp	edi, ebx
	jne	@@9
	call	_FileSeek, [@@S], 5, 0
	jc	@@1a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_pp_crypt, 0, esi, ebx
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	mov	edi, 104h
	call	_ArcName, esi, edi
	lea	esi, [esi+edi+8]
	and	[@@D], 0
	mov	edi, [esi-4]
	mov	ebx, [esi-8]
	call	_FileSeek, [@@S], edi, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	call	_pp_crypt, [@@L0], [@@D], ebx
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_mod_illusion_sb3 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0

	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	pop	ebx
	pop	edx
	lea	ecx, [ebx-1]
	shr	ecx, 14h
	jne	@@9a
	mov	[@@N], ebx
	imul	ebx, 24h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	ecx, [@@N]
	mov	esi, [@@M]
	shl	ecx, 5
	lea	eax, [esi+ecx]
	mov	[@@L0], eax
	call	@@3, esi, ecx
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	call	_ArcName, esi, 20h
	add	esi, 20h
	and	[@@D], 0
	mov	eax, [@@L0]
	mov	ebx, [eax]
	add	eax, 4
	mov	[@@L0], eax
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	call	@@3, [@@D], ebx
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3 PROC
	mov	ecx, [esp+8]
	mov	edx, [esp+4]
	test	ecx, ecx
	je	@@9
@@1:	neg	byte ptr [edx]
	inc	edx
	dec	ecx
	jne	@@1
@@9:	ret	8
ENDP

ENDP
