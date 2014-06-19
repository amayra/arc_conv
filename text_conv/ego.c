
/*
  "Angel's Feather"
  af.exe
  0041AB11 vm
*/

static int afdat_get(FILE *fi) {
	uint a, i, j, p = 0, x[4], n = 2; uchar t[0x200]; CHAR *fn;

	fn = getpathname(in_file);

// 	printf("#"); i = 0; while(a = fn[i++]) putchar(a); putchar('\n');

	if(!cmps(fn, "arms.dat")) { x[0] = 8; x[1] = 0x28; x[2] = 0x124; }
	else if(!cmps(fn, "btlmsg.dat")) { x[0] = 0; x[1] = 0x80; n = 1; }
	else if(!cmps(fn, "enemy.dat")) { x[0] = 4; x[1] = 0x24; x[2] = 0xE4; }
	else if(!cmps(fn, "item.dat")) { x[0] = 8; x[1] = 0x28; x[2] = 0xBC; }
	else if(!cmps(fn, "magic.dat")) { x[0] = 8; x[1] = 0x64; x[2] = 0x124; }
	else if(!cmps(fn, "mapmenu.dat")) { x[0] = 8; x[1] = 0x28; x[2] = 0x68; }
	else if(!cmps(fn, "pc.dat")) { x[0] = 4; x[1] = 0x24; x[2] = 0xE8; }
	else if(!cmps(fn, "skill.dat")) { x[0] = 8; x[1] = 0x34; x[2] = 0xF4; }
	else return -1;

	for(;;) {
	  READ(t, x[n]);
	  for(j = 0; j < n; j++) {
	    printf("%05i ", p + x[j]);
	    for(i = x[j]; i < x[j + 1]; i++) { if(!(a = t[i])) break; text_putc(a); }
	    putchar('\n');
	  }
	  p += x[n];
	}
	return 0;
}

static int afdat_put(FILE *fi, FILE *fo) {
	uint a, i, p = 0, x = 0;
	for(;;) {
	  if(!x) { x = text_num(); if(x < p) continue; }
	  if(p == x) {
	    i = p; do { LODSB; i++; } while(a);
	    x = text_copy(fo);
	    fputc(0, fo);
	    p = ftell(fo);
	    while(p < i) { fputc(0, fo); p++; }
	    if(fseek(fi, p, SEEK_SET)) return -1;
	  } else { LODSB; fputc(a, fo); p++; }
	}
	return 0;
}

static int ego_blk(FILE *fi, uint *p, uchar *t) {
	uint n;
	READ(t, 4); n = *(uint*)t;
	if(n > 0x100) return -1;
	READ(t + 4, n);
	*p += 4 + n;
	return 0;
}

static int ego_blk_fix(FILE *fi, FILE *fo, uint *p, uchar *t, void *m) {
	uint a, x, n;
	READ(t, 4); n = *(uint*)t;
	if(n > 0x100) return -1;
	READ(t + 4, n);
	if((x = reloc_fix(m, n + *p + 4) - reloc_fix(m, *p + 4)) != n) {
	  a = reloc_fix(m, *p);
	  // printf("change %08X %08X\n", a, x);
	  if(fseek(fo, a, SEEK_SET)) return -1;
	  fwrite(&x, 1, 4, fo);
	}
	*p += 4 + n;
	return 0;
}

static void ego_asm_printf(uchar *t, uchar *fmt) {
	uint a, i = 0, n = *(uint*)t, x; uchar *s = t + 4;
	printf(", {");
	if(fmt) while(a = *fmt++) {
	  if(a == '*') fmt -= 2;
	  else if(a == 's') {
	    if(!n) break;
	    if(i++) putchar(',');
	    x = 0;
	    do {
	      a = *s++; n--;
	      asmchar(&x, a);
	    } while(a && n);
	    asmchar(&x, -1);
	  }
	}
	if(n) do {
	  if(i++) putchar(',');
	  printf("0x%02X", *s++);
	} while(--n);
	putchar('}');
}

static void ego_printf(uchar *t, uint p, uchar *fmt) {
	uint a, i, n = *(uint*)t; uchar *s = t + 4;

	while(a = *fmt++) {
	  if(a == '*') fmt -= 2;
	  else if(a == 's') {
	    if(!n) break; *s++; n--;
	    for(i = 0; i < n; i++) if(!s[i]) break;
	    if(i == n) break;
	    printf("%04i ", p - n);
	    for(;;) {
	      a = *s++; n--; if(!a) break;
	      text_putc(a);
	    }
	    putchar('\n');
	  }
	}
}

