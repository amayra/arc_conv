
; "Really? Really!" data\*.dat
; *.dat, *.mpg -> data\

; ReallyReally.exe
; 005A747C enc->file_create
; 005A7580 enc->file_seek
; 005A751C enc->file_read
; 005AD194 enc->decode

; 'NEKOPACK'

	dw 0
_arc_neko_really PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@T
@M0 @@B
@M0 @@SC
@M0 @@E
@M0 @@P
@M0 @@L1, 0Ch

	enter	@@stk+410h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 410h
	jc	@@9a
	pop	eax
	pop	edx
	sub	eax, 'OKEN'
	sub	edx, 'KCAP'
	or	eax, edx
	jne	@@9a
	pop	eax
	pop	eax
	mov	[@@L1], eax
	; 005A84CE
	xor	edx, edx
	lea	ecx, [edx+7]
	div	ecx
	lea	ebx, [edx+3]
	add	esi, 10h
	mov	[@@T], esi
@@2a:	mov	eax, [@@L1]
	xor	ecx, ecx
@@2b:	add	eax, 0EB0974C3h
	and	eax, 1FFh
	mov	edi, [esi+ecx*4]
	mov	edx, [esi+eax]
	add	eax, edi
	xor	edx, edi
	mov	[esi+ecx*4], edx
	inc	ecx
	cmp	ecx, 100h
	jne	@@2b
	dec	ebx
	jne	@@2a
	call	@@4
	mov	esi, [@@D]
	mov	[@@M], esi
	jc	@@9
	call	_ArcDbgData, esi, ebx

	lea	edx, [ebx+41Ch+3]
	mov	[@@SC], ebx
	and	edx, -4
	mov	[@@P], edx
	call	@@5
	lea	ecx, [eax-1]
	shr	ecx, 14h
	jne	@@9
	call	_ArcCount, eax

	mov	[@@E], esp
	sub	[@@SC], 4
	jb	@@9
	lodsd
@@1:	sub	[@@SC], 5
	jb	@@9
	movzx	eax, byte ptr [esi]
	mov	[@@B], esi
	sub	[@@SC], eax
	jb	@@9
	lea	esi, [esi+eax+5]
	mov	eax, [esi-4]
	test	eax, eax
	je	@@1
	mov	[@@N], eax
@@1a:	sub	[@@SC], 6
	jb	@@9
	lodsb
	test	al, al
	jne	@@9
	movzx	ecx, byte ptr [esi]
	mov	edx, [@@B]
	sub	[@@SC], ecx
	jb	@@9
	movzx	eax, byte ptr [edx]
	lea	eax, [eax+ecx+1]
	and	eax, -4
	push	0
	sub	esp, eax
	mov	edi, esp
	push	esi
	movzx	ecx, byte ptr [edx]
	lea	esi, [edx+1]
	rep	movsb
	pop	esi
	mov	al, 2Fh
	stosb
	movzx	ecx, byte ptr [esi]
	inc	esi
	rep	movsb
	mov	edx, esp
	call	_ArcName, edx, -1
	lodsd
	add	eax, [@@P]
	and	[@@D], 0
	xor	ebx, ebx
	call	_FileSeek, [@@S], eax, 0
	jc	@@1b
	call	@@4
@@1b:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	mov	esp, [@@E]
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1a
	jmp	@@1

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@4:	lea	edx, [@@L1]
	and	[@@D], 0
	call	_FileRead, [@@S], edx, 0Ch
	jc	@@4a
	lea	edx, [@@L1+4]
	call	@@3, edx, 8
	mov	eax, [@@L1+4]
	mov	ebx, [@@L1+8]
	sub	eax, ebx
	neg	eax
	jc	@@4a
	mov	ecx, ebx
	neg	ecx
	and	ecx, 3
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, ecx
	xchg	ebx, eax
	call	@@3, [@@D], ebx
	cmp	ebx, [@@L1+8]
@@4a:	ret

@@3:	push	esi
	push	edi
	mov	ecx, [esp+10h]
	mov	edi, [esp+0Ch]
	mov	eax, [@@L1]
	mov	esi, [@@T]
	add	ecx, 3
	shr	ecx, 2
	je	@@3b
@@3a:	mov	edx, [edi]
	add	eax, 0EB0974C3h
	and	eax, 1FFh
	xor	edx, [esi+eax]
	mov	[edi], edx
	add	edi, 4
	add	eax, edx
	dec	ecx
	jne	@@3a
@@3b:	pop	edi
	pop	esi
	ret	8

@@5 PROC	; esi, ebx
	push	ebx
	push	esi
	xor	ecx, ecx
	sub	ebx, 4
	jb	@@9
	lodsd
@@1:	xor	eax, eax
	sub	ebx, 5
	jb	@@9
	lodsb
	sub	ebx, eax
	jb	@@9
	add	esi, eax
	lodsd
	test	eax, eax
	je	@@1
	xchg	edx, eax
@@2:	xor	eax, eax
	sub	ebx, 6
	jb	@@9
	lodsb
	test	al, al
	jne	@@9
	lodsb
	sub	ebx, eax
	jb	@@9
	add	esi, eax
	lodsd
	inc	ecx
	dec	edx
	jne	@@2
	jmp	@@1
@@9:	xchg	eax, ecx
	pop	esi
	pop	ebx
	ret
ENDP

ENDP
