
; "Crescent Moon Girl" ?CG.DAT

	dw _conv_system1-$-2
_arc_system1:
	jmp	_arc_system3

; "Prostudent G" ?CG.DAT

	dw _conv_system3-$-2
_arc_system3 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@I
@M0 @@L0, 0Ch

	enter	@@stk+4, 0

	call	_unicode_name, offset inFileName
	mov	[@@L0], eax
	lea	esi, [eax+2]
	movzx	eax, word ptr [eax]
	or	al, 20h
	sub	al, 61h
	cmp	eax, 19h
	jae	@@9a
	inc	eax
	mov	[@@L0+4], eax
	call	_filename_select, offset @@T, esi
	mov	[@@L0+8], eax

	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	movzx	eax, word ptr [esi]	; 2, 3
	movzx	ebx, word ptr [esi+2]
	lea	edi, [eax-2]
	mov	ecx, ebx
	shr	edi, 1
	sub	ecx, eax
	jbe	@@9a
	dec	ebx
	shr	ecx, 6	; 0x1A00 * 2
	shl	ebx, 8
	or	edi, ecx
	jne	@@9a
	sub	ebx, 4
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 4, ebx, 0
	jc	@@9
	lodsd
	mov	esi, [@@M]
	mov	[esi], eax

	movzx	ebx, word ptr [esi+2]
	movzx	edx, word ptr [esi]
	xor	ecx, ecx
	sub	ebx, edx
	dec	edx
	shl	ebx, 7
	shl	edx, 8
	xor	edi, edi
	add	esi, edx
@@2a:	movzx	eax, word ptr [esi+ecx*2]
	cmp	al, 1Ah
	jae	@@2b
	inc	ecx
	cmp	al, byte ptr [@@L0+4]
	jne	@@2c
	test	ah, ah
	je	@@2c
	inc	edi
@@2c:	cmp	ecx, ebx
	jb	@@2a
@@2b:	test	edi, edi
	je	@@9
	mov	[@@N], ecx
	call	_ArcCount, edi

	and	[@@I], 0
	sub	esp, 10h
@@1:	mov	ebx, [@@I]
	movzx	eax, word ptr [esi+ebx*2]
	inc	ebx
	mov	[@@I], ebx
	cmp	al, byte ptr [@@L0+4]
	jne	@@8
	test	ah, ah
	je	@@8
	movzx	edi, ah
	mov	edx, esp
	push	5
	pop	ecx
	cmp	[@@L0+8], 0
	je	@@1b
	push	-3
	pop	ecx
	mov	word ptr [edx], 'gc'
	inc	edx
	inc	edx
@@1b:	call	_StrDec32, ecx, ebx, edx
	mov	edx, esp
	call	_ArcName, edx, -1
	and	[@@D], 0

	mov	edx, [@@M]
	movzx	ecx, word ptr [edx]
	dec	ecx
	inc	edi
	shl	ecx, 7
	cmp	edi, ecx
	jae	@@1a
	movzx	eax, word ptr [edx+edi*2-2]
	movzx	ebx, word ptr [edx+edi*2]
	sub	ebx, eax
	jb	@@1a
	dec	eax
	js	@@1a
	shl	eax, 8
	shl	ebx, 8
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	cmp	[@@L0+8], 0
	je	@@1c
	call	_ArcSetExt, 'psv'
@@1c:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@T	db 'cg*',0, 0
ENDP

_conv_system3 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'psv'
	je	@@1
@@9:	stc
	leave
	ret

; "Ayumi-chan Monogatari"
; system3.exe
; 004023C0 unpack(1)

; "Rance 3"
; SYSTEM35.EXE
; 004195E0 unpack(0)
; 00424428 deblock

_conv_vsp_sys:
@@1:	sub	ebx, 3Ah
	jb	@@9
	cmp	byte ptr [esi+8], 0
	jne	@@2
	lea	edx, [esi+0Ah]
	call	_conv_vsp_check
	jne	@@9
	movzx	eax, word ptr [esi]
	movzx	ecx, word ptr [esi+2]
	movzx	edi, word ptr [esi+4]
	movzx	edx, word ptr [esi+6]
	sub	edi, eax
	sub	edx, ecx
	shl	edi, 3
	call	_ArcTgaAlloc, 30h, edi, edx
	lea	edi, [eax+12h]
	mov	eax, [esi]
	shl	ax, 3
	mov	word ptr [edi-12h+5], 10h
	mov	[edi-12h+8], eax
	call	@@VSP0, edi, esi, ebx
	clc
	leave
	ret

