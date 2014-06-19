
; "Total Annihilation: The Core Contingency" *.hpi, *.ccx
; TOTALA.EXE
; 004BD9C0 open_archive
; 004BB420 read_file

	dw 0
_arc_hapi PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@L0
@M0 @@L1
@M0 @@L2, 10h

	enter	@@stk+14h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 14h
	jc	@@9a
	mov	edx, [esi+4]
	cmp	dword ptr [esi], 'IPAH'
	jne	@@9a
	ror	edx, 10h
	dec	edx
	jne	_mod_hapi2
	mov	ebx, [esi+8]
	sub	ebx, 14h
	jb	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 14h, ebx, 0
	jc	@@9
	mov	edi, [@@M]
	movsd
	movsd
	movsd
	movsd
	movsd
	lea	esi, [edi-14h]

	mov	al, [esi+0Ch]
	test	al, al
	je	@@2a
	rol	al, 2
	not	al
	mov	[esi+0Ch], al
	call	@@3, 14h, ebx, edi
@@2a:	add	ebx, 14h
	call	_ArcDbgData, esi, ebx
	mov	eax, [esi+10h]
	call	@@5
	lea	ecx, [eax-1]
	shr	ecx, 14h
	jne	@@9
	call	_ArcCount, eax
	mov	[@@L0], esp
	sub	esp, 200h
	mov	[@@L1], esp
	mov	edi, esp

	mov	eax, [esi+10h]
@@1:	push	esi
	mov	esi, [@@M]
	mov	ebx, [eax+esi]
	add	esi, [eax+esi+4]
	test	ebx, ebx
	je	@@1e
@@1d:	mov	edx, [esi]
	push	ebx
	add	edx, [@@M]
	push	edi
@@1c:	mov	al, [edx]
	inc	edx
	cmp	edi, [@@L0]
	je	@@1f
	stosb
	test	al, al
	jne	@@1c
	mov	eax, [esi+4]
	test	byte ptr [esi+8], 1
	je	@@1b
	mov	byte ptr [edi-1], 2Fh
	jmp	@@1

@@1b:	mov	edi, [@@M]
	add	edi, eax
	call	_ArcName, [@@L1], -1
	and	[@@D], 0
	mov	ebx, [edi+4]
	test	ebx, ebx
	je	@@1a
	call	_FileSeek, [@@S], dword ptr [edi], 0
	jc	@@1a
	cmp	byte ptr [edi+8], 0
	jne	@@2b
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	call	@@3, dword ptr [edi], ebx, edx
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
@@1f:	pop	edi
	pop	ebx
	add	esi, 9
	dec	ebx
	jne	@@1d
@@1e:	pop	esi
	cmp	esp, [@@L1]
	jne	@@1f
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2b:	mov	ecx, 0FFFFh
	add	ecx, ebx
	jc	@@1a
	shr	ecx, 10h
	mov	edx, [edi]
	mov	[@@L2], ebx
	mov	[@@L2+8], edx
	shl	ecx, 2
	xor	ebx, ebx
	lea	eax, [@@D]
	call	_ArcMemRead, eax, dword ptr [edi+4], ecx, 0
	jc	@@1a
	push	esi
	mov	ecx, [@@L2+8]
	add	[@@L2+8], eax
	mov	esi, edx
	call	@@3, ecx, eax, edx
	mov	[@@L2+4], ebx

@@2c:	mov	ecx, [@@L2]
	mov	ebx, 10000h
	sub	ecx, ebx
	jae	$+6
	add	ebx, ecx
	xor	ecx, ecx
	mov	[@@L2], ecx
	lodsd
	lea	edx, [@@L2+0Ch]
	call	_ArcMemRead, edx, 0, eax, 0
	xchg	edi, eax
	call	@@3, [@@L2+8], edi, edx
	mov	eax, [@@D]
	add	[@@L2+8], edi
	add	eax, [@@L2+4]
	call	_hapi_unpack, eax, ebx, [@@L2+0Ch], edi
	add	[@@L2+4], eax
	sub	ebx, eax
	call	_MemFree, [@@L2+0Ch]
	test	ebx, ebx
	jne	@@2e
	cmp	edi, [esi-4]
	jb	@@2e
	cmp	[@@L2], 0
	jne	@@2c
