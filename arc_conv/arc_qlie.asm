
; "Asuseka", "Akizora Confetti", "Makai Tenshi Djibril -Episode 3-", "Mehime no Toriko", "Natsukashi" GameData\data?.pack
; soshite.exe

; akicon_trial
; 00482DB4 decode
; 00486890 decode_new
; 00422418 read_file

; 1.0 "CLIe" - "Natsukashi"
; 2.0 "CLIE" - "Mehime no Toriko"
; 3.0 "QLIE" - "Asuseka", "Akizora Confetti", "Makai Tenshi Djibril -Episode 3-"

	dw 0
_arc_qlie PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 8
@M0 @@L1

	enter	@@stk+1Ch, 0
	call	_FileSeek, [@@S], -1Ch, 2
	jc	@@9a
	xchg	ebx, eax
	mov	esi, esp
	call	_FileRead, [@@S], esi, 1Ch
	jc	@@9a
	pop	eax
	pop	edx
	pop	ecx
	pop	edi
	sub	eax, 'eliF'
	sub	edx, 'kcaP'
	sub	ecx, '0reV'
	or	eax, edx
	sub	edi, '0.'
	bswap	ecx
	or	eax, edi
	mov	[@@L0+4], ecx
	jne	@@9a
	dec	ecx
	cmp	ecx, 3
	jae	@@9a
	pop	eax
	mov	[@@N], eax
	dec	eax
	shr	eax, 14h
	jne	@@9a
	pop	ecx
	pop	eax
	test	eax, eax
	jne	@@9a
	sub	ebx, ecx
	jb	@@9a
	call	_FileSeek, [@@S], ecx, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	@@5
	test	eax, eax
	je	@@9
	mov	[@@N], eax
	call	_ArcCount, eax
	call	_ArcDbgData, esi, ebx

	; 8 offset
	; 4 packed_size
	; 4 file_size
	; 4 packed_flag
	; 4 encode_flag(1,4)
	; 4 checksum

@@1:	mov	[@@L1], esi
	movzx	ebx, word ptr [esi]
	inc	esi
	inc	esi
	call	_ArcName, esi, ebx
	add	esi, ebx
	and	[@@D], 0
	mov	ebx, [esi+8]
	cmp	dword ptr [esi+4], 0
	jne	@@1a
	call	_FileSeek, [@@S], dword ptr [esi], 0
	jc	@@1a
	mov	ecx, [esi+0Ch]
	cmp	dword ptr [esi+10h], 1
	je	$+4
	xor	ecx, ecx
	lea	eax, [@@D]
	call	_ArcMemRead, eax, ecx, ebx, 0
	mov	ecx, ebx
	xchg	ebx, eax
	mov	edi, edx
	mov	eax, [esi+14h]
	push	edx
	dec	eax
	jne	@@2a
	call	@@3
@@2b:	pop	edx
	cmp	dword ptr [esi+10h], 1
	jne	@@1a
	call	@@Unpack, [@@D], dword ptr [esi+0Ch], edx, ebx
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 1Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	cmp	eax, 3
	jne	@@2b
	call	@@Crypt4, edi, ebx, [@@L0], [@@L1]
	jmp	@@2b

@@3:	mov	eax, [@@L0]
	add	eax, ecx
	shr	ecx, 3
	je	@@3b
					; 0xA73C5F9D + 0xCE24F523 = 0x756154C0
	xor	eax, 08BA821FEh		; (0xA73C5F9D + 0xCE24F523) ^ 0xFEC9753E
	shl	ecx, 1
	push	ebx
	mov	edx, eax
	xchg	ebx, eax
@@3a:	mov	eax, [edi]
	xor	eax, edx
	stosd
	add	edx, 0CE24F523h
	xor	edx, eax
	xchg	edx, ebx
	dec	ecx
	jne	@@3a
	pop	ebx
@@3b:	ret

@@5:	push	esi
	push	edi
	and	[@@L0], 0
	cmp	[@@L0+4], 2
	jb	@@2c
	sub	ebx, 424h
	jb	@@9
	cmp	[@@L0+4], 3
	jb	@@5f
	lea	edx, [esi+ebx+24h]
	mov	ecx, 100h
	call	_qlie_checksum
	and	eax, 0FFFFFFFh
	mov	[@@L0], eax
