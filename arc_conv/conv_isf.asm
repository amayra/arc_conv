
; "Hitomi -My Stepsister-", "Private Nurse", "Come See Me Tonight 2", "Kango Shicyauzo 2" *.isf
; HITOMIML.EXE
; 0045F6B0 isf_decode

	dw _conv_isf-$-2
_arc_isf:
	ret
_conv_isf PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'fsi'
	jne	@@9
	call	@@3, esi, ebx	; eng
	xchg	ebx, eax
	mov	[@@SC], ebx
	; jap
	cmp	ebx, 6
	jb	@@8
	mov	edx, 'OTIH'
	movzx	eax, word ptr [esi+4]
	sub	edx, [esi]
	sub	eax, 'IM'
	or	eax, edx
	jne	@@2a
	add	esi, 6
	sub	ebx, 6
@@2a:	mov	ecx, ebx
	lea	edx, [esi+8]
	sub	ecx, 8
	jbe	@@8
	mov	eax, [esi+4]
	cmp	ax, 09795h
	jne	@@1b
@@1a:	ror	byte ptr [edx], 2
	inc	edx
	dec	ecx
	jne	@@1a
	jmp	@@7

@@1b:	cmp	ax, 0CE89h
	je	@@1c
	cmp	ax, 0D197h
	jne	@@8
	or	eax, -1
@@1c:	shr	eax, 10h
@@1d:	xor	[edx], al
	inc	edx
	dec	ecx
	jne	@@1d
@@7:	mov	dword ptr [esi+4], 0CE89h
@@8:	call	_ArcData, [@@SB], [@@SC]
	clc
	leave
	ret

@@9:	stc
	leave
	ret

@@3 PROC

@@S = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]

	push	ebx
	push	esi
	push	edi
	enter	10h, 0
	mov	ebx, [@@C]
	mov	edi, [@@S]
	sub	ebx, 10h
	jb	@@9
	push	4
	pop	ecx
	mov	esi, offset @@T
	add	edi, ebx
	repe	cmpsd
	jne	@@9
	mov	[@@C], ebx
	test	ebx, ebx
	je	@@9
	mov	edi, esp
	movsd
	movsd
	movsd
	movsd
	xor	ebx, ebx
	mov	edi, [@@S]

@@1:	mov	ecx, ebx
	mov	edx, 3FFh
	and	ecx, 0Fh
	and	edx, ebx
	movzx	eax, byte ptr [esp+ecx]
	add	al, [esi+edx]
	cmp	al, 24h
	jb	$+4
	sub	al, 24h
	mov	[esp+ecx], al
	mov	al, [esi+eax-44h]
	xor	[edi+ebx], al
	inc	ebx
	cmp	ebx, [@@C]
	jb	@@1
@@9:	mov	eax, [@@C]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

	db 'G5FXIL094MPRKWCJ3OEBVA7HQ2SU8Y6TZ1ND'
@@T	db 'SECRETFILTER100a'
dd 00F1A1513h, 019171022h, 0170C2213h, 005060E19h

