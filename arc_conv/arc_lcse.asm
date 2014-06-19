
; "Shinkon-san ~Sweet Sweet Honeymoon~" lcsebody1, SoundPackSEVo

; "LC-ScriptEngine ver.1.500", "Nexton"

	dw 0
_arc_lcse PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk, 0
	call	_unicode_ext, -1, offset inFileName
	test	eax, eax
	jne	@@9a
	call	@@3
	test	ebx, ebx
	je	@@9
	mov	edx, 1010101h
	mov	esi, [@@M]
	mov	edi, [@@N]
	lodsd
	xor	eax, edx
	mov	[esi-4], eax
	cmp	edi, eax
	jb	@@9
	mov	[@@N], eax
@@2a:	xor	[esi], edx
	xor	[esi+4], edx
	xor	ecx, ecx
@@2b:	mov	al, [esi+8+ecx]
	test	al, al
	je	@@2d
	cmp	al, 1
	je	@@2c
	xor	al, 1
@@2c:	mov	[esi+8+ecx], al
	inc	ecx
	cmp	ecx, 40h
	jb	@@2b
@@2d:	add	esi, 4Ch
	dec	edi
	jne	@@2a

	mov	esi, [@@M]
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx
	lodsd

@@1:	lea	edx, [esi+8]
	call	_ArcName, edx, 40h
	mov	ecx, [esi+48h]
	dec	ecx
	jne	@@1d
	; "NECEMEM.SNI"
	mov	edx, 20202020h
	mov	eax, edx
	shr	edx, 8
	or	eax, [esi+8]
	or	edx, [esi+0Ch]
	sub	eax, 'ecen'
	sub	edx, 'mem'
	or	eax, edx
	mov	eax, 'INS'
	je	@@1f
@@1d:	cmp	ecx, 5
	jae	@@1c
	call	@@1b
	db 'SNX',0, 'BMP',0, 'PNG',0, 'WAV',0, 'OGG',0
@@1b:	pop	edx
	mov	eax, [edx+ecx*4]
@@1f:	call	_ArcSetExt, eax
@@1c:
	and	[@@D], 0
	mov	ebx, [esi+4]
	call	_FileSeek, [@@S], dword ptr [esi], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	cmp	dword ptr [esi+48h], 1
	jne	@@1a
	test	ebx, ebx
	je	@@1a
	mov	edx, [@@D]
	mov	ecx, ebx
@@1e:	xor	byte ptr [edx], 2
	inc	edx
	dec	ecx
	jne	@@1e
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 4Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	xor	ebx, ebx
	mov	[@@M], ebx
	call	_ArcInputExt, 'tsl'
	jc	@@3a
	xchg	esi, eax
	call	_FileGetSize, esi
	xor	edx, edx
	lea	ecx, [edx+4Ch]
	mov	edi, eax
	div	ecx
	cmp	edx, 4
	jne	@@3b
	mov	[@@N], eax
	dec	eax
	shr	eax, 14h
	jne	@@3b
	call	_MemAlloc, edi
	jc	@@3b
	mov	[@@M], eax
	call	_FileRead, esi, eax, edi
	jc	@@3b
	xchg	ebx, eax
@@3b:	call	_FileClose, esi
@@3a:	ret

if 0
@@4 PROC
	cmp	ebx, 20h
	jb	@@9
	; SNX
	mov	eax, [edi]
	imul	eax, 0Ch
	add	eax, [edi+4]
	add	eax, 8
	cmp	eax, ebx
	je	@@9
	; SNI
	mov	eax, [edi+0Ch]
	shl	eax, 2
	add	eax, 20h
	sub	eax, ebx
	neg	eax
	ret
@@9:	stc
	ret
ENDP
endif

ENDP
