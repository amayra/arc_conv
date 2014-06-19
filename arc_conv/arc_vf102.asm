
; "Heart no Kuni no Alice", "Mugen Yakou" game.dat, save.dat
; AliceInHeart.exe
; 000C4FF8 decode_init
; 000C50E8 decode_next
; 0017F837 version_read
; 00180494 get_file_obj

; mem_file:
; 0x14=name
; 0x38=flag_unpacked
; 0x3C=unk2
; 0x40=crc32
; 0x44=unk3

; "livemaker"

; // header(size = 0xA)
; { 2 sign("vf"), 4 ver(102), 4 cnt }
; if(ver < 100) cnt * { 4 size, size name }
; if(ver >= 100) cnt * { 4 size, size encoded_name }
; if(ver < 100) (cnt + 1) * { 4 offset32 }
; if(ver == 100) (cnt + 1) * { 4 encoded_offset32 }
; if(ver >= 101) (cnt + 1) * { 8 encoded_offset64 }
; if(ver >= 101) cnt * { 1 flag_unpacked }
; if(ver >= 101) cnt * { 4 unknown }	// time?
; if(ver >= 101) cnt * { 4 packed_crc32 }
; if(ver >= 102) cnt * { 1 unknown }

	dw 0
_arc_vf102 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1
@M0 @@L2

	enter	@@stk+400h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 400h
	xchg	ebx, eax
	cmp	ebx, 0Eh
	jb	@@9a
	movzx	eax, word ptr [esi]
	mov	edx, [esi+2]
	sub	eax, 'fv'
	sub	edx, 66h
	or	eax, edx
	jne	@@9a
	mov	edx, [esi+6]
	mov	ecx, edx
	shl	edx, 2
	mov	[@@L0], ecx
	mov	[@@N], ecx
	mov	[@@L1], edx
	dec	ecx
	shr	ecx, 14h
	jne	@@9a
	push	0Ah
	pop	edi
@@2a:	call	@@3, 4
	dec	eax
	cmp	eax, 1FFh
	jae	@@9a
	inc	eax
	add	[@@L1], eax
	call	@@3, eax
	dec	[@@L0]
	jne	@@2a
	mov	ebx, [@@N]
	imul	ebx, 12h
	add	ebx, 8
	add	ebx, [@@L1]
	lea	esp, [ebp-@@stk]
	call	_FileSeek, [@@S], 0Ah, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	mov	edx, [@@N]
	xor	eax, eax
@@2b:	mov	ecx, [esi]
	add	esi, 4
@@2c:	lea	eax, [eax*4+eax+39h]	; 75D6EE39h
	xor	[esi], al
	inc	esi
	dec	ecx
	jne	@@2c
	dec	edx
	jne	@@2b
	mov	[@@L0], esi
	mov	ecx, [@@N]
	xor	eax, eax
@@2d:	lea	eax, [eax*4+eax+75D6EE39h]
	cdq
	xor	[esi], eax
	xor	[esi+4], edx
	add	esi, 8
	dec	ecx
	jns	@@2d		; +1
	add	esi, [@@N]
	mov	[@@L2], esi
	mov	esi, [@@M]
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	lodsd
	xchg	ebx, eax
	call	_ArcName, esi, ebx
	add	esi, ebx
	mov	edi, [@@L0]
	mov	ebx, [edi+8]
	mov	edx, [edi+0Ch]
	add	[@@L0], 8
	sub	ebx, [edi]
	sbb	edx, [edi+4]
	jne	@@1a
	mov	edx, [edi+4]
	mov	eax, [edi]
	test	edx, edx
	jne	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	mov	edx, [@@L2]
	sub	edx, [@@N]
	cmp	byte ptr [edx], 0
	jne	@@1a
	call	_zlib_unpack, 0, -1, [@@D], ebx
	jc	@@1a
	test	eax, eax
	je	@@1a
	xchg	edi, eax
	call	_MemAlloc, edi
	jc	@@1a
	xchg	edi, eax
	call	_zlib_unpack, edi, eax, [@@D], ebx
	xchg	ebx, eax
	call	_MemFree, [@@D]
	mov	[@@D], edi
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	mov	ecx, [esp+4]
	xor	eax, eax
@@3a:	cmp	edi, ebx
	je	@@3b
	mov	al, [esi+edi]
	inc	edi
	ror	eax, 8
	dec	ecx
	jne	@@3a
	ret	4
@@3b:	cmp	ebx, 400h
	jne	@@9a
	xor	edi, edi
	push	eax
	push	ecx
	call	_FileRead, [@@S], esi, ebx
	xchg	ebx, eax
	pop	ecx
	pop	eax
	jmp	@@3a
ENDP
