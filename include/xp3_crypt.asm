
_xp3_select PROC
	pop	eax
	call	@@1

	db 'fate',0, 'swan',0, 'seiten',0, 'okiba',0, 'shiden',0
	db 'links',0, 'xor',0, 'avatar',0, 'konkon',0, 'sd_hime',0
	db 'seiyuu',0, 'cafesourire',0, 'himesyo',0, 'location', 0

	db 'ataraxia',0, 'smile',0, 'tenshin',0, 'futur',0, 'kickinghorse',0
	db 'aqua',0, 'relations',0, 'akazukin',0, 'shisukoi',0, 'zchospiral',0
	db 'imostyle',0, 'mahoyo_trial',0, 'osana',0, 'mahoyo',0
	db 0

@@1:	push	eax
	jmp	_string_select
ENDP

_xp3_crypt PROC

@@X = dword ptr [ebp+14h]
@@A = dword ptr [ebp+18h]
@@K = dword ptr [ebp+1Ch]
@@D = dword ptr [ebp+20h]
@@C = dword ptr [ebp+24h]
@@N = dword ptr [ebp+28h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	eax, [@@A]
	mov	edx, [@@X]
	mov	edi, [@@D]
	mov	ebx, [@@C]
	dec	eax
	js	@@9
	test	edi, edi
	je	@@9
	test	ebx, ebx
	je	@@9
	sub	eax, XP3_CRYPT
	sbb	ecx, ecx
	and	ecx, eax
	mov	esi, offset @@T
	lea	edx, [edx+ecx*2]
	mov	ecx, [@@K]
	movzx	edx, word ptr [esi+edx*2]
	add	esi, edx
	mov	edx, [@@N]
	call	esi
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	18h

	dw @@Dec1-@@T, @@Dec1-@@T	; fate
	dw @@Dec2-@@T, @@Enc2-@@T	; swan
	dw @@Dec3-@@T, @@Enc3-@@T	; seiten
	dw @@Dec4-@@T, @@Dec4-@@T	; okiba
	dw @@Dec5-@@T, @@Dec5-@@T	; shiden
	dw @@Dec6-@@T, @@Dec6-@@T	; links
	dw @@Dec7-@@T, @@Dec7-@@T	; xor
	dw @@Dec8-@@T, @@Dec8-@@T	; avatar
	dw @@Dec9-@@T, @@Dec9-@@T	; konkon
	dw @@Dec10-@@T, @@Dec10-@@T	; sd_hime
	dw @@Dec11-@@T, @@Enc11-@@T	; seiyuu
	dw @@Dec12-@@T, @@Dec12-@@T	; cafesourire
	dw @@Dec13-@@T, @@Dec13-@@T	; himesyo
	dw @@Dec14-@@T, @@Dec14-@@T	; location
@@T	dw @@DecX-@@T, @@DecX-@@T	; decc

; "Fate/stay night"
; d[i] = s[i] ^ 0x36 ^ (i == 0x13 ? 1 : 0) ^ (i == 0x2EA29 ? 3 : 0)

@@Dec1 PROC
	mov	eax, 2EA29h
	cmp	ebx, 13h
	jbe	@@1
	xor	byte ptr [edi+13h], 1
	cmp	ebx, eax
	jbe	@@1
	xor	byte ptr [edi+eax], 3
@@1:	xor	byte ptr [edi], 36h
	inc	edi
	dec	ebx
	jne	@@1
	ret
ENDP

; "Swan Song", "Kaiware!"

@@Dec2 PROC
	test	cl, cl
	jne	$+4
	mov	cl, 0Fh
	test	ch, ch
	jne	$+4
	mov	ch, 0F0h
@@1:	xor	[edi], ch
	ror	byte ptr [edi], cl
	inc	edi
	dec	ebx
	jne	@@1
	ret
ENDP

@@Enc2 PROC
	test	cl, cl
	jne	$+4
	mov	cl, 0Fh
	test	ch, ch
	jne	$+4
	mov	ch, 0F0h
@@1:	rol	byte ptr [edi], cl
	xor	[edi], ch
	inc	edi
	dec	ebx
	jne	@@1
	ret
ENDP

; "Seirei Tenshou ~Kowareyuku Sekai no Shoujotachi~"
; Seiten.exe 0072365C file_decode

@@Dec3 PROC

@@K = dword ptr [ebp-4]
@@C = dword ptr [ebp-8]

	push	ebp
	mov	ebp, esp
	push	ecx
	push	ebx
	xor	esi, esi
@@1:	mov	eax, [@@K]
	xor	eax, esi
	mov	dl, [edi+esi]
	test	al, 2
	je	@@1b
	mov	ecx, eax
	mov	ebx, eax
	and	ecx, 18h
	shr	ebx, cl
	and	ecx, 8
	push	eax
	shr	eax, cl
	or	ebx, eax
	pop	eax
	xor	edx, ebx
@@1b:	test	al, 4
	je	@@1c
	add	edx, eax
@@1c:	test	al, 8
	je	@@1d
	mov	ecx, eax
	and	ecx, 10h
	shr	eax, cl
	sub	edx, eax
@@1d:	mov	[edi+esi], dl
	inc	esi
	cmp	esi, [@@C]
	jb	@@1
	leave
	ret
ENDP

@@Enc3 PROC

@@K = dword ptr [ebp-4]
@@C = dword ptr [ebp-8]

	push	ebp
	mov	ebp, esp
	push	ecx
	push	ebx
	xor	esi, esi
@@1:	mov	eax, [@@K]
	xor	eax, esi
	mov	dl, [edi+esi]
	test	al, 8
	je	@@1d
	mov	ecx, eax
	mov	ebx, eax
	and	ecx, 10h
	shr	ebx, cl
	add	edx, ebx
@@1d:	test	al, 4
	je	@@1c
	sub	edx, eax
@@1c:	test	al, 2
	je	@@1b
	mov	ecx, eax
	mov	ebx, eax
	and	ecx, 18h
	shr	ebx, cl
	and	ecx, 8
	shr	eax, cl
	or	ebx, eax
	xor	edx, ebx
@@1b:	mov	[edi+esi], dl
	inc	esi
	cmp	esi, [@@C]
	jb	@@1
	leave
	ret
ENDP

; "Okiba ga Nai!"
; okiba.exe 0044E86C decode

@@Dec4 PROC
	; 0,1,2,3 -> 2,1,0,3
	mov	eax, ecx
	shr	ecx, 4
	xchg	al, ah
	ror	eax, 8
	xchg	al, ah
	rol	eax, 8
	xchg	al, ah
	ror	eax, 8
	push	65h
	pop	edx
@@1:	xor	[edi], cl
	inc	edi
	dec	ebx
	je	@@9
	dec	edx
	jne	@@1
@@2:	xor	[edi], al
	inc	edi
	ror	eax, 8
	dec	ebx
	jne	@@2
@@9:	ret
ENDP

; "Lovely x Cation"
; exe 0044E1C1 decode

@@Dec14 PROC
	shr	ecx, 5
	xor	eax, eax
@@1:	mov	edx, ecx
	test	al, 4
	jne	@@2
	cmp	eax, 68h
	jb	@@2
	shr	edx, 3
@@2:	xor	[edi+eax], dl
	inc	eax
	dec	ebx
	jne	@@1
	ret
ENDP

; "Shiden - Enkan no Kizuna"

@@Dec5 PROC
	shr	ecx, 0Ch
	sub	ebx, 5
	jbe	@@9
@@1:	xor	[edi+5], cl
	inc	edi
	dec	ebx
	jne	@@1
@@9:	ret
ENDP

; "Links! ~Kimi to Seirei to Tsukaima to~"

@@Dec6 PROC
	movzx	ecx, cl
	or	edx, -1
	test	ecx, ecx
	je	@@9
@@1:	inc	edx
	cmp	edx, ecx
	sbb	eax, eax
	and	edx, eax
	je	@@2
	xor	[edi], cl
@@2:	inc	edi
	dec	ebx
	jne	@@1
@@9:	ret
ENDP

; "Cafe Sourire"

@@Dec12:
	xor	cl, 0CDh
	jmp	@@Dec7

; "Tsubasa no Oka no Hime: A red and blue moon -finite loop-"

@@Dec10:
	inc	ecx
	not	ecx
	jmp	@@Dec7

; "Kon Kon"

@@Dec9:	shr	ecx, 7
	not	ecx

; "Heliotrope -Sore wa Shi ni Itaru Kami no Ai-"

@@Dec7 PROC
@@1:	xor	[edi], cl
	inc	edi
	dec	ebx
	jne	@@1
	ret
ENDP

; "Gensou no Avatar"

@@Dec8 PROC
	push	ebp
	mov	ebp, esp
	push	ecx

	call	_unicode_name, edx
	push	eax
	call	@@3
	db 'startup.tjs',0, 'initialize.tjs',0, 'btext.dll',0, 0
@@3:	call	_filename_select
	jnc	@@9

	call	_LoadTable, 2
	jc	@@9
	push	eax
	xor	esi, esi
@@1:	mov	edx, [ebp-8]
	movzx	eax, si
	mov	ecx, esi
	shr	eax, 3
	and	ecx, 7
	mov	edx, [edx+eax*4]
	mov	eax, [ebp-4]
	shl	ecx, 2
	xor	eax, edx
	shr	edx, cl
	shl	ecx, 1
	and	ecx, 1Fh
	and	edx, 0Fh
	shr	eax, cl
	xor	al, byte ptr [@@T+edx]
	inc	esi
	xor	[edi], al
	inc	edi
	dec	ebx
	jne	@@1
@@9:	leave
	ret

@@T	dd 0A7CBDD42h,0964A29F0h,0AAAE505Dh,0F3B69D79h
ENDP

; "Serifu de Kanjite! Seiyuu Doushi"

@@Enc11:
	mov	al, 1
	jmp	@@Dec11Sys
@@Dec11:
	mov	al, -1
@@Dec11Sys PROC
	push	ebp
	mov	ebp, esp
	push	eax
	mov	al, 15h
	call	@@4
	call	@@3
	mov	al, 20h
	call	@@5
	mov	al, 2Bh
	call	@@4
	test	ebx, ebx
	mov	esi, ebx
	je	@@9
	mov	al, 36h
	call	@@5
@@9:	leave
	ret

@@3:	test	ebx, ebx
	je	@@9
	push	7Bh
	pop	esi
	sub	ebx, esi
	jae	$+6
	add	esi, ebx
	xor	ebx, ebx
	ret

@@4:	call	@@3
	imul	eax, ecx
@@4a:	xor	[edi], al
	inc	edi
	dec	esi
	jne	@@4a
	ret

@@5:	imul	eax, [ebp-4]
	imul	eax, ecx
@@5a:	add	[edi], al
	inc	edi
	dec	esi
	jne	@@5a
	ret
ENDP

; "Himesho!"

@@Dec13 PROC
	push	ebp
	mov	ebp, esp
	not	ecx
	push	ecx

	call	_unicode_name, edx
	push	eax
	push	eax
	call	@@3
	db 'startup.tjs',0, 'krlib.dll',0, 0
@@3:	call	_filename_select
	jnc	@@9
	call	_unicode_ext, -1
	cmp	eax, 'sk'
	je	@@2
	cmp	eax, 'sjt'
	je	@@2
	cmp	eax, 'dsa'
	je	@@2
	mov	eax, 100h
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
@@2:
	xor	ecx, ecx
@@1:	mov	eax, ecx
	and	eax, 3
	mov	al, [ebp-4+eax]
	xor	al, cl
	inc	ecx
	xor	[edi], al
	inc	edi
	dec	ebx
	jne	@@1
@@9:	leave
	ret
ENDP

; "Fate/hollow ataraxia", "Smile Cubic!"

@@DecX PROC
	push	ebp
	mov	ebp, esp
	xchg	esi, eax
	push	ecx
	call	_LoadTable, 4
	pop	ecx
	jc	@@9
	imul	edx, esi, 15h
	shl	esi, 0Ch
	add	edx, offset @@T+1
	add	esi, eax
	push	edx
	push	esi
	movzx	eax, word ptr [edx-1]
	and	eax, ecx
	add	ax, [edx+1]
	cmp	eax, ebx
	jb	$+4
	mov	eax, ebx
	xor	esi, esi
	push	ecx
	push	eax
	push	ebx
	xchg	ebx, eax
	call	@@2
	pop	ebx
	pop	esi
	pop	ecx
	sub	ebx, esi
	je	@@9
	mov	eax, ecx
	shr	eax, 10h
	xor	ecx, eax
	call	@@2
@@9:	leave
	ret

@@2:	push	ecx
	call	@@3, ecx, 0
	pop	ecx
	test	al, al
	jne	$+4
	mov	al, 1
	ror	eax, 8
	push	eax
	call	@@3, ecx, -1
	pop	ecx
	movzx	edx, ax
	shr	eax, 10h
	cmp	edx, eax
	jne	$+3
	inc	edx
	sub	eax, esi
	cmp	eax, ebx
	jae	@@2a
	xor	[edi+eax], cl
@@2a:	sub	edx, esi
	cmp	edx, ebx
	jae	@@2b
	xor	[edi+edx], ch
@@2b:	rol	ecx, 8
@@2c:	xor	[edi], cl
	inc	edi
	dec	ebx
	jne	@@2c
	ret

@@T:

; *** ataraxia

dw 143h,787h
db 0,1,2
db 0,1,2,3,4,5,6,7
db 0,1,2,3,4,5

; *** smile

dw 262h,70Ah
db 1,0,2
db 7,3,6,2,0,1,4,5
db 1,2,3,5,4,0

; *** tenshin

dw 167h,498h
db 1,0,2
db 4,2,3,5,6,1,7,0
db 1,0,5,4,3,2

; *** futur

dw 23Ch,60Fh
db 2,0,1
db 1,5,0,3,2,7,6,4
db 4,5,2,1,0,3

; *** kickinghorse

dw 1F8h,67Ch
db 2,0,1
db 6,0,3,7,4,5,1,2
db 3,0,1,2,5,4

; *** aqua

dw 1A8h,776h
db 0,2,1
db 0,1,3,7,4,5,6,2
db 2,0,5,3,1,4

; *** relations

dw 1C3h,0E7h
db 2,1,0		; 210
db 2,4,1,0,5,3,6,7	; 32051467
db 3,4,0,2,1,5		; 243015

; *** akazukin

dw 171h,6BBh
db 1,2,0		; 201
db 1,4,2,3,0,7,6,5	; 40231765
db 2,0,5,1,3,4		; 130452

; *** shisukoi

dw 11Eh,6F1h
db 1,2,0		; 201
db 3,0,5,2,4,1,7,6	; 15304276
db 5,4,1,3,2,0		; 524310

; *** zchospiral (srp.exe + decc)

dw 1ECh,787h
db 2,0,1		; 120
db 3,4,0,5,7,2,1,6	; 26501374
db 0,4,3,1,2,5		; 034215

; *** imostyle

dw 278h,0D7h
db 2,1,0		; 210
db 7,5,1,3,6,4,2,0	; 72635140
db 1,2,4,0,5,3		; 301524

; *** mahoyo_trial

dw 161h,5C9h
db 2,1,0		; 210
db 1,3,5,4,0,2,6,7	; 40513267
db 2,4,1,0,5,3		; 320514

; *** osana

dw 100h,17Fh
db 2,0,1		; 120
db 2,0,7,4,5,3,6,1	; 17053462
db 5,1,3,2,0,4		; 413250

; *** mahoyo

dw 22Ah,2A2h
db 1,0,2		; 102
db 7,6,5,1,0,3,4,2	; 43756210
db 3,2,1,4,5,0		; 521034

; 1E0015F0

@@3 PROC	; 1E001520

@@A = dword ptr [ebp+14h]
@@B = dword ptr [ebp+18h]

	push	ebx
	push	esi
	push	edi
	mov	esi, [ebp-4]
	mov	eax, [ebp-8]
	enter	14h, 0
	mov	edi, esp
	movsd
	movsd
	movsd
	movsd
	movsd
	push	eax
	mov	esi, [@@A]
	mov	eax, esi
	and	esi, 7Fh
	shr	eax, 7
	xor	eax, [@@B]
	mov	[@@A], eax
	push	6
@@9:	lea	esp, [ebp-1Ch]
	pop	ebx
	dec	ebx
	push	ebx
	push	77h
	pop	edi
	call	@@7
	sub	edi, 6
	jb	@@9
	mov	edx, esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

	; 1E0015A0
@@4:	pop	ebx
	call	@@3
	xor	edx, edx
	lea	ecx, [edx+3]
	div	ecx
	mov	dl, byte ptr [ebp+edx-11h]
	dec	edx
	js	@@4a
	je	@@4b
	sub	edi, 7	; 2 2 2 0 0 1 0
	jb	@@9
	; (BE********8B86)
	call	@@3
	and	eax, 3FFh
	mov	ecx, [ebp-18h]
	mov	eax, [ecx+eax*4]
@@4c:	; (********)
	sub	edi, 4
	jb	@@9
	ret
@@4b:	; (8BC7)
	sub	edi, 2	; 1 0 0 2 2 2 1
	jb	@@9
	mov	eax, [@@A]
	ret
@@4a:	; (B8)
	dec	edi	; 0 1 1 1 1 0 2
	js	@@9
	call	@@3
	jmp	@@4c

@@6:	pop	ecx
	movzx	edx, byte ptr [ecx+edx]
	add	edx, ecx
	movzx	ecx, byte ptr [edx-1]
	sub	edi, ecx
	jb	@@9
	pop	eax
	pop	ecx
	pop	ebx
	jmp	edx

@@5:	call	@@3
	jne	@@7
	; 1E001650
	push	ebx
	dec	ebx
	je	@@4
	call	@@5
	push	eax
	push	eax
	call	@@3
	and	eax, 7
	xchg	edx, eax
	mov	dl, byte ptr [ebp+edx-0Eh]
	call	@@6
@@5x:	db @@5a-@@5x
	db @@5b-@@5x
	db @@5c-@@5x
	db @@5d-@@5x
	db @@5e-@@5x
	db @@5f-@@5x
	db @@5g-@@5x
	db @@5h-@@5x

	db 2		; (F7D0)
@@5a:	not	eax	; 0 4 7 2 1 0 4
	ret

	db 1		; (48)
@@5b:	dec	eax	; 1 5 5 0 6 1 0
	ret

	db 2		; (F7D8)
@@5c:	neg	eax	; 2 3 1 4 7 7 5
	ret

	db 1		; (40)
@@5d:	inc	eax	; 3 1 2 3 2 2 1
	ret

	db 5+5+3
@@5e:	and	eax, 3FFh	; 4 6 0 7 4 4 3
	mov	ecx, [ebp-18h]
	mov	eax, [ecx+eax*4]
	ret

	db 15h
@@5f:	and	eax, 55555555h	; 5 7 3 1 5 5 2
	sub	ecx, eax
	shl	eax, 1
	shr	ecx, 1
	add	eax, ecx
	ret

	db 1		; (35)
@@5g:	call	@@3	; 6 2 4 6 0 6 6
	xor	eax, ecx
@@5i:	sub	edi, 4
	jb	@@9
	ret

	db 0
@@5h:	call	@@3	; 7 0 6 5 3 3 7
	xchg	edx, eax
	dec	edi
	js	@@9
	call	@@3
	shr	edx, 1
	jc	$+4
	neg	eax		; (2D)
	add	eax, ecx	; (05)
	jmp	@@5i

	; 1E0018A0
@@7:	push	ebx
	dec	ebx
	je	@@4
	dec	edi
	js	@@9
	call	@@5
	sub	edi, 2
	jb	@@9
	push	eax	; ebx
	call	@@5
	push	eax
	call	@@3
	xor	edx, edx
	lea	ecx, [edx+6]
	div	ecx
	mov	dl, byte ptr [ebp+edx-6]
	call	@@6
@@7x:	db @@7a-@@7x
	db @@7b-@@7x
	db @@7c-@@7x
	db @@7d-@@7x
	db @@7e-@@7x
	db @@7f-@@7x

	db 0Ah			; (D3E8)
@@7a:	and	ecx, 0Fh	; 0 5 1 4 1 1 3
	shr	eax, cl
	ret

	db 0Ah			; (D3E0)
@@7b:	and	ecx, 0Fh	; 1 0 0 3 2 4 2
	shl	eax, cl
	ret

	db 3			; (01D8)
@@7c:	add	eax, ecx	; 2 1 5 2 3 0 0
	ret

	db 5			; (F7D8)
@@7d:	neg	eax		; 3 2 4 5 0 3 5
	add	eax, ecx
	ret

	db 4			; (0FAFC3)
@@7e:	imul	eax, ecx	; 4 4 3 0 5 5 1
	ret

	db 3			; (29D8)
@@7f:	sub	eax, ecx	; 5 3 2 1 4 2 4
	ret

	; 1E001220
@@3:	mov	eax, esi
	imul	esi, 41C64E6Dh
	rol	eax, 10h
	add	esi, 3039h
	xor	eax, esi
	test	al, 1
	ret
ENDP

ENDP	; @@VM

ENDP