
; 03 colors
; 04 align4
; 18 pal_colors
; 20 line_rev
; 40 no_exit

_ArcTgaAlloc PROC
	@M1

@@F = dword ptr [esp+14h]
@@W = dword ptr [esp+18h]
@@H = dword ptr [esp+1Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, [ebp]
	mov	edi, [@@L3]
	test	edi, edi
	je	@@2a
	call	_MemFree, edi
	xor	edi, edi
@@2a:	mov	eax, [@@W]
	mov	edx, [@@H]
	mov	ecx, eax
	mov	esi, edx
	or	ecx, edx
	mov	ebx, [@@F]
	shl	esi, 10h
	shr	ecx, 0Fh
	jne	@@9
	add	esi, eax

	mov	ecx, ebx
	and	ecx, 3
	inc	ecx
	imul	eax, ecx
	test	bl, 4
	je	@@2b
	add	eax, 3
	and	al, -4
@@2b:	mul	edx
	test	eax, eax
	jle	@@9
	test	edx, edx
	jne	@@9

	dec	ecx
	jne	@@1a
	mov	ecx, ebx
	and	ecx, 18h
	je	@@1a
	add	ecx, 8
	shl	ecx, 5
	add	eax, ecx
@@1a:	add	eax, 112h+1Ah
	call	_MemAlloc, eax
	jc	@@9
	xchg	edi, eax
	mov	eax, ebx
	and	eax, 3
	inc	eax
	shl	eax, 3
	mov	ah, 20h
	and	ah, bl
	cmp	al, 20h
	jne	@@1c
	or	ah, 8
@@1c:	mov	dword ptr [edi], 20000h
	and	dword ptr [edi+4], 0
	and	dword ptr [edi+8], 0
	mov	[edi+0Ch], esi
	mov	[edi+10h], ax
	cmp	al, 8
	jne	@@9
	mov	eax, ebx
	inc	byte ptr [edi+2]
	and	eax, 18h
	je	@@9
	shl	eax, 18h
	add	eax, 8010000h
	mov	dword ptr [edi], 10100h
	mov	[edi+4], eax
@@9:	mov	[@@L3], edi
	xchg	eax, edi
	pop	ebp
	cmp	eax, 1
	jb	@@9b
@@9a:	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch

@@9b:	bt	ebx, 6
	jc	@@9a
	stc
	leave
	ret

_ArcTgaFree:
	push	ebp
	mov	ebp, [ebp]
	mov	ecx, [@@L3]
	and	[@@L3], 0
	pop	ebp
	test	ecx, ecx
	je	@@5a
	call	_MemFree, ecx
@@5a:	ret

_ArcTgaSave:
	push	ebp
	mov	ebp, [ebp]
	mov	eax, [@@L3]
	pop	ebp
	test	eax, eax
	je	@@5b
_ArcTgaSaveSys:
	push	edi
	xchg	edi, eax
;	movzx	edx, word ptr [edi+10h]
;	push	dword ptr [edi+4]
;	push	dword ptr [edi]
;	push	edx
	call	_tga_optimize, edi
	push	eax
	call	_ArcSetExt, 'agt'
	call	_ArcData, edi
;	pop	eax
;	pop	dword ptr [edi]
;	pop	dword ptr [edi+4]
;	mov	[edi+10h], ax
	pop	edi
@@5b:	ret
ENDP

_tga_align4 PROC
	push	ebx
	push	esi
	push	edi
	mov	esi, [esp+10h]

	movzx	edx, byte ptr [esi-12h+10h]
	movzx	eax, word ptr [esi-12h+0Ch]
	shr	edx, 3
	movzx	ebx, word ptr [esi-12h+0Eh]
	imul	edx, eax

	movzx	eax, byte ptr [esi-12h+7]
	movzx	ecx, word ptr [esi-12h+5]
	shr	eax, 3
	imul	ecx, eax
	mov	eax, edx
	add	esi, ecx
	neg	eax
	and	eax, 3
	je	@@9
	mov	edi, esi
@@1:	mov	ecx, edx
	rep	movsb
	add	esi, eax
	dec	ebx
	jne	@@1
@@9:	pop	edi
	pop	esi
	pop	ebx
	ret	4
ENDP
