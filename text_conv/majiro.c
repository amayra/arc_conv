
static int majiro_code(uint a) {

	if((uint)(a - 0x100) < 0xB0) a = 0x100;
	if((uint)(a - 0x1B0) < 0x130) a = 0x1B0;

	switch(a) {
	  case 0x100: case 0x82B: case 0x82F: case 0x83E: case 0x83F: case 0x841: case 0x844:
	    return 0;

	  case 0x83A:
	    return 2;

	  case 0x800: case 0x803: case 0x82E: case 0x82C: case 0x82D:
	  case 0x830: case 0x831: case 0x832: case 0x838: case 0x839: case 0x83B: case 0x83D: case 0x843: case 0x847:
	    return 4;

	  case 0x834: case 0x835:
	    return 0x24;

	  case 0x1B0: case 0x802: case 0x837:
	    return 0x242;

	  case 0x80F: case 0x810:
	    return 0x244;

	  // string
	  case 0x801: case 0x840:
	    return 5;

	  // byte tab
	  case 0x829: case 0x842: case 0x836:
	    return 6;

	  // dword tab
	  case 0x850:
	    return 7;
	}
	return 9;
}

static int majiro_fix(FILE *fi, FILE *fo, void *m) {
	uint a, i, n; uchar t[0xC];

	if(fseek(fi, 0x10, SEEK_SET)) return -1;
	if(fseek(fo, 0x10, SEEK_SET)) return -1;
	READ(t, 0xC);
	*(uint*)t = reloc_fix(m, *(uint*)t);
	*(uint*)(t + 4) = reloc_fix(m, *(uint*)(t + 4));	// ???
	fwrite(t, 1, 0xC, fo);

	n = *(uint*)(t + 8);
	for(i = 0; i < n; i++) {
	  READ(t, 8);
	  *(uint*)(t + 4) = reloc_fix(m, *(uint*)(t + 4));
	  fwrite(t, 1, 8, fo);
	}
	READ(t, 4);
	*(uint*)t = reloc_fix(m, *(uint*)t);
	fwrite(t, 1, 4, fo);

	return 0;
}

static int majiro_put(FILE *fi, FILE *fo) {
	uint a, i, n, p = 0, x = 0; uchar t[0x1C]; void *r[2] = { 0, 0 };

	READ(t, 0x1C);
	if(strcmp(t, "MajiroObjV1.000")) return -1;
	fwrite(t, 1, 0x1C, fo);

	n = *(uint*)(t + 0x18);
	for(i = 0; i < n; i++) {
	  READ(t, 8); fwrite(t, 1, 8, fo);
	}
	READ(t, 4); fwrite(t, 1, 4, fo);
	n = n * 8 + 0x20;

	for(;;) {
	  if(!x) x = text_num();
	  // printf("replace %08X\n", x + n);
	  while(p != x) {
	    if((a = fgetc(fi)) == EOF) goto end; p++; fputc(a, fo);
	  }
	  x = text_copy(fo);
	  do { if((a = fgetc(fi)) == EOF) goto end; p++; } while(a);
	  fputc(0, fo);

	  reloc_add(r, p, ftell(fo) - p - n);
	}
end:	if(r[0]) {
	  majiro_fix(fi, fo, r[1]);
	  blk_destroy(r[0]);
	}
	return 0;
}

