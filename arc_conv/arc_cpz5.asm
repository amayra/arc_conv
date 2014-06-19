
; "Natsu ni Kanaderu Bokura no Uta" *.cpz
; cmvs32.exe
; 004038F0 file_read
; 00443870 archive_open
; 00443620 archive_read
; 00421360 pb3_read

; dir: next, count, offset, key, name(*)
; file: next, offset, 0, size, checksum, key, name(*)

	dw _conv_cpz5-$-2
_arc_cpz5 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@L2, 14h
@M0 @@L1, 0Ch

	enter	@@stk+40h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 40h
	jc	@@9a
	cmp	dword ptr [esi], '5ZPC'
	jne	@@9a
	mov	edx, esi
	call	@@HdrCheck
	cmp	eax, [esi+3Ch]
	jne	@@9a
	call	@@HdrCrypt
	mov	ebx, [esi+8]
	cmp	ebx, 10h
	jb	@@9a
	add	ebx, [esi+0Ch]
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 40h, ebx, 0
	jc	@@9
	mov	edi, [@@M]
	push	10h
	pop	ecx
	rep	movsd
	add	ebx, 40h
	lea	esi, [edi-40h]
	sub	esp, 140h
	call	@@6, esi, esp
	test	eax, eax
	je	@@9
	call	@@ListDec, eax, esi, 0, esp
	call	_ArcDbgData, esi, ebx

	call	@@5
	lea	ecx, [eax-1]
	mov	[@@N], eax
	shr	ecx, 14h
	jc	@@9
	call	_ArcCount, [@@N]
	mov	[@@L1+8], esp
	sub	esp, 200h
	mov	[@@L1], esp

	lea	edi, [esi+40h]
	mov	ecx, [esi+4]
	mov	edx, [esi+8]
	mov	[@@L2], edi
	mov	[@@L2+4], ecx
	add	edi, edx
	mov	ecx, [esi+0Ch]
	lea	edx, [edx+ecx+40h]
	mov	[@@L2+8], edi
	mov	[@@L2+0Ch], ecx
	mov	[@@P], edx

@@2:	mov	edx, [@@L2]
	mov	edi, [@@L1]
	mov	ecx, [edx]
	lea	esi, [edx+10h]
	sub	ecx, 10h
	je	@@2b
@@2a:	lodsb
	test	al, al
	je	@@2b
	cmp	edi, [@@L1+8]
	je	$+3
	stosb
	dec	ecx
	jne	@@2a
@@2b:	cmp	edi, [@@L1]
	je	@@2c
	mov	al, 2Fh
	cmp	edi, [@@L1+8]
	je	$+3
	stosb
@@2c:	mov	eax, [edx+4]
	mov	[@@L1+4], edi
	test	eax, eax
	je	@@2e
	mov	[@@N], eax

	mov	esi, [edx+8]
	mov	ebx, [@@L2+0Ch]
	cmp	[@@L2+4], 1
	je	@@2d
	add	edx, [edx]
	mov	eax, [edx+8]
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
@@2d:	sub	ebx, esi
	jb	@@2e
	mov	[@@L2+10h], ebx
	add	esi, [@@L2+8]

@@1:	lea	edx, [esi+18h]
	cmp	[@@L2+10h], 18h
	jb	@@2e
	mov	ecx, [esi]
	mov	edi, [@@L1+4]
	sub	[@@L2+10h], ecx
	jb	@@2e
	sub	ecx, 18h
	jb	@@2e
	je	@@1c
@@1b:	mov	al, [edx]
	inc	edx
	test	al, al
	je	@@1c
	cmp	edi, [@@L1+8]
	je	$+3
	stosb
	dec	ecx
	jne	@@1b
@@1c:	xor	eax, eax
	cmp	edi, [@@L1+8]
	je	@@1d
	stosb
	call	_ArcName, [@@L1], -1
