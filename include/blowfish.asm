
@blowfish_size = 1048h
 
_blowfish_set_key@12 PROC		; state, key, len
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ecx, 412h
	mov	esi, offset _blowfish_tab
	mov	edi, [esp+14h]
	push	edi
	rep	movsd
	pop	esi
	mov	ebp, [esp+1Ch]
	mov	ebx, [esp+18h]
	test	ebp, ebp
	je	@@9
	xor	ecx, ecx
	xor	edi, edi
@@1:	shl	eax, 8
	inc	edi
	mov	al, [ebx+ecx]
	test	edi, 3
	jne	@@2
	xor	[esi+edi-4], eax
@@2:	inc	ecx
	cmp	ecx, ebp
	sbb	edx, edx
	and	ecx, edx
	cmp	edi, 12h*4
	jb	@@1
	xor	eax, eax
	xor	edx, edx
	mov	edi, 209h
	mov	ecx, esi
@@3:	call	_blowfish_encrypt
	mov	[esi], eax
	mov	[esi+4], edx
	add	esi, 8
	dec	edi
	jne	@@3
@@9:	pop	ebp
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

_blowfish_encrypt PROC
	push	ebx
	push	ebp
	push	esi
	push	edi
	push	-10h
	pop	esi
@@1:	xor	eax, [ecx+esi*4+40h]
	shld	ebx, eax, 16
	movzx	ebp, bh
	movzx	ebx, bl
	mov	ebx, [ecx+48h+ebx*4+400h]
	add	ebx, [ecx+48h+ebp*4]
	movzx	ebp, ah
	movzx	edi, al
	xor	ebx, [ecx+48h+ebp*4+800h]
	add	ebx, [ecx+48h+edi*4+0C00h]
	xor	edx, ebx
	xchg	eax, edx
	inc	esi
	jne	@@1
	xor	eax, [ecx+40h]
	xor	edx, [ecx+44h]
	jmp	@@9

_blowfish_decrypt:
	push	ebx
	push	ebp
	push	esi
	push	edi
	push	10h
	pop	esi
@@2:	xor	eax, [ecx+esi*4+4]
	shld	ebx, eax, 16
	movzx	ebp, bh
	movzx	ebx, bl
	mov	ebx, [ecx+48h+ebx*4+400h]
	add	ebx, [ecx+48h+ebp*4]
	movzx	ebp, ah
	movzx	edi, al
	xor	ebx, [ecx+48h+ebp*4+800h]
	add	ebx, [ecx+48h+edi*4+0C00h]
	xor	edx, ebx
	xchg	eax, edx
	dec	esi
	jne	@@2
	xor	eax, [ecx+4]
	xor	edx, [ecx]
@@9:	xchg	eax, edx
	pop	edi
	pop	esi
	pop	ebp
	pop	ebx
	ret
PURGE @M1
ENDP

_blowfish_tab:
	include blowfish_tab.inc
