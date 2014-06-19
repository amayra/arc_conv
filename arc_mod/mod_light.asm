
_mod_light PROC

@@stk = 0
@M0 @@L1
@M0 @@S
@M0 @@D
@M0 @@L0

	push	ebp
	mov	ebp, esp
	dec	eax
	js	@@9a
	xchg	ebx, eax
	call	_string_select, offset @@strTab, dword ptr [ebp+0Ch]
	jc	@@9a
	dec	eax
	imul	eax, 1Ah
	lea	eax, [@@K+eax*8]
	push	eax	; @@L1

	dec	ebx
	jne	@@4a
	call	_FileCreate, dword ptr [ebp+10h], FILE_PATCH
	jc	@@9a
	push	eax
	push	-1
	jmp	@@4b

@@4a:	dec	ebx
	jne	@@9a
	call	_FileCreate, dword ptr [ebp+10h], FILE_INPUT
	jc	@@9a
	push	eax
	call	_FileCreate, dword ptr [ebp+14h], FILE_OUTPUT
	jc	@@9b
	push	eax
@@4b:	push	ecx	; @@L0

	mov	ebx, 0FFCh
	xor	ecx, ecx
	sub	esp, ebx
	push	ecx
	mov	edi, esp
	sub	esp, ebx
	push	ecx
	add	ebx, 4
	mov	edx, 000FFFFFFh
	mov	esi, offset @@T
	mov	[@@L0], edi
@@2a:	rol	edx, 8
@@2b:	xor	eax, eax
	lodsb
	imul	eax, 1010101h
	and	eax, edx
	stosd
	inc	cl
	jne	@@2b
	test	edx, edx
	js	@@2a

	mov	edi, esp
@@1:	call	_FileRead, [@@S], edi, ebx
	test	eax, eax
	je	@@9
	mov	esi, eax
	shr	eax, 4
	je	@@1a
	call	@@3, edi, eax, [@@L1], [@@L0]
@@1a:	mov	eax, [@@D]
	cmp	eax, -1
	jne	@@1b
	mov	eax, esi
	neg	eax
	call	_FileSeek, [@@S], eax, 1
	mov	eax, [@@S]
@@1b:	call	_FileWrite, eax, edi, esi
	cmp	esi, ebx
	je	@@1

@@9:	call	_FileClose, [@@D]
@@9b:	call	_FileClose, [@@S]
@@9a:	leave
	ret

@@strTab db 'dies_irae',0, 'donchan',0, 'grimmdc',0, 0

@@3 PROC

@@D = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]
@@K = dword ptr [ebp+1Ch]
@@L0 = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	xor	ebx, ebx
	mov	esi, [@@D]
@@1:	mov	ecx, ebx
	and	ecx, 0Fh
	add	ecx, 10h
	mov	eax, [esi]
	mov	edx, [esi+4]
	rol	eax, cl
	ror	edx, cl
	mov	[esi], eax
	mov	[esi+4], edx
	mov	eax, [esi+8]
	mov	edx, [esi+0Ch]
	rol	eax, cl
	ror	edx, cl
	mov	[esi+8], eax
	mov	[esi+0Ch], edx
	call	@@Dec, 3, esi, [@@K], [@@L0]
	inc	ebx
	add	esi, 10h
	cmp	ebx, [@@C]
	jb	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@Dec PROC

@@N = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@K = dword ptr [ebp+1Ch]
@@L0 = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@N]
	mov	ebx, [@@L0]
	shl	edi, 6
	mov	esi, [@@S]
	add	edi, [@@K]
	call	@@5
	mov	eax, [edi]
	mov	edx, [edi+4]
	xor	[esi], eax
	xor	[esi+4], edx
	mov	eax, [edi+8]
	mov	edx, [edi+0Ch]
	xor	[esi+8], eax
	xor	[esi+0Ch], edx
	sub	edi, 8
	jmp	@@2

@@1:	mov	eax, [esi]
	and	eax, [edi]
	rol	eax, 1
	mov	edx, [edi+4]
	xor	eax, [esi+4]
	or	edx, eax
	mov	[esi+4], eax
	xor	[esi], edx

	mov	eax, [esi+0Ch]
	or	eax, [edi-4]
	mov	edx, [edi-8]
	xor	eax, [esi+8]
	and	edx, eax
	rol	edx, 1
	mov	[esi+8], eax
	xor	[esi+0Ch], edx
	sub	edi, 10h