@@1d:	and	[@@D], 0
	mov	eax, [esi+4]
	mov	ebx, [esi+0Ch]
	add	eax, [@@P]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	mov	edx, [@@M]
	xchg	ebx, eax
	cmp	dword ptr [edx+34h], 0
	je	@@1a
	mov	ecx, [@@L2]
	mov	eax, [esi+14h]
	add	eax, [ecx+0Ch]
	xor	eax, [edx+30h]
	add	eax, [edx+4]
	add	eax, 0A3D61785h
	call	@@FileDec, [@@M], [@@D], ebx, eax, [@@L1+8]

@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, [esi]
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@2e:	mov	esi, [@@L2]
	add	esi, [esi]
	mov	[@@L2], esi
	dec	[@@L2+4]
	jne	@@2
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@5 PROC
	push	esi
	mov	edi, [esi+8]
	mov	ecx, [esi+4]
	xor	eax, eax
	add	esi, 40h
@@1:	cmp	edi, 10h
	jb	@@9
	mov	edx, [esi]
	add	eax, [esi+4]
	jc	@@9
	cmp	edx, 10h
	jb	@@9
	sub	edi, edx
	jb	@@9
	add	esi, edx
	dec	ecx
	jne	@@1
@@8:	pop	esi
	ret

@@9:	xor	eax, eax
	jmp	@@8
ENDP

@@HdrCheck PROC
	mov	eax, 923A564Ch
	xor	ecx, ecx
@@1:	add	eax, [edx+ecx*4]
	inc	ecx
	cmp	ecx, 0Fh
	jb	@@1
	ret
ENDP

@@HdrCrypt PROC
	push	esi
	call	@@2
	dd 0FE3A53D9h, 037F298E7h, 07A6F3A2Ch
	dd 043DE7C19h, 0CC65F415h, 0D016A93Ch, 097A3BA9Ah
	dd 0AE7D39BFh, 0FB73A955h, 037ACF831h
@@2:	pop	esi
	xor	ecx, ecx
	inc	ecx
@@1:	lodsd
	xor	[edx+ecx*4], eax
	inc	ecx
	cmp	ecx, 4
	jne	$+4
	shl	ecx, 1
	cmp	ecx, 0Fh
	jb	@@1
	pop	esi
	ret
ENDP

@@6:	push	ebx
	push	esi
	push	edi
	enter	10h, 0
	mov	edi, esp
	mov	esi, offset @@T
	lodsd
	xchg	ebx, eax
@@6a:	call	@@ListDec, esi, dword ptr [ebp+14h], edi, dword ptr [ebp+18h]
	mov	eax, [edi]
	mov	edx, [edi+4]
	sub	eax, 10h
	shr	edx, 14h
	shr	eax, 9
	or	edx, [edi+8]
	or	eax, edx
	je	@@6b
	add	esi, 28h
	dec	ebx
	jne	@@6a
	xor	esi, esi
@@6b:	xchg	eax, esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@T PROC
dd 3

@@1a:	; "Memoria"
dd 0A79463F9h,0B6E755C5h,0C696AF21h,06983E978h
dd 000000000h,000000000h,000000000h,000000000h
db 01h,82h,03h,80h
dd @@2a-@@1a

@@1b:	; "Natsu ni Kanaderu Bokura no Uta"
dd 063FE9A7Ch,0C2B93E98h,0EF91BA5Ch,072C9A82Eh
dd 045876329h,054F36D6Ch,04387A749h,0E3F9A742h
db 01h,82h,03h,80h
dd @@2a-@@1b

@@1c:	; "Mirai Nostalgia (trial v1.1)"
dd 064FE9A8Ch,0C2F93EA8h,0EF81BA5Dh,092C8A72Fh
dd 049876325h,054F46D7Ch,0AC7958B7h,01C0638BDh
db 81h,02h,83h,00h
dd @@2b-@@1c

@@2a:
dd 0CD90F089h,0E982B782h,0A282AB88h,0CD82718Eh
dd 052838A83h,0A882AA82h,07592648Eh,0B582AB82h
dd 0E182BF82h,0DC82A282h,04281B782h,0ED82F48Eh
dd 0BF82EA82h,0A282E182h,0B782DC82h,06081E682h
dd 0C6824181h,0A482A282h,0E082A982h,0F48EA482h
dd 0BF82C182h,0A282E182h,0B582DC82h,0F481BD82h

