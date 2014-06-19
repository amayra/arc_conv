
; "Quartett!" *.dat
; Quartett!.000
; 0053337F sys_load_error
; 00408397 read_header
; 00405D20 md5
; 0040776B decode_tab
; 00415740,00415790 str_call
; 004075EA name_hook
; for(i = 0; i < 0x40; i++) md5str(" ");

_mod_repipack4 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L1
@M0 @@L0, 30h

	lea	esp, [ebp-@@stk]
	call	_repipack_list
	mov	[@@L1], eax
@@1:	and	[@@D], 0
	call	_repipack_find, [@@L1], esi
	jnc	@@7
	mov	edx, esi
	mov	edi, esp
	call	_repipack_hex, 10h
	mov	ebx, [esi+14h]
	lea	edx, [@@L0+21h]
	mov	byte ptr [@@L0+20h], '-'
	call	_StrDec32, 0, ebx, edx
	call	_FileSeek, [@@S], dword ptr [esi+10h], 0
	jc	@@1a
	mov	ecx, [esi+18h]
	lea	eax, [@@D]
	cmp	ebx, ecx
	jne	@@2a
	call	_ArcMemRead, eax, 0, ebx, 0Fh
	xchg	ebx, eax
	cmp	ebx, 8
	jb	@@1a
	call	@@5, offset @@Test1
@@1a:	mov	edi, [@@D]
@@1b:	mov	edx, esp
	call	_ArcName, edx, 30h
@@1c:	call	_ArcData, edi, ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 20h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_repipack_close, [@@L1]
	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	call	_ArcMemRead, eax, ecx, ebx, 0Fh
	xchg	ebx, eax
	cmp	ebx, 8
	jb	@@1a
	call	@@5, offset @@Test2
	mov	edx, [@@D]
	mov	eax, [esi+18h]
	lea	edi, [edx+eax]
	jc	@@1b
	call	_lzss_unpack, edx, eax, edi, ebx
	xchg	ebx, eax
	jmp	@@1a

@@7:	xchg	edi, eax
	lea	edx, [edi+18h]
	call	_ArcName, edx, dword ptr [edi+10h]
	mov	ebx, [esi+14h]
	call	_FileSeek, [@@S], dword ptr [esi+10h], 0
	jc	@@7a
	mov	ecx, [esi+18h]
	lea	eax, [@@D]
	cmp	ebx, ecx
	jne	@@7b
	call	_ArcMemRead, eax, 0, ebx, 0Fh
	xchg	ebx, eax
	test	ebx, ebx
	je	@@7a
	call	@@6, edi
@@7a:	mov	edi, [@@D]
	jmp	@@1c

@@7b:	call	_ArcMemRead, eax, ecx, ebx, 0Fh
	xchg	ebx, eax
	test	ebx, ebx
	je	@@7a
	call	@@6, edi
	mov	edx, [@@D]
	mov	eax, [esi+18h]
	lea	edi, [edx+eax]
	call	_lzss_unpack, edx, eax, edi, ebx
	xchg	ebx, eax
	jmp	@@7a

@@6:	mov	ecx, [edi+10h]
	inc	ecx
	shl	ecx, 3
	sub	esp, 14h
	xor	eax, eax
	push	ecx
	sub	esp, 34h
	lea	ecx, [eax+34h/4]
	mov	edi, esp
	push	8020h
	rep	stosd
	scasd
	stosd
	push	ebx
	push	edx
	movsd
	movsd
	movsd
	movsd
	sub	edi, 10h
	sub	esi, 10h
	lea	edx, [edi-40h]
	call	_md5_transform@8, edi, edx
	jmp	@@6a

@@Test1 PROC
	mov	eax, [esi]
	cmp	eax, 474E5089h
	je	@@2
	cmp	eax, 'SggO'
	je	@@3
	cmp	ax, 'MB'
	je	@@4
	cmp	eax, 'FFIR'
	je	@@5
	cmp	eax, 'EKOT'
	je	@@6
	cmp	eax, 'TSAR'
	je	@@7
@@9:	stc
	ret

@@2:	cmp	dword ptr [esi+4], 00A1A0A0Dh
	jne	@@9
	mov	eax, 'gnp'
	ret

@@3:	cmp	word ptr [esi+4], 200h
	jne	@@9
	mov	eax, 'ggo'
	ret

@@4:	cmp	dword ptr [esi+0Ch], 280000h
	jne	@@9
	mov	eax, 'pmb'
	ret