@@2:	push	3
	pop	ecx
@@3:	push	ecx
	call	@@4
	xor	[esi], eax
	xor	[esi+4], ecx
	call	@@4
	sub	esi, 10h
	xor	[esi], eax
	xor	[esi+4], ecx
	pop	ecx
	dec	ecx
	jne	@@3
	dec	dword ptr [esp+14h]	; @@N
	jne	@@1
	sub	edi, 8
	mov	eax, [esi+8]
	mov	edx, [esi]
	xor	eax, [edi]
	xor	edx, [edi+8]
	mov	[esi], eax
	mov	[esi+8], edx
	mov	eax, [esi+0Ch]
	mov	edx, [esi+4]
	xor	eax, [edi+4]
	xor	edx, [edi+0Ch]
	mov	[esi+4], eax
	mov	[esi+0Ch], edx
	call	@@5
	pop	ebp
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@4:	mov	ecx, [edi]
	xor	ecx, [esi]
	movzx	ebp, ch
	movzx	eax, cl
	shr	ecx, 10h
	mov	eax, [ebx+eax*4+400h]
	xor	eax, [ebx+ebp*4+800h]
	movzx	ebp, ch
	movzx	ecx, cl
	xor	eax, [ebx+ebp*4]
	xor	eax, [ebx+ecx*4+0C00h]
	mov	ecx, [edi+4]
	xor	ecx, [esi+4]
	movzx	ebp, ch
	movzx	edx, cl
	shr	ecx, 10h
	mov	edx, [ebx+edx*4]
	xor	edx, [ebx+ebp*4+400h]
	movzx	ebp, ch
	movzx	ecx, cl
	xor	edx, [ebx+ebp*4+0C00h]
	xor	edx, [ebx+ecx*4+800h]
	add	esi, 8
	mov	ecx, eax
	xor	eax, edx
	ror	ecx, 8
	sub	edi, 8
	xor	ecx, eax
	ret

@@5:	mov	eax, [esi]
	mov	edx, [esi+4]
	bswap	eax
	bswap	edx
	mov	[esi], eax
	mov	[esi+4], edx
	mov	eax, [esi+8]
	mov	edx, [esi+0Ch]
	bswap	eax
	bswap	edx
	mov	[esi+8], eax
	mov	[esi+0Ch], edx
	ret
ENDP

ENDP

@@K:

; "Dies irae"
; key 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
dd 000000000h, 000000000h, 000000000h, 000000000h
dd 016C976B6h, 06CEC462Fh, 0BA30F99Ah, 06E6CDE71h
dd 000000000h, 000000000h, 000000000h, 000000000h
dd 0BB5B3676h, 02317DD18h, 07CCD3736h, 06F388B64h
dd 09B3B118Bh, 0EE8C3E66h, 09B9B379Ch, 045B25DADh
dd 000000000h, 000000000h, 000000000h, 000000000h
dd 088C5F746h, 01F334DCDh, 000000000h, 000000000h
dd 0FBA30F99h, 0A6E6CDE7h, 0116C976Bh, 066CEC462h
dd 000000000h, 000000000h, 000000000h, 000000000h
dd 000000000h, 000000000h, 000000000h, 000000000h
dd 09B9B379Ch, 045B25DADh, 09B3B118Bh, 0EE8C3E66h
dd 000000000h, 000000000h, 000000000h, 000000000h
dd 06F388B64h, 0BB5B3676h, 02317DD18h, 07CCD3736h