@@5f:	lea	edi, [esi+ebx]
	push	20h
	pop	ecx
	call	@@3
	sub	edi, 20h
	push	8
	pop	ecx
	push	esi
	call	@@2d
	db '8hr48uky,8ugi8ewra4g8d5vbf5hb5s6'
@@2d:	pop	esi
	repe	cmpsd
	pop	esi
	jne	@@9
@@2c:	push	-3Ch
	pop	edi
	cmp	[@@L0+4], 3
	jb	@@5g
	mov	edi, [@@L0]
@@5g:	xor	edi, 3Eh
	push	[@@N]
@@5c:	sub	ebx, 1Ch+2
	jb	@@5e
	movzx	edx, word ptr [esi]
	inc	esi
	inc	esi
	sub	ebx, edx
	jb	@@5e
	xor	ecx, ecx
@@5d:	lea	eax, [edi+edx]
	inc	ecx
	xor	eax, ecx
	add	eax, ecx
	xor	[esi], al
	inc	esi
	cmp	ecx, edx
	jb	@@5d
	add	esi, 1Ch
	dec	[@@N]
	jne	@@5c
@@5e:	pop	eax
	sub	eax, [@@N]
	mov	ebx, esi
	pop	edi
	pop	esi
	sub	ebx, esi
	ret

@@Unpack PROC	; "Asuseka" 00470A5C

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	enter	404h, 0
	mov	esi, [@@SB]
	mov	edi, [@@DB]
	sub	[@@SC], 4
	jb	@@9
	xor	ecx, ecx
	lodsd
	cmp	eax, 0FF435031h
	jne	@@2a
	sub	[@@SC], 8
	jb	@@9
	lodsd
	xchg	ecx, eax
	lodsd
@@2a:	mov	edx, [@@DC]
	mov	[@@L0], ecx
	cmp	edx, eax
	jb	$+3
	xchg	edx, eax
	mov	[@@DC], edx

@@1:	xor	eax, eax
	cmp	[@@DC], eax
	je	@@7
@@1a:	mov	[esp+eax*4], al
	inc	al
	jne	@@1a
	xor	ecx, ecx
@@1b:	dec	[@@SC]
	js	@@9
	lodsb
	mov	edx, eax
	sub	al, 7Fh
	jbe	@@1c
	add	ecx, eax
	xor	edx, edx
@@1c:	test	ch, ch
	jne	@@1f
@@1d:	test	ch, ch
	jne	@@9
	dec	[@@SC]
	js	@@9
	lodsb
	mov	[esp+ecx*4], al
	cmp	ecx, eax
	je	@@1e
	dec	[@@SC]
	js	@@9
	lodsb
	mov	[esp+ecx*4+1], al
@@1e:	inc	ecx
	dec	edx
	jns	@@1d
	test	ch, ch
	je	@@1b
@@1f:
	mov	edx, [@@L0]
	shr	edx, 1
	jnc	@@2b
	sub	[@@SC], 2
	jb	@@9
	lodsw
	jmp	@@2c
@@2b:	sub	[@@SC], 4
	jb	@@9
	lodsd
@@2c:	xchg	ecx, eax

	xor	edx, edx
	xor	eax, eax
@@3:	dec	edx
	js	@@3a
	mov	al, [esp+edx*4+2]
	jmp	@@3b
@@3a:	inc	edx
	dec	ecx
	js	@@1
	dec	[@@SC]
	js	@@9
	lodsb
@@3b:	mov	ebx, eax
	mov	al, [esp+eax*4]
	cmp	ebx, eax
	jne	@@3c
	dec	[@@DC]
	js	@@9
	stosb
	jmp	@@3
@@3c:	test	dh, dh
	jne	@@9
	mov	bl, [esp+ebx*4+1]
	mov	[esp+edx*4+2], bl
	inc	edx
	jmp	@@3b

@@7:	xor	esi, esi
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

@@Crypt4 PROC		; "Akizora Confetti" 0048663C

@@S = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]
@@L0 = dword ptr [ebp+1Ch]	; key
@@L1 = dword ptr [ebp+20h]	; name

	push	ebx
	push	esi
	push	edi
	enter	1B0h, 0
	mov	esi, [@@L1]
	xor	eax, eax
	lodsw
	xchg	ecx, eax
	mov	edx, 85F532h
	mov	edi, 33F641h
	test	ecx, ecx
	je	@@1a
	xor	ebx, ebx