@@5:	cmp	dword ptr [esi+8], 'EVAW'
	jne	@@9
	mov	eax, 'vaw'
	ret

@@6:	cmp	dword ptr [esi+4], 'TESN'
	jne	@@9
	mov	eax, 'nkt'
	ret

@@7:	cmp	dword ptr [esi+4], 'TNOF'
	jne	@@9
	mov	eax, 'fsr'
	ret
ENDP

@@Test2 PROC
	mov	eax, [esi]
	cmp	eax, 04E5089FFh
	je	@@2
	cmp	eax, 04B4F54FFh
	je	@@6
	cmp	eax, 0534152FFh
	je	@@7
	and	al, 3Fh
	cmp	eax, 067674F3Fh
	je	@@3
	and	al, 0Fh
	cmp	eax, 4649520Fh
	je	@@5
	and	eax, 0FFFF03h
	cmp	eax, 04D4203h
	je	@@4
@@9:	stc
	ret

@@2:	cmp	dword ptr [esi+4], 01A0A0D47h
	jne	@@9
	mov	eax, 'gnp'
	ret

@@3:	mov	eax, [esi+4]
	shl	eax, 4
	cmp	eax, 2005300h
	jne	@@9
	mov	eax, 'ggo'
	ret

@@4:	sub	esp, 10h
	mov	edx, esp
	call	_lzss_unpack, edx, 10h, esi, 10h
	mov	edx, [esp+0Ah]
	add	esp, 10h
	cmp	eax, 0Eh
	jb	@@9
	sub	edx, 36h
	and	edx, NOT 400h
	jne	@@9
	mov	eax, 'pmb'
	ret

@@5:	cmp	byte ptr [esi+4], 'F'
	jne	@@9
	sub	esp, 10h
	mov	edx, esp
	call	_lzss_unpack, edx, 10h, esi, 10h
	mov	edx, [esp+0Ch]
	add	esp, 10h
	cmp	eax, 0Eh
	jb	@@9
	cmp	edx, 'EVAW'
	jne	@@9
	mov	eax, 'vaw'
	ret

@@6:	cmp	dword ptr [esi+4], 'ESNE'
	jne	@@9
	mov	eax, 'nkt'
	ret

@@7:	cmp	dword ptr [esi+4], 'NOFT'
	jne	@@9
	mov	eax, 'fsr'
	ret
ENDP

@@5:	xor	eax, eax
	sub	esp, 4Ch
	lea	ecx, [eax+3Ch/4]
	mov	edi, esp
	push	8020h
	rep	stosd
	push	ebx
	push	edx
@@5a:	add	ecx, 8
	mov	[edi-8], ecx
	movsd
	movsd
	movsd
	movsd
	sub	edi, 10h
	sub	esi, 10h
	lea	edx, [edi-40h]
	call	_md5_transform@8, edi, edx
	pop	edx
	mov	eax, [edi+0Ch]
	xor	eax, [edx+0Ch]
	push	edx
	push	esi
	push	eax
	mov	eax, [edi+8]
	xor	eax, [edx+8]
	push	eax
	mov	eax, [edi+4]
	xor	eax, [edx+4]
	push	eax
	mov	eax, [edi]
	xor	eax, [edx]
	push	eax
	mov	esi, esp
	call	dword ptr [esi+58h+14h+4]
	lea	esp, [esi+10h]
	pop	esi
	mov	ecx, [edi-8]
	jnc	@@5b
	cmp	ecx, 600h
	jb	@@5a
	add	esp, 58h
	stc
	ret	4

@@5b:	push	eax
	shr	ecx, 3
	dec	ecx
	lea	edx, [@@L0+21h]
	call	_StrDec32, 0, ecx, edx
	lea	edx, [@@L0+21h+eax]
	pop	eax
	mov	byte ptr [edx], 2Eh
	mov	[edx+1], eax
@@6a:	add	ebx, 0Fh
	shr	ebx, 4
	push	40h
	pop	eax
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
@@5c:	pop	edx
	xor	ecx, ecx
@@5d:	mov	eax, [edi+ecx*4]
	xor	[edx], eax
	inc	ecx
	add	edx, 4
	cmp	ecx, 4
	jb	@@5d
	dec	ebx
	je	@@5e
	push	edx
	add	dword ptr [edi-8], 8
	lea	edx, [edi-40h]
	call	_md5_transform@8, edi, edx
	jmp	@@5c
@@5e:	pop	ebx
	add	esp, 50h
	clc
	ret	4
ENDP
