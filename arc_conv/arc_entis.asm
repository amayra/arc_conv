
; "Tsubasa wo Kudasai", "Kura no Naka wa Kiken ga Ippai!?" *.noa

; fwing.exe
; 0053E990 entis_decode

	dw 0
_arc_entis PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@SC
@M0 @@L0, 10h
@M0 @@L1

	enter	@@stk+54h, 0
	mov	edi, esp
	call	_FileRead, [@@S], edi, 54h
	jc	@@9a
	xor	eax, eax
	mov	esi, offset @@sign
	lea	ecx, [eax+9]
	repe	cmpsd
	jne	@@9a
	lea	ecx, [eax+5]
	repe	scasd
	jne	@@9a
	lea	ecx, [eax+2]
	add	edi, 8
	repe	cmpsd
	jne	@@9a
	mov	esi, edi
	lodsd
	xchg	ebx, eax
	lodsd
	test	eax, eax
	jne	@@9a
	sub	ebx, 4
	jb	@@9a
	lodsd
	lea	ecx, [eax-1]
	shr	ecx, 14h
	jne	@@9a
	push	40h
	pop	[@@P]
	mov	[@@SC], ebx
	mov	[@@N], eax
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

	call	_ArcParamNum, 0
	db 'entis', 0
	cmp	eax, 5
	sbb	edx, edx
	and	eax, edx
	mov	[@@L1], eax

@@1:	sub	[@@SC], 28h
	jb	@@9
	mov	ecx, [esi+24h]
	lea	edx, [esi+28h]
	sub	[@@SC], ecx
	jb	@@9
	call	_ArcName, edx, ecx
	and	[@@D], 0
	mov	eax, [esi+14h]
	or	eax, [esi+4]
	jne	@@1a
	mov	eax, [esi+10h]
	add	eax, [@@P]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	edx, [@@L0]
	call	_FileRead, [@@S], edx, 10h
	mov	edx, 'atad'
	mov	eax, [@@L0]
	sub	edx, [@@L0+4]
	sub	eax, 'elif'
	or	eax, edx
	jne	@@1a
	mov	ebx, [@@L0+8]
	cmp	[@@L0+0Ch], 0
	jne	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	test	byte ptr [esi+0Fh], 40h
	je	@@1a
	mov	ecx, [@@L1]
	test	ecx, ecx
	je	@@1a
	call	@@3, [@@D], ebx
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	mov	ecx, [esi+24h]
	lea	esi, [esi+28h+ecx]
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3 PROC
	call	@@1

	; "Tsubasa wo Kudasai"
	; graphics02.noa
	db 4Bh	
	db '2o3bZEwqb9JMfkU4CYv2BaAD2sSdyUxtiAR4IQWG8UP6EmWkN0JcA9nmV6MAHH3AspaGBUqib3i'
	; scenario.noa
	db 4Bh
	db '0XT9ORIT0WlIl7U16yjKxTCyUOYZoN1cL7FxrBTiuvi0EY50b7Pu8uvLVlX0opOU5ash97Bkkqq'

	; "Kura no Naka wa Kiken ga Ippai!?"
	; data1.noa
	db 20h
	dd 029283876h,066444139h,071656E68h,0F1C9911Bh
	dd 0D894531Ah,07914A63Eh,0B37B05EAh,07E3D04DBh
	; data3.noa
	db 20h
	dd 077626876h,053414438h,056367231h,038666671h
	dd 05BF9911Bh,08F4E0AD2h,0BB8513E2h,04EE88211h

	db 0

@@1:	pop	edx
	xor	eax, eax
@@2:	add	edx, eax
	movzx	eax, byte ptr [edx]
	inc	edx
	test	eax, eax
	je	@@9
	dec	ecx
	jne	@@2
	pop	ecx
	push	eax
	push	edx
	push	0
	push	ecx
	jmp	@@Decode

@@9:	ret	8

@@Decode PROC

@@I = dword ptr [ebp+14h]
@@K = dword ptr [ebp+18h]
@@N = dword ptr [ebp+1Ch]

@@SB = dword ptr [ebp+20h]
@@SC = dword ptr [ebp+24h]

@@M = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]
@@L0 = dword ptr [ebp-28h]

	push	ebx
	push	esi
	push	edi
	enter	28h, 0

	mov	ecx, [@@SC]
	mov	eax, [@@N]
	shr	ecx, 5
	je	@@9
	shl	eax, 8
	mov	[@@SC], ecx
	call	_MemAlloc, eax
	jc	@@9
	mov	[@@M], eax
	xchg	edi, eax
	xor	esi, esi
@@2:	push	edi
	xor	eax, eax
	lea	edi, [@@L0]
	lea	ecx, [eax+8]
	rep	stosd
	pop	edi
	xor	ebx, ebx
	mov	[@@L1], esi
@@1:	mov	edx, [@@K]
	add	bl, [edx+esi]
	inc	esi
	cmp	esi, [@@N]
	sbb	edx, edx
	and	esi, edx

	mov	eax, ebx
	mov	ecx, ebx
	shr	eax, 3
	mov	dl, 80h
	and	ecx, 7
	shr	dl, cl
	jmp	@@1b

@@1a:	inc	eax
	add	bl, 8
	and	eax, 1Fh
@@1b:	cmp	byte ptr [esp+eax], 0FFh
	je	@@1a
	jmp	@@1d

@@1c:	mov	ecx, edx
	ror	dl, 1
	and	ecx, 1
	lea	eax, [eax+ecx*2]
	lea	ebx, [ebx+ecx*8+1]
	and	eax, 1Fh
	movzx	ebx, bl
@@1d:	test	[esp+eax], dl
	jne	@@1c
	or	[esp+eax], dl
	shl	eax, 3
@@1e:	inc	eax
	shr	dl, 1
	jne	@@1e
	dec	eax
	stosb
	inc	byte ptr [@@L1+3]
	jne	@@1
	mov	esi, [@@L1]
	inc	esi
	cmp	esi, [@@N]
	jb	@@2

	mov	edi, [@@SB]
@@3:	mov	eax, [@@I]
	mov	esi, eax
	inc	eax
	cmp	eax, [@@N]
	sbb	edx, edx
	shl	esi, 8
	and	eax, edx
	add	esi, [@@M]
	mov	[@@I], eax

	push	edi
	xor	eax, eax
	lea	edi, [@@L0]
	lea	ecx, [eax+8]
	rep	stosd
	pop	edi
@@3a:	mov	edx, [edi+ecx*4]
	inc	ecx
	bswap	edx
	stc
	adc	edx, edx
@@3b:	jnc	@@3c
	movzx	eax, byte ptr [esi]
	mov	ebx, eax
	shr	eax, 5
	and	ebx, 1Fh
	bts	dword ptr [esp+eax*4], ebx
@@3c:	inc	esi
	add	edx, edx
	jne	@@3b
	cmp	ecx, 8
	jb	@@3a
	mov	esi, esp
	rep	movsd
	dec	[@@SC]
	jne	@@3

	call	_MemFree, [@@M]
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h
ENDP

ENDP	; @@3

@@sign	db 'Entis',1Ah,0,0, 0,4,0,2, 0,0,0,0
	db 'ERISA-Archive file',0,0
	db 'DirEntry'
ENDP
