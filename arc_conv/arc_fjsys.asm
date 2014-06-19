
; "Natsuiro Sagittarius"
; NATUSAZI.EXE
; NATUSAZIMUSUME.EXE

; "Amakara Twins"
; AMAKARA.EXE
; 004350F0 CDIBSprite::ExecDecodeSGD

	dw _conv_fjsys-$-2
_arc_fjsys PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1

	enter	@@stk+54h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 54h
	jc	@@9a
	pop	eax
	pop	edx
	sub	eax, 'YSJF'
	sub	edx, 'S'
	or	eax, edx
	jne	@@9a
	pop	ebx
	pop	edx
	pop	ecx
	sub	ebx, 54h
	jb	@@9a
	sub	ebx, edx
	jb	@@9a
	lea	eax, [ecx-1]
	mov	[@@N], ecx
	shr	eax, 14h
	mov	eax, ebx
	jne	@@9a
	shl	ecx, 4
	cmp	ebx, ecx
	jne	@@9a
	add	edx, ebx
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, edx, 0
	jc	@@9
	mov	edx, [@@N]
	mov	esi, [@@M]
	mov	ecx, edx 
	shl	edx, 4
	add	edx, esi
	mov	[@@L1], ebx
	mov	[@@L0], edx
	call	_ArcCount, ecx

@@1:	mov	ecx, [@@L1]
	mov	eax, [esi]
	sub	ecx, eax
	jbe	@@8
	add	eax, [@@L0]
	call	_ArcName, eax, ecx
	and	[@@D], 0
	mov	ebx, [esi+4]
	call	_FileSeek, [@@S], dword ptr [esi+8], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 10h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_fjsys PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'dsm'
	je	@@1
	cmp	eax, 'dgm'
	je	@@2
@@9:	stc
	leave
	ret

@@1:	cmp	ebx, 10h
	jb	@@9
	xor	edx, edx
	mov	edi, offset @@T
@@1a:	add	edi, edx
	movzx	edx, byte ptr [edi]
	inc	edi
	test	edx, edx
	je	@@9
	push	4
	pop	ecx
	push	esi
	repe	cmpsd
	pop	esi
	lea	edi, [edi+ecx*4]
	jne	@@1a
	call	@@Decode, esi, ebx, edi
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@2:	cmp	ebx, 68h
	jb	@@9
	mov	edx, 1005Ch
	mov	eax, [esi]
	sub	edx, [esi+4]
	sub	eax, ' DGM'
	or	eax, edx
	jne	@@9
	mov	eax, [esi+5Ch]
	sub	ebx, 60h
	cmp	ebx, eax
	jb	@@9
	xchg	ebx, eax
	mov	eax, [esi+18h]	; 0-none, 1-sgd, 2-png
	dec	eax
	je	@@2a
	dec	eax
	jne	@@9
	add	esi, 60h
	mov	edx, 0A1A0A0Dh
	mov	eax, [esi]
	sub	edx, [esi+4]
	sub	eax, 474E5089h
	or	eax, edx
	jne	@@9
	call	_ArcSetExt, 'gnp'
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@2a:	sub	ebx, 8
	jb	@@9
	mov	eax, [esi+60h]
	sub	ebx, eax
	jb	@@9
	mov	eax, [esi+64h+eax]
	cmp	ebx, eax
	jne	@@9
	movzx	edi, word ptr [esi+0Ch]
	movzx	edx, word ptr [esi+0Eh]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 23h, edi, edx
	xchg	edi, eax
	add	esi, 60h
	add	edi, 12h
	lodsd
	push	eax
	push	esi
	add	esi, eax
	call	@@UnpA, edi, ebx
	lodsd
	call	@@UnpC, edi, ebx, esi, eax
	clc
	leave
	ret

@@UnpA PROC

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
@@1:	cmp	[@@DC], 0
	je	@@7
	sub	[@@SC], 2
	jb	@@9
	lodsw
	movzx	ecx, ax
	test	ah, ah
	jns	@@1a
	and	ch, 7Fh
	inc	ecx
	dec	[@@SC]
	js	@@9
	sub	[@@DC], ecx
	jb	@@9
	lodsb
	shl	eax, 18h
	rep	stosd
	jmp	@@1

@@1a:	test	ecx, ecx
	je	@@1
	sub	[@@SC], ecx
	jb	@@9
	sub	[@@DC], ecx
	jb	@@9
@@1b:	lodsb
	shl	eax, 18h
	stosd
	dec	ecx
	jne	@@1b
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

@@UnpC PROC

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
@@1:	cmp	[@@DC], 0
	je	@@7
	dec	[@@SC]
	js	@@9
	movzx	ecx, byte ptr [esi]
	inc	esi
	mov	eax, ecx
	and	ecx, 3Fh
	sub	[@@DC], ecx
	jb	@@9
	shr	eax, 6
	je	@@2c
	dec	eax
	je	@@2a
	dec	eax
	jne	@@9
	lea	eax, [ecx+ecx]
	dec	ecx
	js	@@1
	sub	[@@SC], eax
	jb	@@9
	cmp	edi, [@@DB]
	je	@@9
