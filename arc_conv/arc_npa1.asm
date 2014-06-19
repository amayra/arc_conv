
; "ChaosHead", "Nekoda -Nyanda-", "Lamento -Beyond the Void-" *.npa

; 00401000 open
; 004018D0 read_filetab

; 00-3 'NPA'
; 03-4 1
; 07-4 name_crypt1
; 0B-4 name_crypt2
; 0F-1 pack_flag
; 10-1 crypt_flag
; 11-4 item_count
; 15-4 dir_count
; 19-4 file_count
; 1D-8 0
; 25-4 list_size

	dw 0
_arc_npa1 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@SC
@M0 @@L0
@M0 @@L1
@M0 @@L2
@M0 @@L3

	enter	@@stk+2Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 29h
	jc	@@9a
	pop	eax
	mov	edx, [esi+3]
	sub	eax, 141504Eh
	dec	edx
	or	eax, edx
	jne	@@9a
	mov	ecx, [esi+11h]
	mov	ebx, [esi+25h]
	mov	[@@N], ecx
	movzx	eax, byte ptr [esi+10h]
	mov	dl, [esi+0Fh]
	dec	eax
	mov	[@@L1], eax
	mov	byte ptr [@@L1+2], dl
	imul	eax, ecx, 15h
	dec	ecx
	shr	ecx, 14h
	jne	@@9a
	cmp	ebx, eax
	jb	@@9a
	lea	eax, [ebx+29h]
	mov	[@@SC], ebx
	mov	[@@P], eax
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9

	call	_ArcParam
	db 'npa1', 0
	xchg	ecx, eax
	push	1
	pop	eax
	jc	@@4c
	call	_npa1_select, ecx
	jc	@@9
@@4c:
	cmp	eax, 3		; lamento
	mov	[@@L3], eax
	mov	eax, [esi+7]
	mov	edx, [esi+0Bh]
	je	@@4a
	imul	eax, edx
	xor	edx, edx
@@4a:	add	eax, edx
	mov	[@@L0], eax

	mov	esi, [@@M]
	call	_npa1_crypt_names, 0, eax, [@@N], esi, ebx
	test	eax, eax
	je	@@9
	mov	[@@N], eax
	call	_ArcCount, eax
	call	_ArcDbgData, esi, ebx

	sub	esp, 100h
	call	_npa1_crypt_init, [@@L3], esp

@@1:	lodsd
	xchg	ebx, eax
	call	_ArcName, esi, ebx
	; 00401FC0
	mov	ecx, ebx
	mov	edx, 87654321h
	cmp	[@@L3], 8	; kikokugai, sonicomi
	jb	$+7
	mov	edx, 20101118h
	xor	eax, eax
@@1c:	lodsb
	sub	edx, eax
	dec	ecx
	jne	@@1c
	imul	edx, ebx
	mov	[@@L2], ebx
	mov	byte ptr [@@L1+1], dl
	lodsb
	cmp	al, 2
	jne	@@8
	mov	eax, [esi+4]
	mov	ebx, [esi+8]
	add	eax, [@@P]
	and	[@@D], 0
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	mov	ecx, [esi+0Ch]
	lea	eax, [@@D]
	cmp	byte ptr [@@L1+2], 0
	jne	$+4
	xor	ecx, ecx
	call	_ArcMemRead, eax, ecx, ebx, 0
	mov	edi, edx
	xchg	ebx, eax
	test	ebx, ebx
	je	@@1a
	mov	edx, [@@L1]
	mov	ecx, 1000h
	test	dl, dl
	jne	@@1e
	movzx	edx, dh
	cmp	[@@L3], 3	; lamento
	je	@@1b
	add	edx, [@@L0]
	add	ecx, [@@L2]
	imul	edx, [esi+0Ch]
	mov	dh, 1
@@1b:	mov	eax, esp
	push	esi
	xchg	esi, eax
	cmp	ecx, ebx
	jb	$+4
	mov	ecx, ebx
	xor	eax, eax
	push	edi
@@1d:	mov	al, [edi]
	mov	al, [esi+eax]
	sub	al, dl
	stosb
	add	dl, dh
	dec	ecx
	jne	@@1d
	pop	edi
	pop	esi
@@1e:	cmp	byte ptr [@@L1+2], 0
	je	@@1a
	call	_zlib_unpack, [@@D], dword ptr [esi+0Ch], edi, ebx
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
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
