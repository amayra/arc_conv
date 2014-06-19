
; "Sugar Coat Freaks" *.dat
; 00472CD0 read_header
; 00489A70 str_call
; 00472D00 file_decode
; 00472CD0 header_decode
; 00471E17 name_hook(ecx)
; 00471313 name_hook(eax)
; for(i = 0; i < 0x40; i++) md5str(reverse_str + (i % len));

_mod_repipack5 PROC

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
	call	_StrDec32, 0, dword ptr [esi+18h], edx
	call	_FileSeek, [@@S], dword ptr [esi+10h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0Fh
	xchg	ebx, eax
@@1a:	mov	edx, esp
	call	_ArcName, edx, 30h
@@1c:	call	_ArcData, [@@D], ebx
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

@@7:	xchg	edi, eax
	lea	edx, [edi+18h]
	call	_ArcName, edx, dword ptr [edi+10h]
	mov	ebx, [esi+14h]
	call	_FileSeek, [@@S], dword ptr [esi+10h], 0
	jc	@@1c
	mov	ecx, [esi+18h]
	lea	eax, [@@D]
	cmp	ebx, ecx
	jne	@@7b
	xor	ecx, ecx
	call	@@6
	jmp	@@1c

@@7b:	call	@@6
	call	_lzss_unpack, [@@D], dword ptr [esi+18h], edx, ebx
	xchg	ebx, eax
	jmp	@@1c

@@6 PROC

@@stk = 0
@M0 @@D
@M0 @@C
@M0 @@L0, 14h

	call	_ArcMemRead, eax, ecx, ebx, 0
	xchg	ebx, eax
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ecx, [edi+10h]
	push	edx
	push	ecx
	push	0
	mov	edx, 10325476h
	mov	eax, 98BADCFEh
	push	edx
	push	eax
	not	edx
	not	eax
	push	edx
	push	eax

	lea	edx, [edi+18h-1]
	lea	eax, [ecx+3]
	and	eax, -4
	sub	esp, eax
	mov	edi, esp
@@2:	mov	al, [edx+ecx]
	stosb
	dec	ecx
	jne	@@2
	mov	edi, [@@D]
	xor	esi, esi
	test	ebx, ebx
	je	@@9
@@1:	cmp	esi, 40h
	jae	@@9
	mov	ecx, [@@C]
	mov	eax, esi
	xor	edx, edx
	inc	esi
	div	ecx
	lea	eax, [@@L0]
	sub	ecx, edx
	add	edx, esp
	call	_repipack_md5, edx, ecx, eax
	xor	ecx, ecx
@@3:	cmp	ecx, 10h
	je	@@1
	mov	al, byte ptr [@@L0+ecx]
	inc	ecx
	xor	[edi], al
	inc	edi
	dec	ebx
	jne	@@3
@@9:	mov	edx, [@@D]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	
ENDP

ENDP