; "Donchan ga Kyu"
; key 'qcGblQSEdXunaMiF'
dd 071634762h, 06C515345h, 06458756Eh, 0614D6946h
dd 036F4C19Ch, 05048EE0Ah, 040D49CBEh, 03E9914EEh
dd 0A3B13628h, 0A9A2B22Ch, 03AB730A6h, 0B4A338B1h
dd 060CE2824h, 07705206Ah, 04E5F1F4Ch, 08A771B7Ah
dd 014123B82h, 09035272Fh, 08FA6453Bh, 08DBD3067h
dd 02A68AC8Bh, 00EADCC29h, 0AD28CE2Ch, 068EC4D8Ah
dd 01DC1481Ah, 09397C7D3h, 067163476h, 026C51534h
dd 0A40D49CBh, 0E3E9914Eh, 0E36F4C19h, 0C5048EE0h
dd 00EADCC29h, 0AD28CE2Ch, 068EC4D8Ah, 02A68AC8Bh
dd 098535A51h, 09C58D1D8h, 09B1454D1h, 059161D5Bh
dd 08FA6453Bh, 08DBD3067h, 014123B82h, 09035272Fh
dd 0B4A338B1h, 0A3B13628h, 0A9A2B22Ch, 03AB730A6h
dd 08A771B7Ah, 060CE2824h, 07705206Ah, 04E5F1F4Ch

; grimmDC.exe 00410220
; "Zettai Meikyuu Grimm DC"
dd 0324A4556h, 07E66435Dh, 02C296B76h, 02D4C5D5Ah
dd 0435D501Bh, 085A90C12h, 0A237E277h, 0E4C49CF0h
dd 022AB3F33h, 021AE9614h, 0B5BB16A6h, 02EAD1925h
dd 0A80DC2D4h, 08609511Bh, 0F13BF262h, 04E7821AEh
dd 0E16A4304h, 0A88DF89Dh, 0F931273Ch, 010D75406h
dd 0C86BA585h, 02D6EC5A9h, 08BAB4649h, 048AACFCCh
dd 021825446h, 0FC4EFC98h, 0A324A455h, 067E66435h
dd 02A237E27h, 07E4C49CFh, 00435D501h, 0B85A90C1h
dd 02D6EC5A9h, 08BAB4649h, 048AACFCCh, 0C86BA585h
dd 08B531756h, 08C929155h, 09F9990D7h, 04B0A5ADDh
dd 0F931273Ch, 010D75406h, 0E16A4304h, 0A88DF89Dh
dd 02EAD1925h, 022AB3F33h, 021AE9614h, 0B5BB16A6h
dd 04E7821AEh, 0A80DC2D4h, 08609511Bh, 0F13BF262h

@@T:	; tab 0 1 3 2
dd 0EC2C8270h, 0E5C027B3h, 0355785E4h, 041AE0CEAh
dd 0936BEF23h, 021A51945h, 04E4F0EEDh, 0BD92651Dh
dd 08FAFB886h, 0CE1FEB7Ch, 05FDC303Eh, 01A0BC55Eh
dd 0CA39E1A6h, 03D5D47D5h, 0D65A01D9h, 04D6C5651h
dd 0669A0D8Bh, 02DB0CCFBh, 0202B1274h, 09984B1F0h
dd 0C2CB4CDFh, 005767E34h, 031A9B76Dh, 0D70417D1h
dd 0613A5814h, 01C111BDEh, 0169C0F32h, 022F21853h
dd 0B2CF44FEh, 0917AB5C3h, 0A8E80824h, 05069FC60h
dd 07DA0D0AAh, 0976289A1h, 0951E5B54h, 0D264FFE0h
dd 04800C410h, 0DB75F7A3h, 0DAE6038Ah, 094DD3F09h
dd 002835C87h, 033904ACDh, 0F3F66773h, 0E2BF7F9Dh
dd 026D89B52h, 03BC637C8h, 04B6F9681h, 02E63BE13h
dd 08CA779E9h, 08EBC6E9Fh, 0B6F9F529h, 059B4FD2Fh
dd 06A069878h, 0BA7146E7h, 042AB25D4h, 0FA8DA288h
dd 055B90772h, 00AACEEF8h, 0682A4936h, 0A4F1383Ch
dd 07BD32840h, 0C143C9BBh, 0F4ADE315h, 09E80C777h

