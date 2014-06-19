
#define BSWAP(a) (a << 24) + ((a & 0xFF00) << 8) + ((a >> 8) & 0xFF00) + (a >> 24)

static int biniku_asmstr(FILE *fi, uint *p) {
	uint a, x = 0;
	for(;;) {
	  LODSB; (*p)++; if(!a) break;
	  asmchar(&x, a);
	}
	asmchar(&x, -1);
	return 0;
}

/*
 00472800 vm_loop
 004739E0 vm_byte
 00473A70 vm_dword
*/

static int biniku_code(uint a) {
	switch(a) {
	  // offset
	  case 0x14: case 0x15: case 0x1A:
	    return 1;

	  // int
	  case 0x19: case 0x32:
	    return 2;

	  // string
	  case 0x0A: case 0x33:
	    return 3;
	}
	return 0;
}

static int biniku_jmp(FILE *fi, uint *m, uint x) {
	uint a, i = 1;
	*m = i;
	for(;;) {
	  if((a = fgetc(fi)) == EOF) break;
	  switch(biniku_code(a)) {

	  case 1:	  // offset
	    READ(&a, 4);
	    if(i == x) break;
	    if(x) m[i] = BSWAP(a); i++; *m = i;
	    break;

	  case 2:	  // int
	    READ(&a, 4);
	    break;

	  case 3:	  // string
	    do LODSB; while(a);
	    break;
	  }
	}
	return 0;
}

static int biniku_asm_local(FILE *fi, uint **m) {
	uint a, n, i = 0, p = 0;

	READ(&n, 4);
	printf("dd %i", n);
	for(i = 0; i < n; i++) {
	  READ(&a, 4);
	  if(i & 3) printf(", _x%04X", a);
	  else printf("\nm2 _x%04X", a);
	}
	printf("\n_x:\n");

	a = ftell(fi);
	biniku_jmp(fi, &i, 0);
	if(!(*m = malloc((i + n) << 2))) return -1;
	**m = i; if(i > 1) {
	  if(fseek(fi, a, SEEK_SET)) return -1;
	  biniku_jmp(fi, *m, i);
	}
	if(n) {
	  if(fseek(fi, 4, SEEK_SET)) return -1;
	  i = **m; **m = i + n;
	  READ(*m + i, n << 2);
	}
	if(fseek(fi, a, SEEK_SET)) return -1;

	for(;;) {
	  for(n = **m, i = 1; i < n; i++) if((*m)[i] == p) { printf("_x%04X:\n", p); break; }
	  LODSB; p++;
	  printf("m1 0x%02X", a);
	  switch(biniku_code(a)) {

	  case 1:	  // offset
	    READ(&a, 4); p += 4;
	    printf(", _x%04X", BSWAP(a));
	    break;

	  case 2:	  // int
	    READ(&a, 4); p += 4;
	    printf(", 0x%08X", BSWAP(a));
	    break;

	  case 3:	  // string
	    printf(", {");
	    if(biniku_asmstr(fi, &p)) return -1;
	    putchar('}');
	    break;
	  }
	  putchar('\n');
	}
	return 0;
}

static int biniku_asm(FILE *fi) {
	uint a; uint *m = 0;
	a = biniku_asm_local(fi, &m);
	if(m) free(m);
	return a;
}

static int biniku_get(FILE *fi) {
	uint a, p = 0;

	READ(&a, 4);
	if(fseek(fi, a * 4 + 4, SEEK_SET)) return -1;

	for(;;) {
	  LODSB; p++;
	  switch(biniku_code(a)) {

	  case 1:	  // offset
	  case 2:	  // int
	    READ(&a, 4); p += 4;
	    break;
	  case 3:	  // string
	    if(a != 0x0A) break;
	    printf("%05i ", p);
	    for(;;) {
	      LODSB; p++;
	      if(!a) break;
	      text_putc(a);
	    }
	    putchar('\n');
	    break;
	  }
	}
	return 0;
}

static int biniku_fix(FILE *fi, FILE *fo, void *m) {
	uint a, i, n, p = 0, x;

	if(fseek(fi, 0, SEEK_SET)) return -1;
	if(fseek(fo, 4, SEEK_SET)) return -1;
	READ(&n, 4);
	for(i = 0; i < n; i++) {
	  READ(&a, 4); a = reloc_fix(m, a);
	  fwrite(&a, 1, 4, fo);
	}
	n = n * 4 + 4;

	for(;;) {
	  LODSB; p++;
	  switch(biniku_code(a)) {

	  case 1:	  // offset
	    READ(&a, 4);
	    a = BSWAP(a);
	    if((x = reloc_fix(m, a)) != a) {
	      a = BSWAP(x); x = n + reloc_fix(m, p);
	      // printf("change %08X %08X\n", x, a);
	      if(fseek(fo, x, SEEK_SET)) return -1;
	      fwrite(&a, 1, 4, fo);
	    }
	    p += 4;
	    break;
	  case 2:	  // int
	    READ(&a, 4); p += 4;
	    break;
	  case 3:	  // string
	    if(a != 0x0A) break;
	    for(;;) {
	      LODSB; p++;
	      if(!a) break;
	    }
	    break;
	  }
	}
	return 0;
}

static int biniku_put(FILE *fi, FILE *fo) {
	uint a, i, n, p = 0, x = 0; void *r[2] = { 0, 0 };

	READ(&n, 4); fwrite(&n, 1, 4, fo);
	for(i = 0; i < n; i++) {
	  READ(&a, 4); fwrite(&a, 1, 4, fo);
	}
	n = n * 4 + 4;

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
	  biniku_fix(fi, fo, r[1]);
	  blk_destroy(r[0]);
	}
	return 0;
}

#undef BSWAP
