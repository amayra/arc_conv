
_mod_compose PROC
	push	ebp
	mov	ebp, esp
	cmp	eax, 3
	jne	@@9a
	call	_Bm32ReadFile, dword ptr [ebp+0Ch]
	jc	@@9a
	xchg	edi, eax
	call	_Bm32ReadFile, dword ptr [ebp+10h]
	jc	@@9b
	xchg	esi, eax

	mov	eax, [esi+10h]
	mov	edx, [esi+14h]
	sub	eax, [edi+10h]
	sub	edx, [edi+14h]
	call	@@Compose, edi, esi, eax, edx

	call	_BmWriteTga, edi, dword ptr [ebp+14h]
@@9:	call	_MemFree, esi
@@9b:	call	_MemFree, edi
@@9a:	leave
	ret

@@Compose PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@X = dword ptr [ebp+1Ch]
@@Y = dword ptr [ebp+20h]

@M0 macro p0
@@stk=@@stk+4
p0=dword ptr [ebp-@@stk]
endm
@@stk = 0
@M0 @@SB
@M0 @@DB
@M0 @@SA
@M0 @@DA
@M0 @@W
@M0 @@H
PURGE @M0

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@S]
	mov	edi, [@@D]
	push	dword ptr [esi+8]
	push	dword ptr [edi+8]
	push	dword ptr [esi+0Ch]
	push	dword ptr [edi+0Ch]

	mov	ecx, [@@X]
	mov	eax, [edi]
	mov	edx, [esi]
	test	ecx, ecx
	jns	@@1a
	neg	ecx
	sub	edx, ecx
	jbe	@@9
	shl	ecx, 2
	add	[@@SB], ecx
	jmp	@@1b
@@1a:	sub	eax, ecx
	jbe	@@9
	shl	ecx, 2
	add	[@@DB], ecx
@@1b:	cmp	eax, edx
	jb	$+3
	xchg	eax, edx
	push	eax	; @@W
	shl	eax, 2
	sub	[@@SA], eax
	sub	[@@DA], eax

	mov	ecx, [@@Y]
	mov	eax, [edi+4]
	mov	edx, [esi+4]
	test	ecx, ecx
	jns	@@1c
	neg	ecx
	sub	edx, ecx
	jbe	@@9
	imul	ecx, [esi+0Ch]
	add	[@@SB], ecx
	jmp	@@1d

@@1c:	sub	eax, ecx
	jbe	@@9
	imul	ecx, [edi+0Ch]
	add	[@@DB], ecx
@@1d:	cmp	eax, edx
	jb	$+3
	xchg	eax, edx
	push	eax	; @@H

	mov	esi, [@@SB]
	mov	edi, [@@DB]
@@2a:	mov	ecx, [@@W]
@@2b:	movzx	ebx, byte ptr [esi+3]
	inc	ebx
rept 3
	movzx	eax, byte ptr [edi]
	movzx	edx, byte ptr [esi]
	inc	esi
	sub	edx, eax
	imul	edx, ebx
	add	al, dh
	stosb
endm
	movzx	eax, byte ptr [edi]
	mov	edx, eax
	inc	esi
	not	dl
	imul	edx, ebx
	add	al, dh
	stosb
	dec	ecx
	jne	@@2b
	add	esi, [@@SA]
	add	edi, [@@DA]
	dec	[@@H]
	jne	@@2a
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

ENDP
