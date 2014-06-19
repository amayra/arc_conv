
; "Steins;Gate" *.npa
; STEINSGATE.exe
; 004A5390 decode
; 004A5330 key_init

	dw 0
_arc_npa_sg PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@SC

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	pop	ebx
	cmp	ebx, 14h
	jb	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	@@3, esi, ebx
	mov	eax, [esi]
	mov	[@@N], eax
	dec	eax
	shr	eax, 14h
	jne	@@9
	mov	eax, [esi+4]
	lea	edx, [eax+10h]
	lea	ecx, [ebx+4]
	cmp	ebx, edx
	jb	@@9
	cmp	dword ptr [esi+0Ch+eax], ecx
	jne	@@9
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx
	sub	ebx, 4
	add	esi, 4
	mov	[@@SC], ebx

@@1:	sub	[@@SC], 10h
	jb	@@9
	lodsd
	sub	[@@SC], eax
	jb	@@9
	xchg	ebx, eax
	call	_ArcName, esi, ebx
	lea	esi, [esi+ebx+0Ch]
	and	[@@D], 0
	mov	ebx, [esi-0Ch]
	call	_FileSeek, [@@S], dword ptr [esi-8], 0
	jc	@@1a
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
	push	ebx
	mov	edx, [esp+8]
	mov	ebx, [esp+0Ch]
	push	0B4BCB6ABh
	push	0B4BCAABDh
	xor	ecx, ecx
	test	ebx, ebx
	je	@@9
@@1:	mov	al, [esp+ecx]
	inc	ecx
	xor	[edx], al
	inc	edx
	and	ecx, 7
	dec	ebx
	jne	@@1
@@9:	pop	ecx
	pop	ecx
	pop	ebx
	ret	8
ENDP

ENDP
