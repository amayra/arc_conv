
; "Solfege" *.pak
; Setup.exe
; 0040AB18 create
; 0040AEE0 open
; 00411B40, 00410C48 decode
; 0040A7F0 crc16

; "Gadget Trial"
; GADGETT.exe
; 0047BDEC open
; 0047B71C crc16

	dw 0
_arc_hypack PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	edx
	sub	eax, 61507948h
	sub	edx, 3006B63h
	rol	edx, 10h
	shr	edx, 1
	or	eax, edx
	jne	@@9a
	pop	edi
	pop	ebx
	lea	eax, [ebx-1]
	mov	[@@N], ebx
	shr	eax, 14h
	jne	@@9a
	imul	ebx, 30h
	add	edi, 10h
;	inc	ebx
;	inc	ebx
	call	_FileSeek, [@@S], edi, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 15h
	mov	eax, [esi+14h]
	shr	eax, 8
	call	_ArcSetExt, eax
	and	[@@D], 0
	mov	eax, [esi+18h]
	mov	ebx, [esi+20h]
	add	eax, 10h
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	movzx	ecx, byte ptr [esi+24h]
	mov	edi, [esi+1Ch]
	dec	ecx
	je	@@2a
	dec	ecx
	je	@@2b
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
	cmp	byte ptr [esi+24h], 3
	jne	@@1a
	mov	ecx, ebx
	test	ebx, ebx
	je	@@1a
	mov	edx, [@@D]
@@1c:	not	byte ptr [edx]
	inc	edx
	dec	ecx
	jne	@@1c
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 30h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	call	_ArcMemRead, eax, edi, ebx, 0
	call	@@Mariel_Unpack, [@@D], edi, edx, eax
	jmp	@@1b

@@2b:	call	_ArcMemRead, eax, edi, ebx, 40000h
	test	eax, eax
	je	@@1b
	call	@@Cocotte_Unpack, [@@D], edi, edx, eax
	jmp	@@1b

@@Mariel_Unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@SB]
	mov	edi, [@@DB]
	xor	ebx, ebx
@@1:	cmp	[@@DC], 0
	je	@@7
	shl	ebx, 1
	jne	@@1a
	sub	[@@SC], 4
	jb	@@9
	lodsd
	xchg	ebx, eax
	stc
	adc	ebx, ebx
@@1a:	jc	@@1b
	dec	[@@SC]
	js	@@9
	dec	[@@DC]
	movsb
	jmp	@@1

@@1b:	dec	[@@SC]
	js	@@9
	xor	eax, eax
	lodsb
	mov	edx, eax
	shr	eax, 4
	and	edx, 0Fh
	inc	eax
	inc	edx
	cmp	eax, 0Fh
	jb	@@1d
	jne	@@1c
	dec	[@@SC]
	js	@@9
	lodsb
	jmp	@@1d

@@1c:	sub	[@@SC], 2
	jb	@@9
	lodsw
@@1d:	xchg	ecx, eax
	cmp	edx, 0Bh
	jb	@@1e
	sub	edx, 0Bh
	shl	edx, 8
	dec	[@@SC]
	js	@@9
	mov	dl, [esi]
	inc	esi
@@1e:	neg	edx
	sub	[@@DC], ecx
	jae	@@1f
	add	ecx, [@@DC]
	and	[@@DC], 0
@@1f:	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	push	esi
	lea	esi, [edi+edx]
	rep	movsb
	pop	esi
	jmp	@@1

@@7:	xor	esi, esi
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

@@Cocotte_Unpack PROC	; 00410C48

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]	; +2
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@SE = dword ptr [ebx]
@@DE = dword ptr [ebx+4]
@@L0 = dword ptr [ebx+8]
@@L1 = dword ptr [ebx+0Ch]
@@L2 = dword ptr [ebx+10h]

@@C0 = 101h		; ebx+38h+4
@@C1 = 0Ch
@@C2 = @@C1-9		; ebx+38h+1Ch = max(@@C1-9, 0)
@@C3 = 7D0h		; ebx+38h+14h

	push	ebx
	push	esi
	push	edi
	enter	404h, 0
	mov	dword ptr [ebp-4], @@C0-1	; [[ebx+38h+28h]+400h] = @@C0-1
	mov	ecx, (@@C0+1)*2
	mov	eax, esp
	sub	esp, 38h+2Ch
	mov	ebx, esp
	mov	[ebx+38h+28h], eax
	sub	esp, ecx
	mov	[ebx+38h+24h], esp
	sub	esp, ecx
	mov	[ebx+38h+20h], esp
	sub	esp, 100h
	mov	[@@L1], esp
	mov	edi, esp
	mov	eax, 3020100h
@@5c:	stosd
	add	eax, 4040404h
	jnc	@@5c
	mov	esi, [@@SB]
	mov	eax, [@@SC]
	mov	edi, [@@DB]
	add	eax, esi
	mov	[@@L2], eax
	call	@@5
