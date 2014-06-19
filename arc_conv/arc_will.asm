
; "Snow Drop", "Yume Miru Kusuri", "Little My Maid", "Laughter Land" *.arc
; laughter.exe
; 00406900 wsc_read
; 00406F2E vm_read
; yumemiru.exe
; 00405B62 vm_read

	dw _conv_will-$-2
_arc_will PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1
@M0 @@L2

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	pop	edi
	lea	eax, [edi-1]
	shr	eax, 7
	jne	@@9a
	imul	ebx, edi, 0Ch
	sub	esp, ebx
	mov	esi, esp
	call	_FileRead, [@@S], esi, ebx
	jc	@@9a
	mov	[@@L0], edi

	call	_ArcParamNum, 8
	db 'will', 0
	lea	ecx, [eax+9]
	shr	eax, 9
	jne	@@9a
	mov	[@@L2], ecx

	xor	edx, edx
	xor	ecx, ecx
	add	ebx, 4
@@2a:	mov	eax, [esi+4]
	add	esi, 0Ch
	add	ecx, eax
	or	edx, eax
	imul	eax, [@@L2]
	cmp	[esi-4], ebx
	jne	@@9a
	add	ebx, eax
	dec	edi
	jne	@@2a
	mov	esp, esi
	mov	[@@N], ecx
	dec	ecx
	shr	edx, 14h
	shr	ecx, 14h
	or	ecx, edx
	jne	@@9a
	call	_FileSeek, [@@S], 0, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	mov	eax, [esi]
	mov	edx, [@@L2]
	lea	eax, [eax*2+eax]
	lea	eax, [edx+eax*4]
	cmp	[esi+eax], ebx
	jne	@@9
	call	_ArcCount, [@@N]

	lodsd
@@1:	lodsd
	mov	[@@L1], eax
	lodsd
	mov	[@@N], eax
	lodsd
	push	esi
	add	eax, [@@M]
	xchg	esi, eax
@@1b:	mov	ebx, [@@L2]
	lea	ecx, [ebx-8]
	call	_ArcName, esi, ecx
	add	esi, ebx
	call	_ArcSetExt, [@@L1]
	and	[@@D], 0
	mov	ebx, [esi-8]
	call	_FileSeek, [@@S], dword ptr [esi-4], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1b
	pop	esi
	dec	[@@L0]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

; 57 49 50 46
; 01 00 08 00 bm8pal32
; 01 00 18 00 bm24
; 03 00 18 00 0x20+0x30
; 09 00 18 00 0x20+0xC0

; "Snow Drop" chip.arc
; SNOWDROP.EXE .0041B490

; "Yume Miru Kusuri" chip.arc
; yumemiru.exe .00432910

; "Little My Maid" chip.arc

; db 'WIPF'		; head
; dw frames, bpp

; dd width, height	; frame
; dd x, y
; dd 0			; ?
; dd frame_size

_conv_will PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L2 = dword ptr [ebp-8]
@@L0 = dword ptr [ebp-0Ch]
@@L1 = dword ptr [ebp-10h]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	sub	ebx, 8
	jb	@@9
	cmp	dword ptr [esi], 'FPIW'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	movzx	eax, word ptr [esi+4]
	movzx	edx, word ptr [esi+6]
	lea	edi, [eax*2+eax]
	dec	eax
	js	@@9
	shl	edi, 3
	ror	edx, 3
	sub	ebx, edi
	jb	@@9
	dec	edx
	mov	[@@SC], ebx
	lea	ecx, [edx+38h]
	push	edx
	push	edx
	and	edx, NOT 2
	jne	@@9
	xor	ebx, ebx
	test	eax, eax
	jne	@@2
	call	@@3
	jc	@@9
	call	@@Ext
	clc
	leave
	ret

@@2:	push	eax	; @@L0
	call	@@Ext
	call	_ArcSetExt, 0
	push	edx	; @@L1