@@1:	xor	eax, eax
	lodsb
	imul	eax, ebx
	add	edx, eax
	xor	edi, edx
	inc	bl
	dec	ecx
	jne	@@1
@@1a:	mov	eax, [@@C]
	mov	ecx, eax
	xor	eax, 8F32DCh
	xor	eax, edx
	add	eax, edx
	lea	eax, [eax+ecx*8]
	xor	eax, [@@L0]
	add	eax, edi
	and	eax, 0FFFFFFh
	lea	eax, [eax+eax*8]
	xor	ecx, ecx
	xor	eax, 453Ah
@@2:	mov	edx, dword ptr [@@T+ecx*4]
	xor	edx, eax
	mov	[esp+ecx*4], edx
	inc	ecx
	mov	edx, eax
	shr	eax, 1Eh
	xor	eax, edx
	imul	eax, 6611BC19h
	add	eax, ecx
	cmp	ecx, 40h
	jb	@@2
	xor	ebx, ebx
	lea	esi, [esp+ecx*4]
@@3:	lea	edx, [ebx+1]
	and	edx, 3Fh
	mov	edx, [esp+edx*4]
	mov	eax, [esp+ebx*4]
	and	edx, 7FFFFFFFh
	shl	eax, 1
	rcr	edx, 1
	sbb	eax, eax
	and	eax, 9908B0DFh
	xor	eax, edx
	lea	edx, [ebx+27h]
	and	edx, 3Fh
	xor	eax, [esp+edx*4]
	mov	[esp+ebx*4], eax
	mov	edx, eax
	shr	eax, 0Bh
	xor	eax, edx
	mov	edx, eax
	shl	eax, 7
	and	eax, 09C4F88E3h
	xor	eax, edx
	mov	edx, eax
	shl	eax, 0Fh
	and	eax, 0E7F70000h
	xor	eax, edx
	mov	edx, eax
	shr	eax, 12h
	xor	eax, edx
	mov	[esp+ecx*4], eax
	inc	ebx
	inc	ecx
	and	ebx, 3Fh
	cmp	ecx, 6Ch
	jb	@@3
	mov	ecx, [@@C]
	mov	esp, esi
	shr	ecx, 3
	je	@@9
	mov	ebx, [ebp-4]
	mov	edi, [@@S]
	movq	mm0, [ebp-0Ch]
@@4:	and	ebx, 0Fh
	movq	mm1, [esp+ebx*8]
	movq	mm2, [edi]
	pxor	mm0, mm1
	paddd	mm0, mm1
	pxor	mm2, mm0
	paddb	mm0, mm2
	pxor	mm0, mm2
	pslld	mm0, 1
	paddw	mm0, mm2
	movq	[edi], mm2
	add	edi, 8
	inc	ebx
	dec	ecx
	jne	@@4
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@T:	; "key.fkey" xor "akizora.ico"
dd 04678654Bh, 060256C68h, 031736576h, 04228300Eh
dd 000160001h, 000281000h, 000400025h, 000800000h
dd 030303032h, 065202F00h, 027647574h, 08F202F20h
dd 082F38B48h, 0829195C9h, 0835283A4h, 083748393h
dd 083658346h, 000000042h, 0AD519200h, 04A48052Dh
dd 06018F602h, 0C90B4117h, 09B1F0BC5h, 029BD237Ah
dd 081EE6D4Ch, 04892CAB3h, 09486BDE3h, 019FBF2F3h
dd 0D18EF9A6h, 0E388A640h, 063D9DE9Eh, 0721AD618h
dd 0120F4814h, 004730173h, 0DA15A935h, 06719F36Eh
dd 02A1CAB22h, 0F9876D50h, 0B98F8787h, 0CF87AC9Eh
dd 0CAEC24DDh, 0031C58EDh, 0BECE6E47h, 0A559466Ah
dd 0F51D1067h, 0E7383F38h, 0711F9D75h, 08148BEBCh
dd 0EBD844B5h, 0BFA957ABh, 0B1E11F08h, 09DAC2CE5h
dd 00E755B86h, 0014596D0h, 05B384950h, 08C4CEF1Fh
dd 0DE364337h, 0E7682EFDh, 06A7FEDCFh, 00224F14Eh
dd 0786DB0C6h, 040BEAAA6h, 02BA864E4h, 04CD89578h
ENDP

ENDP
