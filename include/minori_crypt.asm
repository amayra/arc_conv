
_minori_select PROC
	pop	eax
	push	offset @@T
	push	eax
	jmp	_string_select

@@T	db 'riddle',0, 'eden',0, 'eden_pm',0, 'ef_first_en',0, 0
ENDP

_minori_test PROC
	call	_unicode_name, dword ptr [esp+8]
	xchg	edx, eax

	cmp	dword ptr [esp+4], 3
	jne	@@1a
	movzx	eax, word ptr [edx]
	or	al, 20h
	cmp	eax, 'p'
	jne	@@1a
	movzx	eax, word ptr [edx+2]
	or	al, 20h
	cmp	eax, 'm'
	jne	@@1a
	add	edx, 4
@@1a:
	xor	ecx, ecx
	movzx	eax, word ptr [edx]
	or	al, 20h
	cmp	eax, 'm'
	jne	@@1c
	movzx	eax, word ptr [edx+2]
	or	al, 20h
	cmp	eax, 'o'
	jne	@@1c
	movzx	eax, word ptr [edx+4]
	or	al, 20h
	cmp	eax, 'v'
	jne	@@1c
	movzx	eax, word ptr [edx+6]
	cmp	eax, 2Eh
	je	@@1b
	sub	al, 30h
	cmp	eax, 0Ah
	jae	@@1c
@@1b:	inc	ecx
@@1c:
	push	edi
	mov	edi, edx
@@2:	movzx	eax, word ptr [edi]
	inc	edi
	inc	edi
	test	eax, eax
	je	@@2b
	cmp	eax, 2Eh
	je	@@2a
	sub	al, 30h
	cmp	eax, 0Ah
	jae	@@2
	xor	eax, eax
	inc	eax
	jmp	@@2b
@@2a:	xor	eax, eax
@@2b:	pop	edi

	xchg	eax, ecx
	ret	8
ENDP

_minori_crypt PROC

@@D = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]
@@Name = dword ptr [ebp+1Ch]
@@Size = dword ptr [ebp+20h]
@@Ext = dword ptr [ebp+24h]
@@Tab = dword ptr [ebp+28h]
@@Key = dword ptr [ebp+2Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	xor	ecx, ecx
	cmp	[@@Tab], 0
	jne	@@1a
	mov	eax, [@@Ext]
	inc	ecx
	cmp	eax, 'cs'
	je	@@1a
	inc	ecx
	cmp	eax, 'ggo'
	je	@@1a
	cmp	eax, 'fas'
	je	@@1a
	inc	ecx
	cmp	eax, 'gnp'
	jne	@@9
@@1a:	mov	edx, [@@Key]
	lea	ecx, [edx+ecx*8+3]
	mov	[@@Ext], ecx

	mov	edi, [@@Name]
	mov	esi, edi
	or	ecx, -1
	xor	eax, eax
	repne	scasb
	not	ecx
	dec	ecx
	lea	eax, [ecx+0Ah+8]
	and	al, -4
	push	0
	sub	esp, eax
	mov	edi, esp
	rep	movsb
	mov	[edi], cl
	call	_sjis_lower, esp

	mov	al, 20h
	stosb

	mov	eax, [@@Size]
	push	8
	pop	ecx
@@1b:	rol	eax, 4
	push	eax
	and	al, 0Fh
	add	al, -10
	sbb	ah, ah
	add	al, 3Ah
	and	ah, 27h-20h
	add	al, ah
	stosb
	dec	ecx
	pop	eax
	jne	@@1b
	mov	al, 20h
	stosb
	mov	esi, [@@Ext]
	movsd
	movsd
	mov	esi, esp
	sub	edi, esp

	mov	ebx, [@@Tab]
	test	ebx, ebx
	jne	@@4
	sub	esp, @arc4_size
	mov	ebx, esp
	call	_arc4_set_key@12, ebx, esi, edi
	call	_arc4_crypt@12, ebx, [@@D], [@@C]
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	1Ch

@@4:	mov	edi, 100h
	sub	esp, edi
	xor	edx, edx
@@4a:	xor	ecx, ecx
@@4b:	mov	al, [esi+ecx]
	inc	ecx
	test	al, al
	je	@@4a
	xor	al, [ebx+edx]
	mov	[esp+edx], al
	inc	dl
	jne	@@4b
	mov	esi, esp
	sub	esp, @arc4_size
	mov	ebx, esp
	call	_arc4_set_key@12, ebx, esi, edi
	shl	edi, 8
	call	_MemAlloc, edi
	jc	@@9
	xchg	esi, eax
	call	_arc4_crypt@12, ebx, esi, edi
	xor	ebx, ebx
	mov	edi, [@@D]
	mov	ecx, [@@C]
@@4c:	mov	al, [esi+ebx]
	xor	[edi], al
	inc	edi
	inc	bx
	dec	ecx
	jne	@@4c
	call	_MemFree, esi
	jmp	@@9
ENDP

_minori_table PROC
	pop	eax
	pop	ecx
	mov	edx, offset @@T
	push	eax
	movzx	eax, word ptr [edx+ecx*2]
	add	eax, edx
	ret

@@T:	dw @@X0-@@T
	dw @@X1-@@T
	dw @@X2-@@T
	dw @@X3-@@T
	dw @@X4-@@T

@@X0:	db 3,0,0, 0,0,0

; startup.sc 00000039 AOeicjid
; 30.ogg 002ED61B POJksI0a
; title\logo.png 00013C30 kaKMLi3_

@@X1:	db 23h,0,0, 'jaoim39m', 'AOeicjid', 'POJksI0a', 'kaKMLi3_'
	db 20h, 0Dh,'RiddleGarden',0, 0Bh
	include minori_RiddleGarden.inc

; test.sc 00000016 N426Fd94
; eden_kaze01.ogg 00080097 ol0lOrAf
; topmenu0.png 000D752E p37j344s

@@X2:	db 23h,0AAh,0, 'Uyiu4Ruy', 'N426Fd94', 'ol0lOrAf', 'p37j344s'
	db 20h, 0Ah,'eden_main',0, 0Ah
	include minori_EdenMain.inc

@@X3:	db 23h,0,0, 'Uyiu4Ruy', 'N426Fd94', 'ol0lOrAf', 'p37j344s'
	db 20h, 10h,'eden_PlusMosaic',0, 0Ah
	include minori_EdenPlus.inc

@@X4:	db 23h,0,0, 'n1hJKx3X', 'B3b09urx', '0tR6yq5P', '8xvC4k7J'
	db 20h, 0Ch,'ef_first_en',0, 0Ah
	include minori_EfFirstEn.inc
ENDP
