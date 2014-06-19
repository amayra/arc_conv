
; "School Days HQ" Packs\*.GPK
; SCHOOLDAYS HQ.exe

; dw fn_len, unicode_filename * n, 0
; dd 0, offset, size, method, unp_size
; db header_size, header * n

; dw 0,0 - ending

	dw 0
_arc_foris PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0

	enter	@@stk+20h, 0
	call	_FileSeek, [@@S], -20h, 2
	jc	@@9a
	mov	[@@L0], eax
	mov	esi, esp
	call	_FileRead, [@@S], esi, 20h
	jc	@@9a
	push	8
	pop	ecx
	mov	ebx, [esi+0Ch]
	mov	[esi+0Ch], ecx
	call	@@2a
	db 'STKFile0PIDX',8,0,0,0
	db 'STKFile0PACKFILE'
@@2a:	pop	edi
	repe	cmpsd
	jne	@@9a
	cmp	ebx, 6
	mov	eax, [@@L0]
	jle	@@9a
	sub	eax, ebx
	jb	@@9a
	call	_FileSeek, [@@S], eax, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	edi, [@@M]
	call	@@3
	call	_MemAlloc, dword ptr [edi]
	jc	@@9
	mov	[@@M], eax
	xchg	esi, eax
	mov	eax, [edi]
	sub	ebx, 4
	add	edi, 4
	call	_zlib_unpack, esi, eax, edi, ebx
	xchg	ebx, eax
	call	_MemFree, edi

	call	@@5
	mov	[@@N], eax
	call	_ArcCount, eax
	call	_ArcDbgData, esi, ebx
	call	_ArcUnicode, 1
	cmp	[@@N], 0
	je	@@9

@@1:	movzx	edi, word ptr [esi]
	inc	esi
	inc	esi
	call	_ArcName, esi, edi
	lea	esi, [esi+2+edi*2+15h]
	and	[@@D], 0
	call	_FileSeek, [@@S], dword ptr [esi-15h+4], 0
	jc	@@1a
	mov	ebx, [esi-15h+8]
	movzx	edi, byte ptr [esi-1]
	sub	ebx, edi
	jae	$+6
	add	edi, ebx
	xor	ebx, ebx
	lea	eax, [@@D]
	call	_ArcMemRead, eax, edi, ebx, 0
	lea	ebx, [eax+edi]
	mov	ecx, edi
	mov	edi, [@@D]
	push	esi
	rep	movsb
	pop	esi

	mov	edi, [esi-15h+10h]
	cmp	dword ptr [esi-15h+0Ch], 'TLFD'
	jne	@@1a
	test	edi, edi
	je	@@1a
	call	_MemAlloc, edi
	jc	@@1a
	mov	edx, [@@D]
	mov	[@@D], eax
	push	edx
	call	_zlib_unpack, eax, edi, edx, ebx
	xchg	ebx, eax
	call	_MemFree

@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]

@@8:	movzx	edi, byte ptr [esi-1]
	add	esi, edi
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@5 PROC
	push	ebx
	push	esi
	xor	eax, eax

@@1:	sub	ebx, 4+15h
	jb	@@9
	movzx	ecx, word ptr [esi]
	shl	ecx, 1
	sub	ebx, ecx
	lea	esi, [esi+ecx+4+15h]
	jb	@@9
	movzx	ecx, byte ptr [esi-1]
	sub	ebx, ecx
	jb	@@9
	add	esi, ecx
	inc	eax
	jmp	@@1
@@9:	pop	esi
	pop	ebx
	ret
ENDP

@@3 PROC
	mov	edx, offset @@T
@@3:	movzx	eax, word ptr [edi+4]
	xor	ax, [edx+4]
	cmp	al, 78h
	jne	@@9
	xchg	al, ah
	imul	ecx, eax, 8422h	; div16(0x1F)
	shr	ecx, 14h
	imul	ecx, 1Fh
	cmp	eax, ecx
	jne	@@9
	mov	eax, [edi]
	xor	eax, [edx]
	shr	eax, 1Ch
	je	@@2
@@9:	cmp	dword ptr [edx], 0
	lea	edx, [edx+10h]
	jne	@@3
	ret

@@2:	push	edi
	xor	ecx, ecx
@@1:	mov	al, [edx+ecx]
	inc	ecx
	xor	[edi], al
	inc	edi
	and	ecx, 0Fh
	dec	ebx
	jne	@@1
	pop	edi
	ret

@@T	dd 0B31DEE82h,0C22CE957h,0107B542Fh,049759A4Ch	; SCHOOLDAYS
	dd 005BCD0F0h,0A968AC54h,03D8E7CF1h,0AAF30B64h	; SHINYDAYS
	dd 000000000h,000000000h,000000000h,000000000h
ENDP

ENDP