dd 0C0B32C70h, 0AEEA57E4h, 0A5456B23h, 0921D4FEDh
dd 01F7CAF86h, 00B5EDC3Eh, 05DD539A6h, 06C515AD9h
dd 0B0FB9A8Bh, 084F02B74h, 07634CBDFh, 004D1A96Dh
dd 011DE3A14h, 0F2539C32h, 07AC3CFFEh, 06960E824h
dd 062A1A0AAh, 064E01E54h, 075A30010h, 0DD09E68Ah
dd 090CD8387h, 0BF9DF673h, 0C6C8D852h, 063136F81h
dd 0BC9FA7E9h, 0B42FF929h, 071E70678h, 08D88ABD4h
dd 0ACF8B972h, 0F13C2A36h, 043BBD340h, 08077AD15h
dd 0E527EC82h, 0410C3585h, 0211993EFh, 0BD654E0Eh
dd 0CEEB8FB8h, 01AC55F30h, 03D47CAE1h, 04D56D601h
dd 02DCC660Dh, 099B12012h, 0057EC24Ch, 0D71731B7h
dd 01C1B6158h, 02218160Fh, 091B5B244h, 050FCA808h
dd 097897DD0h, 0D2FF955Bh, 0DBF748C4h, 0943FDA03h
dd 0334A025Ch, 0E27FF367h, 03B37269Bh, 02EBE4B96h
dd 08E6E8C79h, 059FDB6F5h, 0BA466A98h, 0FAA24225h
dd 00AEE5507h, 0A4386849h, 0C1C97B28h, 09EC7F4E3h

dd 076164138h, 0F26093D9h, 09AABC272h, 0A0570675h
dd 0C9B5F791h, 090D28CA2h, 027A707F6h, 0DE49B28Eh
dd 0C7D75C43h, 0678FF53Eh, 0AF6E181Fh, 00D85E22Fh
dd 0659CF053h, 09EAEA3EAh, 06B2D80ECh, 0A6362BA8h
dd 0334D86C5h, 0965866FDh, 01095093Ah, 0CC42D878h
dd 061E526EFh, 0823B3F1Ah, 098D4DBB6h, 0EB028BE8h
dd 0B01D2C0Ah, 00E888D6Fh, 00B4E8719h, 011790CA9h
dd 059E7227Fh, 0C83DDAE1h, 054740412h, 028B47E30h
dd 0BE506855h, 0CB31C4D0h, 0CA0FAD2Ah, 06932FF70h
dd 024006208h, 0EDBAFBD1h, 06D738145h, 04AEE9F84h
dd 001C12EC3h, 0994825E6h, 0F97BB3B9h, 071DFBFCEh
dd 0136CCD29h, 09D639B64h, 0A5B74BC0h, 017B15F89h
dd 046D3BCF4h, 0475E37CFh, 05BFCFA94h, 0AC5AFE97h
dd 035034C3Ch, 05DB823F3h, 021D5926Ah, 07DC65144h
dd 0AADC8339h, 00556777Ch, 03415A41Bh, 052F81C1Eh
dd 0BDE91420h, 0E0A1E4DDh, 07AD6F18Ah, 04F40E3BBh

dd 0D95805E0h, 0CB814E67h, 06AAE0BC9h, 0825D18D5h
dd 027D6DF46h, 0424B328Ah, 09C9E1CDBh, 07B25CA3Ah
dd 01F5F710Dh, 09D3ED7F8h, 0BEB9607Ch, 034168BBCh
dd 09572C34Dh, 07ABA8EABh, 0ADB402B3h, 09AD8ACA2h
dd 0CC351A17h, 05A6199F7h, 0405624E8h, 0330963E1h
dd 0859798BFh, 00AECFC68h, 062536FDAh, 0AF082EA3h
dd 0C274B028h, 0382236BDh, 02C391E64h, 044E530A6h
dd 0659F88FDh, 023F46B87h, 051D11048h, 0A0D2F9C0h
dd 0FA41A155h, 02FC41343h, 02B3CB6A8h, 0A5C8FFC1h
dd 090008920h, 0B7EAEF47h, 0B5CD0615h, 029BB7E12h
dd 00407B80Fh, 06621949Bh, 0E7EDCEE6h, 0C57FFE3Bh
dd 04CB137A4h, 0768D6E91h, 096DE2D03h, 05CC67D26h
dd 0194FF2D3h, 01D79DC3Fh, 06DF3EB52h, 0B269FB5Eh
dd 0D40C31F0h, 075E28CCFh, 084574AA9h, 0F51B4511h
dd 0AA730EE4h, 01459DDF1h, 0D054926Ch, 049E37078h
dd 0F6A75080h, 083869377h, 0E95BC72Ah, 03D018FEEh

ENDP
