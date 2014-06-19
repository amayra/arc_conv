
; "Marble Bloomers" bmp.dat, chara.dat
; 6B876CD8.exe .4042F7

	dw 0
_arc_noesis PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	edx
	sub	eax, 'KCAP'
	sub	edx, '.TAD'
	or	eax, edx
	jne	@@9a
	pop	ebx
	pop	ecx
	cmp	ebx, ecx
	jne	@@9a
	lea	eax, [ebx-1]
	mov	[@@N], ebx
	shr	eax, 14h
	jne	@@9a
	imul	ebx, 30h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	lea	eax, [ebx+10h]
	cmp	[esi+20h], eax
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 20h
	and	[@@D], 0
	call	_FileSeek, [@@S], dword ptr [esi+20h], 0
	jc	@@1a
	mov	ebx, [esi+28h]
	cmp	ebx, [esi+2Ch]
	jne	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	test	byte ptr [esi+26h], 1
	je	@@1a
	mov	edi, ebx
	shr	edi, 2
	je	@@1a
	push	ebx
	push	esi
	mov	esi, edx
	mov	ecx, edi
	mov	ebx, edi
	and	ecx, 7
	add	ecx, 8
	shl	ebx, cl
	xor	ebx, edi
@@1b:	mov	eax, [esi]
	xor	eax, ebx
	mov	[esi], eax
	add	esi, 4
	mov	ecx, eax
	mov	edx, 0AAAAAAABh
	mul	edx
	shr	edx, 4
	lea	edx, [edx+edx*2]
	shl	edx, 3
	sub	ecx, edx
	rol	ebx, cl
	dec	edi
	jne	@@1b
	pop	esi
	pop	ebx
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
ENDP
