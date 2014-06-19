
;#define LF_FACESIZE 32
;typedef struct tagLOGFONT {
;  LONG lfHeight;
;  LONG lfWidth;
;  LONG lfEscapement;
;  LONG lfOrientation;
;  LONG lfWeight;
;  BYTE lfItalic;
;  BYTE lfUnderline;
;  BYTE lfStrikeOut;
;  BYTE lfCharSet;
;  BYTE lfOutPrecision;
;  BYTE lfClipPrecision;
;  BYTE lfQuality;
;  BYTE lfPitchAndFamily;
;  TCHAR lfFaceName[LF_FACESIZE];
;} LOGFONT;

_mod_fontdesc PROC
	enter	5Ch, 0
	cmp	eax, 1+(5+8+1)
	jne	@@9
	mov	edi, esp
	lea	esi, [ebp+10h]
	xor	ebx, ebx
@@1:	lodsd
	call	_string_num, eax
	jc	@@9
	stosd
	inc	ebx
	cmp	ebx, 5
	jb	@@1
@@2:	lodsd
	call	_string_num, eax
	jc	@@9
	stosb
	sub	eax, -80h
	cmp	eax, 180h
	jae	@@9
	inc	ebx
	cmp	ebx, 5+8
	jb	@@2
	lodsd
	xchg	esi, eax
	xor	eax, eax
	lea	ecx, [eax+20h]
@@3:	lodsw
	test	eax, eax
	je	@@7
	stosw
	dec	ecx
	jne	@@3
@@9:	xor	edi, edi
	jmp	_fontdesc_end

@@7:	rep	stosw
	mov	edi, esp
ENDP

_fontdesc_end PROC
	xor	ebx, ebx
	test	edi, edi
	je	@@9
	call	_FileCreate, dword ptr [ebp+0Ch], FILE_OUTPUT
	jc	@@9
	push	eax
	call	_FileWrite, eax, edi, 5Ch
	xchg	ebx, eax
	call	_FileClose
@@9:	sub	ebx, 5Ch
	neg	ebx
	sbb	ebx, ebx
	neg	ebx
	call    ExitProcess, ebx
ENDP

_mod_fontdlg PROC
	enter	60h, 0
	xor	ebx, ebx
	mov	edi, esp
	call	_FileCreate, dword ptr [ebp+0Ch], FILE_INPUT
	jc	@@1a
	push	eax
	call	_FileRead, eax, edi, 60h
	xchg	ebx, eax
	call	_FileClose
@@1a:	xor	eax, eax
	cmp	ebx, 5Ch
	je	@@1b
	lea	ecx, [eax+5Ch/4]
	rep	stosd
	mov	edi, esp
@@1b:	push	eax
	push	eax
	push	eax
	push	eax
	push	eax
	push	eax
	push	eax
	push	eax
	push	eax
	push	41h	; CF_SCREENFONTS+CF_INITTOLOGFONTSTRUCT
	push	eax
	push	edi
	push	eax
	push	eax
	push	3Ch
	call	_comdlg32, esp
	db 'ChooseFontW', 0
	test	eax, eax
	jne	@@9
	xor	edi, edi
@@9:	jmp	_fontdesc_end
ENDP
