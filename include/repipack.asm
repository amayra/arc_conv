
_repipack_table:
	dd 000500101h, 0F1F5A132h, 018512362h, 072FD5C32h	; 0x3B80CA64 "Episode of the Clovers Summer"
	dd 000500102h, 03F897F15h, 09F15655Fh, 018F2355Ah	; 0x3CFEEB6E "Episode of the Clovers Trial"
	dd 000500002h, 0389ABB57h, 0D107AF35h, 021F5ACCDh	; 0x3DFD6A86 "Episode of the Clovers Extra"
	dd 000500002h, 098FCDBA2h, 0837FC07Ah, 0F517AA26h	; 0x457C9132 "Episode of the Clovers"
	dd 000500003h, 0F497265Ch, 084F6BD90h, 0CAB563ABh	; 0x403CA76A "Quartett! Trial v1.1"
	dd 000500003h, 04056FA2Dh, 08D4322C0h, 033A1B798h	; 0x403EAE50 "Quartett! PUSH!! Trial"
	dd 000500003h, 0A4C16FD2h, 01E689A0Ch, 031F56B41h	; 0x40454BB5 "Quartett! Trial v1.2"
	dd 000200004h, 038F5CB86h, 0B76522ABh, 0F5FACF01h	; 0x40710AC8 "Quartett!"
	dd 000200005h, 035A321B3h, 0AF501792h, 0D75C9255h	; 0x42AC7DFC "Romanesque PUSH!! Trial"
								; 0x42AC7F3D "Romanesque TECH Trial"
								; 0x42B640B4 "Romanesque Trial"
	dd 000200005h, 037C1ADE2h, 07D59CAB4h, 0805F2CADh	; 0x432A912A "Romanesque Extra"
	dd 000200005h, 0DC5DAFFDh, 05D08BE67h, 033AF5162h	; 0x43D08E82 "FanDisk TECH Trial"
	dd 000200005h, 048D5FA21h, 03729FBB4h, 08C820F5Dh	; 0x44451BBF "FanDisk"
	dd 000200005h, 08B4E16D9h, 0361F8AA5h, 05C920F8Ah	; 0x45616A66 "Rondo Leaflet Trial"
	dd 000200005h, 0CE4985A0h, 08AF4622Eh, 01AF56CDBh	; 0x457EF20D "Rondo Leaflet Trial v2.0"
	dd 000200005h, 0AA58E9BDh, 07E5CB068h, 0502A2CF5h	; 0x45AAB9E9 "Rondo Leaflet"
	dd 000200005h, 038A4E237h, 0762089BDh, 0F5AB5BDCh	; 0x4637F155 "Screen Saver"
	dd 000200005h, 0FA871AB2h, 0DED5A4D1h, 08128CFA5h	; 0x475877E4 "Period"
	dd 000200005h, 077DF8518h, 0BD42D5EFh, 0F358ACE6h	; 0x484C69C8 "Romanesque Editio Perfecta"
	dd 000200005h, 0A54F18BFh, 0ED570357h, 04A2B81DCh	; 0x48CCC2A4 "Period Sweet Drops"
	dd 000200005h, 06B7AC18Dh, 01A4D8052h, 040578245h	; 0x49830202 "Seiken no Fairies Trial"
	dd 000200005h, 05B1E3078h, 06C84D7FBh, 0F17B254Ah	; 0x49BEAAD4 "Seiken no Fairies"
	dd 000200005h, 0501ABBCFh, 049D21831h, 0C6AFB354h	; 0x4AD5AA70 "Sugar Coat Freaks Trial"
	dd 000200005h, 0CC545B24h, 08305AFBEh, 0AE7106FBh	; 0x4B4AF099 "Sugar Coat Freaks"
	dd 000200005h, 0EF157364h, 07C0DB4A3h, 05A8FBCC2h	; 0x4F5A35C5 "Eiyuu*Senki Trial"
	dd 000200005h, 057CC4EC0h, 0DB3637A8h, 0FB4A25F1h	; 0x5321003D "Eiyuu*Senki GOLD"
	dd -1

_repipack_md5 PROC	; src, cnt, dest
	push	ebx
	push	esi
	push	edi
	enter	40h, 0
	mov	edi, [ebp+1Ch]
	mov	ebx, [ebp+18h]
	mov	esi, [ebp+14h]
	add	[edi+10h], ebx
	sub	ebx, 40h
	jb	@@2
@@1:	call	_md5_transform@8, edi, esi
	add	esi, 40h
	sub	ebx, 40h
	jae	@@1
@@2:	and	ebx, 3Fh
	mov	edi, esp
	mov	ecx, ebx
	mov	eax, ecx
	shr	ecx, 2
	and	eax, 3
	rep	movsd
	xchg	ecx, eax
	rep	movsb
	mov	ecx, ebx
	mov	al, 80h
	stosb
	xor	ecx, 3Fh
	xor	eax, eax
	mov	esi, [ebp+1Ch]
	cmp	ecx, 8
	jae	@@3
	mov	edx, ecx
	shr	ecx, 2
	and	edx, 3
	rep	stosd
	mov	ecx, edx
	rep	stosb
	call	_md5_transform@8, esi, esp
	xor	eax, eax
	mov	edi, esp
	lea	ecx, [eax+40h]
@@3:	sub	ecx, 8
	mov	edx, ecx
	shr	ecx, 2
	and	edx, 3
	rep	stosd
	mov	ecx, edx
	rep	stosb
	mov	eax, [esi+10h]
	shl	eax, 3
	stosd
	xchg	eax, ecx
	stosd
	call	_md5_transform@8, esi, esp
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP
