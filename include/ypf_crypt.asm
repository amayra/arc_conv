
_ypf_crypt PROC
	mov	eax, [esp+4]
	mov	edx, [esp+8]
	push	14h
	pop	ecx
	sub	eax, 100h
	jb	@@1
	add	ecx, 4
	sub	eax, 12Ch-100h
	cmp	eax, 196h-12Ch
	jae	@@1
	sub	ecx, 0Ah
@@1:	push	edi
	mov	edi, offset @@T
	xchg	eax, edx
	sub	edi, ecx
	repne	scasb
	jne	@@2
	and	ecx, 1
	dec	ecx
	mov	al, [edi+ecx*2]
@@2:	pop	edi
	ret	8

	; 4-name_checksum, 1-name_count, *-name, 1-file_type
	; 1-pack_flag, 4-size, 4-packed_size, 4-offset, 4-packed_adler32

	db 03h,48h,06h,35h		; 0x122, 0x196
	db 0Ch,10h,11h,19h,1Ch,1Eh	; 0x0F7
	db 09h,0Bh,0Dh,13h,15h,1Bh	; 0x12C
	db 20h,23h,26h,29h
	db 2Ch,2Fh,2Eh,32h
@@T:
	; 0xFF 0x0F7 "Four-Leaf" adler32
	; 0x0F7: 0-ybn, 1-bmp, 2-png, 3-jpg, 4-gif, 5-avi, 6-wav, 7-ogg, 8-psd
	; 0x34 0x122 "Neko Koi!" crc32
	; 0x122, 0x12C, 0x196: 0-ybn, 1-bmp, 2-png, 3-jpg, 4-gif, 5-wav, 6-ogg, 7-psd
	; 0x28 0x12C "Suzukaze no Melt" (no recovery - 00 00 00 00)
	; 0xFF 0x196 "Mamono Musume-tachi to no Rakuen ~Slime & Scylla~"
ENDP