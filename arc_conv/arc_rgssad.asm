
; "Succubus Quest" Game.rgssad
; RGSS102J.dll
; 1000A620 arc_open

	dw 0
_arc_rgssad PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@D
@M0 @@N

	enter	@@stk+108h+8, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	pop	eax
	pop	edx
	sub	eax, 'SSGR'
	sub	edx, 1000000h+'DA'
	or	eax, edx
	jne	@@9a
	mov	[@@N], 100000h

	mov	ebx, 0DEADCAFEh
@@1:	mov	edx, esp
	call	_FileRead, [@@S], edx, 4
	jc	@@9
	pop	edi
	push	edi
	xor	edi, ebx
	lea	eax, [ebx*2+ebx]
	lea	ebx, [ebx*4+eax+3]
	cmp	edi, 104h
	jae	@@9
	mov	edx, esp
	lea	ecx, [edi+4]
	call	_FileRead, [@@S], edx, ecx
	jc	@@9
	xor	ecx, ecx
	test	edi, edi
	je	@@1c
@@1b:	xor	[esp+ecx], bl
	inc	ecx
	lea	eax, [ebx*2+ebx]
	lea	ebx, [ebx*4+eax+3]
	cmp	ecx, edi
	jb	@@1b
@@1c:	mov	edx, esp
	call	_ArcName, edx, edi
	mov	edi, [esp+edi]
	xor	edi, ebx
	lea	eax, [ebx*2+ebx]
	lea	ebx, [ebx*4+eax+3]

	and	[@@D], 0
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, edi, 0
	xchg	edi, eax

	lea	ecx, [edi+3]
	shr	ecx, 2
	je	@@1a
	mov	edx, [@@D]
	push	ebx
@@1d:	xor	[edx], ebx
	add	edx, 4
	lea	eax, [ebx*2+ebx]
	lea	ebx, [ebx*4+eax+3]
	dec	ecx
	jne	@@1d
	pop	ebx
@@1a:	call	_ArcData, [@@D], edi
	call	_MemFree, [@@D]

@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	; ...
@@9a:	leave
	ret
ENDP