@@2:	sub	ebx, 320h-3Ah
	jb	@@9
	movzx	eax, word ptr [esi]
	movzx	ecx, word ptr [esi+2]
	movzx	edi, word ptr [esi+4]
	movzx	edx, word ptr [esi+6]
	sub	edi, eax
	sub	edx, ecx
	inc	edi
	call	_ArcTgaAlloc, 30h, edi, edx
	lea	edi, [eax+12h]
	mov	eax, [esi]
	mov	[edi-12h+8], eax
	call	@@VSP1, edi, esi, ebx
	clc
	leave
	ret

@@VSP1 PROC

@@D = dword ptr [ebp+14h]
@@SB = dword ptr [ebp+18h]
@@SC = dword ptr [ebp+1Ch]

@@W = dword ptr [ebp-4]
@@H = dword ptr [ebp-8]
@@DC = dword ptr [ebp-0Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	edi, [@@D]
	mov	esi, [@@SB]
	movzx	edx, word ptr [edi-12h+0Ch]
	movzx	ebx, word ptr [edi-12h+0Eh]
	push	edx
	push	ebx
	xor	ecx, ecx
	add	esi, 20h
@@7b:	lodsb
	stosb
	movsb
	stosb
	lodsb
	mov	[edi-3], al
	inc	cl
	jne	@@7b

@@7a:	push	[@@W]		; @@DC
@@1:	cmp	[@@DC], 0
	je	@@7
	dec	[@@SC]
	js	@@9
	lodsb
	cmp	al, 0FCh
	jae	@@1b
	cmp	al, 0F8h
	jb	@@1a
	dec	[@@SC]
	js	@@9
	lodsb
@@1a:	dec	[@@DC]
	stosb
	jmp	@@1

@@1b:	dec	[@@SC]
	js	@@9
	movzx	ecx, byte ptr [esi]
	inc	esi
	add	ecx, 3
	sub	[@@DC], ecx
	jb	@@9
	cmp	al, 0FDh
	jb	@@1e
	je	@@1d
	; FF FE
	movsx	edx, al
	imul	edx, [@@W]
	mov	eax, edi
	sub	eax, [@@D]
	add	eax, edx
	mov	al, 0
	jnc	@@1c
	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

	; FD
@@1d:	inc	ecx
	dec	[@@DC]
	js	@@9
	dec	[@@SC]
	js	@@9
	lodsb
@@1c:	rep	stosb
	jmp	@@1

	; FC
@@1e:	sub	[@@DC], ecx
	jb	@@9
	sub	[@@SC], 2
	jb	@@9
	lodsw
	rep	stosw
	jmp	@@1

@@7:	pop	ecx
	dec	[@@H]
	jne	@@7a
	xor	esi, esi
@@9:	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

@@VSP0 PROC

@@D = dword ptr [ebp+14h]
@@SB = dword ptr [ebp+18h]
@@SC = dword ptr [ebp+1Ch]

@@H = dword ptr [ebp-4]
@@W = dword ptr [ebp-8]
@@X = dword ptr [ebp-0Ch]
@@M = dword ptr [ebp-10h]
@@L0 = dword ptr [ebp-14h]
@@DC = dword ptr [ebp-18h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	edi, [@@D]
	mov	esi, [@@SB]
	movzx	edx, word ptr [edi-12h+0Ch]
	movzx	ebx, word ptr [edi-12h+0Eh]
	shr	edx, 1
	push	ebx
	push	edx
	push	edx
	imul	ebx, edx
	add	esi, 0Ah
	call	_conv_vsp_pal

	call	_MemAlloc, ebx
	jb	@@9a
	push	eax
	xchg	edi, eax
	push	0		; @@L0
@@7a:	push	[@@H]		; @@DC
@@1:	cmp	[@@DC], 0
	je	@@7
	dec	[@@SC]
	js	@@9
	lodsb
	cmp	al, 7
	jb	@@1c
	jne	@@1a
	; 07
	dec	[@@SC]
	js	@@9
	lodsb
@@1a:	dec	[@@DC]
	js	@@9
	stosb
	jmp	@@1

	; 06
@@1b:	mov	byte ptr [@@L0], 1
	jmp	@@1

@@1c:	cmp	al, 6
	je	@@1b
	dec	[@@SC]
	js	@@9
	movzx	ecx, byte ptr [esi]
	inc	esi
	inc	ecx
	sub	[@@DC], ecx
	jb	@@9
	sub	al, 3
	jae	@@2
	cmp	al, 1-3
	je	@@1e
	ja	@@1f
	; 00
	mov	edx, [@@H]
	shl	edx, 2
	neg	edx
	mov	eax, edi
	sub	eax, [@@M]
	add	eax, edx
	jnc	@@9
@@1d:	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

	; 01
@@1e:	dec	[@@SC]
	js	@@9
	lodsb
	rep	stosb
	jmp	@@1

	; 02
@@1f:	sub	[@@SC], 2
	jb	@@9
	sub	[@@DC], ecx
	jb	@@9
	lodsw
	rep	stosw
	jmp	@@1

@@2:	; 03,04,05
	movzx	eax, al
	mov	edx, [@@X]
	neg	edx
	and	edx, 3
	sub	edx, eax
	imul	edx, [@@H]
	neg	edx
	mov	eax, edi
	sub	eax, [@@M]
	add	eax, edx
	jnc	@@9
	shr	[@@L0], 1
	jnc	@@1d
@@2a:	mov	al, [edi+edx]
	not	al
	stosb
	dec	ecx
	jne	@@2a
	jmp	@@1

@@7:	pop	ecx
	dec	[@@X]
	jne	@@7a
	and	[@@SB], 0
@@9:	mov	edi, [@@D]
	mov	esi, [@@M]
	add	edi, 30h
	mov	ebx, [@@H]
	push	edi
	mov	ecx, [@@W]
	add	ecx, 4
	call	@@3
	pop	edi
	mov	ecx, [@@W]
	lea	eax, [ecx+4]
	shr	eax, 3
	lea	edi, [edi+eax*8]
	call	@@3
	call	_MemFree, [@@M]
@@9a:	neg	[@@SB]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch

@@3:	shr	ecx, 3
	mov	[@@X], ecx
	je	@@3b
@@3a:	xor	eax, eax
	mov	ecx, ebx
	call	@@4
	mov	eax, ebx
	shr	eax, 1
	lea	ecx, [ebx+1]
	imul	eax, [@@W]
	call	@@4
	lea	eax, [ebx*2+ebx]
	add	edi, 8
	add	esi, eax
	dec	[@@X]
	jne	@@3a
@@3b:	ret

@@4:	mov	edx, [@@W]
	shr	ecx, 1
	push	edi
	lea	edi, [edi+eax*2]
	je	@@4a
	shl	edx, 1
	call	_conv_vsp_line, edx, ecx
@@4a:	pop	edi
	ret
ENDP

ENDP

_conv_system1 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'psv'
	je	@@1
@@9:	stc
	leave
	ret

; CMOON_WIN\adv.exe
; 00401C40 unpack

@@1:	sub	ebx, 36h
	jb	@@9
	mov	edx, esi
	call	_conv_vsp_check
	jne	@@9
	movzx	eax, word ptr [esi+30h]
	xor	edx, edx
	xor	ah, 80h
	lea	ecx, [edx+50h]
	div	ecx
	shl	eax, 10h
	lea	eax, [eax+edx*8]
	push	eax

	movzx	edi, word ptr [esi+32h]
	movzx	edx, word ptr [esi+34h]
	shl	edi, 3
	call	_ArcTgaAlloc, 30h, edi, edx
	lea	edi, [eax+12h]
	mov	word ptr [edi-12h+5], 10h
	pop	dword ptr [edi-12h+8]
	call	@@Unpack, edi, esi, ebx
	clc
	leave
	ret

@@Unpack PROC

@@D = dword ptr [ebp+14h]
@@SB = dword ptr [ebp+18h]
@@SC = dword ptr [ebp+1Ch]

@@W = dword ptr [ebp-4]
@@H = dword ptr [ebp-8]
@@Y = dword ptr [ebp-0Ch]
@@M = dword ptr [ebp-10h]
@@DC = dword ptr [ebp-14h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	edi, [@@D]
	mov	esi, [@@SB]
	movzx	edx, word ptr [esi+32h]
	movzx	ebx, word ptr [esi+34h]
	push	edx
	push	ebx
	shl	ebx, 2
	push	ebx
	add	ebx, 8
	imul	ebx, edx
	call	_conv_vsp_pal
	add	esi, 6

	call	_MemAlloc, ebx
	jb	@@9a
	push	eax
	xchg	edi, eax

	mov	ecx, [@@W]
	xor	eax, eax
	shl	ecx, 1
	rep	stosd

@@7a:	push	[@@W]		; @@DC
@@1:	cmp	[@@DC], 0
	je	@@7
	dec	[@@SC]
	js	@@9
	lodsb
	cmp	al, 10h
	jb	@@1a
	dec	[@@DC]
	stosb
	jmp	@@1

@@1a:	movzx	ecx, al
	test	al, al
	jne	@@1c
	dec	[@@SC]
	js	@@9
	mov	cl, [esi]
	inc	esi
	test	cl, cl
	js	@@1d
@@1b:	dec	[@@SC]
	js	@@9
	lodsb
	jmp	@@1f

@@1c:	cmp	al, 8
	jb	@@1b
	sub	ecx, 6
	cmp	al, 0Eh
	jb	@@1e
	mov	edx, [@@Y]
	dec	edx
	dec	edx
	mov	cl, [esi]
	inc	esi
	cmp	al, 0Eh
	je	@@1g
	dec	edx
	test	cl, cl
	js	$+3
	dec	edx
	and	ecx, 7Fh
@@1g:	or	edx, -4
	imul	edx, [@@W]
	sub	[@@DC], ecx
	jb	@@9
	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@1d:	and	ecx, 7Fh
@@1e:	mov	edx, [@@W]
	neg	edx
	mov	al, [edi+edx*8+1]
@@1f:	sub	[@@DC], ecx
	jb	@@9
	rep	stosb
	jmp	@@1

@@7:	pop	ecx
	dec	[@@Y]
	jne	@@7a
	and	[@@SB], 0
@@9:	mov	ebx, [@@W]
	mov	esi, [@@M]
	mov	edi, [@@D]
	lea	esi, [esi+ebx*8]
	add	edi, 30h
@@3a:	call	_conv_vsp_line, 8, ebx
	lea	eax, [ebx*2+ebx]
	add	esi, eax
	dec	[@@H]
	jne	@@3a
	call	_MemFree, [@@M]
@@9a:	neg	[@@SB]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

_conv_vsp_check PROC
	xor	eax, eax
	lea	ecx, [eax+0Ch-1]
@@1:	or	eax, [edx+ecx*4]
	dec	ecx
	jns	@@1
	test	eax, 0F0F0F0F0h
	ret
ENDP

_conv_vsp_pal PROC
	push	10h
	pop	ecx
@@1:	lodsb
	imul	eax, 11h
	stosb
	lodsb
	imul	eax, 11h
	stosb
	stosb
	lodsb
	imul	eax, 11h
	mov	[edi-2], al
	dec	ecx
	jne	@@1
	ret
ENDP

_conv_vsp_line PROC
@@1:	mov	cl, [esi]
	mov	dl, [esi+ebx]
	lea	eax, [ebx*2+ebx]
	mov	ch, [esi+ebx*2]
	mov	dh, [esi+eax]
	xor	eax, eax
	inc	esi
	inc	eax
@@2:	add	dh, dh
	adc	eax, eax
	add	ch, ch
	adc	eax, eax
	add	dl, dl
	adc	eax, eax
	add	cl, cl
	adc	eax, eax
	jnc	@@2
	mov	edx, eax
	mov	ecx, 0F0F0F0Fh
	shr	eax, 4
	and	edx, ecx
	and	eax, ecx
	mov	[edi+4], ah
	mov	[edi+5], dh
	mov	[edi+6], al
	mov	[edi+7], dl
	shr	eax, 10h
	shr	edx, 10h
	mov	[edi], ah
	mov	[edi+1], dh
	mov	[edi+2], al
	mov	[edi+3], dl
	add	edi, [esp+4]
	dec	dword ptr [esp+8]
	jne	@@1
	ret	8
ENDP
