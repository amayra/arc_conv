
	dw 0
_arc_auto PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@L0

	push	ebp
	mov	ebp, esp
	call	_unicode_name, offset inFileName
	push	eax
	call	_unicode_ext, -1, eax
	mov	ebx, offset _arc_mink
	cmp	eax, 'ted'
	je	@@7
	mov	ebx, offset _arc_aos
	cmp	eax, 'soa'
	je	@@7
	mov	ebx, offset _arc_cycsoft
	cmp	eax, 'kpg'
	je	@@7
	cmp	eax, 'kpv'
	je	@@7
	mov	ebx, offset _arc_nsa
	cmp	eax, 'asn'
	je	@@7
	mov	ebx, offset _arc_illusion
	cmp	eax, 'pp'
	je	@@7
	mov	ebx, offset _arc_k3
	cmp	eax, '3k'
	je	@@7
	mov	ebx, offset _arc_kif_zt
	cmp	eax, 'tz'
	je	@@7
	mov	ebx, offset _arc_mbl
	cmp	eax, 'lbm'
	je	@@7
	mov	ebx, offset _arc_gsp
	cmp	eax, 'psg'
	je	@@7
	mov	ebx, offset _arc_systemc
	cmp	eax, 'kpf'
	je	@@7
	mov	ebx, offset _arc_rpd
	cmp	eax, 'dpr'
	je	@@7
	push	[@@L0]
	call	@@1a
	db 'seen.txt',0, 0
@@1a:	call	_filename_select
	mov	ebx, offset _arc_rlseen
	jnc	@@7
@@9a:	leave
	ret

@@7:	call	_ArcSetConv, ebx
	leave
	push	ebx
	ret
ENDP
