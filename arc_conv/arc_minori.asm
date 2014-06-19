
; "Ef - A Fairy Tale of the Two" *.paz
; ef.exe

; "Ef - the First Tale" *.paz
; 004CD410 header_keys
; 004CD6C0 arc4_keys

; "Riddle Garden" *.dat
; RiddleGarden.exe
; 0042E2DF IsDebuggerPresent
; 0042D511 string_neg
; 00438917 read_header
; 0042D93F blowfish
; 004562E3 movie_arc_tab
; 0042E787 arc4_init
; 0043B3CD arc4_file_decode_init
; 0043B87E arc4_file_decode
; 004B4630 arc4_keys
; 00436161 opening
; 00439482 movie_decode_loop
; 004391DB movie_key_loop

; "Eden*" *.paz
; eden.exe
; 00475F84 run_fix
; 0041E52F IsDebuggerPresent
; 0041D6D8 string_neg
; 004BAEC8 header_keys
; 004BB148 data_keys
; 0041DB06 blowfish

	dw 0
_arc_minori PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@SC
@M0 @@L0
@M0 @@L1
@M0 @@L2
@M0 @@L3, 8
@M0 @@L4
@M0 @@L5

	enter	@@stk+0Ch, 0

	call	_ArcParam
	db 'minori', 0
	jc	@@4g
	call	_minori_select, eax
	jc	@@9a
@@4g:	mov	[@@L0], eax
	call	_minori_table, eax
	mov	[@@L4], eax
	xchg	edi, eax

	call	_minori_test, [@@L0], offset inFileName
	shl	eax, 8
	and	[@@L3], 0
	mov	[@@L3+4], eax
	movzx	eax, byte ptr [edi+ecx+1]
	mov	[@@L5], eax

	movzx	eax, byte ptr [edi]
	add	edi, eax
	movzx	ebx, byte ptr [edi]
	inc	edi
	lea	ecx, [ebx+0Ch]
	sub	esp, ebx
	mov	esi, esp
	call	_FileRead, [@@S], esi, ecx
	jc	@@9a
	mov	eax, [@@L5]
	mov	edx, esi
	test	eax, eax
	je	@@4e
	lea	ecx, [ebx+0Ch]
@@4d:	xor	[edx], al
	inc	edx
	dec	ecx
	jne	@@4d
@@4e:	movzx	ecx, byte ptr [edi]
	inc	edi
	test	ecx, ecx
	je	$+4
	repe	cmpsb
	jne	@@9a
	lea	esp, [ebp-@@stk-0Ch]
	pop	ebx
	cmp	ebx, 1Ch
	jb	@@9
	sub	ebx, 4
	mov	[@@SC], ebx
	mov	esi, esp
	movzx	ebx, byte ptr [edi]
	inc	edi
	mov	[@@N], ebx
	mov	ecx, [esi]
	mov	edx, [esi+4]
	test	ebx, ebx
	je	@@4b
	sub	esp, 0FFCh
	push	ecx
	sub	esp, 48h
	mov	ebx, esp
@@4a:	xor	eax, eax
	or	ecx, -1
	repne	scasb
	call	_blowfish_set_key@12, ebx, edi, 20h
	mov	ecx, ebx
	mov	eax, [esi]
	mov	edx, [esi+4]
	call	_blowfish_decrypt
	mov	ecx, eax
	dec	eax
	shr	eax, 14h
	je	@@4b
	add	edi, 40h
	dec	[@@N]
	jne	@@4a
	jmp	@@9a

@@4b:	mov	[@@L1], ebx
	and	[@@L2], 0
	push	edx
	mov	ebx, [@@SC]
	mov	[@@N], ecx
	imul	eax, ecx, 19h
	dec	ecx
	shr	ecx, 14h
	jne	@@9a
	cmp	ebx, eax
	jb	@@9a
	sub	ebx, 4
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 4, ebx, 0
	jc	@@9
	call	@@3
	mov	esi, [@@M]
	mov	eax, [@@L1]
	pop	dword ptr [esi]
	test	eax, eax
	je	@@4c
	add	edi, 20h
	call	_blowfish_set_key@12, eax, edi, 20h
@@4c:	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, [@@SC]

	mov	ecx, [@@L3+4]
	test	ecx, ecx
	je	@@1
	sub	[@@SC], ecx
	jb	@@9
	mov	[@@L3], esi
	add	esi, ecx

@@1:	mov	ecx, [@@SC]
	mov	edi, esi
	sub	ecx, 18h
	jbe	@@9
	xor	eax, eax
	repne	scasb
	jne	@@9
	mov	[@@SC], ecx
	mov	[@@L2], esi
	call	_ArcName, esi, -1
	and	[@@D], 0
	lea	esi, [edi+18h]
	; offset, zero, unp_size, size, align8_size, pack_flag
	mov	edi, [esi-10h]
	mov	ebx, [esi-8]
	cmp	dword ptr [esi-14h], 0
	jne	@@8
	call	_FileSeek, [@@S], dword ptr [esi-18h], 0
	jc	@@1a
	xor	ecx, ecx
	cmp	dword ptr [esi-4], 1
	jne	$+4
	mov	ecx, edi
	lea	eax, [@@D]
	call	_ArcMemRead, eax, ecx, ebx, 0
	call	@@3
	cmp	dword ptr [esi-4], 1
	je	@@2a
	cmp	eax, edi
	jb	$+3
	xchg	eax, edi
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	call	_zlib_unpack, [@@D], edi, edx, eax
	jmp	@@1b

@@3:	push	eax
	push	edx
	push	ebx
	push	edi
	xchg	ebx, eax
	mov	edi, edx
	test	ebx, ebx
	je	@@3e
	mov	eax, [@@L5]
	test	eax, eax
	je	@@3g
	mov	ecx, ebx
@@3f:	xor	[edx], al
	inc	edx
	dec	ecx
	jne	@@3f
@@3g:
	mov	ecx, [@@L1]
	test	ecx, ecx
	je	@@3e
	cmp	[@@L3], 0
	jne	@@3b
	shr	ebx, 3
	je	@@3b
@@3a:	mov	eax, [edi]
	mov	edx, [edi+4]
	call	_blowfish_decrypt
	mov	[edi], eax
	mov	[edi+4], edx
	add	edi, 8
	dec	ebx
	jne	@@3a
@@3b:	cmp	[@@L2], 0
	je	@@3e
	mov	edi, [esp+8]
	mov	ebx, [esp+0Ch]
	call	_ArcGetExt
	cmp	eax, 'ggo'
	jne	@@3h
	cmp	ebx, 8
	jb	@@3h
	mov	ecx, 'SggO'
	mov	edx, 200h
	sub	ecx, [edi]
	sub	edx, [edi+4]
	or	ecx, edx
	je	@@3e
@@3h:	call	_minori_crypt, edi, ebx, [@@L2], dword ptr [esi-10h], eax, [@@L3], [@@L4]
@@3e:	pop	edi
	pop	ebx
	pop	edx
	pop	eax
	ret

ENDP
