@SYS_TMP = 0
IFDEF @SYS_UNICODE
@SYS_TMP = @SYS_UNICODE
ENDIF
IF @SYS_TMP
extrn	GetCommandLineW:PROC
_CmdLineArg PROC
	call	GetCommandLineW
	test	eax, eax
	jne	@@4
	pop	edx
	push	eax
	push	eax
	push	edx
	ret
@@4:	push	esi
	push	edi
	push	eax
	xor	edi, edi
	xchg	esi, eax
	cld
	xor	edx, edx
@@1:	xor	eax, eax
	lea	ecx, [eax+20h]
@@1a:	lodsw
	cmp	eax, ecx
	je	@@1a
	test	eax, eax
	je	@@1e
	add	edx, esi
	cmp	eax, 22h
	jne	@@1c
	inc	edx
	inc	edx
	mov	ecx, eax
@@1b:	lodsw
@@1c:	test	eax, eax
	je	@@1d
	cmp	eax, ecx
	jne	@@1b
@@1d:	dec	edx
	dec	edx
	inc	edi
	sub	edx, esi
	and	edx, -4
	test	eax, eax
	jne	@@1
@@1e:	pop	esi
	neg	edx
	lea	ecx, [edx+edi*4+8]
	mov	edx, esp
	mov	eax, -1000h
	add	ecx, eax
	jnc	@@2a
@@2:	lea	esp, [esp+eax+4]
	push	eax
	add	ecx, eax
	jc	@@2
@@2a:	sub	ecx, eax
	sub	esp, ecx
	mov	eax, [edx]
	mov	ecx, [edx+4]
	mov	edx, [edx+8]
	add	esp, 0Ch
	lea	edi, [esp+edi*4+8]
	push	edx
	push	ecx
	xor	edx, edx
	push	eax
	mov	[edi-4], edx
@@3:	xor	eax, eax
	lea	ecx, [eax+20h]
@@3a:	lodsw
	cmp	eax, 20h
	je	@@3a
	test	eax, eax
	je	@@3e
	mov	[esp+edx*4+10h], edi
	cmp	eax, 22h
	jne	@@3c
	mov	ecx, eax
@@3b:	lodsw
@@3c:	stosw
	test	eax, eax
	je	@@3d
	cmp	eax, ecx
	jne	@@3b
@@3d:	mov	[edi-2], ah
	add	edi, 3
	inc	edx
	and	edi, -4
	test	eax, eax
	jne	@@3
@@3e:	pop	edi
	pop	esi
	mov	[esp+4], edx
	xchg	eax, edx
	ret
ENDP
ELSE
extrn	GetCommandLineA:PROC
_CmdLineArg PROC
	call	GetCommandLineA
	test	eax, eax
	jne	@@4
	pop	edx
	push	eax
	push	eax
	push	edx
	ret
@@4:	push	esi
	push	edi
	push	eax
	xor	edi, edi
	xchg	esi, eax
	cld
	xor	edx, edx
@@1:	xor	eax, eax
	lea	ecx, [eax+20h]
@@1a:	lodsb
	cmp	eax, ecx
	je	@@1a
	test	eax, eax
	je	@@1e
	add	edx, esi
	cmp	eax, 22h
	jne	@@1c
	inc	edx
	mov	ecx, eax
@@1b:	lodsb
@@1c:	test	eax, eax
	je	@@1d
	cmp	eax, ecx
	jne	@@1b
@@1d:	dec	edx
	inc	edi
	sub	edx, esi
	and	edx, -4
	test	eax, eax
	jne	@@1
@@1e:	pop	esi
	neg	edx
	lea	ecx, [edx+edi*4+8]
	mov	edx, esp
	mov	eax, -1000h
	add	ecx, eax
	jnc	@@2a
@@2:	lea	esp, [esp+eax+4]
	push	eax
	add	ecx, eax
	jc	@@2
@@2a:	sub	ecx, eax
	sub	esp, ecx
	mov	eax, [edx]
	mov	ecx, [edx+4]
	mov	edx, [edx+8]
	add	esp, 0Ch
	lea	edi, [esp+edi*4+8]
	push	edx
	push	ecx
	xor	edx, edx
	push	eax
	mov	[edi-4], edx
@@3:	xor	eax, eax
	lea	ecx, [eax+20h]
@@3a:	lodsb
	cmp	eax, 20h
	je	@@3a
	test	eax, eax
	je	@@3e
	mov	[esp+edx*4+10h], edi
	cmp	eax, 22h
	jne	@@3c
	mov	ecx, eax
@@3b:	lodsb
@@3c:	stosb
	test	eax, eax
	je	@@3d
	cmp	eax, ecx
	jne	@@3b
@@3d:	mov	[edi-1], ah
	add	edi, 3
	inc	edx
	and	edi, -4
	test	eax, eax
	jne	@@3
@@3e:	pop	edi
	pop	esi
	mov	[esp+4], edx
	xchg	eax, edx
	ret
ENDP
ENDIF