_pp_select PROC
	pop	eax
	call	@@1

	db 'sb3',0, 'sm',0, 'rk',0, 'sbz',0, 'js3',0, 0

@@1:	push	eax
	jmp	_string_select
ENDP

_pp_crypt PROC
	push	ebx
	push	edi
	mov	eax, [esp+0Ch]
	mov	edi, [esp+10h]
	mov	ebx, [esp+14h]
	xor	ecx, ecx
	dec	eax
	jns	@@2
	push	0FEA61EBDh
	push	0C287E33Ah
	push	00A834DF9h
	push	01C7B49FAh
@@1:	mov	al, [esp+ecx]
	add	al, [esp+ecx+8]
	mov	[esp+ecx], al
	inc	ecx
	xor	[edi], al
	inc	edi
	and	ecx, 7
	dec	ebx
	jne	@@1
@@8:	add	esp, 10h
@@9:	pop	edi
	pop	ebx
	ret	8

@@2:	mov	edx, eax
	shl	edx, 5
	add	edx, offset @@T
	cmp	al, 3
	jae	@@3
	shr	ebx, 2
	je	@@9
@@2a:	mov	eax, [edx+ecx*4]
	inc	ecx
	xor	[edi], eax
	add	edi, 4
	and	ecx, 7
	dec	ebx
	jne	@@2a
	jmp	@@9

@@3:	shr	ebx, 1
	je	@@9
	push	dword ptr [edx+4]
	push	dword ptr [edx]
@@3a:	movzx	eax, word ptr [esp+ecx*2]
	add	ax, [edx+ecx*2+8]
	mov	[esp+ecx*2], ax
	inc	ecx
	xor	[edi], ax
	inc	edi
	inc	edi
	and	ecx, 3
	dec	ebx
	jne	@@3a
	pop	ecx
	pop	ecx
	jmp	@@9

ALIGN 4
@@T	dd 0DD135D1Eh,0A74F4C7Dh,01429A7DBh,0BEC0F810h	; sm
	dd 063D07F44h,09F7C221Ch,0BEF8B9E8h,0F4EFB358h

	dd 0D2866258h,05FC42F3Bh,02D7658EEh,0CD0202B4h	; rk
	dd 03040080Ah,0E81D6608h,0CB61A69Bh,0B4F3F363h

	dd 0B8076F14h,044840E9Ah,0188E2559h,05C9E39BCh	; sbz
	dd 092A07A99h,055BCB7D4h,027882E1Eh,027E6A114h

	dd 0006E00CAh,000B3000Dh,00036009Ch,000E8001Eh	; js3
ENDP
