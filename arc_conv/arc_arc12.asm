
; "Mimikko Yomekko"
; "Nessa no Rakuen" dat0?, system, setup
; nsr.exe

; 00401FE0 lzss_unpack(not)

	dw 0
_arc_arc12 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1

	enter	@@stk+0Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@9a
	pop	eax
	pop	ecx
	pop	ebx
	sub	eax, '1CRA'
	lea	edx, [ecx-1]
	bswap	eax
	mov	[@@N], ecx
	mov	[@@L0], eax
	shr	eax, 1
	shr	edx, 14h
	or	eax, edx
	jne	@@9a
	imul	eax, ecx, -9
	imul	edx, ecx, 0FFh
	lea	eax, [eax+ebx-8]
	cmp	eax, edx
	jae	@@9a
	lea	ecx, [ebx-0Ch]
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 4, ecx, 0
	jc	@@9
	mov	esi, [@@M]
	mov	edx, [@@L0]
	mov	[esi], ebx
	neg	edx
	sub	ebx, 8
	call	@@5
	jc	@@9
	cmp	eax, [@@N]
	jne	@@9
	call	_ArcCount, eax
	call	_ArcDbgData, esi, ebx

	cmp	[@@L0], 0
	je	@@1
	call	_FileGetSize, [@@S]
	mov	[@@L1], eax

@@1:	movzx	edi, byte ptr [esi+8]
	add	esi, 9
	call	_ArcName, esi, edi
	and	[@@D], 0
	mov	eax, [esi-9]
	mov	ebx, [esi-5]
	add	esi, edi
	xchg	edi, eax
	call	_FileSeek, [@@S], edi, 0
	jc	@@1a
	mov	eax, [@@L0]
	test	eax, eax
	jne	@@2a
@@1c:	xchg	edi, eax
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	test	ebx, ebx
	je	@@1a
	test	edi, edi
	je	@@1a
	mov	edx, [@@D]
	mov	ecx, ebx
@@1b:	not	byte ptr [edx]
	inc	edx
	dec	ecx
	jne	@@1b
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	call	_ArcGetExt
	cmp	eax, 'gnp'
	je	@@1c
	sub	eax, 'ggo'
	je	@@1c
	mov	eax, [@@L1]
	cmp	[@@N], 1
	je	@@2b
	mov	eax, [esi]
	sub	eax, edi
	jb	@@1a
@@2b:	xchg	edi, eax
	lea	eax, [@@D]
	call	_ArcMemRead, eax, ebx, edi, 0
	push	eax
	push	edx
	xchg	ecx, eax
	call	_arc12_lzss_crypt
	call	_lzss_unpack, [@@D], ebx
	jmp	@@1a

@@5 PROC
	push	ebx
	push	esi
	xor	ecx, ecx
@@1:	sub	ebx, 9
	jb	@@9
	add	esi, 8
	xor	eax, eax
	lodsb
	sub	ebx, eax
	jb	@@9
	test	edx, edx
	je	@@1b
	test	eax, eax
	je	@@1b
@@1a:	xor	[esi], dl
	inc	esi
	dec	eax
	jne	@@1a
@@1b:	add	esi, eax
	inc	ecx
	test	ebx, ebx
	jne	@@1
@@9:	neg	ebx
	xchg	eax, ecx
	pop	esi
	pop	ebx
	ret
ENDP

ENDP