@@2e:	pop	esi
	mov	ebx, [@@L2+4]
	jmp	@@1a

@@3:	mov	edx, [@@M]
	mov	ecx, [esp+8]
	mov	dl, [edx+0Ch]
	test	ecx, ecx
	je	@@3b
	test	dl, dl
	je	@@3b
	push	ebx
	push	esi
	mov	esi, [esp+14h]
	mov	ebx, [esp+0Ch]
	not	edx
	sub	esi, ebx
@@3a:	mov	al, bl
	xor	al, dl
	xor	[esi+ebx], al
	inc	ebx
	dec	ecx
	jne	@@3a
	pop	esi
	pop	ebx
@@3b:	ret	0Ch

@@5 PROC
	mov	edi, esi
	xor	ecx, ecx
	push	0
	push	ebp
	mov	ebp, esp
	jmp	@@1f
@@1:	lea	ecx, [ebx*8+ebx]
@@1f:	push	ebx
	push	edi
	add	edi, ecx
	call	@@3
	sub	edi, esi
	cmp	ecx, 8
	jb	@@9
	cmp	eax, edi
	jb	@@9
	mov	ebx, [esi+eax]
	mov	eax, [esi+eax+4]
	test	ebx, ebx
	je	@@1c
	lea	edi, [ebx*8+ebx]
	call	@@3
	cmp	ecx, edi
	jb	@@9
	lea	edi, [esi+eax]
@@1a:	mov	eax, [edi]
	call	@@3
	push	edi
	lea	edi, [esi+eax]
	xor	eax, eax
	cmp	[edi], al
	je	@@9
	repne	scasb
	pop	edi
	jne	@@9
	mov	al, [edi+8]	; 0-file, 1-dir
	shr	al, 1
	jne	@@9
	mov	eax, [edi+4]
	jc	@@1
	call	@@3
	cmp	ecx, 9
	jb	@@9
	cmp	byte ptr [esi+eax+8], 3		; 0-raw, 1-lzss, 2-zlib
	jae	@@9
	inc	dword ptr [ebp+4]
@@1b:	add	edi, 9
	dec	ebx
	jne	@@1a
@@1c:	pop	edi
	pop	ebx
	cmp	esp, ebp
	jne	@@1b
	leave
	pop	eax
	ret

@@9:	leave
	pop	eax
	xor	eax, eax
	ret

@@3:	mov	ecx, [ebp-4]
	cmp	eax, 14h
	jb	@@9
	sub	ecx, eax
	jbe	@@9
	ret
ENDP

ENDP

; "Total Annihilation: Kingdoms" *.hpi
; Kingdoms.exe
; 0050DB00 open_archive

	dw 0
_mod_hapi2 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M, 10h
@M0 @@D
@M0 @@L0
@M0 @@L1
@M0 @@L2, 14h

	dec	edx
	jne	@@9a
	lea	esp, [ebp-@@stk-20h]
	call	_FileSeek, [@@S], 0, 0
	jc	@@9a
	mov	esi, esp
	call	_FileRead, [@@S], esi, 20h
	jc	@@9a
	cmp	dword ptr [esi+18h], 20h
	jne	@@9a

	lea	edi, [@@M]
	and	dword ptr [edi], 0
	and	dword ptr [edi+8], 0
	call	@@3
	call	@@3
	lea	esi, [@@M]
	call	@@5
	lea	ecx, [eax-1]
	shr	ecx, 14h
	jne	@@9
	call	_ArcCount, eax
	mov	[@@L0], esp
	sub	esp, 200h
	mov	[@@L1], esp
	mov	edi, esp

	xor	ebx, ebx
	mov	esi, [@@M]
	inc	ebx
