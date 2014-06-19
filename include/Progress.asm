extrn	CreateThread:PROC
extrn	CloseHandle:PROC
extrn	WaitForSingleObject:PROC
extrn	Sleep:PROC

extrn	DialogBoxIndirectParamA:PROC
extrn	EndDialog:PROC
extrn	GetDlgItem:PROC
extrn	SendMessageA:PROC
extrn	PostMessageA:PROC
extrn	SetTimer:PROC

extrn	GetAsyncKeyState:PROC
extrn	IsDebuggerPresent:PROC
extrn	_wsprintfA:PROC

	.data?

ALIGN 4
ProgressData	dd 4+10 dup(?)	; flags, thread, window, static

	.code

_ProgressStart PROC
	call	IsDebuggerPresent
	test	eax, eax
	jne	@@8
	call	_ProgressEnter
	mov	dword ptr [ecx+10h], offset _ProgressDefText
	mov	eax, [ecx+8]
	mov	edx, [esp+4]
	test	eax, eax
	jne	@@4
	and	dword ptr [ecx], 41h
	push	ecx
	push	ecx
	call	CreateThread, eax, eax, offset @@1, edx, eax, esp
	pop	ecx
	pop	ecx
	test	eax, eax
	mov	[ecx+4], eax
	je	@@7
	call	_ProgressEnter
	cmp	dword ptr [ecx+8], 0
	jne	@@7
	call	_ProgressEnd+5
@@8:	xor	eax, eax
	ret	4

@@4:	push	ecx
	call	SendMessageA, eax, WM_SETTEXT, 0, edx
	pop	ecx
@@7:	mov	eax, [ecx+8]
	lock
	btr	dword ptr [ecx], 0
	ret	4

@@1:	call	DialogBoxIndirectParamA, ExeBase, \
		offset @@5, 0, offset _ProgressDlgProc, dword ptr [esp+4]
	cmp	eax, -1
	jne	@@3
	mov	ecx, offset ProgressData
	lock
	btr	dword ptr [ecx], 0
@@3:	xor	eax, eax
	ret	4

ALIGN 4
@@5:
dd 090C008C4h, 000000000h, 000000001h, 000800000h
dd 000000028h, 000000000h, 0004D0008h, 000200053h
dd 000680053h, 0006C0065h, 00020006Ch, 0006C0044h
dd 000000067h, 050020081h, 000000000h, 0000C0004h
dd 000100078h, 0FFFF0040h, 000000082h, 000000000h

_ProgressDefText db 'Please wait...', 0

@@2:	call	Sleep, 0
_ProgressEnter:
	mov	ecx, offset ProgressData
	lock
	bts	dword ptr [ecx], 0
	jc	@@2
	ret
ENDP

_ProgressEnd PROC
	call	_ProgressEnter
	xor	eax, eax
	xor	edx, edx
	xchg	[ecx+8], eax
	xchg	[ecx+4], edx
	bts	dword ptr [ecx], 15
	lock
	btr	dword ptr [ecx], 0
	test	edx, edx
	je	@@2
	push	edx
	push	-1
	push	edx
	test	eax, eax
	je	@@1
	call	SendMessageA, eax, WM_CLOSE, 0, 0
@@1:	call	WaitForSingleObject
	call	CloseHandle
@@2:	ret
ENDP

_ProgressWndProc PROC

@@hwnd = dword ptr [ebp+8]
@@wmsg = dword ptr [ebp+12]
@@wparam = dword ptr [ebp+16]
@@lparam = dword ptr [ebp+20]

@@wm_initdialog:
	call	SendMessageA, [@@hwnd], WM_SETTEXT, 0, [@@lparam]
	call	GetDlgItem, [@@hwnd], 40h
	mov	edx, [@@hwnd]
	mov	ecx, offset ProgressData
	mov	[ecx+8], edx
	mov	[ecx+0Ch], eax
	lock
	btr	dword ptr [ecx], 0

	call	SendMessageA, eax, WM_SETTEXT, 0, offset _ProgressDefText
	call	SetTimer, [@@hwnd], 1, 125, 0
	jmp	@@finish

