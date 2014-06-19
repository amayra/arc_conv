
include warc_include.asm

if 0
_warc_select PROC
	pop	ecx
	pop	edx
	pop	eax
	push	ecx
	push	esi
	push	edi
	xchg	edi, eax
	call	@@3

@@1:	db 'deco_*',0, 'helter_*',0
	db 'yougaku_*',0, 'purelove_*',0, 'oreimoplus_*',0, 'hanarb_*',0
	db 'oonap_*',0, 'mahost_*',0, 'rensai_*',0, 'onegan_*',0, 'shiteage_*',0
	db 0

	ALIGN 4
@@2:	; SABAE (v2.36), RON,OTOME(v2.37), METRO (v2.38)
	dd 39, 0486D887Eh,00F7DBC73h,05D7D327Dh,0997C427Dh,0877EAD7Ch	; DECO (v2.39)
	dd 40, 0747C887Ch,0A47EA17Ch,0AF7CA77Ch,0A17C747Ch,00000A47Eh	; HELTER (v2.40)
	dd 47, 04DE2AB4Dh,098AB5D46h,066496349h,0485D685Dh,05F4D4C5Dh	; YOUGAKU (v2.47)
	dd 47, 031500050h,035507250h,087821350h,09D9E9780h,000009784h	; PURELOVE (v2.47)
	dd 47, 024371528h,02822D722h,01528F922h,0D7222437h,0F9222822h	; OREIMOPLUS (v2.47)
	dd 47, 0E3A7F1ACh,0B2AA96ACh,04FAAECA7h,0D5A7BAB0h,044A754A7h	; HANARB (v2.47)
	dd 47, 0D59CB69Ch,0F69CA09Ch,0779D579Dh,07C9D679Dh,00000799Dh	; OONAP (v2.47)
	dd 47, 051879387h,0869EBC9Eh,0F480DD93h,0D993C981h,0D793A093h	; MAHOST (v2.47)
	dd 47, 06E423C5Dh,07A5C0947h,06E423C5Dh,07A5C0947h,06E423C5Dh	; RENSAI (v2.47)
	dd 48, 0C881AB81h,090804880h,0AB814A82h,04880C881h,04A829080h	; ONEGAN (v2.48)
	dd 48, 070562056h,087470744h,002449045h,076446644h,08F472F44h	; SHITEAGE (v2.48)

@@3:	pop	esi
	call	_unicode_name, edx
	call	_filename_select, esi, eax
	jc	@@9
	lea	edx, [eax*2+eax]
	lea	esi, [edx*8+esi+(@@2-@@1)-18h]
	lodsd
	call	_warc_init
	clc
@@9:	pop	edi
	pop	esi
	ret
ENDP
endif

_warc_init PROC
	call	@@3
	dw 39*32
	dw 40*32
	dw 41*32
	dw 48*32+1
	dw 49*32
	dw -1
@@3:	pop	edx
	or	ecx, -1
@@3a:	inc	ecx
	cmp	ax, [edx+ecx*2]
	jae	@@3a
	xchg	eax, ecx
	stosw
	cmp	al, WARC_V240
	sbb	eax, eax
	shl	eax, 4
	add	eax, 38h
	stosw
	push	5
	pop	ecx
	test	esi, esi
	jne	@@1
	call	@@2
	dd 0F182C682h,0E882AA82h,0718E5896h,08183CC82h,0DAC98283h
@@2:	pop	esi
@@1:	rep	movsd
	ret
ENDP

_exe_timestamp PROC
	push	esi
	mov	esi, [esp+8]
	mov	ecx, [esp+0Ch]
	xor	eax, eax
	cmp	ecx, 40h
	jb	@@1
	mov	edx, [esi+3Ch]
	cmp	word ptr [esi], 'ZM'
	jne	@@1
	sub	ecx, edx
	jb	@@1
	sub	ecx, 18h+60h
	jb	@@1
	cmp	dword ptr [esi+edx], 'EP'
	jne	@@1
	mov	eax, [esi+edx+8]
	xor	esi, esi
@@1:	neg	esi
	pop	esi
	ret	8
ENDP

_warc_scan PROC