static int ego_asm_local(FILE *fi, uint **m) {
	uint a, i, n = 0, p = 5, x; uchar t[0x104], *fmt;

	READ(&a, 4);
	if(a != 0x31465342) return -1;	// "BSF1"
	for(;;) {
	  LODSB; if(!a) break;
	  ungetc(a, fi);
	  printf("m2 {", a);
	  biniku_asmstr(fi, &p);
	  READ(&a, 4); p += 4;
	  printf("}, _x%04X\n", a);
	  n++;
	}

	if(!(*m = malloc((n + 1) << 2))) return -1;
	**m = n + 1;
	if(fseek(fi, 4, SEEK_SET)) return -1;
	if(n) {
	  i = 1; do {
	    do LODSB; while(a);
	    READ(&a, 4); *(*m + i++) = a;
	  } while(--n);
	}
	LODSB;

	for(;;) {
	  for(n = **m, i = 1; i < n; i++) if((*m)[i] == p) { printf("_x%04X:\n", p); break; }

	  if((n = fread(t, 1, 2, fi)) != 2) return n; p += 2;
	  a = *(ushort*)t;
	  if(a > 0x38) {
	    printf("m3 ");
	    x = 0; asmchar(&x, t[0]); a = t[1];
	    while(a) { asmchar(&x, a); LODSB; p++; }
	    asmchar(&x, -1); putchar('\n');
	    continue;
	  }
	  printf("m1 0x%04X", a);
	  if(ego_blk(fi, &p, t)) return -1;

	  fmt = 0;
	  switch(a) {
	  case 0x01: case 0x03: case 0x04: case 0x16: case 0x1D:
	    fmt = "s";
	    break;
	  case 0x0F:
	    fmt = "s*";
	    break;
	  case 0x12:
	    fmt = "ss";
	    break;
	  }
	  ego_asm_printf(t, fmt);

	  switch(a) {

	  case 0x2F:
	    if(ego_blk(fi, &p, t)) return -1;
	    ego_asm_printf(t, 0);
	    break;

	  case 0x31: case 0x32: case 0x35: case 0x36:
	    if(ego_blk(fi, &p, t)) return -1;
	    ego_asm_printf(t, 0);
	  case 0x30: case 0x38:
	    printf(", {");
	    if(biniku_asmstr(fi, &p)) return -1;
	    putchar('}');
	    break;

	  case 0x34:
	    READ(t, 2); p += 2;
	    printf(", 0x%04X", *(ushort*)t); 
	    break;
	  }
	  putchar('\n');
	}
	return 0;
}

static int ego_asm(FILE *fi) {
	uint a; uint *m = 0;
	a = ego_asm_local(fi, &m);
	if(m) free(m);
	if(a) printf("\n%%error");
	return a;
}

static int ego_get(FILE *fi) {
	uint a, p; uchar t[0x104];

	READ(&a, 4);
	if(a != 0x31465342) return -1;	// "BSF1"
	for(;;) {
	  LODSB; if(!a) break;
	  do LODSB; while(a);
	  READ(&a, 4);
	}
	p = ftell(fi);

	for(;;) {
	  READ(t, 2); p += 2;
	  a = *(ushort*)t;
	  if(a > 0x38) {
	    printf("%04i ", p - 2);
	    text_putc(t[0]); a = t[1];
	    while(a) {
	      text_putc(a);
	      LODSB; p++;
	    }
	    putchar('\n');
	    continue;
	  }
	  if(ego_blk(fi, &p, t)) return -1;
	  if(a == 0x01) {
	    a = *(uint*)t;
	    if(a == 3) if(*(ushort*)(t + 5) == 0x2A) a = 0;
	    if(a) ego_printf(t, p, "s");
	  } else if(a == 0x0F) ego_printf(t, p, "s*");

	  switch(a) {

	  case 0x2F:
	    if(ego_blk(fi, &p, t)) return -1;
	    break;

	  case 0x31: case 0x32: case 0x35: case 0x36:
	    if(ego_blk(fi, &p, t)) return -1;
	  case 0x30: case 0x38:
	    do { LODSB; p++; } while(a);
	    break;

	  case 0x34:
	    READ(t, 2); p += 2;
	    break;
	  }
	}
	return 0;
}

static int ego_fix(FILE *fi, FILE *fo, void *m) {
	uint a, x, p = 4; uchar t[0x104];

	if(fseek(fi, 0, SEEK_SET)) return -1;
	READ(&a, 4);
	if(a != 0x31465342) return -1;	// "BSF1"
	for(;;) {
	  LODSB; p++; if(!a) break;
	  do { LODSB; p++; } while(a);
	  READ(&a, 4);
 	  if((x = reloc_fix(m, a)) != a) { 
	    if(fseek(fo, reloc_fix(m, p), SEEK_SET)) return -1;
	    fwrite(&x, 1, 4, fo);
	  }
	  p += 4;
	}

	for(;;) {
	  READ(t, 2); p += 2;
	  a = *(ushort*)t;
	  if(a > 0x38) {
	    a = t[1];
	    while(a) { LODSB; p++; }
	    continue;
	  }
	  if(ego_blk_fix(fi, fo, &p, t, m)) return -1;

	  switch(a) {

	  case 0x2F:
	    if(ego_blk_fix(fi, fo, &p, t, m)) return -1;
	    break;

	  case 0x31: case 0x32: case 0x35: case 0x36:
	    if(ego_blk_fix(fi, fo, &p, t, m)) return -1;
	  case 0x30: case 0x38:
	    do { LODSB; p++; } while(a);
	    break;

	  case 0x34:
	    READ(t, 2); p += 2;
	    break;
	  }
	}

	return 0;
}

static int ego_put(FILE *fi, FILE *fo) {
	uint a, i, p = 0, x = 0; void *r[2] = { 0, 0 };

	for(;;) {
	  if(!x) x = text_num();
	  // printf("replace %08X\n", x);
	  while(p != x) {
	    if((a = fgetc(fi)) == EOF) goto end; p++; fputc(a, fo);
	  }
	  x = text_copy(fo);
	  do { if((a = fgetc(fi)) == EOF) goto end; p++; } while(a);
	  fputc(0, fo);

	  reloc_add(r, p, ftell(fo) - p);
	}
end:	if(r[0]) {
	  ego_fix(fi, fo, r[1]);
	  blk_destroy(r[0]);
	}
	return 0;
}

