
; "Tenkuu no Symphonia", "Tenkuu no Symphonia 2" *.pak
; sinfonia.exe
; 00404E63 open_archive
; 00403E94 expand
; 00401FE0 file_decrypt
; 0049F8AB get_key
; 00405449 read_file1
; 0040573A read_file2

; "Advanced Game Script Interpreter"

	dw 0
_arc_agsi PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 8
@M0 @@P
@M0 @@L1, 8

	enter	@@stk+10h, 0
	mov	edi, esp
	call	_FileRead, [@@S], edi, 0Ch
	jc	@@9a
	and	[@@L0+4], 0
	cmp	dword ptr [edi], 'KCAP'
	je	@@2b
	dec	[@@L0+4]
	call	_FileSeek, [@@S], -9, 2
	jc	@@9a
	lea	edx, [edi+0Ch]
	call	_FileRead, [@@S], edx, 4
	jc	@@9a
	call	_FileSeek, [@@S], 0Ch, 0
	jc	@@9a
	push	0Ch
	pop	ebx
	mov	cl, [edi+0Fh]
	mov	dl, [edi+0Ch]
	and	ecx, 7
	jne	$+3
	inc	ecx
@@2a:	mov	al, [edi]
	rol	al, cl
	xor	al, dl
	inc	dl
	stosb
	dec	ebx
	jne	@@2a
@@2b:	mov	esi, esp
	cmp	dword ptr [esi], 'KCAP'
	jne	@@9a
	mov	ebx, [esi+4]
	mov	edi, [esi+8]
	lea	ecx, [ebx-1]
	lea	eax, [edi-10h]
	mov	[@@N], ebx
	shr	eax, 9
	shr	ecx, 14h
	or	eax, ecx
	jne	@@9a
	mov	[@@L0], edi
	imul	ebx, edi
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0Ch, ebx, 0
	jc	@@9
	mov	edi, [@@M]
	movsd
	movsd
	movsd
	lea	ecx, [ebx+0Ch]
	lea	esi, [edi-0Ch]
	mov	[@@P], ecx

	cmp	[@@L0+4], 0
	je	@@2c
	call	@@5, edi, ebx
	call	_ArcDbgData, esi, [@@P]

	call	@@4
	mov	[@@L0+4], eax
	test	eax, eax
	je	@@2c
	add	esp, -80h
	mov	[@@L1+4], esp
	call	_des_set_key@8, [@@L1+4], edx
	sub	esp, 800h
	mov	[@@L1], esp
	call	_des_init@4, esp

@@2c:	call	_ArcCount, [@@N]
	add	esi, 0Ch

@@1:	mov	ecx, [@@L0]
	lea	edx, [esi+10h]
	sub	ecx, 10h
	call	_ArcName, edx, ecx
	and	[@@D], 0
	mov	eax, [esi+0Ch]
	mov	ebx, [esi+4]
	add	eax, [@@P]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	mov	eax, [esi+8]
	cmp	eax, 6
	je	@@1b
	sub	eax, 3
	cmp	eax, 5
	jae	@@1b
	; 3,4,5,7
	cmp	[@@L0+4], 0
	je	@@1a
	call	@@3
@@1b:	; 2,5 - expand; 6,7 - lzss
	mov	eax, [esi+8]
	sub	eax, 6
	shr	eax, 1
	jne	@@1a
	mov	edi, [esi]
	call	_MemAlloc, edi
	jc	@@1a
	mov	edx, [@@D]
	mov	[@@D], eax
	push	edx
	call	_lzss_unpack, eax, edi, edx, ebx
	xchg	ebx, eax
	call	_MemFree
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, [@@L0]
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	mov	edi, [@@D]
	push	esi
	mov	esi, 408h
	cmp	ebx, esi
	jae	@@3c
	mov	esi, ebx
	test	bl, 7
	jne	@@3b
@@3c:	shr	esi, 3
	je	@@3b
@@3a:	mov	eax, [edi]
	mov	edx, [edi+4]
	call	_des_crypt@8, [@@L1], [@@L1+4]
	mov	[edi], eax
	mov	[edi+4], edx
	add	edi, 8
	dec	esi
	jne	@@3a
	mov	ecx, ebx
	sub	ecx, 408h
	jb	@@3b
	mov	esi, edi
	sub	edi, 8
	sub	ebx, 8
	rep	movsb
@@3b:	pop	esi
	ret

@@5 PROC

@@S = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]

	push	ebx
	push	esi
	push	edi
	enter	270h*4, 0
	mov	eax, 1D64h
	call	_twister_init
	mov	esi, [@@S]
@@1:	call	_twister_next
	mov	ecx, eax
	and	ecx, 7
	jne	$+3
	inc	ecx
	mov	dl, [esi]
	rol	dl, cl
	xor	al, dl
	mov	[esi], al
	inc	esi
	dec	[@@C]
	jne	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

@@4:	call	_unicode_name, offset inFileName
	push	eax
	call	@@4b

	; sinfonia
	db 'bg.pak', 0
	db 'bgm.pak', 0
	db 'bust.pak', 0
	db 'chipbattle_0.pak', 0
	db 'chipbattle_1.pak', 0
	db 'chipbattle_2.pak', 0
	db 'chipbattle_3.pak', 0
	db 'chipbattle_4.pak', 0
	db 'chiptraining_0.pak', 0
	db 'chiptraining_1.pak', 0
	db 'chiptraining_2.pak', 0
	db 'chiptraining_3.pak', 0
	db 'chiptraining_4.pak', 0
	db 'data.pak', 0
	db 'event_0.pak', 0
	db 'event_1.pak', 0
	db 'event_2.pak', 0
	db 'event_3.pak', 0
	db 'event_4.pak', 0
	db 'framemain.pak', 0
	db 'frametitleextra.pak', 0
	db 'magiceffect.pak', 0
	db 'se.pak', 0
	db 'voice.pak', 0

	; sinfonia2
	db 'data00.pak', 0
	db 'data01.pak', 0
	db 0

@@4b:	call	_filename_select
	call	@@4d

dd 0C821CD65h, 032BE7DC0h, 0C7676D70h, 0C4326D41h
dd 0D3363E57h, 047B34A31h, 03CD045B5h, 0B27DB1C5h
dd 0CE64D1B9h, 043B4B478h, 06733B967h, 03E706F5Ah
dd 0D2D06BC6h, 0BE534058h, 072B866B9h, 0635A7724h
dd 0486736CDh, 0CA436731h, 06B4B3E54h, 06DB336C4h
dd 0724B7830h, 034BECC6Eh, 051B4C644h, 0C2B84FB2h
dd 058566A61h, 06F3D662Dh, 0D16A32CDh, 0BEB9723Dh
dd 03C774FCDh, 0B7BBBE64h, 061C4BAC7h, 056CBCA63h
dd 032407126h, 0C5B87964h, 0BD3D46C1h, 0633DC1BAh
dd 038433755h, 0CF32C347h, 06A2D3D65h, 0497664B6h
dd 0554664D1h, 0D34C7034h, 0BD767B37h, 048742149h
dd 0CA484F75h, 032CA4B3Eh, 04740634Fh, 053744157h

dd 0324965BAh, 0D172CA73h, 02A704F30h, 05AB349B1h

@@4d:	pop	edx
	lea	edx, [edx+eax*8-8]
	ret
ENDP
