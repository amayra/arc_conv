
@M2 macro
@M1 CreateDIBSection
@M1 CreateCompatibleDC
@M1 CreateFontIndirectW
@M1 SelectObject
@M1 DeleteObject
@M1 DeleteDC
@M1 SetBkMode
@M1 SetTextColor
@M1 PatBlt
@M1 TextOutW
@M1 GetTextExtentPoint32W
@M1 GdiFlush
endm

extrn	LoadLibraryA:PROC
extrn	GetProcAddress:PROC

	.data

_GDI32Tab	dd 6 dup(?)

	.code

@X = 0
@M1 macro p0
p0:
push @X
jmp _GDI32Call
@X=@X+1
endm
@M2
PURGE @M1

_GDI32Call PROC
@@0:	pop	eax
	mov	edx, offset _GDI32Tab
	mov	ecx, [edx+eax*4]
	test	ecx, ecx
	je	@@2
	jmp	ecx

@@2:	push	eax
	push	ebx
	push	esi
	push	edi
	mov	edi, edx
	call	@@4
	db 'GDI32.DLL', 0
@M1 macro p0
db '&p0', 0
endm
@M2
PURGE @M1,@M2
	db 0
@@4:	pop	esi
	call	LoadLibraryA, esi
	test	eax, eax
	je	@@9
	xchg	ebx, eax
@@1:	lodsb
	test	al, al
	jne	@@1
	cmp	byte ptr [esi], 0
	je	@@3
	call	GetProcAddress, ebx, esi
	test	eax, eax
	je	@@9
	stosd
	jmp	@@1
@@3:	pop	edi
	pop	esi
	pop	ebx
	jmp	@@0

@@9:	int	3
	jmp	@@9
ENDP
