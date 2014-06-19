
; "Kuims", "Nitro Royale" *.pak
; N3RWops.dll
; 100023F0 decode

	; 00 00 00 00
	; 13 57 00 05

	; 34 F9 00 0F
	; 4E 00 62 F2
	; 74 00 BC A3
	; 3A 00 DE 51
	; 27 AE 00 0A
	; 5F 4C 0A AA
	; AA 41 02 27

	dw 0
_arc_n3pk_enc PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0

	enter	@@stk+0Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@9a
	mov	eax, [esi]
	mov	ebx, 0AAAAAAAAh
	push	8
	xor	eax, 'kP3N'
	pop	edx
	cmp	eax, ebx
	jne	$+4
	xor	eax, eax
	cmp	al, 13h
	jne	@@2a
	xor	eax, 0AA0000h
@@2a:	shl	eax, 1
	jnc	$+7
	xor	eax, 0DB710641h
	dec	edx
	jne	@@2a
	shr	eax, 8
	jne	@@9a
	sub	esp, 400h
	mov	[@@L0], esp
	call	_n3pk_init, esp
	mov	edi, esp
	mov	eax, [esi]
	or	ecx, -1
	xor	eax, 'kP3N'
	repne	scasd
	not	ecx
	lea	edi, [ecx-1]
	; 0x9A
	call	_n3pk_xor, esi, 0Ch, [@@L0], edi
	mov	eax, [esi+8]	; "NitroRoyale" 0x0D19229A
	mov	ebx, [esi+4]
	xor	eax, edi
	test	al, al
	jne	@@9a
	lea	eax, [ebx-1]
	mov	[@@N], ebx
	shr	eax, 14h
	jne	@@9a
	imul	ebx, 98h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	mov	ecx, [@@N]
@@2b:	push	ecx
	call	_n3pk_xor, esi, 98h, [@@L0], edi
	pop	ecx
	add	esi, 98h
	dec	ecx
	jne	@@2b
	mov	esi, [@@M]
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	lea	edi, [esi+16h]
	xor	eax, eax
	lea	ecx, [eax+3Fh]
	mov	edx, edi
	cmp	[edi], al
	je	@@1d
	repne	scasb
	jne	@@8
	mov	byte ptr [edi-1], 2Fh
@@1d:	push	esi
	lea	esi, [esi+56h]
	lea	ecx, [eax+10h]
	rep	movsd
	pop	esi
	stosb
	call	_ArcName, edx, -1

	mov	ebx, [esi+4]
	and	[@@D], 0
	call	_FileSeek, [@@S], dword ptr [esi], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	test	ebx, ebx
	je	@@1a
	mov	eax, [esi+10h]
	test	al, 2
	je	@@1a
	shr	eax, 10h
	mov	ecx, ebx
	dec	eax
	je	@@1c
	dec	eax
	jne	@@1a
	mov	eax, 400h
	cmp	ecx, eax
	jb	$+3
	xchg	ecx, eax
@@1c:	movzx	eax, byte ptr [esi+15h]
	call	_n3pk_xor, [@@D], ecx, [@@L0], eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 98h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