@@2b:
dd 0CD90F089h,0E982B782h,0A282AB88h,0CD82718Eh
dd 052838A83h,0A882AA82h,07592648Eh,0B582AB82h
dd 0E182BF82h,0DC82A282h,04281B782h,062838183h
dd 0A9824981h,0A282ED82h,0C682A282h,0BE8CA982h
dd 0C482C182h,0968BE082h,0C482B582h,0B082A082h
dd 0A282C882h,0BE82F182h,0E782A982h,049819F82h
ENDP

@@ListDec PROC

@@K = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@D = dword ptr [ebp+1Ch]
@@X = dword ptr [ebp+20h]

@@stk = 0
@M0 @@N
@M0 @@L2, 10h
@M0 @@L1
@M0 @@L0, 10h

	push	ebx
	push	esi
	push	edi
	enter	18h*4+@@stk, 0

	mov	esi, [@@S]
	mov	edx, [esi+30h]
	lea	edi, [esi+40h]
	mov	ecx, [esi+8]
	mov	[@@L1], edx
	mov	[@@L2], edi
	mov	[@@L2+4], ecx
	add	edi, ecx
	mov	ecx, [esi+0Ch]
	mov	eax, [esi+4]
	mov	[@@L2+8], edi
	mov	[@@L2+0Ch], ecx
	mov	[@@N], eax

	mov	edi, esp
	mov	esi, [@@K]
	xor	edx, 3795B39Ah
	add	esi, [esi+24h]
	push	18h
	pop	ecx
@@1b:	lodsd
	sub	eax, edx
	stosd
	dec	ecx
	jne	@@1b
	mov	ecx, edx
	shr	ecx, 8
	xor	ecx, edx
	shr	ecx, 8
	xor	ecx, edx
	shr	ecx, 8
	xor	ecx, edx
	xor	ecx, 0Bh
	and	ecx, 0Fh
	add	ecx, 7

	push	10h
	pop	ebx
	mov	edi, [@@D]
	mov	esi, [@@L2]
	test	edi, edi
	jne	@@2e
	mov	ebx, [@@L2+4]
	mov	edi, esi
	add	ebx, [@@L2+0Ch]
@@2e:
	push	5
	pop	edx
	sub	ebx, 4
	jb	@@2b
@@2a:	lodsd
	xor	eax, [esp+edx*4]
	add	eax, 784C5962h
	ror	eax, cl
	add	eax, 1010101h
	stosd
	inc	edx
	cmp	edx, 18h
	sbb	eax, eax
	and	edx, eax
	sub	ebx, 4
	jae	@@2a
@@2b:	and	ebx, 3
	je	@@2d
	mov	ecx, ebx
	shl	ecx, 2
@@2c:	mov	eax, [esp+edx*4]
	shr	eax, cl
	xor	al, [esi]
	inc	esi
	sub	al, 79h
	stosb
	inc	edx
	cmp	edx, 18h
	sbb	eax, eax
	and	edx, eax
	sub	ecx, 4
	jne	@@2c
@@2d:
	mov	ebx, [@@K]
	mov	esi, [@@S]
	lea	edi, [@@L0]
	lea	edx, [esi+20h]
	lea	esp, [edi-40h]
	add	esi, 10h
	push	0
	push	0
	push	dword ptr [ebx+0Ch]
	push	dword ptr [ebx+8]
	push	dword ptr [ebx+4]
	push	dword ptr [ebx]
	mov	eax, esp
	push	edi
	push	eax
	call	_md5_update@12, eax, edx, 10h
	call	_md5_final@8
	mov	esp, edi

	xor	ecx, ecx
@@1c:	movsx	eax, byte ptr [ebx+20h+ecx]
	mov	edx, eax
	and	eax, 3
	test	edx, edx
	mov	eax, [edi+eax*4]
	mov	edx, [ebx+10h+ecx*4]
	js	@@1d
	add	eax, edx
	jmp	@@1e
