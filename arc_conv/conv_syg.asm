
; "Taiiku Souko ~Shoujotachi no Sange~" *.syg

	dw _conv_syg-$-2
_arc_syg:
	ret
_conv_syg PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'gys'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 20h
	jb	@@9
	cmp	dword ptr [esi], 'GYS$'
	jne	@@9
	xchg	eax, ebx
	mov	edi, [esi+10h]
	mov	edx, [esi+14h]
	mov	ebx, edi
	imul	ebx, edx
	lea	ecx, [ebx*2+ebx]
	cmp	dword ptr [esi+1Ch], 0
	jne	@@2
	cmp	eax, ecx
	jne	@@9
	call	_ArcTgaAlloc, 22h, edi, edx
	lea	edi, [eax+12h]
	add	esi, 20h
	lea	ecx, [ebx*2+ebx]
	rep	movsb
	clc
	leave
	ret

@@2:	cmp	[esi+1Ch], ecx
	jne	@@9
	add	ecx, ebx
	cmp	eax, ecx
	jne	@@9
	call	_ArcTgaAlloc, 23h, edi, edx
	lea	edi, [eax+12h]
	add	esi, 20h
	lea	edx, [ebx*2+ebx]
	add	edx, esi
@@2a:	movsb
	movsb
	movsb
	mov	al, [edx]
	inc	edx
	stosb
	dec	ebx
	jne	@@2a
	clc
	leave
	ret
ENDP

