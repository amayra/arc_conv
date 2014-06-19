
; "Guren Tenshou -Rasetsu-", "Guren Tenshou -Shura-" *.pak

	dw 0
_arc_md002 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1

	enter	@@stk+28h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 28h
	jc	@@9a
	mov	ebx, [esi+24h]
	pop	eax
	pop	edx
	lea	ecx, [ebx-1]
	sub	eax, '00DM'
	sub	edx, '2'
	shr	ecx, 14h
	or	eax, edx
	or	eax, ecx
	jne	@@9a
	mov	edi, esp
	lea	ecx, [eax+5]
	repe	scasd
	jne	@@9
	mov	[@@N], ebx
	mov	eax, [esi+20h]
	sub	eax, 'V001'
	cmp	eax, 9
	jae	@@9a
	dec	eax
	mov	[@@L0], eax
	and	al, 3
	cmp	eax, 1
	sbb	eax, eax
	or	eax, [esi+1Ch]
	mov	[@@L1], eax
	imul	ebx, 30h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	@@3
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	call	_ArcName, esi, 20h
	and	[@@D], 0
	mov	ebx, [esi+2Ch]
	mov	edi, [esi+28h]
	call	_FileSeek, [@@S], dword ptr [esi+24h], 0
	jc	@@1a
	lea	eax, [@@D]
	cmp	dword ptr [esi+20h], 0
	jne	@@2a
	call	_ArcMemRead, eax, 0, ebx, 0
	call	@@4
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 30h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	call	_ArcMemRead, eax, edi, ebx, 0
	call	@@4
	call	_lzss_unpack, [@@D], edi, edx, ebx
	xchg	ebx, eax
	jmp	@@1a

@@4:	xchg	ebx, eax
	mov	eax, [@@L0]
	mov	ecx, ebx
	sub	eax, 3
	shr	eax, 2
	jne	@@4b
@@4a:	not	byte ptr [edx]
	inc	edx
	dec	ecx
	jne	@@4a
	sub	edx, ebx
@@4b:	ret

@@3:	push	ebx
	push	esi
	mov	edx, [@@N]
	mov	edi, [@@L0]
	mov	ebx, [@@L1]
	test	edi, edi
	js	@@3f
	cmp	edi, 3
	je	@@3f
	and	edi, 3
@@3a:	xor	ecx, ecx
@@3b:	mov	eax, [esi+24h+ecx*4]
	inc	ecx
	xor	eax, ebx
	cmp	edi, 3
	jne	@@3c
	rol	eax, 10h
@@3c:	shr	eax, cl
	mov	[esi+20h+ecx*4], eax
	cmp	ecx, 3
	jb	@@3b
	cmp	edi, 2
	jb	@@3e
@@3d:	xor	[esi-0Ch+ecx*4], ebx
	inc	ecx
	cmp	ecx, 0Ah
	jb	@@3d
@@3e:	add	esi, 30h
	dec	edx
	jne	@@3a
@@3f:	pop	esi
	pop	ebx
	ret
ENDP
