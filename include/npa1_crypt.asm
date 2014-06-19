
_npa1_select PROC
	pop	eax
	call	@@1

	db 'chaos',0, 'nekoda',0, 'lamento',0
	db 'django',0, 'muramasa',0, 'sweetpool',0
	db 'demonbane',0, 'kikokugai',0, 'sonicomi',0
	db 'gclx', 0, 'dmmd', 0, 'phenomeno', 0
	db 0

@@1:	push	eax
	jmp	_string_select
ENDP

_npa1_crypt_names PROC

@@L0 = dword ptr [ebp+14h]
@@L1 = dword ptr [ebp+18h]

@@N = dword ptr [ebp+1Ch]
@@S = dword ptr [ebp+20h]
@@C = dword ptr [ebp+24h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	eax, [@@L1]
	mov	esi, [@@S]
	mov	edx, eax
	shr	eax, 10h
	mov	ebx, [@@C]
	add	al, ah
	add	al, dl
	add	al, dh
	mov	[@@L1], eax

	xor	edx, edx
@@1:	sub	ebx, 15h
	jb	@@9
	lodsd
	sub	ebx, eax
	jb	@@9
	test	eax, eax
	je	@@9
	xchg	ecx, eax
	mov	eax, edx
	shr	eax, 10h
	add	al, ah
	add	al, dl
	add	al, dh
	add	eax, [@@L1]
	cmp	[@@L0], 0
	jne	@@3
@@2:	sub	[esi], al
	inc	esi
	add	eax, 4
	dec	ecx
	jne	@@2
	jmp	@@4

@@3:	add	[esi], al
	inc	esi
	add	eax, 4
	dec	ecx
	jne	@@3
@@4:	add	esi, 11h
	inc	edx
	dec	[@@N]
	jne	@@1
@@9:	xchg	eax, edx
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

_npa1_crypt_init PROC
	push	ebx
	push	esi
	push	edi
	mov	esi, [esp+10h]
	mov	ebx, offset @@T
	neg	esi
	mov	edi, [esp+14h]
	movsx	esi, word ptr [ebx+esi*2]
	xor	ecx, ecx
	add	esi, ebx

@@1:	mov	eax, ecx
	mov	edx, ecx
	and	al, 0Fh
	shl	edx, 4
	add	dl, [esi+eax]
	mov	eax, ecx
	shr	eax, 4
	add	dh, [esi+eax]
	shr	edx, 4
	movzx	eax, byte ptr [ebx+ecx]
	mov	[edi+eax], dl
	inc	cl
	jne	@@1
@@2:	movzx	ecx, byte ptr [esi+10h]
	inc	esi
	movzx	edx, byte ptr [esi+10h]
	inc	esi
	mov	al, [edi+ecx]
	xchg	al, [edi+edx]
	mov	[edi+ecx], al
	cmp	ecx, edx
	jne	@@2

	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@T0 db 10h dup(000h), 000h,000h
@@T1 db 0DCh,0DCh,0ECh,0CDh,0DBh,0DCh,0DCh,0DCh,0DCh,0DCh,0DCh,0DCh,0DCh,0DCh,0DCh,0DCh, 01Eh,04Eh, 066h,0B6h, 000h,000h
@@T2 db 10h dup(0EEh), 01Eh,04Eh, 066h,0B6h, 000h,000h
@@T3 db 000h,004h,004h,068h,068h,068h,068h,068h,06Fh,06Fh,09Fh,096h,096h,096h,096h,09Bh, 000h,000h
@@T4 db 038h,09Ch,02Ah,08Bh,08Bh,08Bh,08Bh,08Ch,08Ah,08Bh,08Bh,0AEh,0AEh,0AEh,0A8h,0A8h, 000h,000h
@@T6 db 096h,0B9h,047h,048h,099h,097h,09Ch,0AAh,088h,0CAh,0EAh,073h,073h,07Bh,0C9h,0C6h, 000h,000h
@@T5 db 00Fh,007h,007h,090h,0F7h,0F7h,0F7h,0F7h,0F2h,047h,047h,049h,0C9h,0C9h,0C9h,0C3h, 000h,000h
@@T7 db 00Eh,00Bh,00Eh,077h,02Eh,02Eh,080h,086h,0B9h,02Eh,02Eh,029h,089h,082h,0ADh,0AAh, 000h,000h
@@T8 db 034h,07Ah,0BBh,0CBh,011h,065h,0EAh,05Ch,027h,00Fh,0CFh,0C6h,066h,039h,039h,0FDh, 000h,000h
@@T9 db 005h,00Dh,00Dh,013h,0B5h,03Dh,08Dh,02Dh,020h,0C7h,0C7h,0CFh,01Fh,0EFh,0EFh,048h, 000h,000h
@@T10 db 030h,096h,0DBh,02Bh,03Dh,081h,002h,074h,047h,02Bh,0EBh,0EEh,06Eh,035h,035h,05Dh, 000h,000h

; (4) 8883 2AAA AA98 8888, BBAC BB88 8EEE ACBB
; (6) 8A77 7C44 E9CC B999, 8ACA A669 B798 7933
; (5) 000F FFFF CCCC 9444, 7730 9999 7727 777F
; (7) 000B 8822 AA72 2288, E9EE 990E EA7D B6E2
; (8) 3363 E1CC 7026 5BFC, A66C 4199 FF5A DBB7

dw @@T10-@@T
dw @@T9-@@T
dw @@T8-@@T
dw @@T7-@@T
dw @@T5-@@T
dw @@T6-@@T
dw @@T4-@@T
dw @@T3-@@T
dw @@T2-@@T
dw @@T2-@@T
dw @@T1-@@T
dw @@T0-@@T
@@T label byte
db 06Fh,005h,06Ah,0BFh,0A1h,0C7h,08Eh,0FBh,0D4h,02Fh,080h,058h,04Ah,017h,03Bh,0B1h
db 089h,0ECh,0A0h,09Fh,0D3h,0FCh,0C2h,004h,068h,003h,0F3h,025h,0BEh,024h,0F1h,0BDh
db 0B8h,041h,0C9h,027h,00Eh,0A3h,0D8h,07Fh,05Bh,08Fh,016h,049h,0AAh,0B2h,018h,0A7h
db 033h,0E4h,0DBh,048h,0CAh,0DEh,0AEh,0CDh,013h,01Fh,015h,02Eh,039h,0F5h,01Eh,0DDh
db 00Fh,088h,04Ch,098h,036h,0B4h,03Fh,009h,083h,0FDh,032h,0BAh,014h,030h,07Ah,063h
db 0B9h,056h,095h,061h,0CCh,08Bh,0EFh,0DAh,0E5h,02Ch,0DCh,012h,01Ah,067h,023h,050h
db 0D1h,0C3h,07Eh,06Dh,0B6h,090h,03Ch,0B3h,00Bh,0E2h,091h,070h,0A8h,0DFh,044h,0C4h
db 0F4h,001h,05Ch,010h,006h,0E7h,054h,040h,043h,072h,038h,0BCh,0E3h,007h,0FAh,034h
db 002h,0A4h,0F7h,074h,0A9h,04Dh,042h,0A5h,085h,035h,079h,0D2h,076h,097h,045h,04Fh
db 008h,05Ah,0B0h,0EEh,051h,073h,069h,09Eh,094h,047h,077h,029h,0D9h,064h,011h,0EBh
db 037h,0ACh,020h,062h,09Ah,06Bh,09Ch,075h,022h,087h,0ABh,078h,053h,0C8h,05Dh,0ADh
db 02Ah,0F2h,0CBh,0B7h,00Dh,0EDh,086h,055h,0FFh,019h,057h,0D7h,0D5h,060h,0C6h,03Dh
db 0EAh,0C1h,06Ch,0E1h,0C0h,065h,084h,0C5h,0E0h,03Eh,07Dh,028h,066h,0AFh,01Ch,09Bh
db 0CFh,081h,04Eh,026h,059h,02Bh,05Fh,07Bh,0E8h,08Dh,052h,07Ch,0F8h,082h,00Ch,0F9h
db 08Ch,0E9h,0B5h,0E6h,031h,093h,046h,05Eh,01Dh,01Bh,04Bh,071h,0D6h,092h,03Ah,0A6h
db 02Dh,000h,09Dh,0BBh,06Eh,0F0h,099h,0CEh,021h,00Ah,0D0h,0F6h,0FEh,0A2h,08Ah,096h

ENDP