@@1d:	xor	eax, edx
@@1e:	mov	[esi+ecx*4], eax
	inc	ecx
	cmp	ecx, 4
	jb	@@1c
	movsd
	movsd
	movsd
	movsd

	mov	edi, [@@D]
	push	10h
	pop	ebx
	test	edi, edi
	jne	@@2f
	mov	edi, [@@L2]
	mov	ebx, [@@L2+4]
@@2f:	call	@@5, [@@L1], [@@L0+4], [@@X]
	mov	cl, 3Ah
	call	@@6

	mov	ecx, [@@L1]
	mov	edx, [@@L0+0Ch]
	lea	eax, [ecx+10000000h]
	xor	edx, ecx
	xor	eax, [@@L0+8]
	push	edx
	push	eax
	mov	edx, [@@L0+4]
	lea	eax, [ecx+76A3BF29h]
	xor	edx, ecx
	xor	eax, [@@L0]
	push	edx
	push	eax

	mov	ecx, 76548AEFh
	xor	edx, edx
	sub	ebx, 4
	jb	@@3b
@@3a:	mov	eax, [edi]
	xor	eax, [esp+edx*4]
	sub	eax, 4A91C262h
	rol	eax, 3
	sub	eax, ecx
	stosd
	inc	edx
	add	ecx, 10FB562Ah
	and	edx, 3
	sub	ebx, 4
	jae	@@3a
@@3b:	and	ebx, 3
	je	@@3d
@@3c:	mov	eax, [esp+edx*4]
	inc	edx
	shr	eax, 6
	and	edx, 3
	xor	al, [edi]
	add	al, 37h
	stosb
	dec	ebx
	jne	@@3c
@@3d:
	cmp	[@@D], 0
	jne	@@9a
	cmp	[@@N], 0
	je	@@9
@@4:	lea	esp, [ebp-@@stk]
	mov	ecx, [@@L2+4]
	mov	esi, [@@L2]
	cmp	ecx, 10h
	jb	@@9
	mov	edx, [esi]
	mov	edi, [esi+8]
	cmp	edx, 10h
	jb	@@9
	sub	ecx, edx
	jb	@@9
	add	edx, esi
	mov	ebx, [@@L2+0Ch]
	mov	[@@L2+4], ecx
	mov	[@@L2], edx
	cmp	[@@N], 1
	je	@@4e
	cmp	ecx, 10h
	jb	@@4e
	mov	eax, [edx+8]
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
@@4e:	sub	ebx, edi
	jb	@@9
	add	edi, [@@L2+8]
	call	@@5, [@@L1], [@@L0+8], [@@X]
	mov	cl, 7Eh
	call	@@6

	mov	ecx, [esi+0Ch]
	lea	edx, [ecx+34258765h]
	mov	eax, [@@L0+8]
	xor	edx, [@@L0+0Ch]
	xor	eax, ecx
	push	edx
	push	eax
	lea	edx, [ecx+112233h]
	mov	eax, [@@L0]
	xor	edx, [@@L0+4]
	xor	eax, ecx
	push	edx
	push	eax

	mov	ecx, 2A65CB4Eh
	xor	edx, edx
	sub	ebx, 4
	jb	@@4b
@@4a:	mov	eax, [edi]
	xor	eax, [esp+edx*4]
	sub	eax, ecx
	rol	eax, 2
	add	eax, 37A19E8Bh
	stosd
	inc	edx
	sub	ecx, 139FA9Bh
	and	edx, 3
	sub	ebx, 4
	jae	@@4a
@@4b:	and	ebx, 3
	je	@@4d
@@4c:	mov	eax, [esp+edx*4]
	inc	edx
	shr	eax, 4
	and	edx, 3
	xor	al, [edi]
	add	al, 5
	stosb
	dec	ebx
	jne	@@4c
@@4d:	dec	[@@N]
	jne	@@4

@@9:	mov	edi, [@@X]
	lea	ebx, [edi+40h]
	call	@@5, [@@L0+0Ch], [@@L1], ebx
	mov	edx, [@@S]
	mov	esi, [@@K]
	mov	edx, [edx+14h]
	add	esi, [esi+24h]
	xor	eax, eax
	shr	edx, 2
	lea	ecx, [eax+40h]