@@7:	sub	[@@SC], 4
	jb	@@9
	lodsd
	movzx	ecx, ax
	shr	eax, 10h
	je	@@9
	cmp	ecx, 6
	jbe	@@9
	sub	ecx, 4
	sub	[@@DC], eax
	jb	@@9
	inc	eax
	inc	eax
	sub	[@@SC], ecx
	jb	@@9
	mov	[@@L0], eax
	cmp	ecx, eax
	je	@@7e
	add	ecx, esi
	add	eax, edi
	mov	[@@SE], ecx
	mov	[@@DE], eax

	; 00410AAC
	xor	eax, eax
	lodsb			; not used
	lodsb
	mov	[ebx+34h], al
	shr	eax, 1
	mov	[ebx+28h], eax
	mov	al, 80h
	mov	[ebx+2Ch], eax
	jmp	@@7b

@@7e:	rep	movsb
	call	@@5
	jmp	@@7f

@@7a:	call	@@1
	test	ah, ah		; 0x100 end
	jne	@@9
	stosb
@@7b:	cmp	[@@DE], edi
	jne	@@7a
	call	@@1
	test	ah, ah
	je	@@9
	mov	esi, [@@SE]
@@7f:
	push	esi
	push	ebx
	mov	esi, [@@L1]
	mov	ebx, [@@L0]
	sub	edi, ebx
	call	@@MTF
	pop	ebx
	push	ebx
	mov	esi, [@@L2]
	mov	ebx, [@@L0]
	sub	edi, ebx
	call	@@BWT
	pop	ebx
	pop	esi
	cmp	[@@DC], 0
	jne	@@7
	xor	esi, esi
@@9:	xchg	eax, edi
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@1:	call	@@2
	xchg	edx, eax
	call	@@3
	push	eax
	mov	edx, [ebx+38h+20h]
	mov	edx, [edx+eax*2]
	movzx	ecx, dx
	shr	edx, 10h
	; 00410C18
	mov	eax, [ebx+30h]
	imul	eax, ecx
	sub	[ebx+28h], eax
	cmp	edx, 1 SHL @@C1
	jae	@@1a
	sub	edx, ecx
	mov	eax, [ebx+30h]
	imul	eax, edx
	mov	[ebx+2Ch], eax
	jmp	@@1b
@@1a:	sub	[ebx+2Ch], eax
@@1b:	pop	eax
	test	ah, ah
	jne	@@1d
	; 004102D0
	mov	edx, [ebx+38h+8]
	test	edx, edx
	jne	@@1c
	push	eax
	call	@@4
	pop	eax
@@1c:	mov	edx, [ebx+38h+24h]
	mov	ecx, [ebx+38h+18h]
	dec	dword ptr [ebx+38h+8]
	add	[edx+eax*2], cx
@@1d:	ret

	; 00410B14
@@2:	mov	ecx, [ebx+2Ch]
	mov	edx, [ebx+28h]
	test	ecx, ecx
	jne	@@2b
	jmp	@@9		; "Range Is Zero"

@@2a:	shl	edx, 8
	mov	dl, [ebx+34h]
	shl	dl, 7
	cmp	[@@SE], esi
	je	@@9
	xor	eax, eax
	lodsb
	mov	[ebx+34h], al
	shr	eax, 1
	shl	ecx, 8
	add	edx, eax
@@2b:	cmp	ecx, 800000h
	jbe	@@2a
	mov	[ebx+28h], edx
	mov	[ebx+2Ch], ecx
	xchg	eax, edx
	; 00410BD8
	shr	ecx, @@C1
	xor	edx, edx
	mov	[ebx+30h], ecx
	div	ecx
	cmp	eax, 1 SHL @@C1
	jb	@@2c
	mov	eax, (1 SHL @@C1)-1
@@2c:	ret

	; 00410290
@@3:	push	esi
	push	edi
	mov	esi, edx
	shr	esi, @@C2
	mov	edi, [ebx+38h+28h]
	mov	esi, [edi+esi*2]
	movzx	eax, si
	shr	esi, 10h
	mov	edi, [ebx+38h+20h]
	inc	esi
	jmp	@@3c
@@3a:	lea	ecx, [esi+eax]
	shr	ecx, 1
	cmp	dx, [edi+ecx*2]
	jae	@@3b
	mov	esi, ecx
	jmp	@@3c
@@3b:	mov	eax, ecx
@@3c:	lea	ecx, [eax+1]
	cmp	esi, ecx
	ja	@@3a
	pop	edi
	pop	esi
	ret

	; 0041016C
@@5:	push	(@@C0 SHR 4) OR 2
	pop	dword ptr [ebx+38h+10h]
	and	dword ptr [ebx+38h+0Ch], 0
	push	esi
	push	edi
	mov	esi, offset @@T
	mov	edi, [ebx+38h+24h]
