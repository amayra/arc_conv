
; 78 DA
; 63 F8-FF FF 3F 00	; 00 FF FF FF
; 05 FE 02 FE		; adler32 rev

_zlib_raw_pack PROC
	xor	eax, eax
	jmp	@@5a

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@M = dword ptr [ebp-4]
@@D = dword ptr [ebp-8]
@@B = dword ptr [ebp-0Ch]
@@A = dword ptr [ebp-14h]

@tblcnt = 8000h
@@adler32 = 1

_zlib_pack:
	or	eax, -1
@@5a:	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	xchg	ebx, eax
	call	_MemAlloc, 10000h*4+@tblcnt*2
	jc	@@9c
	push	eax
	mov	esi, [@@SB]
	xchg	edi, eax
	mov	ecx, 10000h
	lea	eax, [esi-@tblcnt-1]
	rep	stosd
	push	edi
	push	-80h
ifdef @@adler32
	push	0
	push	1
endif
	mov	edi, [@@DB]
	add	ecx, 13h
	mov	eax, 3DA78h
	test	ebx, ebx
	jne	@@5b
	shr	eax, 10h
	sub	ecx, 10h
@@5b:	call	@@out
	cmp	[@@SC], 0
	je	@@9
@@1:	call	@@next
@@2:	mov	ecx, [@@SC]
	cmp	ecx, 3
	jb	@@1
	call	@@match
	test	ecx, ecx
	je	@@1
	; ecx - address, eax - count
	not	ecx
	push	ecx
	call	@@len
	pop	eax

	; dist
	xor	ecx, ecx
	cmp	eax, 4
	jb	@@4
	bsr	ecx, eax
	dec	ecx
@@4:	ror	eax, cl
	lea	eax, [eax+ecx*2]
	push	5
	pop	edx
	call	@@rev
@@3:	call	@@skip
	dec	ebx
	jne	@@3
	jmp	@@2

@@9:	xor	eax, eax
	lea	ecx, [eax+7]
	call	@@out
	mov	edx, [@@B]
	cmp	dl, 80h
	je	@@9b
@@9a:	shr	dl, 1
	jnc	@@9a
	mov	[edi], dl
	inc	edi
@@9b:
if @@adler32
	mov	eax, [@@A+4]
	shl	eax, 10h
	add	eax, [@@A]
	bswap	eax
	stosd
endif
	call	_MemFree, [@@M]
	xchg	eax, edi
	sub	eax, [@@DB]
@@9c:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@rev:	push	ecx
	mov	ecx, edx
	ror	eax, cl
	mov	edx, [@@B]
@@rev1:	shl	eax, 1
	rcr	dl, 1
	jnc	@@rev2
	mov	[edi], dl
	inc	edi
	mov	dl, 80h
@@rev2:	dec	ecx
	jne	@@rev1
	mov	[@@B], edx
	pop	ecx
	rol	eax, cl

@@out:	test	ecx, ecx
	je	@@out3
	push	edx
	mov	edx, [@@B]
@@out1:	shr	eax, 1
	rcr	dl, 1
	jnc	@@out2
	mov	[edi], dl
	inc	edi
	mov	dl, 80h
@@out2:	dec	ecx
	jne	@@out1
	mov	[@@B], edx
	pop	edx
@@out3:	ret

@@next:	xor	ecx, ecx
	movzx	eax, byte ptr [esi]
	lea	edx, [ecx+8]
	cmp	eax, 90h
	jb	@@next_1
	add	eax, 18h*4+98h*2-90h-18h*2
	inc	edx
@@next_1:
	add	eax, 18h*2
	call	@@rev
@@skip:
if @@adler32
	movzx	eax, byte ptr [esi]
	mov	ecx, 0FFF1h
	add	eax, [@@A]
	cmp	eax, ecx
	jb	$+4
	sub	eax, ecx
	mov	[@@A], eax
	add	eax, [@@A+4]
	cmp	eax, ecx
	jb	$+4
	sub	eax, ecx
	mov	[@@A+4], eax
endif
	dec	[@@SC]
	je	@@9
	mov	ecx, esi
	mov	edx, [@@M]
	movzx	eax, word ptr [esi]
	xchg	ecx, [edx+eax*4]
	sub	ecx, esi
	cmp	ecx, -@tblcnt+1
	sbb	eax, eax
	neg	ecx
	mov	edx, esi
	or	ecx, eax
	mov	eax, [@@D]
	and	edx, @tblcnt-1
	mov	[eax+edx*2], cx
	inc	esi
	ret

@@len:	xor	ecx, ecx
	mov	ebx, 102h
	lea	edx, [ecx+7]
	cmp	eax, ebx
	jae	@@len3
	mov	ebx, eax
	sub	eax, 3
	cmp	eax, 8
	jb	@@len1
	bsr	ecx, eax
	dec	ecx
	dec	ecx
@@len1:	ror	eax, cl
	lea	eax, [eax+ecx*4+1]
	cmp	al, 18h
	jb	@@len4
	add	al, 18h*2+90h-18h
@@len5:	inc	edx
@@len4:	call	@@rev
@@len2:	ret

@@len3:	mov	al, 18h*2+90h-18h+1Dh
	jmp	@@len5

@@match PROC
	push	edi
	push	0	; D
	push	2	; C = min-1
	mov	ebx, 102h
	cmp	ecx, ebx
	jae	$+4
	mov	ebx, ecx
	mov	ecx, [ebp-4]
	movzx	eax, word ptr [esi]
	mov	ecx, [ecx+eax*4]
	sub	ecx, esi
	jmp	@@3

@@4:	xor	edx, edx
	lea	edi, [esi+ecx]
	inc	edx
@@5:	inc	edx
	cmp	edx, ebx
	jae	@@6
	mov	al, [esi+edx]
	cmp	[edi+edx], al
	je	@@5
@@6:	pop	eax
	cmp	eax, edx
	jae	@@2
	xchg	eax, edx
	pop	edx
	cmp	eax, ebx
	jae	@@9
	push	ecx
@@2:	push	eax
	and	edi, @tblcnt-1
	mov	edx, [ebp-8]
	movzx	edi, word ptr [edx+edi*2]
	sub	ecx, edi
@@3:	cmp	ecx, -@tblcnt
	jae	@@4
	pop	eax
	pop	ecx
@@9:	pop	edi
	ret
ENDP

ENDP