@@7a:	lodsb
	mov	al, [ebx+eax]
	xor	al, dl
	stosb
	dec	ecx
	jne	@@7a
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@6:	test	ebx, ebx
	je	@@6b
	mov	edx, [@@X]
	xor	eax, eax
	push	ebx
@@6a:	mov	al, [edi]
	xor	al, cl
	mov	al, [edx+eax]
	stosb
	dec	ebx
	jne	@@6a
	pop	ebx
	sub	edi, ebx
@@6b:	ret

	; 004434E0
@@5:	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	push	100h
	mov	ebx, [ebp+1Ch]
	mov	edi, ebx
	mov	eax, 3020100h
@@5a:	stosd
	add	eax, 4040404h
	jnc	@@5a
	mov	eax, [ebp+14h]
@@5b:	mov	edi, eax
	shl	edi, 8
	movzx	esi, al
	shr	edi, 18h
	mov	dl, [ebx+esi]
	mov	dh, [ebx+edi]
	mov	[ebx+edi], dl
	mov	[ebx+esi], dh
	mov	edi, eax
	movzx	esi, ah
	shr	edi, 18h
	mov	dl, [ebx+esi]
	mov	dh, [ebx+edi]
	mov	[ebx+edi], dl
	mov	[ebx+esi], dh
	ror	eax, 2
	imul	eax, 1A743125h
	add	eax, [ebp+18h]
	dec	dword ptr [ebp-4]
	jne	@@5b
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

@@FileDec PROC	; 00442DB0

@@S = dword ptr [ebp+14h]
@@D = dword ptr [ebp+18h]
@@C = dword ptr [ebp+1Ch]
@@K = dword ptr [ebp+20h]
@@X = dword ptr [ebp+24h]

@@L0 = dword ptr [ebp-10h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ebx, [@@S]
	mov	esi, [@@X]
	push	dword ptr [ebx+1Ch]
	push	dword ptr [ebx+18h]
	push	dword ptr [ebx+14h]
	push	dword ptr [ebx+10h]
	sub	esp, 40h
	mov	edx, [@@K]
	mov	edi, esp
	push	10h
	pop	ecx
@@2:	lodsd
	xor	eax, edx
	stosd
	dec	ecx
	jne	@@2

	mov	edi, [@@D]
	mov	ebx, [@@C]
	push	9
	pop	edx
	mov	ecx, 2547A39Eh
	sub	ebx, 4
	jb	@@1b
@@1a:	mov	eax, [esp+edx*4]
	mov	esi, ecx
	inc	edx
	shr	esi, 6
	shr	eax, 1
	and	esi, 0Fh
	and	edx, 0Fh
	xor	eax, [esp+esi*4]
	mov	esi, ecx
	xor	eax, [edi]
	and	esi, 3
	sub	eax, [@@K]
	add	ecx, [@@K]
	xor	eax, [@@L0+esi*4]
	add	ecx, eax
	stosd
	sub	ebx, 4
	jae	@@1a
@@1b:	and	ebx, 3
	je	@@1d
	xor	eax, eax
	mov	esi, [@@X]
@@1c:	mov	al, [edi]
	xor	al, 0BCh
	mov	al, [esi+40h+eax]
	stosb
	dec	ebx
	jne	@@1c
@@1d:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h
ENDP

ENDP

_conv_cpz5 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, '3bp'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	cmp	ebx, 34h
	jb	@@9
	lea	edx, [esi+ebx]
	cmp	dword ptr [esi], 'B3BP'
	jne	@@9
	movzx	eax, word ptr [edx-3]
	movzx	ecx, word ptr [esi+1Ch]
	xor	ecx, eax
	sub	cl, [edx-37h+1Ch]
	sub	ch, [edx-37h+1Dh]
	dec	ecx
	jne	@@9
	xor	ecx, ecx
@@1a:	xor	[esi+8+ecx*2], ax
	inc	ecx
	cmp	ecx, 2Ch/2
	jb	@@1a
	xor	ecx, ecx
@@1b:	mov	al, [edx-2Fh+ecx]
	sub	[esi+8+ecx], al
	inc	ecx
	cmp	ecx, 2Ch
	jb	@@1b
	call	@@PB31Check, esi, ebx
	jc	@@9
	movzx	ecx, word ptr [esi+22h]
	shr	ecx, 3
	add	ecx, 20h-1
	movzx	edi, word ptr [esi+1Eh]
	movzx	edx, word ptr [esi+20h]
	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]
	call	@@PB31, edi, esi, ebx
	clc
	leave
	ret

