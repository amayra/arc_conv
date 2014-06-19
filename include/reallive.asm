
_rlseen_xor PROC
	push	edi
	mov	ecx, [esp+0Ch]
	mov	edi, [esp+8]
	test	ecx, ecx
	je	@@9
	xor	edx, edx
@@1:	mov	al, [@@T+edx]
	inc	dl
	xor	[edi], al
	inc	edi
	dec	ecx
	jne	@@1
@@9:	pop	edi
	ret	8

@@T label byte
dd 0C35DE58Bh, 04430E0A1h, 074C08500h, 0335E5F09h
dd 0E58B5BC0h, 0458BC35Dh, 075C0850Ch, 0EC558B14h
dd 05220C283h, 0F5E8006Ah, 083000128h, 0458908C4h
dd 0E4458B0Ch, 0006A006Ah, 015FF5350h, 00043B134h
dd 08510458Bh, 08B0574C0h, 00889EC4Dh, 084F0458Ah
dd 0A17875C0h, 0004430E0h, 08BE87D8Bh, 0C0850C75h
dd 01D8B4475h, 00043B0D0h, 03776FF85h, 00000FF81h
dd 0006A0004h, 0458B4376h, 0FC558DF8h, 000006852h
dd 050560004h, 0B12C15FFh, 0056A0043h, 0E0A1D3FFh
dd 081004430h, 0040000EFh, 000C68100h, 085000400h
dd 08BC574C0h, 0E853F85Dh, 0FFFFFBF4h, 0830C458Bh
dd 05E5F04C4h, 05DE58B5Bh, 0F8558BC3h, 051FC4D8Dh
dd 0FF525657h, 043B12C15h, 08BD8EB00h, 0C083E845h
dd 0006A5020h, 0012847E8h, 0E87D8B00h, 08BF44589h
dd 030E0A1F0h, 0C4830044h, 075C08508h, 0D01D8B56h
dd 0850043B0h, 0814976FFh, 0040000FFh, 076006A00h

ENDP

_reallive_pack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@M = dword ptr [ebp-4]
@@D = dword ptr [ebp-8]
@@L0 = dword ptr [ebp-0Ch]
@@L1 = dword ptr [ebp-10h]

@tblcnt = 1000h

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	call	_MemAlloc, 10000h*4+@tblcnt*2
	jc	@@9a
	push	eax
	mov	esi, [@@SB]
	xchg	edi, eax
	mov	ecx, 10000h
	lea	eax, [esi-@tblcnt-1]
	rep	stosd
	push	edi
	push	-80h
	mov	edi, [@@DB]
	xor	ebx, ebx
	push	edi	; @@L1
@@1:	cmp	[@@SC], 0
	je	@@9
	stc
	call	@@3
	mov	al, [esi]
	stosb
	call	@@next
@@1a:	call	@@match
@@1b:	cmp	eax, 2
	jb	@@1
	lea	esp, [@@L1]
	push	ecx
	push	eax
	xchg	ebx, eax
	call	@@next
	xor	eax, eax
	cmp	ebx, 11h
	jae	@@2a
	call	@@match
	mov	ebx, [@@L1-8]
@@2a:	push	ecx
	push	eax
	dec	ebx
@@2b:	call	@@next
	dec	ebx
	jne	@@2b
	mov	ebx, [@@L1-10h]
	cmp	[@@L1-8], 3
	jae	@@2f
	cmp	ebx, 3
	jae	@@2g
@@2f:	call	@@match
	push	ecx
	push	eax
	cmp	[@@L1-10h], 4
	jae	@@2d
@@2c:	mov	ebx, [@@L1-8]
	mov	ecx, [@@L1-4]
	; ecx - address, eax - count
	call	@@3a
	neg	ecx
	shl	ecx, 1
	lea	eax, [ecx*8+ebx-2]
	stosw
	pop	eax
	pop	ecx
	jmp	@@1b

@@9b:	call	@@3a
@@9:	cmp	byte ptr [@@L0], 80h
	jne	@@9b
	call	_MemFree, [@@M]
	mov	esi, [@@SC]
	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@2d:	mov	edx, [@@L1-8]
	mov	ebx, [@@L1-10h]
	add	edx, eax
	dec	edx
	cmp	ebx, edx
	jb	@@2c
@@2g:	stc
	call	@@3
	mov	eax, esi
	sub	eax, [@@L1-8]
	mov	al, [eax]
	stosb
	mov	ecx, [@@L1-0Ch]
	call	@@3a
	neg	ecx
	shl	ecx, 1
	lea	eax, [ecx*8+ebx-2]
	stosw
	inc	ebx
	sub	ebx, [@@L1-8]
@@2e:	call	@@next
	dec	ebx
	jne	@@2e
	jmp	@@1a

@@3a:	clc
@@3:	mov	eax, [@@L0]
	rcr	al, 1
	jc	@@3c
	test	al, 3Fh
	jne	@@3b
	mov	[@@L1], edi
	inc	edi
@@3b:	mov	[@@L0], eax
	ret
@@3c:	mov	edx, [@@L1]
	mov	[edx], al
	mov	al, 80h
	jmp	@@3b

@@next:	dec	[@@SC]
	je	@@3d
	mov	ecx, esi
	mov	edx, [@@M]
	movzx	eax, word ptr [esi]
	xchg	ecx, [edx+eax*4]
	sub	ecx, esi
	cmp	ecx, -@tblcnt+1
	sbb	eax, eax
	neg	ecx
	mov	edx, esi
	or	ecx, eax
	mov	eax, [@@D]
	and	edx, @tblcnt-1
	mov	[eax+edx*2], cx
@@3d:	inc	esi
	ret

@@match PROC
	mov	ecx, [ebp+20h]	; @@SC
	push	edi
	push	0	; D
	push	1	; C = min-1
	push	11h
	pop	ebx
	cmp	ecx, 2
	jb	@@8
	cmp	ecx, ebx
	jae	$+4
	mov	ebx, ecx
	mov	ecx, [ebp-4]
	movzx	eax, word ptr [esi]
	mov	ecx, [ecx+eax*4]
	sub	ecx, esi
	jmp	@@3

@@4:	xor	edx, edx
	lea	edi, [esi+ecx]
	inc	edx
	lea	eax, [edi+1]
	sub	eax, [ebp+1Ch]	; @@SB
	shl	eax, 14h
	je	@@6
@@5:	inc	edx
	cmp	edx, ebx
	jae	@@6
	mov	al, [esi+edx]
	cmp	[edi+edx], al
	je	@@5
@@6:	pop	eax
	cmp	eax, edx
	jae	@@2
	xchg	eax, edx
	pop	edx
	cmp	eax, ebx
	jae	@@9
	push	ecx
@@2:	push	eax
	and	edi, @tblcnt-1
	mov	edx, [ebp-8]
	movzx	edi, word ptr [edx+edi*2]
	sub	ecx, edi
@@3:	cmp	ecx, -0FFFh	; !!!
	jae	@@4
@@8:	pop	eax
	pop	ecx
@@9:	pop	edi
	ret
ENDP

ENDP
