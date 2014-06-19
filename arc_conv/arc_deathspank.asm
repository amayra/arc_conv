
; "DeathSpank" GameData-*.gg

; 004973AD name_decode
; 0051D9F0 data_decode
; 00531B37 tab_init

	dw 0
_arc_deathspank PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	edx
	pop	ebx
	pop	ecx
	sub	eax, 0D9B48B81h
	sub	edx, 20000h
	lea	edi, [ecx-1]
	or	eax, edx
	jne	@@9a
	shr	edi, 14h
	jne	@@9a
	mov	[@@N], ecx
	mov	[@@L0], ebx

	; 0x330-"DeathSpank", 0x3D0-"DeathSpank: Thongs of Virtue"

	call	_ArcParamNum, 330h
	db 'deathspank', 0
	cmp	eax, 10h
	jb	@@9a
	call	_FileSeek, [@@S], eax, 0
	jc	@@9a

	imul	ecx, [@@N], 24h
	add	ecx, ebx
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ecx, 0
	jc	@@9
	mov	edi, [@@M]
	lea	esi, [edi+ebx]
	call	@@NameDecode
	call	_ArcCount, [@@N]
	imul	ecx, [@@N], 24h
	add	ecx, ebx
	call	_ArcDbgData, edi, ecx

	sub	esp, 100h
	call	@@InitTab, 0AD66h, esp
	mov	[@@L1], esp
	sub	esp, 200h

@@1:	mov	edi, esp
	mov	eax, [esi]
	call	@@3
	mov	eax, [esi+4]
	call	@@3
	mov	edx, esp
	sub	edi, esp
	call	_ArcName, edx, edi
	and	[@@D], 0
	mov	edi, [esi+14h]
	mov	ebx, [esi+18h]
	call	_FileSeek, [@@S], dword ptr [esi+20h], 0
	jc	@@1a
	lea	eax, [@@D]
	cmp	dword ptr [esi+1Ch], 0
	jne	@@1c
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
	test	ebx, ebx
	je	@@1a
	cmp	dword ptr [esi+10h], 12h	; bik
	je	@@1a
	mov	edx, [@@L1]
	mov	edi, [@@D]
	mov	ecx, ebx
@@1d:	movzx	eax, byte ptr [edi]
	mov	al, [edx+eax]
	stosb
	dec	ecx
	jne	@@1d
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 24h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@1c:	call	_ArcMemRead, eax, edi, ebx, 0
	call	_zlib_unpack, [@@D], edi, edx, eax
	jmp	@@1b

@@3:	mov	ecx, [@@L0]
	mov	edx, [@@M]
	sub	ecx, eax
	jb	@@3c
	add	edx, eax
	jmp	@@3b
@@3a:	cmp	edi, [@@L1]
	je	$+3
	stosb
@@3b:	dec	ecx
	js	@@3c
	mov	al, [edx]
	inc	edx
	test	al, al
	jne	@@3a
@@3c:	ret

@@NameDecode PROC
	push	ebx
	push	edi
@@1:	mov	cl, 87h
	jmp	@@3
@@2:	xor	[edi-1], cl
	inc	ecx
@@3:	dec	ebx
	js	@@9
	mov	al, [edi]
	inc	edi
	test	al, al
	jne	@@2
	jmp	@@1
@@9:	pop	edi
	pop	ebx
	ret
ENDP

@@InitTab PROC
	push	ebx
	push	esi
	push	edi
	enter	100h, 0
	mov	edi, esp
	mov	eax, 3020100h
@@1:	stosd
	add	eax, 4040404h
	jnc	@@1
	mov	eax, [ebp+14h]
	imul	esi, eax, 0Ah
	sar	esi, 10h
	adc	esi, 0Ah
	xor	ecx, ecx
@@2:	imul	eax, 6255h
	add	eax, 3619h
	movzx	eax, ax
	imul	edi, eax, 0FFh
	sar	edi, 10h
	adc	edi, 0
	mov	dl, [esp+ecx]
	mov	bl, [esp+edi]
	mov	[esp+ecx], bl
	mov	[esp+edi], dl
	inc	cl
	jne	@@2
	dec	esi
	jne	@@2
	xor	eax, eax
	mov	edi, [ebp+18h]
@@3:	movzx	edx, byte ptr [esp+eax]
	mov	[edi+edx], al
	add	al, 1
	jne	@@3
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

ENDP
