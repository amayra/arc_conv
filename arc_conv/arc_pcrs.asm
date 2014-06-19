
; "Youkai" *.a5r

; header:
; 0x00 "PCRS"
; 0x04 ~("PCRS")
; 0x24 file_size
; 0x34 hdr_size (0x6A)
; 0x28,0x3C (file_size - hdr_size - tab_size)
; 0x2C tab_size (file_count * 0xA + 4 + ?)
; 0x30 file_count

; block:
; 0x00 file_pos
; 0x04 size
; 0x08 (0x3C - wav, 0x3E - bmp)
; 0x09 (0x02 - raw, 0x03 - zlib)

	dw 0
_arc_pcrs PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+6Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 6Ah
	jc	@@9a
	pop	eax
	pop	edx
	add	edx, eax
	sub	eax, 53524350h
	inc	edx
	or	eax, edx
	jne	@@9a
	cmp	dword ptr [esi+34h], 6Ah
	jne	@@9a
	mov	ebx, [esi+30h]
	mov	[@@N], ebx
	test	ebx, ebx
	je	@@9a
	imul	ebx, 0Ah
	add	ebx, 4
	cmp	[esi+2Ch], ebx
	jb	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]
	lea	esp, [ebp-@@stk]

@@1:	mov	eax, [esi]
	mov	ebx, [esi+0Ah]
	sub	ebx, eax
	jb	@@9
	and	[@@D], 0
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	cmp	byte ptr [esi+9], 3
	je	@@2a
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
	cmp	ebx, 12h
	jb	@@1a
	mov	edi, [@@D]
	cmp	word ptr [edi], 'MB'
	jne	@@1a
	mov	eax, [edi+0Ah]
	mov	edx, [edi+0Eh]
	sub	eax, 36h
	sub	edx, 28h
	and	eax, NOT 400h
	or	eax, edx
	jne	@@1a
	call	_ArcSetExt, 'pmb'
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 0Ah
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	mov	edi, [esi+4]
	call	_ArcMemRead, eax, edi, ebx, 0
	call	_zlib_unpack, [@@D], edi, edx, eax
	jmp	@@1b
ENDP
