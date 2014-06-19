
; "Four-Leaf", "Neko Koi!", "Suzukaze no Melt" pac\*.ypf
; Four-leaf.exe
; 0042F344 open

; sliscy_T.exe, sliscy.exe
; 006DC998 "ysbin\yscfg.ybn"
; 005682A0 length_tab

	dw 0
_arc_ypf PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+20h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 20h
	jc	@@9a
	pop	eax
	pop	edi
	pop	ecx
	pop	ebx
	cmp	eax, 'FPY'
	jne	@@9a
	imul	eax, ecx, 17h
	mov	[@@N], ecx
	dec	ecx
	cmp	ebx, eax
	jb	@@9a
	shr	ecx, 14h
	jne	@@9a
	imul	ecx, [@@N], 8
	add	ecx, 3
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, ecx
	xchg	ebx, eax
	mov	esi, [@@M]

	call	_ArcParamNum, -1
	db 'ypf', 0
	mov	edx, eax
	shr	edx, 8
	neg	edx
	sbb	edx, edx
	or	edx, eax

	mov	ecx, [@@N]
	xchg	eax, edi
	push	ebx
	call	@@5
	test	eax, eax
	je	@@9
	mov	[@@N], eax
	call	_ArcCount, eax
	call	_ArcDbgData, esi, ebx
	pop	ebx
	lea	edi, [ebx+3]
	and	edi, -4
	add	esi, edi
	call	@@Sort, esi, [@@N]

@@1:	mov	edi, [esi]
	movzx	ebx, byte ptr [edi+4]
	add	edi, 5
	call	_ArcName, edi, ebx
	add	edi, ebx
	and	[@@D], 0
	mov	ebx, [edi+6]
	call	_FileSeek, [@@S], dword ptr [edi+0Ah], 0
	jc	@@1a
	lea	eax, [@@D]
	cmp	byte ptr [edi+1], 1
	mov	edi, [edi+2]
	je	@@2a
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 8
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	call	_ArcMemRead, eax, edi, ebx, 0
	call	_zlib_unpack, [@@D], edi, edx, eax
	jmp	@@1b

@@5 PROC	; esi, ebx

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]
@@N = dword ptr [ebp-0Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	push	eax
	push	edx
	push	ecx
	push	ecx
	lea	edi, [ebx+3]
	and	edi, -4
	add	edi, esi
@@1:	sub	ebx, 17h
	jb	@@9
	mov	eax, esi
	stosd
	movzx	eax, byte ptr [esi+4]
	xor	al, -1
	call	_ypf_crypt, [@@L0], eax
	mov	[esi+4], al
	sub	ebx, eax
	jb	@@9
	mov	edx, [@@L1]
	test	eax, eax
	je	@@3a
	test	edx, edx
	jns	@@3
	cmp	eax, 4
	jb	@@9
	movzx	edx, byte ptr [esi+5+eax-4]
	xor	edx, 2Eh
	mov	[@@L1], edx
@@3:	xor	[esi+5], dl
	inc	esi
	dec	eax
	jne	@@3
@@3a:	mov	eax, [esi+5+0Ah]
	add	esi, 17h
	stosd
	dec	[@@N]
	jne	@@1
@@9:	sub	[ebp+0Ch], ebx
	pop	eax
	pop	edx
	sub	eax, edx
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret
ENDP

@@Sort PROC

@@S = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	xor	ecx, ecx
	jmp	@@4
@@1:	mov	eax, [ebx-4]
	mov	edx, [ebx+4]
	cmp	edx, eax
	jae	@@4
	mov	[ebx-4], edx
	mov	[ebx+4], eax
	mov	edi, [ebx]
	mov	esi, [ebx-8]
	mov	[ebx-8], edi
	mov	[ebx], esi
	sub	ebx, 8
	cmp	ebx, [@@S]
	jne	@@1
@@4:	inc	ecx
	mov	eax, [@@S]
	lea	ebx, [eax+ecx*8]
	cmp	ecx, [@@C]
	jb	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

ENDP
