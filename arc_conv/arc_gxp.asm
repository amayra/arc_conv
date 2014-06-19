
; "Shojo to Maou to Tactics (Trial)" *.gxp
; SRPG_trial20.exe
; 005009E0 open_archive
; 004FE7A0 decrypt

	dw 0
_arc_gxp PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@L0

	enter	@@stk+30h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 30h
	jc	@@9a
	pop	eax
	pop	edx
	sub	eax, 'PXG'
	sub	edx, 64h
	or	eax, edx
	jne	@@9a
	cmp	dword ptr [esi+2Ch], 0
	jne	@@9a
	mov	ecx, [esi+14h]
	mov	eax, [esi+18h]
	mov	ebx, [esi+1Ch]
	mov	edx, [esi+28h]
	mov	[@@L0], ecx
	mov	[@@N], eax
	mov	[@@P], edx

	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	@@5
	mov	ecx, [@@N]
	cmp	eax, ecx
	jb	$+3
	xchg	eax, ecx
	lea	ecx, [eax-1]
	shr	ecx, 14h
	jne	@@9a
	mov	[@@N], eax
	call	_ArcCount, eax
	call	_ArcDbgData, esi, ebx
	call	_ArcUnicode, 1

@@1:	mov	ecx, [esi]
	lea	edx, [esi+20h]
	sub	ecx, 20h
	mov	eax, [esi+0Ch]
	shr	ecx, 1
	cmp	eax, ecx
	jb	$+3
	xchg	eax, ecx
	call	_ArcName, edx, eax
	and	[@@D], 0
	mov	ebx, [esi+4]
	cmp	dword ptr [esi+8], 0
	jne	@@1a
	mov	eax, [esi+18h]
	mov	edx, [esi+1Ch]
	add	eax, [@@P]
	adc	edx, 0
	jc	@@1a
	call	_FileSeek64, [@@S], eax, edx, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	call	@@3, [@@D], ebx, 0
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, [esi]
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@5:	push	ebx
	push	esi
	xor	edi, edi
@@5a:	cmp	ebx, 20h
	jb	@@5b
	call	@@3, esi, 4, 0
	lodsd
	cmp	eax, 20h
	jb	@@5b
	sub	ebx, eax
	jb	@@5b
	sub	eax, 4
	push	4
	push	eax
	push	esi
	add	esi, eax
	call	@@3
	inc	edi
	jmp	@@5a
@@5b:	xchg	eax, edi
	pop	esi
	pop	ebx
	ret

@@3:	cmp	[@@L0], 0
	jne	@@Decrypt
	ret	0Ch

@@Decrypt PROC

@@D = dword ptr [ebp+14h]
@@N = dword ptr [ebp+18h]
@@P = dword ptr [ebp+1Ch]

	push	ebx
	push	esi
	push	edi
	mov	ecx, [esp+14h]
	mov	ebx, [esp+18h]
	test	ecx, ecx
	je	@@9
	mov	eax, ebx
	xor	edx, edx
	lea	edi, [edx+17h]
	div	edi
	mov	edi, [esp+10h]
@@1:	mov	eax, ebx
	inc	ebx
	xor	al, byte ptr [@@T+edx]
	inc	edx
	xor	[edi], al
	inc	edi
	cmp	edx, 17h
	sbb	eax, eax
	and	edx, eax
	dec	ecx
	jne	@@1
@@9:	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch

@@T	dd 038282140h,0A5436EA6h,038282140h,064A543A6h
	dd 02024653Eh,000746E46h
ENDP

ENDP
