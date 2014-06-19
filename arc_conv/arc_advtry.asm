
; "Tsuki to Mahou to Taiyo to", "Chokotto Vampire!" *.dat

	dw 0
_arc_advtry PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 8
@M0 @@P
@M0 @@L1

	enter	@@stk+200h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 200h
	sub	eax, 24h
	jb	@@9a
	mov	[@@L0], eax

	; 08,0C
	; "TrpAdTRY", "Tsuki to Mahou to Taiyo to"
	; "SETSUEI-", "Kindan"
	; "CHOKOPAI", "Chokotto Vampire!"

@@2a:	mov	ebx, [esi]
	mov	edi, [esi+4]
	xor	ebx, 'HCRA'
	xor	edi, 'EVI'
	mov	eax, ebx
	or	eax, edi
	shr	eax, 10h
	jne	@@2c
	mov	ecx, [esi+20h]
	xor	ecx, ebx
	mov	[@@N], ecx
	dec	ecx
	mov	eax, [esi+0Ch]
	mov	edx, [esi+14h]
	xor	eax, edi
	xor	edx, edi
	sub	eax, 24h
	sub	edx, 114h
	or	eax, edx
	shr	ecx, 14h
	or	eax, ecx
	je	@@2b
@@2c:	inc	esi
	dec	[@@L0]
	jns	@@2a
@@2b:	mov	eax, [esi+10h]
	sub	esi, esp
	mov	[@@L0], ebx
	xor	eax, ebx
	mov	[@@L0+4], edi
	add	eax, esi
	jc	@@9a
	mov	[@@P], eax
	mov	[@@L1], esi

	call	_FileSeek, [@@S], eax, 0
	jc	@@9a
	imul	ebx, [@@N], 114h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	@@3, esi, ebx
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	mov	edi, 100h
	inc	esi
	call	_ArcName, esi, edi
	lea	esi, [esi+edi+13h]
	and	[@@D], 0
	mov	eax, [esi-0Ch]
	mov	ebx, [esi-8]
	add	eax, [@@L1]
	jc	@@1a
	mov	[@@P], eax
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	test	ebx, ebx
	je	@@1a
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

@@3:	push	edi
	mov	edx, [@@P]
	mov	edi, [esp+8]
	mov	ecx, [esp+0Ch]
	sub	edx, [@@L1]
@@3a:	and	edx, 7
	mov	al, byte ptr [@@L0+edx]
	inc	edx
	xor	[edi], al
	inc	edi
	dec	ecx
	jne	@@3a
	pop	edi
	ret	8
ENDP