static int majiro_get(FILE *fi) {
	uint a, i, n, p = 0; uchar t[0x1C];

	READ(t, 0x1C);
	if(strcmp(t, "MajiroObjV1.000")) return -1;
	n = *(uint*)(t + 0x18);
	if(fseek(fi, 0x20 + n * 8, SEEK_SET)) return -1;

	for(;;) {
	  if((n = fread(t, 1, 2, fi)) != 2) break; p += 2;
	  i = majiro_code(a = *(ushort*)t);

	  if((i & 0xF) < 5) {
	    if(i) {
	      a = 0; do a += i & 0xF; while (i >>= 4);
	      READ(t, a); p += a;
	    }

	  } else if(i == 5) {	    // string 0x801, 0x840
	    READ(t + 2, 2); p += 2; n = *(ushort*)(t + 2);
	    printf("%04i ", p);
	    if(!n) printf("# error"); else {
	      if(--n) do { LODSB; p++; text_putc(a); } while(--n);
	      LODSB; p++; if(a) printf("\n# error");
	    }
	    putchar('\n');

	  } else if(i == 6) {	  // tab1 0x829, 0x842, 0x836
	    READ(t + 2, 2); p += 2; n = *(ushort*)(t + 2);
	    if(fseek(fi, n, SEEK_CUR)) return -1; p += n;

	  } else if(i == 7) {	  // tab4 0x850
	    READ(t + 2, 2); p += 2; n = *(ushort*)(t + 2);
	    n <<= 2;
	    if(fseek(fi, n, SEEK_CUR)) return -1; p += n;

	  } else printf("# error\n");
	}
	if(n) printf("# error\n");
	return 0;
}

static int majiro_printf(FILE *fi, uint *p, uint a) {
	uint b; uchar t[4];
	while(a) {
	  b = a & 0xF; a >>= 4;
	  if(b == 2) { READ(t, 2); *p += 2; printf(", 0x%04X", *(ushort*)t); }
	  else if(b == 4) { READ(t, 4); *p += 4; printf(", 0x%08X", *(uint*)t); }
	}
	return 0;
}

static int majiro_asm_local(FILE *fi, uint **m) {
	uint a, i, n, p = 0, x; uchar t[0x1C];

	READ(t, 0x1C);
	if(strcmp(t, "MajiroObjV1.000")) return -1;
	a = *(uint*)(t + 0x10);
	n = *(uint*)(t + 0x18);
	printf("dd _x%05X-_x, 0x%08X, 0x%08X\n", a, *(uint*)(t + 0x14), n);

	if(!(*m = malloc((n + 2) << 2))) return -1;
	**m = n + 2;
	*(*m + 1) = a;

	for(i = 0; i < n; i++) {
	  READ(t, 8);
	  a = *(uint*)(t + 4); *(*m + 2 + i) = a;
	  printf("dd 0x%08X, _x%05X-_x\n", *(uint*)t, a);
	}
	READ(&a, 4);
	printf("dd _e-_x\n_x:\n");

	for(;;) {
	  for(n = **m, i = 1; i < n; i++) if((*m)[i] == p) { printf("_x%05X:\n", p); break; }

	  if((n = fread(t, 1, 2, fi)) != 2) break; p += 2;
	  i = majiro_code(a = *(ushort*)t);
	  printf("m%X 0x%04X", i, a);

	  if((i & 0xF) < 5) {
	    if(majiro_printf(fi, &p, i)) return -1;

	  } else if(i == 5) {	    // string 0x801, 0x840
	    READ(t + 2, 2); p += 2; n = *(ushort*)(t + 2);
	    printf(", {");
	    if(!n) printf("\n%%error"); else {
	      x = 0; if(--n) do { LODSB; p++; asmchar(&x, a); } while(--n);
	      asmchar(&x, -1);
	      LODSB; p++; if(a) printf("\n%%error");
	    }
	    putchar('}');

	  } else if(i == 6) {	  // tab1 0x829, 0x842, 0x836
	    READ(t + 2, 2); p += 2; n = *(ushort*)(t + 2);
	    printf(", {");
	    for(i = 0; i < n; i++) {
	      if(i) putchar(',');
	      LODSB; p++; printf("0x%02X", a);
	    }
	    putchar('}');

	  } else if(i == 7) {	  // tab4 0x850
	    READ(t + 2, 2); p += 2; n = *(ushort*)(t + 2);
	    printf(", {");
	    for(i = 0; i < n; i++) {
	      if(i) putchar(',');
	      READ(&a, 4); p += 4; printf("0x%08X", a);
	    }
	    putchar('}');

	  } else printf("\n%%error");

	  putchar('\n');
	}
	printf("_e:\n");
	return n;
}

static int majiro_asm(FILE *fi) {
	uint a, *m = 0;
	if(a = majiro_asm_local(fi, &m)) printf("\n%%error");
	if(m) free(m);
	return a;
}