@@2a:	call	_ArcNameFmt, [@@L1], ebx
	db '\%05i',0
	pop	ecx
	push	ebx
	call	@@3
	jc	@@2b
	call	_ArcTgaSave
@@2b:	call	_ArcTgaFree
	pop	ebx
	inc	ebx
	cmp	ebx, [@@L0]
	jbe	@@2a
@@2c:	clc
	leave
	ret

@@3:	mov	esi, [@@SB]
	mov	ecx, [@@SC]
	movzx	eax, word ptr [esi+4]
	movzx	edx, word ptr [esi+6]
	lea	eax, [eax*2+eax]
	not	edx
	lea	eax, [esi+8+eax*8]
	and	edx, 10h
	sub	esi, 10h
	shl	edx, 6		; 8 - 400h, 18h - 0 
	xor	edi, edi
@@3a:	lea	esi, [esi+18h]
	add	eax, edi
	mov	edi, [esi+14h]
	sub	ecx, edx
	jb	@@9
	sub	ecx, edi
	jb	@@9
	add	edi, edx
	dec	ebx
	jns	@@3a
	mov	[@@L2], eax

	mov	edi, [esi]
	mov	edx, [esi+4]
	mov	ebx, edi
	mov	ecx, [@@L2+4]
	imul	ebx, edx
	add	ecx, 40h+38h
	call	_ArcTgaAlloc, ecx, edi, edx
	jc	@@3e
	xchg	edi, eax
	mov	eax, [esi+0Ch]
	shl	eax, 10h
	mov	ax, [esi+8]
	mov	[edi+8], eax
	add	edi, 12h
	cmp	[@@L2+4], 0
	jne	@@3b
	push	dword ptr [esi+14h]
	mov	esi, [@@L2]
	mov	ecx, 100h
	rep	movsd
	call	@@Unpack, edi, ebx, esi
	clc
@@3e:	ret

@@3b:	lea	ecx, [ebx*2+ebx]
	call	_MemAlloc, ecx
	jc	@@3e
	lea	ecx, [ebx*2+ebx]
	push	dword ptr [esi+14h]
	xchg	esi, eax
	call	@@Unpack, esi, ecx, [@@L2]
	push	esi
	push	3
	pop	eax
@@3c:	push	edi
	mov	ecx, ebx
@@3d:	movsb
	inc	edi
	inc	edi
	dec	ecx
	jne	@@3d
	pop	edi
	inc	edi
	dec	eax
	jne	@@3c
	call	_MemFree
	clc
	ret

@@Ext PROC
	call	_ArcGetExt
	cmp	eax, 'piw'
	mov	al, 0
	je	@@1
	cmp	[edx], al
	je	@@1
	mov	al, '_'
@@1:	mov	[edx], al
	ret
ENDP

@@Unpack PROC	; yumemiru.exe 00432910

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
@@1:	shr	ebx, 1
	jne	@@1a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@1a:	jnc	@@1b
	dec	[@@DC]
	js	@@9
	dec	[@@SC]
	js	@@9
	movsb
	jmp	@@1

@@1b:	sub	[@@SC], 2
	jb	@@9
	movzx	edx, word ptr [esi]
	inc	esi
	inc	esi
	xchg	dl, dh
	mov	ecx, edx
	shr	edx, 4
	je	@@7
	and	ecx, 0Fh
	inc	ecx
	inc	ecx
	sub	[@@DC], ecx
	jb	@@9
	mov	eax, edi
	sub	eax, [@@DB]
	sub	edx, eax
	dec	edx
	or	edx, -1000h
	add	eax, edx
	jns	@@1d
@@1c:	mov	byte ptr [edi], 0
	inc	edi
	dec	ecx
	je	@@1
	inc	eax
	jne	@@1c
@@1d:	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@7:	mov	esi, [@@DC]
@@9:	xchg	eax, edi
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

ENDP