@@PB31Check PROC

@@S = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]

@@stk = 0
@M0 @@N
@M0 @@L0

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@S]
	movzx	ecx, word ptr [esi+22h]
	movzx	eax, word ptr [esi+1Ch]
	ror	ecx, 3
	dec	eax
	lea	edx, [ecx-3]
	shr	edx, 1
	or	eax, edx
	jne	@@9
	cmp	dword ptr [esi+18h], 0
	je	@@9
	movzx	eax, word ptr [esi+1Eh]
	movzx	edx, word ptr [esi+20h]
	imul	eax, edx
	push	ecx
	push	eax

	mov	edx, [esi+2Ch]
	call	@@3
	mov	edx, [esi+30h]
	call	@@3
	mov	edx, [esi+2Ch]
	mov	ecx, [@@N]
	add	edx, esi
	lea	edi, [edx+ecx*4]
@@1a:	mov	ebx, [edx]
	sub	ebx, 0Ch
	jb	@@9
	sub	ebx, [edi]
	jb	@@9
	mov	eax, [edi+8]
	sub	ebx, [edi+4]
	jb	@@9
	cmp	[@@L0], eax
	jb	@@9
	add	edi, [edx]
	add	edx, 4
	dec	ecx
	jne	@@1a
	clc
	jmp	@@9a

@@9:	stc
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@3:	mov	ecx, [@@N]
	mov	ebx, [@@C]
	shl	ecx, 2
	sub	ebx, edx
	jb	@@9
	sub	ebx, ecx
	jb	@@9
@@3a:	sub	ebx, [esi+edx]
	jb	@@9
	add	edx, 4
	sub	ecx, 4
	jne	@@3a
	ret
ENDP

@@PB31 PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@C = dword ptr [ebp+1Ch]

@@stk = 0
@M0 @@L4, 14h
@M0 @@L3, 10h
@M0 @@L2, 0Ch
@M0 @@L0, 8
@M0 @@L1, 8
@M0 @@B
@M0 @@H
@M0 @@W
@M0 @@I
@M0 @@L
@M0 @@N
@M0 @@M

	push	ebx
	push	esi
	push	edi
	enter	30h, 0

	mov	esi, [@@S]
	movzx	ecx, word ptr [esi+22h]
	mov	edx, [esi+30h]
	mov	eax, [esi+2Ch]
	shr	ecx, 3
	add	edx, esi
	add	eax, esi
	push	edx
	push	eax
	lea	edx, [edx+ecx*4]
	lea	eax, [eax+ecx*4]
	push	edx
	push	eax
	push	dword ptr [esi+18h]
	movzx	edx, word ptr [esi+20h]
	movzx	eax, word ptr [esi+1Eh]
	push	edx	; @@H
	push	eax	; @@W
	imul	edx, eax
	imul	eax, ecx
	push	0
	push	eax	; @@L
	push	ecx	; @@N
	call	_MemAlloc, edx
	jc	@@9
	push	eax	; @@M

@@1:	mov	ecx, [@@I]
	mov	eax, [@@L0]
	mov	edx, [@@L0+4]
	mov	eax, [eax+ecx*4]
	mov	edx, [edx+ecx*4]
	mov	[@@L2], eax
	mov	[@@L2+4], edx

	mov	ebx, [@@L1]
	mov	ecx, [@@L2]
	mov	edx, [ebx]
	add	edx, [ebx+4]
	add	edx, 0Ch
	sub	ecx, edx
	add	edx, ebx

	mov	esi, [@@M]
	call	@@Unpack, esi, dword ptr [ebx+8], [@@L1+4], [@@L2+4], edx, ebx
	mov	[@@L2+8], eax

	mov	eax, [ebx]
	mov	edx, [ebx+4]
	add	ebx, 0Ch
	mov	[@@L4+4], eax
	mov	[@@L4+0Ch], edx
	add	eax, ebx
	mov	[@@L4], ebx
	mov	[@@L4+8], eax
	and	[@@L4+10h], 0

	mov	edi, [@@D]
	mov	eax, [@@H]
	mov	[@@L3+4], eax