@@1a:	movsx	eax, word ptr [esi]
	add	esi, 2
	mov	dl, al
	shr	eax, 2
	and	dl, 1Fh
	shr	al, 3
	test	ah, ah
	jns	@@1c
	and	ah, 1Fh
@@1b:	add	dl, [edi-4]
	add	al, [edi-3]
	add	ah, [edi-2]
	mov	[edi], dl
	mov	[edi+1], ax
	add	edi, 4
	dec	ecx
	jns	@@1a
	jmp	@@1

@@1c:	test	dl, 10h
	je	@@1d
	and	dl, 0Fh
	neg	dl
@@1d:	test	al, 10h
	je	@@1e
	and	al, 0Fh
	neg	al
@@1e:	test	ah, 10h
	je	@@1f
	and	ah, 0Fh
	neg	ah
@@1f:	jmp	@@1b

@@2a:	sub	[@@SC], 3
	jb	@@9
	dec	[@@DC]
	js	@@9
	mov	dl, [esi]
	movzx	eax, word ptr [esi+1]
	add	esi, 3
@@2b:	mov	[edi], dl
	mov	[edi+1], ax
	add	edi, 4
	dec	ecx
	jns	@@2b
	jmp	@@1

@@2c:	lea	eax, [ecx*2+ecx]
	dec	ecx
	js	@@1
	sub	[@@SC], eax
	jb	@@9
@@2d:	mov	dl, [esi]
	movzx	eax, word ptr [esi+1]
	add	esi, 3
	mov	[edi], dl
	mov	[edi+1], ax
	add	edi, 4
	dec	ecx
	jns	@@2d
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

@@Decode PROC

@@S = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]
@@K = dword ptr [ebp+1Ch]

@@L0 = dword ptr [ebp-10h]
@@L1 = byte ptr [ebp-30h]
@@L2 = dword ptr [ebp-34h]

	push	ebx
	push	esi
	push	edi
	enter	30h, 0
	mov	esi, [@@K]
	movzx	ecx, byte ptr [esi-11h]
	push	ecx	; @@L2
	lea	eax, [ecx+10h]
	and	al, -4
	sub	esp, eax
	mov	edi, esp
	rep	movsb

	mov	esi, [@@S]
	xor	ebx, ebx
@@1:	mov	edx, [@@L2]
	add	edx, esp
	call	_StrDec32, 0, ebx, edx
	mov	ecx, esp
	lea	edx, [@@L0]
	add	eax, [@@L2]
	call	_md5_fast@12, ecx, eax, edx
	lea	edx, [@@L0]
	lea	edi, [@@L1]

	push	10h
	pop	ecx
@@3:	mov	al, [edx]
	shr	al, 4
	add	al, -10
	sbb	ah, ah
	add	al, 3Ah
	and	ah, 27h
	add	al, ah
	stosb
	mov	al, [edx]
	inc	edx
	and	al, 0Fh
	add	al, -10
	sbb	ah, ah
	add	al, 3Ah
	and	ah, 27h
	add	al, ah
	stosb
	dec	ecx
	jne	@@3

	xor	ecx, ecx
@@2:	mov	al, [@@L1+ecx]
	xor	[esi], al
	dec	[@@C]
	je	@@9
	inc	esi
	inc	ecx
	cmp	ecx, 20h
	jb	@@2
	inc	ebx
	jmp	@@1

@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

@@T:
db 26h	; NATUSAZI
db 074h,030h,075h,027h,02Ch,076h,067h,071h,07Dh,011h,074h,02Dh,028h,021h,012h,016h
db 089h,0C4h,090h,046h,082h,0B3h,082h,0B6h,082h,0BDh,082h,0E8h,082h,0A4h,082h,0B7h
db 081h,040h,081h,060h,095h,06Ch,088h,0E4h,08Ch,0B4h,08Ah,077h,089h,080h,08Bh,07Ch
db 093h,0B9h,095h,094h,081h,060h

db 30h	; NATUSAZIMUSUME
db 07Fh,066h,022h,021h,02Ah,022h,033h,07Eh,079h,015h,073h,078h,029h,075h,011h,013h
db 089h,0C4h,090h,046h,082h,0B3h,082h,0B6h,082h,0BDh,082h,0E8h,082h,0A4h,082h,0B7h
db 08Ah,04Fh,093h,060h,081h,040h,088h,0BBh,090h,06Ch,082h,0ABh,082h,0E3h,082h,0F1h
db 082h,0CCh,082h,0A8h,082h,0C6h,082h,0B1h,082h,0CCh,096h,0BAh,093h,0FAh,08Bh,04Ch

db 24h	; AMAKARA
db 07Eh,060h,027h,076h,07Ah,077h,06Ah,02Ch,07Dh,043h,07Eh,07Bh,07Ah,07Dh,042h,042h
db 082h,0A0h,082h,0DCh,082h,0A9h,082h,0E7h,083h,063h,083h,043h,083h,093h,083h,059h
db 081h,040h,081h,060h,091h,06Fh,08Eh,06Fh,082h,0C6h,082h,0A2h,082h,0C1h,082h,0B5h
db 082h,0E5h,081h,060h