@@1:	push	ebx
	mov	ebx, [esi+10h]
	mov	eax, [esi+0Ch]
	test	ebx, ebx
	je	@@1c
	push	esi
	add	eax, [@@M]
	xchg	esi, eax
@@1f:	push	edi
	call	@@4
	jc	@@1g
	call	_ArcName, [@@L1], -1
	and	[@@D], 0
	push	ebx
	mov	ebx, [esi+8]
	call	_FileSeek, [@@S], dword ptr [esi+4], 0
	jc	@@1a
	mov	edx, [esi+0Ch]
	lea	eax, [@@D]
	test	edx, edx
	jne	@@2a
	call	_ArcMemRead, eax, 0, ebx, 0
	jmp	@@1b

@@2a:	call	_ArcMemRead, eax, ebx, edx, 0
	call	_hapi_unpack, [@@D], ebx, edx, eax
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	pop	ebx
	call	_ArcBreak
	jc	@@9
@@1g:	pop	edi
	add	esi, 18h
	dec	ebx
	jne	@@1f
	pop	esi
@@1c:	mov	ebx, [esi+8]
	mov	eax, [esi+4]
	test	ebx, ebx
	je	@@1d
	push	esi
	add	eax, [@@M]
	xchg	esi, eax
	push	edi
	call	@@4
	jc	@@1e
	mov	byte ptr [edi-1], 2Fh
	jmp	@@1

@@1d:	pop	ebx
	add	esi, 14h
	dec	ebx
	jne	@@1
@@1e:	cmp	esp, [@@L1]
	je	@@9
	pop	edi
	pop	esi
	jmp	@@1d

@@9:	call	_MemFree, [@@M+8]
	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@4:	mov	edx, [esi]
	add	edx, [@@M+8]
@@4a:	mov	al, [edx]
	inc	edx
	cmp	edi, [@@L0]
	je	@@4b
	stosb
	test	al, al
	jne	@@4a
	ret
@@4b:	stc
	ret

@@3:	add	esi, 8
	call	_FileSeek, [@@S], dword ptr [esi], 0
	jc	@@9
	mov	ebx, [esi+4]
	call	_ArcMemRead, edi, 0, ebx, 0
	jc	@@9
	mov	edx, [edi]
	mov	[edi+4], ebx
	cmp	ebx, 13h
	jb	@@9
	cmp	dword ptr [edx], 'HSQS'
	jne	@@3a
	mov	ebx, [edx+0Bh]
	call	_MemAlloc, ebx
	jc	@@9
	mov	edx, [edi]
	mov	[edi], eax
	mov	[edi+4], ebx
	push	edx
	call	_hapi_unpack, eax, ebx, edx, dword ptr [esi+4]
	sub	ebx, eax
	call	_MemFree
	test	ebx, ebx
	jne	@@9
@@3a:	call	_ArcDbgData, dword ptr [edi], dword ptr [edi+4]
	add	edi, 8
	ret

; dir: dd name, dir_tab, dir_cnt, file_tab, file_cnt
; file: dd name, offset, unp_size, size, time(?), ?

@@5 PROC
	xor	eax, eax
	mov	edi, [esi]
	lea	edx, [eax+1]
	xor	ebx, ebx
	push	0
	push	ebp
	mov	ebp, esp
@@1:	imul	ecx, ebx, 14h
	push	ebx
	push	edi
	add	edi, ecx
	sub	edi, [esi]
	cmp	eax, edi
	jb	@@9
	imul	edi, edx, 14h
	call	@@3
	mov	ebx, edx
@@1a:	call	@@4
	mov	edx, [edi+10h]
	mov	eax, [edi+0Ch]
	test	edx, edx
	je	@@1c
	add	[ebp+4], edx
	jc	@@9
	push	edi
	imul	edi, edx, 18h
	call	@@3