@@5a:	xor	eax, eax
	lodsb
	test	eax, eax
	je	@@5b
	xchg	ecx, eax
	lodsw
	rep	stosw
	jmp	@@5a
@@5b:	pop	edi
	pop	esi

	; 0040FE58
@@4:	mov	edx, [ebx+38h+0Ch]
	test	edx, edx
	je	@@4a
	inc	dword ptr [ebx+38h+18h]
	xor	eax, eax
	mov	[ebx+38h+8], edx
	mov	[ebx+38h+0Ch], eax
	ret

@@4a:	mov	ecx, [ebx+38h+10h]
	mov	eax, @@C3
	cmp	ecx, eax
	jae	@@4b
	shl	ecx, 1
	cmp	eax, ecx
	jae	@@4b
	xchg	ecx, eax
@@4b:	mov	[ebx+38h+10h], ecx
	push	esi
	push	edi
	mov	edx, @@C0-1
	mov	esi, [ebx+38h+20h]
	mov	ecx, [ebx+38h+24h]
	mov	edi, 1 SHL @@C1
	mov	[esi+edx*2+2], di
	push	edi
@@4c:	movzx	eax, word ptr [ecx+edx*2]
	sub	edi, eax
	shr	eax, 1
	or	eax, 1
	mov	[esi+edx*2], di
	mov	[ecx+edx*2], ax
	sub	[esp], eax
	dec	edx
	jns	@@4c
	pop	eax
	test	edi, edi
	pop	edi
	jne	@@9		; "rescaling left %d total frequency"
	mov	ecx, [ebx+38h+10h]
	xor	edx, edx
	div	ecx
	sub	ecx, edx
	mov	[ebx+38h+18h], eax
	mov	[ebx+38h+0Ch], edx
	mov	[ebx+38h+8], ecx
	mov	edx, @@C0-1
@@4d:	mov	eax, [ebx+38h+20h]
	mov	esi, [eax+edx*2]
	movzx	eax, si
	shr	esi, 10h
	dec	esi
	shr	eax, @@C2
	shr	esi, @@C2
	mov	ecx, [ebx+38h+28h]
	cmp	eax, esi
	ja	@@4f
@@4e:	mov	[ecx+eax*2], dx
	inc	eax
	cmp	eax, esi
	jbe	@@4e
@@4f:	dec	edx
	jns	@@4d
	pop	esi
	ret

@@MTF PROC	; 0040FD44
@@1:	movzx	ecx, byte ptr [edi]
	mov	al, [esi+ecx]
	dec	ecx
	js	@@3
@@2:	mov	dl, [esi+ecx]
	mov	[esi+ecx+1], dl
	dec	ecx
	jns	@@2
	mov	[esi], al
@@3:	stosb
	dec	ebx
	jne	@@1
	ret
ENDP

@@BWT PROC	; 0040F9AC
	dec	ebx
	dec	ebx
	mov	edx, edi
	mov	ecx, 100h
	xor	eax, eax
	enter	400h, 0
	mov	edi, esp
	rep	stosd
	mov	edi, edx
	mov	ecx, ebx
@@1:	movzx	eax, byte ptr [edx+2]
	inc	edx
	inc	dword ptr [esp+eax*4]
	dec	ecx
	jne	@@1
	; ecx = 0
	xor	eax, eax
@@2:	add	eax, [esp+ecx*4]
	mov	[esp+ecx*4], eax
	inc	ecx
	cmp	ecx, 100h
	jb	@@2
	lea	ecx, [ebx-1]
@@3:	movzx	eax, byte ptr [edi+ecx+2]
	dec	dword ptr [esp+eax*4]
	mov	edx, [esp+eax*4]
	shl	eax, 18h
	add	eax, ecx
	rol	eax, 8
	mov	[esi+edx*4], eax
	dec	ecx
	jns	@@3
	leave
	movzx	eax, word ptr [edi]
@@4:	mov	eax, [esi+eax*4]
	stosb
	shr	eax, 8
	dec	ebx
	jne	@@4
	ret
ENDP

@M1 macro p0,p1
db p0
dw p1
endm
@@T:
@M1 1, 578h
@M1 1, 280h
@M1 1, 140h
@M1 1, 0F0h
@M1 1, 0A0h
@M1 1, 78h
@M1 1, 50h
@M1 1, 40h
@M1 1, 30h
@M1 1, 28h
@M1 1, 20h
@M1 1, 18h
@M1 4, 14h
@M1 4, 10h
@M1 6, 0Ch
@M1 6, 8
@M1 10h, 6
@M1 10h, 5
@M1 20h, 4
@M1 26h, 3
@M1 7Bh, 2
db 0
PURGE @M1
ENDP

ENDP