@@S = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]
@@T = dword ptr [ebp+1Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ecx, [@@C]
	mov	edi, [@@S]
	shr	ecx, 2
	sub	ecx, 9		; 28h
	mov	[@@C], ecx
	jae	@@1a
@@9:	stc
@@8:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch

@@1a:	test	ecx, ecx
	je	@@9
	mov	eax, 08B060D01h	; png data crc32
	repne	scasd
	jne	@@9
	mov	edx, 0826042AEh
	mov	eax, [edi+4]
	sub	edx, [edi+8]
	sub	eax, 'DNEI'
	or	edx, [edi]
	or	eax, [edi+0Ch]
	or	eax, edx
	jne	@@1a
	lea	eax, [edi+10h]
	push	eax
	mov	ecx, [@@C]
	mov	edi, [@@S]
	call	@@2
	jnc	@@1b
	mov	ecx, [@@C]
	mov	edi, [@@S]
	call	@@3	; Chinese RioShiina
	jc	@@9
@@1b:	movzx	eax, byte ptr [edi+8]
	sub	al, 30h
	cmp	al, 0Ah
	jae	@@9
	lea	edx, [eax*4+eax]
	movzx	eax, byte ptr [edi+9]
	sub	al, 30h
	cmp	al, 0Ah
	jae	@@9
	lea	eax, [edx*2+eax]
	pop	edx
	clc
	xor	ecx, ecx
	cmp	eax, 48
	jne	@@1c
	cmp	[@@T], 4D81B073h
	jb	@@1c
	inc	ecx
@@1c:	shl	eax, 5
	add	eax, ecx
	jmp	@@8

@@2:	test	ecx, ecx
	je	@@2a
	mov	eax, 0BC96C592h
	repne	scasd
	jne	@@2a
	mov	edx, '.2v '
	mov	eax, [edi]
	sub	edx, [edi+4]
	sub	eax, 08F8FA297h
	or	eax, edx
	jne	@@2
	clc
	ret
@@2a:	stc
	ret

@@3:	test	ecx, ecx
	je	@@2a
	mov	eax, ' oiR'
	repne	scasd
	jne	@@2a
	mov	edx, 'v an'
	mov	eax, [edi]
	sub	edx, [edi+4]
	sub	eax, 'iihS'
	or	eax, edx
	jne	@@3
	cmp	word ptr [edi+8], '.2'
	jne	@@3
	inc	edi
	inc	edi
	clc
	ret
ENDP

_warc_readkey PROC
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ecx, [ebp+14h]
	mov	edi, [ebp+18h]
	cmp	word ptr [ecx], '2'
	jne	@@9
	movzx	eax, word ptr [ecx+2]
	sub	al, 30h
	cmp	eax, 0Ah
	jae	@@9
	lea	edx, [eax*4+eax]
	movzx	eax, word ptr [ecx+4]
	sub	al, 30h
	cmp	eax, 0Ah
	jae	@@9
	lea	eax, [edx*2+eax]
	shl	eax, 5
	movzx	esi, word ptr [ecx+6]
	lea	edx, [esi-61h]
	and	edx, NOT 20h
	cmp	edx, 1Ah
	jae	@@4a
	inc	ecx
	inc	ecx
	add	eax, edx
	movzx	esi, word ptr [ecx+6]
	inc	eax
@@4a:	test	esi, esi
	je	@@8
	cmp	esi, '-'
	jne	@@9
	stosd
	lea	esi, [ecx+8]
	push	14h
	pop	ecx
@@1:	dec	ecx
	js	@@9
	call	@@2
	shl	eax, 4
	xchg	edx, eax
	call	@@2
	add	eax, edx
	stosb
	cmp	word ptr [esi], 0
	jne	@@1
	xor	eax, eax
	rep	stosb

	sub	edi, 18h
	mov	esi, edi
	lodsd
@@8:	call	_warc_init
	xor	edi, edi
@@9:	neg	edi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@2:	xor	eax, eax
	lodsw
	sub	al, 30h
	cmp	eax, 0Ah
	jb	@@2a
	or	al, 20h
	sub	al, 31h
	cmp	eax, 6
	jae	@@9
	add	al, 0Ah
@@2a:	ret
ENDP

_warc_crypt PROC	; 004429C0

@@F = dword ptr [ebp+14h]
@@B = dword ptr [ebp+18h]
@@A = dword ptr [ebp+1Ch]
@@SB = dword ptr [ebp+20h]
@@SC = dword ptr [ebp+24h]

@@L0 = dword ptr [ebp-8]
@@L1 = dword ptr [ebp-0Ch]
@@L2 = dword ptr [ebp-10h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ecx, [@@SC]
	mov	edi, [@@SB]
	cmp	ecx, 3
	jb	@@9
	push	27Fh
	finit
;	fstcw	[ebp-2]
	fldcw	word ptr [ebp-4]

	mov	eax, 400h
	cmp	eax, ecx
	jb	$+4
	mov	eax, ecx
	mov	[@@SC], eax

	mov	esi, ecx
	movsx	ebx, cl
	shr	ecx, 1
	movsx	ecx, cl
	movsx	eax, byte ptr [edi]
	movsx	edx, byte ptr [edi+1]
	xor	eax, ebx
	xor	edx, ecx
	mov	ecx, [@@A]
	push	eax		; @@L0
	push	edx		; @@L1
	push	0		; @@L2

	movzx	edx, word ptr [ecx+2]
	shl	edx, 0Eh
	cmp	esi, edx
	je	@@2c
	imul	esi, 5D588B65h
	inc	esi

	mov	dl, [ecx]
	cmp	dl, WARC_V239
	mov	ecx, [@@B]
	mov	eax, 0C27Eh
	jb	@@2e
	add	ecx, eax
	mov	eax, 829Eh
	cmp	dl, WARC_V248A
	jb	@@2e
	mov	eax, 8FACh
@@2e:	mul	esi
	movzx	eax, byte ptr [ecx+edx+2400h]
	add	eax, esi
	call	@@VM, eax
	mov	ecx, 80h
	mov	[@@L2], eax
	cmp	[@@SC], ecx
	jbe	@@2d
	lea	eax, [edi+4]
	sub	[@@SC], ecx
	call	@@SHA, [@@A], [@@B], eax
	sub	edi, -80h
@@2d:	mov	eax, [@@L0]
@@2c:	test	eax, eax
	jns	$+4
	neg	eax
	push	eax
	fild	dword ptr [esp]
	pop	eax
	call	@@4		; 004422A0
	mov	eax, 100000000
	call	@@3
	cmp	[@@L0], 0
	jns	$+4
	neg	eax
	xor	esi, eax	; 008BE880

	mov	ecx, [@@L1]
	mov	eax, [@@L0]
	mov	edx, ecx
	imul	eax, eax
	imul	edx, edx
	add	eax, edx
	push	eax
	fild	dword ptr [esp]
	pop	eax
	je	@@2b
	fsqrt
	fidivr	[@@L0]
	; __CIacos
	fld1
	fadd	st(0), st(1)
	fld1
	fsub	st(0), st(2)
	fmulp	st(1), st(0)
	fsqrt
	fxch	st(1)
	fpatan

	fldpi
	fdivp	st(1), st(0)
	test	ecx, ecx
	jns	@@2a
	fld1
	fadd	st(0), st(0)
	fsubrp	st(1), st(0)
@@2a:	db 68h
	dd 180.0
	fmul	dword ptr [esp]
	pop	ecx
@@2b:	call	@@5		; 00442370
	mov	eax, 100h
	call	@@3
;	fldcw	[ebp-2]
	add	eax, [@@L2]

	xor	ebx, ebx
	cmp	[@@F], ebx
	lea	ecx, [ebx+2]
	jne	@@1b
@@1a:	and	eax, 3Fh
	imul	esi, 5D588B65h
	xchg	edx, eax
	inc	esi
	mov	eax, esi
	shr	eax, 18h
	xor	al, [edi+ecx]
	ror	al, 1
	xor	al, [@@T+ebx]
	xor	al, [@@T+edx]
	mov	[edi+ecx], al
	inc	ebx
	inc	ecx
	and	ebx, 3Fh
	cmp	ecx, [@@SC]
	jb	@@1a
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h

@@1b:	and	eax, 3Fh
	imul	esi, 5D588B65h
	xchg	edx, eax
	inc	esi
	mov	eax, esi
	shr	eax, 10h
	mov	dl, [@@T+edx]
	mov	al, [edi+ecx]
	xor	dl, [@@T+ebx]
	xor	dl, al
	rol	dl, 1
	xor	dl, ah
	mov	[edi+ecx], dl
	inc	ebx
	inc	ecx
	and	ebx, 3Fh
	cmp	ecx, [@@SC]
	jb	@@1b
	jmp	@@9

	; __ftol2
@@3:	push	eax
	mov	ecx, esp
	fimul	dword ptr [ecx]
	fstcw	[ecx]
	mov	eax, [ecx]
	or	ah, 0Ch
	push	eax
	fldcw	[ecx-4]
	fistp	dword ptr [ecx-4]
	fldcw	[ecx]
	pop	eax
	pop	ecx
	ret

@@VM PROC	; 00423E80 vm(0x100)

@@L0 = byte ptr [ebp+8]

	push	ebp
	mov	ebp, esp
	push	3DCCCCCDh	; 0.1
	push	3FC00000h	; 1.5
	movzx	ecx, [@@L0+1]
	movzx	eax, [@@L0]
	lea	ecx, [ecx*2+ecx]
	call	@@2
	shr	ecx, 1
	bswap	eax
	add	ecx, eax
	movzx	edx, [@@L0+3]
	movzx	eax, [@@L0+2]
	call	@@2
	xchg	edx, eax
	call	@@2
	leave
	; -a-(~b) == b+1-a
	inc	eax
	sub	eax, edx
	or	eax, ecx
	ret	4

@@2:	push	eax
	fild	dword ptr [ebp-10h]
	fmul	dword ptr [ebp-8]
	fadd	dword ptr [ebp-4]
	fstp	dword ptr [ebp-10h]
	pop	eax
	ret
ENDP	; @@VM

@@SHA PROC	; 004425D0

@@T = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@D = dword ptr [ebp+1Ch]
@@L0 = dword ptr [ebp-28h]

	push	ebx
	push	esi
	push	edi
	enter	140h+28h, 0

	push	10h
	mov	esi, [@@D]
	pop	ecx
	add	esi, 28h
	mov	edi, esp
@@1a:	lodsd
	bswap	eax
	stosd
	dec	ecx
	jne	@@1a
	mov	cl, 40h
@@1b:	mov	eax, [edi-40h]
	xor	eax, [edi-38h]
	xor	eax, [edi-20h]
	xor	eax, [edi-0Ch]
	rol	eax, 1
	stosd
	dec	ecx
	jne	@@1b

	mov	esi, [@@T]
	lea	edi, [@@L0]
	lodsd
	movsd
	movsd
	movsd
	movsd
	movsd

	mov	edx, [@@L0]
	mov	esi, [@@L0+4]
	mov	ebx, [@@L0+8]
	mov	edi, [@@L0+0Ch]
	mov	eax, [@@L0+10h]
	xor	ecx, ecx
@@2:	mov	[@@L0+14h], edx
	mov	[@@L0+18h], eax
	cmp	ecx, 10h
	jae	@@2a
	mov	eax, edi
	xor	eax, ebx
	xor	eax, esi
	jmp	@@2e

@@2a:	cmp	ecx, 20h
	jae	@@2b
	mov	edx, esi
	not	edx
	mov	eax, ebx
	and	edx, edi
	and	eax, esi
	or	eax, edx
	add	eax, 05A827999h
	jmp	@@2e

@@2b:	cmp	ecx, 30h
	jae	@@2c
	mov	eax, ebx
	not	eax
	or	eax, esi
	xor	eax, edi
	add	eax, 06ED9EBA1h
	jmp	@@2e

@@2c:	cmp	ecx, 40h
	jae	@@2d
	mov	edx, edi
	not	edx
	mov	eax, edi
	and	edx, ebx
	and	eax, esi
	or	eax, edx
	add	eax, 08F1BBCDCh
	jmp	@@2e

@@2d:	mov	eax, edi
	not	eax
	or	eax, ebx
	xor	eax, esi
	add	eax, 0A953FD4Eh
@@2e:	mov	edx, [@@L0+14h]
	add	eax, [esp+ecx*4]
	rol	edx, 5
	ror	esi, 2
	add	edx, eax
	add	edx, [@@L0+18h]
	mov	eax, edi
	mov	edi, ebx
	mov	ebx, esi
	mov	esi, [@@L0+14h]
	inc	ecx
	cmp	ecx, 50h
	jb	@@2
	add	[@@L0], edx
	add	[@@L0+4], esi
	add	[@@L0+8], ebx
	add	[@@L0+0Ch], edi
	add	[@@L0+10h], eax
	pop	eax
	pop	ecx
	lea	esp, [@@L0]
	shr	ecx, 8
	test	al, 78h
	jne	$+4
	or	al, 18h
	bswap	eax
	call	@@PNG, [@@S], eax, ecx
	xchg	ebx, eax

	mov	eax, [@@L0]
	and	eax, 7FFFFFFFh
	push	eax
	push	dword ptr [@@L0+4]
	lea	ecx, [@@L0+14h]
	mov	eax, esp
	call	FileTimeToSystemTime, eax, ecx
	mov	eax, [@@L0+0Ch]
	imul	dword ptr [@@L0+8]
	shrd	eax, edx, 8
	mov	edx, [@@T]
	cmp	byte ptr [edx], WARC_V239
	jb	$+4
	add	ebx, eax
	mov	[@@L0+24h], eax
	mov	[@@L0+18h], ebx

	mov	edi, [@@D]
	xor	ecx, ecx
@@1d:	mov	eax, [@@L0+ecx*4]
	xor	[edi+ecx*4], eax
	inc	ecx
	cmp	ecx, 0Ah
	jb	@@1d
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch

@@PNG PROC	; 0040B520

@@S = dword ptr [ebp+14h]
@@L0 = dword ptr [ebp+18h]
@@L1 = dword ptr [ebp+1Ch]

@@L2 = dword ptr [ebp-4]
@@YA = dword ptr [ebp-8]
@@XA = dword ptr [ebp-0Ch]
@@Y = dword ptr [ebp-10h]
@@X = dword ptr [ebp-14h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	ebx, [@@L0]
	mov	al, byte ptr [@@L0+3]
	mov	ecx, 1FFh
	mov	edx, ebx
	shr	ebx, 0Ch
	and	edx, ecx
	and	ebx, ecx
	test	al, 10h
	jne	$+4
	xor	ebx, ebx
	test	al, 8
	jne	$+7
	mov	edx, 100h
	mov	[@@L0], ebx
	push	edx	; @@L2

	xor	edx, edx
	lea	ecx, [edx+4]
	lea	ebx, [edx+30h]
	mov	esi, [@@S]
	test	al, 40h
	je	@@2a
	add	edx, ebx
	lea	esi, [esi+ebx*4-4]
	neg	ecx
@@2a:	test	al, 20h
	je	@@2b
	sub	edx, ebx
	imul	ebx, 2Fh
	lea	esi, [esi+ebx*4]
@@2b:	shl	edx, 3
	xor	ebx, ebx
	push	edx	; @@YA
	push	ecx	; @@XA
	; 0040B8D4
	push	30h	; @@Y
	push	ecx	; @@X

	sub	esp, 400h
	xor	ecx, ecx
@@3a:	mov	eax, ecx
	push	8
	pop	edx
@@3b:	ror	eax, 1
	jc	$+7
	xor	eax, 06DB88320h
	dec	edx
	jne	@@3b
	mov	[esp+ecx*4], eax
	inc	cl
	jne	@@3a

@@1a:	push	30h
	pop	[@@X]
@@1b:	movzx	edi, byte ptr [esi+3]
	imul	edi, [@@L2]
	shr	edi, 8
	xor	ecx, ecx
@@1c:	movzx	edx, byte ptr [esi+ecx]
	movzx	eax, byte ptr [@@L1+ecx]
	sub	eax, edx
	imul	eax, [@@L0]
	shr	eax, 8
	add	eax, edx
	movzx	eax, al
	imul	eax, edi
	movzx	eax, ah
	xor	al, bl
	shr	ebx, 8
	inc	ecx
	xor	ebx, [esp+eax*4]
	cmp	ecx, 3
	jb	@@1c
	add	esi, [@@XA]
	dec	[@@X]
	jne	@@1b
	add	esi, [@@YA]
	dec	[@@Y]
	jne	@@1a
	xchg	eax, ebx
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP	; @@PNG

ENDP	; @@SHA

@@4 PROC	; 004422A0 decode init part1
	push	18
	ficom	dword ptr [esp]
	pop	edx
	fnstsw	ax
	test	ah, 1
	je	@@3
	; 00442300
	fld	st(0)
	fmul	st(0), st(0)
	fchs
	fld	st(1)
	push	3
	pop	ecx
@@4:	lea	eax, [ecx-1]
	imul	eax, ecx
	push	eax
	fild	dword ptr [esp]
	pop	eax
	fdivr	st(0), st(2)
	fmulp	st(1), st(0)
	fld	st(2)
	push	ecx
	fild	dword ptr [esp]
	pop	eax
	fdivr	st(0), st(2)
	faddp	st(4), st(0)
	fcomp	st(3)
	fnstsw	ax
	sahf
	je	@@9
	add	ecx, 2
	cmp	ecx, 3E8h
	jb	@@4
@@9:	fcompp
	ret

@@L0 = qword ptr [ebp-8]
@@L1 = qword ptr [ebp-10h]
@@L2 = qword ptr [ebp-18h]
@@L3 = qword ptr [ebp-20h]
@@L4 = qword ptr [ebp-28h]
@@L5 = qword ptr [ebp-30h]
@@L6 = qword ptr [ebp-38h]
@@P0 = qword ptr [ebp-40h]

	; 00442110
@@3:	enter	40h, 0

	fld1
	fdiv	st(0), st(1)
	fstp	[@@L0]
	fstp	[@@P0]

	fldz
	fst	[@@L1]
	fst	[@@L2]
	fst	[@@L5]
	fstp	[@@L6]
	fld1
	fadd	st(0), st(0)
	fst	[@@L4]
	fstp	[@@L3]

	xor	edx, edx
	xor	ecx, ecx
@@1:	fld	[@@L0]
	fadd	[@@L5]
	fst	[@@L5]
	fcom	[@@L3]
	fnstsw	ax
	sahf
	jae	@@1a
	fst	[@@L3]
	jmp	@@1b
@@1a:	or	ecx, 1
@@1b:	call	@@2

	fld	[@@L0]
	fadd	[@@L6]
	fst	[@@L6]
	fcom	[@@L4]
	fnstsw	ax
	sahf
	jae	@@1c
	fst	[@@L4]
	jmp	@@1d
@@1c:	or	ecx, 2
@@1d:	call	@@2

	fld	[@@L0]
	fsubr	[@@L5]
	fst	[@@L5]
	fcom	[@@L1]
	fnstsw	ax
	sahf
	jbe	@@1e
	fst	[@@L1]
	jmp	@@1f
@@1e:	or	ecx, 4
@@1f:	call	@@2

	fld	[@@L0]
	fsubr	[@@L6]
	fst	[@@L6]
	fcom	[@@L2]
	fnstsw	ax
	sahf
	jbe	@@1g
	fst	[@@L2]
	jmp	@@1h
@@1g:	or	ecx, 8
@@1h:	call	@@2
	cmp	ecx, 0Fh
	jne	@@1

	fldpi
	fld	[@@P0]
	fcos
	fld	[@@L1]
	fadd	[@@L3]
	fmulp	st(1), st(0)
	fsubp	st(1), st(0)
	fld	[@@P0]
	fsin
	fld	[@@L2]
	fadd	[@@L4]
	fmulp	st(1), st(0)
	fsubp	st(1), st(0)
	fld1
	fadd	st(0), st(0)
	fdivp	st(1), st(0)
	leave
	ret

@@2:	fstp	st(0)
	inc	edx
	push	edx
	fild	dword ptr [esp]
	pop	edx
	fdiv	[@@P0]
	fmul	[@@L0]
	fstp	[@@L0]
	ret
ENDP	; @@4

@@5 PROC	; 00442370 decode init part2

@@P0 = qword ptr [ebp-8]
@@L0 = qword ptr [ebp-10h]
@@L1 = qword ptr [ebp-18h]

	enter	18h, 0
	fst	[@@P0]
	fld1
	fcomp	st(1)
	fnstsw	ax
	sahf
	ja	@@1c
	fadd	st(0), st(0)
	fld1
	fsubp	st(1), st(0)
	fsqrt
	fstp	[@@L0]
	jmp	@@1

@@1b:	fstp	st(0)
@@1a:	fstp	st(0)
@@1:	call	@@3
	call	@@3
	fadd	st(0), st(0)
	fld1
	fsubr	st(2), st(0)
	fsub	st(1), st(0)
	fld	st(2)
	fmul	st(0), st(0)
	fld	st(2)
	fmul	st(0), st(0)
	faddp	st(1), st(0)
	fcompp
	fnstsw	ax
	sahf
	ja	@@1b
	fdivrp	st(1), st(0)
	fst	[@@L1]
	fmul	[@@L0]
	fadd	[@@P0]
	fld1
	fsubp	st(1), st(0)
	ftst
	fnstsw	ax
	sahf
	jbe	@@1a
	fld1
	fsubr	[@@P0]
	fldln2
	fld	st(2)
	fdiv	st(0), st(2)
	fyl2x
	fmulp	st(1), st(0)
	fld	[@@L1]
	fmul	[@@L0]
	fsubp	st(1), st
	push	-50
	ficom	dword ptr [esp]
	pop	edx
	fnstsw	ax
	sahf
	jb	@@1b
	call	@@3
	fldl2e
	fmul	st(0), st(2)
	call	@@5
	fld	[@@L1]
	fmul	st(0), st(0)
	fld1
	faddp	st(1), st(0)
	fmulp	st(1), st(0)
	fcompp
	fnstsw	ax
	fstp	st(0)
	sahf
	jb	@@1a
	jmp	@@9

@@1c:	fldl2e
	call	@@5	; 00467E98
	fadd	st(1), st(0)
	fdivrp	st(1), st(0)
	fstp	[@@L0]
@@2:	call	@@3
	fcomp	[@@L0]
	fnstsw	ax
	sahf
	jae	@@2a
	call	@@3
	fld1
	fdiv	[@@P0]
	call	@@4
	fld	st(0)
	fchs
	fldl2e
	fmulp	st(1), st(0)
	call	@@5
	jmp	@@2b

@@2a:	fldln2
	call	@@3
	fyl2x
	fld1
	fsubrp	st(1), st(0)
	fst	[@@L1]
	fld1
	fsubr	[@@P0]
	call	@@4
	fld	[@@L1]
	fxch	st(1)
@@2b:	call	@@3
	fcomp	st(1)
	fnstsw	ax
	fstp	st(0)
	fstp	st(0)
	sahf
	jae	@@2
@@9:	leave
	ret

	; __CIpow
@@4:	fxch	st(1)
	fyl2x
@@5:	fld	st(0)		; pow2
	frndint
	fsub	st(1), st(0)
	fxch	st(1)
	f2xm1
	fld1
	faddp	st(1), st(0)
	fscale
	fstp	st(1)
	ret

@@3:	imul	esi, 5D588B65h
	inc	esi
	mov	edx, esi
	mov	eax, esi
	shr	edx, 0Ch
	shl	eax, 14h
	add	edx, 3FF00000h
	push	edx
	push	eax
	fld1
	fsubr	qword ptr [esp]
	pop	eax
	pop	edx
	ret
ENDP	; @@5
	; "Yoshikun", "20011002"
@@T	db 'Crypt Type 20011002 - Copyright('
	db 'C) 2000 Y.Yamada/STUDIO '
	db 82h,0E6h,82h,0B5h,82h,0ADh,82h,0F1h
ENDP