_ProgressDlgProc:
	push	ebp
	mov	ebp, esp
	mov	eax, [@@wmsg]
	sub	eax, 7
	je	@@8		; 0x007 WM_SETFOCUS
	dec	eax
	je	@@8		; 0x008 WM_KILLFOCUS
	cmp	eax, 8
	je	@@wm_close	; 0x010 WM_CLOSE
	sub	eax, 0F8h
	je	@@wm_keydown	; 0x100 WM_KEYDOWN
	cmp	eax, 10h
	je	@@wm_initdialog	; 0x110 WM_INITDIALOG
	cmp	eax, 13h
	je	@@wm_timer	; 0x113 WM_TIMER
@@finish:
	xor	eax, eax
	pop	ebp
	ret	10h

@@8:	inc	eax
	pop	ebp
	ret	10h

@@wm_close:
	or	byte ptr [ProgressData+1], 1
	jns	@@finish
	call	EndDialog, [@@hwnd], 0
	jmp	@@finish

@@wm_keydown:
	cmp	[@@wparam], 'C'
	jne	@@wm_keydown_1
	test	byte ptr [@@lparam+3], 40h
	jne	@@wm_keydown_1
	call	GetAsyncKeyState, 11h	; VK_CONTROL
	shr	eax, 31
	or	byte ptr [ProgressData+1], al
@@wm_keydown_1:
	jmp	@@finish

@@wm_timer:
	call	_ProgressEnter
	btr	dword ptr [ecx], 1
	jnc	@@5
	mov	edx, [ecx+10h]
	push	edx
@@1:	mov	al, [edx]
	cmp	al, '%'
	je	@@2
	inc	edx
	test	al, al
	jne	@@1
	pop	edx
@@3:	mov	ecx, offset ProgressData
	push	ecx
	call	SendMessageA, dword ptr [ecx+0Ch], WM_SETTEXT, 0, edx
	pop	ecx
@@5:	lock
	btr	dword ptr [ecx], 0
	xor	eax, eax
	leave
	ret	10h

@@2:	pop	eax
	cmp	eax, edx
	jne	@@2a
	cmp	byte ptr [edx+1], 's'
	jne	@@2a
	cmp	byte ptr [edx+2], 0
	jne	@@2a
	mov	edx, [ecx+14h]
	jmp	@@3

@@2a:	sub	esp, 400h
	mov	edx, esp
	push	dword ptr [ecx+34h]
	push	dword ptr [ecx+30h]
	push	dword ptr [ecx+2Ch]
	push	dword ptr [ecx+28h]
	push	dword ptr [ecx+24h]
	push	dword ptr [ecx+20h]
	push	dword ptr [ecx+1Ch]
	push	dword ptr [ecx+18h]
	push	dword ptr [ecx+14h]
	call	_wsprintfA, edx, eax
	add	esp, 4+10*4
	mov	edx, esp
	jmp	@@3
ENDP

_ProgressUpdate PROC
	call	_ProgressEnter
	mov	edx, [esp+4]
	mov	eax, [esp+8]
	test	edx, edx
	jle	@@2
	cmp	edx, 0Ah
	jae	@@9
	or	byte ptr [ecx], 2
	mov	[ecx+10h+edx*4], eax
	jmp	@@9

@@2:	inc	edx
	je	@@2a
	inc	edx
	je	@@2b
	test	eax, eax
	jne	@@1
	mov	eax, offset _ProgressDefText
@@1:	or	byte ptr [ecx], 2
	mov	[ecx+10h], eax
	mov	eax, [ecx+8]
	test	eax, eax
	je	@@9
	push	ecx
	call	PostMessageA, eax, WM_TIMER, 0, 0
	pop	ecx
@@9:	lock
	btr	dword ptr [ecx], 0
	ret	8

@@2a:	mov	[ecx+14h], eax
	mov	eax, offset @@6
	jmp	@@1

@@2b:	and	dword ptr [ecx+14h], 0
	mov	dword ptr [ecx+18h], eax
	mov	eax, offset @@7
	jmp	@@1

@@6	db '%s', 0
@@7	db '%i/%i', 0
ENDP

_ProgressBreak PROC
	btr	[ProgressData], 8
	sbb	eax, eax
	neg	eax
	ret
ENDP