@@1d:	call	@@4
	add	edi, 18h
	dec	edx
	jne	@@1d
	pop	edi
@@1c:	mov	edx, [edi+8]
	mov	eax, [edi+4]
	test	edx, edx
	jne	@@1
@@1b:	add	edi, 14h
	dec	ebx
	jne	@@1a
	pop	edi
	pop	ebx
	cmp	esp, ebp
	jne	@@1b
	mov	edi, [esi]
	mov	edx, [esi+8]
	mov	eax, [edi]
	or	al, [edx]
	test	eax, eax
	jne	@@9
	leave
	pop	eax
	ret

@@9:	leave
	pop	eax
	xor	eax, eax
	ret

@@4:	push	edi
	mov	edi, [edi]
	mov	ecx, [esi+0Ch]
	xor	eax, eax
	sub	ecx, edi
	jbe	@@9
	add	edi, [esi+8]
	repne	scasb
	pop	edi
	jne	@@9
	ret

@@3:	mov	ecx, [esi+4]
	cmp	edx, 100000h
	jae	@@9
	sub	ecx, eax
	jbe	@@9
	add	eax, [esi]
	cmp	ecx, edi
	jb	@@9
	xchg	edi, eax
	ret
ENDP

ENDP

; db 'SQSH'
; db ?, pack_type, crypt_flag
; dd data_size
; dd unp_size
; dd checksum

_hapi_unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	push	offset _null_unpack

	mov	edi, [@@SC]
	mov	esi, [@@SB]
	cmp	edi, 13h
	jb	@@8
	cmp	dword ptr [esi], 'HSQS'
	jne	@@8
	cmp	byte ptr [esi+4], 2
	jne	@@8

	mov	eax, [esi+7]
	lea	ecx, [edi-13h]
	cmp	eax, ecx
	jb	$+3
	xchg	eax, ecx
	lea	edx, [esi+13h]
	mov	[@@SC], ecx
	mov	[@@SB], edx

	cmp	byte ptr [esi+6], 0
	je	@@1b
	test	ecx, ecx
	je	@@1b
	xor	ebx, ebx
@@1a:	mov	al, [edx]
	sub	al, bl
	xor	al, bl
	mov	[edx], al
	inc	edx
	inc	ebx
	dec	ecx
	jne	@@1a
@@1b:
	mov	ecx, [esi+0Bh]
	mov	eax, [@@DC]
	cmp	eax, ecx
	jb	$+3
	xchg	eax, ecx
	mov	[@@DC], eax

	mov	al, [esi+5]
	pop	edx
	cmp	al, 1
	jne	$+7
	mov	edx, offset @@Unpack
	cmp	al, 2
	jne	$+7
	mov	edx, offset _zlib_unpack
	push	edx
@@8:	pop	eax
	leave
	pop	edi
	pop	esi
	pop	ebx
	jmp	eax

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
@@1:	shr	ebx, 1
	jne	@@1a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@1a:	jc	@@1b
	dec	[@@SC]
	js	@@9
	dec	[@@DC]
	js	@@9
	movsb
	jmp	@@1

@@1b:	sub	[@@SC], 2
	jb	@@9
	movzx	edx, word ptr [esi]
	inc	esi
	inc	esi
	mov	ecx, edx
	shr	edx, 4
	je	@@7
	and	ecx, 0Fh
	inc	ecx
	inc	ecx
	sub	[@@DC], ecx
	jae	@@1c
	add	ecx, [@@DC]
	and	[@@DC], 0
@@1c:	mov	eax, edi
	sub	eax, [@@DB]
	sub	edx, eax
	dec	edx
	or	edx, -1000h
	add	eax, edx
	jns	@@2b
@@2a:	mov	byte ptr [edi], 0
	inc	edi
	dec	ecx
	je	@@1
	inc	eax
	jne	@@2a
@@2b:	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@7:	mov	esi, [@@DC]
@@9:	xchg	eax, edi
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

ENDP