dd 00613111Bh, 009140900h, 0211C0C1Ch, 00A200019h
dd 00E0F1421h, 00A222315h, 001030519h, 0100B1008h
dd 01A110A13h, 01E1B0B09h, 0040C1513h, 01E131D14h
dd 00B0F190Dh, 01702180Bh, 00E1D1022h, 0141A2201h
dd 01F041501h, 003111E1Fh, 00D112304h, 0110B1D06h
dd 0161F0B1Fh, 0080F0209h, 014210B01h, 01602021Dh
dd 004000921h, 011040308h, 0010E201Bh, 0060B2121h
dd 00E0F1517h, 01B200D1Eh, 012201206h, 006171B1Bh
dd 01F15160Ch, 008161B06h, 011040C07h, 001020514h
dd 00E081502h, 003021310h, 0081F1909h, 001021C00h
dd 0010D1A16h, 0081E0012h, 000071B05h, 0200C0B03h
dd 01D061119h, 018162200h, 00B180815h, 00515091Bh
dd 00F020223h, 017221E0Fh, 01D141F05h, 0170C171Dh
dd 0120D090Bh, 00C1C180Bh, 00C191C16h, 00E141F04h
dd 00019170Eh, 0190E011Eh, 01C180B0Dh, 022041701h
dd 01705091Ah, 01F1E060Dh, 023151304h, 012050015h
dd 01D070C23h, 01A0B1523h, 01F121608h, 00F1E1519h
dd 004080215h, 00D150D1Ch, 002210C16h, 01A040304h
dd 0220C0F0Ch, 00C060E22h, 01A09210Ah, 01E1D0111h
dd 0130F190Eh, 015040212h, 022010016h, 0090E121Fh
dd 005220903h, 00E1F1A1Dh, 01A072306h, 022141E02h
dd 015160D03h, 012000405h, 0020F0B13h, 020001B23h
dd 004020712h, 008090D05h, 01D230913h, 010220119h
dd 00E0C171Dh, 01A131B15h, 009130F13h, 006032009h
dd 01703161Fh, 003171815h, 02010021Bh, 011110B1Bh
dd 00D1E0A01h, 01D191B00h, 00A0B101Bh, 014020E04h
dd 015150003h, 01F1E081Eh, 0191F1F11h, 00C031223h
dd 0031F0B07h, 0041C1802h, 022132112h, 00B15160Eh
dd 0080D0E23h, 01B190A1Fh, 01D21061Ah, 020081C22h
dd 01D022114h, 006210F0Dh, 0200F1517h, 01D0C0A1Bh
dd 00B160218h, 0011E1401h, 003120408h, 01E0C0710h
dd 020210E17h, 0100E1910h, 0181E2002h, 022142201h
dd 0040D0512h, 014071F0Fh, 00B181E00h, 002071C0Ch
dd 00503050Fh, 0020A1B0Ch, 00008050Fh, 0160C110Bh
dd 01618201Fh, 01E091718h, 01B20100Fh, 0061B2207h
dd 014000113h, 00A07151Ch, 015021B03h, 00D0C0711h
dd 01E18061Ch, 01315220Dh, 02115091Dh, 00E221414h
dd 000010F19h, 0220D1717h, 01B07180Ah, 0100C0516h
dd 00E06021Fh, 0001D1A09h, 00A1D0215h, 00A052000h
dd 0170A2203h, 021082310h, 015210514h, 01E1B2210h
dd 0101A1E22h, 003030714h, 01A12021Dh, 00C0E1B12h
dd 022060C1Dh, 009210915h, 013072013h, 009151E0Fh
dd 0020C0C18h, 021160119h, 00B1C1407h, 00E080122h
dd 016191821h, 01C040B05h, 01E0C1A1Ah, 01A0C0B19h
dd 01F140820h, 01912151Dh, 005161C0Fh, 004141502h
dd 014211B19h, 0181D2119h, 0051B1021h, 01C0D1811h
dd 007170A1Eh, 0121B230Bh, 01B161514h, 00F1E0F12h
dd 003161B1Fh, 01D0F0021h, 014210E22h, 0021E1E0Bh
dd 00E151219h, 000021F10h, 00C15080Eh, 020151411h
dd 01610210Dh, 014060D12h, 01B15151Eh, 003210619h
dd 010232216h, 0221B1F1Dh, 013181903h, 02308190Bh
dd 0210E0303h, 0121F0D13h, 014031B20h, 01322031Fh
dd 0010D101Eh, 00007230Bh, 007141804h, 00E1E0A04h
dd 0150A2323h, 004190D12h, 01F231500h, 0160D130Ch
dd 022150A23h, 01311150Eh, 0201C211Bh, 0170A081Ch
dd 0121E0205h, 016171918h, 01915161Ah, 0160E1723h
dd 015211801h, 01A220803h, 0180F1622h, 0000F0022h
dd 0151F1703h, 004171311h, 009232301h, 020011209h
dd 01C1F0A18h, 012231E01h, 01E090904h, 0031C0914h
dd 0120D1C04h, 00F081208h, 01D091D0Ch, 015160D01h
dd 01C171213h, 00B1A0519h, 00C000803h, 0221D1502h
dd 01A1B0517h, 00E081F13h, 021191506h, 01F200C01h
dd 00C210314h, 017120708h, 0111C1115h, 00E0F1D16h
dd 01D1C1A1Bh, 0191B1414h, 000031013h, 01311181Ch
ENDP

ENDP