db 16h	; HANABIRA
db 074h,032h,025h,071h,079h,025h,062h,07Eh,077h,018h,077h,079h,078h,07Ch,019h,019h
db 082h,0BBh,082h,0CCh,089h,0D4h,082h,0D1h,082h,0E7h,082h,0C9h,082h,0ADh,082h,0BFh
db 082h,0C3h,082h,0AFh,082h,0F0h

db 28h	; HANABIRA2
db 02Eh,065h,075h,020h,07Dh,022h,036h,079h,076h,010h,077h,02Fh,029h,072h,013h,017h
db 082h,0BBh,082h,0CCh,089h,0D4h,082h,0D1h,082h,0E7h,082h,0C9h,082h,0ADh,082h,0BFh
db 082h,0C3h,082h,0AFh,082h,0F0h,081h,040h,082h,0EDh,082h,0BDh,082h,0B5h,082h,0CCh
db 089h,0A4h,08Eh,071h,082h,0B3h,082h,0DCh

db 2Ah	; HANABIRA3
db 07Ch,065h,021h,020h,079h,020h,033h,02Fh,02Dh,011h,076h,02Ch,074h,070h,011h,044h
db 082h,0BBh,082h,0CCh,089h,0D4h,082h,0D1h,082h,0E7h,082h,0C9h,082h,0ADh,082h,0BFh
db 082h,0C3h,082h,0AFh,082h,0F0h,081h,040h,082h,0A0h,082h,0C8h,082h,0BDh,082h,0C6h
db 097h,0F6h,090h,06Ch,082h,0C2h,082h,0C8h,082h,0ACh

db 2Ch	; HANABIRA4
db 07Ch,061h,07Bh,073h,07Dh,072h,06Ah,07Ah,02Ah,013h,076h,078h,07Fh,024h,018h,014h
db 082h,0BBh,082h,0CCh,089h,0D4h,082h,0D1h,082h,0E7h,082h,0C9h,082h,0ADh,082h,0BFh
db 082h,0C3h,082h,0AFh,082h,0F0h,081h,040h,088h,0A4h,082h,0B5h,082h,0B3h,082h,0CCh
db 083h,074h,083h,048h,083h,067h,083h,04Fh,083h,089h,083h,074h

db 2Ah	; HANABIRA5
db 079h,062h,072h,076h,07Fh,072h,063h,070h,02Ah,016h,072h,07Ch,078h,026h,011h,014h
db 082h,0BBh,082h,0CCh,089h,0D4h,082h,0D1h,082h,0E7h,082h,0C9h,082h,0ADh,082h,0BFh
db 082h,0C3h,082h,0AFh,082h,0F0h,081h,040h,082h,0A0h,082h,0C8h,082h,0BDh,082h,0F0h
db 08Dh,044h,082h,0ABh,082h,0C8h,08Dh,04Bh,082h,0B9h

db 28h	; HANABIRA6
db 02Fh,067h,07Ah,071h,076h,075h,06Ah,078h,078h,015h,074h,02Ch,074h,077h,019h,013h
db 082h,0BBh,082h,0CCh,089h,0D4h,082h,0D1h,082h,0E7h,082h,0C9h,082h,0ADh,082h,0BFh
db 082h,0C3h,082h,0AFh,082h,0F0h,081h,040h,090h,04Fh,082h,0C6h,083h,04Ch,083h,058h
db 082h,0C5h,099h,0EAh,082h,0A2h,082h,0C4h

db 36h	; HANA7
db 07Bh,035h,022h,077h,02Ch,024h,067h,02Ch,02Ah,045h,077h,02Bh,02Eh,026h,045h,017h
db 082h,0BBh,082h,0CCh,089h,0D4h,082h,0D1h,082h,0E7h,082h,0C9h,082h,0ADh,082h,0BFh
db 082h,0C3h,082h,0AFh,082h,0F0h,081h,040h,082h,0A0h,082h,0DCh,082h,0ADh,082h,0C4h
db 082h,0D9h,082h,0B5h,082h,0ADh,082h,0C4h,082h,0C6h,082h,0EBh,082h,0AFh,082h,0E9h
db 082h,0BFh,082h,0E3h,082h,0A4h

db 28h	; HANA8
db 07Dh,032h,072h,023h,02Fh,022h,062h,02Ch,02Eh,010h,022h,02Ch,028h,071h,041h,042h
db 082h,0BBh,082h,0CCh,089h,0D4h,082h,0D1h,082h,0E7h,082h,0C9h,082h,0ADh,082h,0BFh
db 082h,0C3h,082h,0AFh,082h,0F0h,081h,040h,093h,056h,08Eh,067h,082h,0CCh,089h,0D4h
db 082h,0D1h,082h,0E7h,090h,0F5h,082h,0DFh

db 0
ENDP