@@1a:	mov	eax, [@@B]
	mov	edx, [@@L3+4]
	sub	edx, eax
	jae	$+6
	add	eax, edx
	xor	edx, edx
	mov	[@@L3+0Ch], eax
	mov	[@@L3+4], edx

	mov	eax, [@@W]
	mov	[@@L3], eax
@@1b:	mov	eax, [@@B]
	mov	edx, [@@L3]
	sub	edx, eax
	jae	$+6
	add	eax, edx
	xor	edx, edx
	mov	[@@L3+8], eax
	mov	[@@L3], edx

	mov	ebx, [@@N]
	mov	eax, [@@L4+10h]
	dec	ebx
	shl	al, 1
	jne	@@1c
	mov	edx, [@@L4]
	dec	[@@L4+4]
	js	@@8
	mov	al, [edx]
	inc	edx
	mov	[@@L4], edx
	stc
	adc	al, al
@@1c:	mov	ecx, [@@L3+0Ch]
	mov	[@@L4+10h], eax
	jnc	@@1d
	dec	[@@L4+0Ch]
	js	@@8
	mov	edx, [@@L4+8]
	mov	al, [edx]
	inc	edx
	mov	[@@L4+8], edx
	push	edi
@@2a:	mov	edx, [@@L3+8]
	push	edi
@@2b:	stosb
	add	edi, ebx
	dec	edx
	jne	@@2b
	pop	edi
	add	edi, [@@L]
	dec	ecx
	jne	@@2a
	jmp	@@1e

@@1d:	mov	edx, [@@L3+8]
	imul	edx, ecx
	sub	[@@L2+8], edx
	jb	@@8
	push	edi
@@2c:	mov	edx, [@@L3+8]
	push	edi
@@2d:	movsb
	add	edi, ebx
	dec	edx
	jne	@@2d
	pop	edi
	add	edi, [@@L]
	dec	ecx
	jne	@@2c
@@1e:	pop	edi

	mov	eax, [@@L3+8]
	imul	eax, [@@N]
	add	edi, eax
	cmp	[@@L3], 0
	jne	@@1b
	mov	eax, [@@B]
	dec	eax
	imul	eax, [@@L]
	add	edi, eax
	cmp	[@@L3+4], 0
	jne	@@1a

@@8:	mov	ecx, [@@I]
	mov	eax, [@@L2]
	mov	edx, [@@L2+4]
	add	[@@L1], eax
	add	[@@L1+4], edx
	inc	ecx
	inc	[@@D]
	mov	[@@I], ecx
	cmp	ecx, [@@N]
	jb	@@1	
	call	_MemFree, [@@M]
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp+24h]
@@L1 = dword ptr [ebp+28h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
@@1:	dec	[@@DC]
	js	@@7
	shl	bl, 1
	jne	@@1a
	mov	edx, [@@L0]
	dec	[@@L1]
	js	@@9
	mov	bl, [edx]
	inc	edx
	mov	[@@L0], edx
	stc
	adc	bl, bl
@@1a:	jc	@@1b
	dec	[@@SC]
	js	@@9
	movsb
	jmp	@@1

@@1b:	sub	[@@SC], 2
	jb	@@9
	movzx	edx, word ptr [esi]
	inc	esi
	inc	esi
	mov	ecx, edx
	shr	edx, 5
	and	ecx, 1Fh
	add	ecx, 2
	sub	[@@DC], ecx
	jae	@@1c
	add	ecx, [@@DC]
@@1c:	inc	ecx
	mov	eax, edi
	sub	eax, [@@DB]
	sub	edx, eax
	add	edx, 22h
	or	edx, -800h
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
	inc	esi
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	18h
ENDP

ENDP

ENDP
