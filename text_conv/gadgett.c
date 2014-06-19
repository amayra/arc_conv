
/*
  GADGETT.exe 0x44B79BA9
  00407C90 vm
  00408034 vm_list
  004080D8 vm_exp
*/

static void* gadgett_load(FILE *fi, uint *d) {
	int n = 0; uchar *m = 0;
	do {
	  if(fseek(fi, 0, SEEK_END)) break;
	  if((n = ftell(fi)) <= 0) break;
	  if(fseek(fi, 0, SEEK_SET)) break;
	  if(!(m = mem_alloc(n))) break;
	  if(fread(m, 1, n, fi) != n) { mem_free(m); m = 0; }
	} while(0);
	*d = m ? n : 0;
	return m;
}

static char gadgett_tab[] = {
	1,1,1,1,1, 1,1,2,2,2,
	2,2,2,2,2, 2,2,2,2,1,
	1,0,1,1,1, 1,1,1,2,1,
	1,1,1,1,0, 1,1,2,2,0,
	1,2,1,2,2, 3,1,1,0,1,
	1,2,0,0,3, 2,2,1,1,0,
	0,0,0,2,1, 0,1,1,0,0,
	1,1,1,1,1, 0,0,1,1
};

static int gadgett_str(uchar *b, uchar **d, uchar *e, uint f) {
	uint a, x = 0; uchar *s = *d;
	if(f != 2) {
	  if(f) printf("\ndb ");
	  for(;;) {
	    if(s == e) return -1;
	    a = *s++; if(!a) break;
	    if(f) asmchar(&x, a);
	  }
	  if(f) asmchar(&x, -1);
	} else {
	  for(;;) {
	    if(s == e) return -1;
	    a = *s++; if(!a) break;
	    text_putc(a);
	  }
	}
	*d = s;
	return 0;
}

static int gadgett_fmt(uchar *b, uchar **d, uchar *e, uint f) {
	int a, n; uchar *s = *d;
	a = *(short*)(s - 2);
	if(a <= 0x7F) {
	  if(a == 0x21 || a == 0x26 || a == 0x28 || a == 0x29 || a == 0x7C || a == 0x7D) return 0;
	  return -1;
	}
	a += -0x80;
	if(a <= 0x7F) {
	  if(a == 0 || a == 1 || a == 5) {
	    if(e - s < 4) return -1; a = *(uint*)s; s += 4; *d = s;
	    if(f == 1) printf(", _x%04X", (s - b) + a);
	    return 0;
	  }
	  if(a == 3 || a == 4) {
	    if(s == e) return -1; a = (char)*s++;
	    if(f == 1) printf(", %i", a);
	  } else if(a != 2) return -1;
	  if(s == e) return -1; n = (char)*s++;
	  if(f == 1) printf(", %i", n);
	  *d = s;
	  if(n < 0) return -1;
	  if(n) {
	    if(f == 2) printf("%04i ", (s - b) - 1);
	    do {
	      if(gadgett_str(b, d, e, f)) return -1;
	      if(f == 2 && n != 1) text_putc(0);
	    } while(--n);
	    putchar('\n');
	  }
	  return 0;
	}
	a += -0x80;
	if(a >= 0x4F) return -1;
	n = gadgett_tab[a];
	if(n) do {
	  if(e - s < 4) return -1; a = *(uint*)s; s += 4; *d = s;
	  if(f == 1) printf(", 0x%08X", a);
	} while(--n);
	return 0;
}

static int gadgett_next(uchar *b, uchar *s, uchar *e) {
	int a, n = 0;
	for(;;) {
	  if(e - s < 2) return 0; a = *(ushort*)s; s += 2;
	  if(a == 0x21 || a == 0x26 || a == 0x7C) continue;
	  if(a == 0x29) { if(--n < 0) break; continue; }
	  if(a == 0x28) { n++; continue; }
	  if((a -= 0x100) >= 0x4F) return 0;
	  n = gadgett_tab[a] * 4;
	  if(e - s < n) return 0; s += n;
	}
	return s - b;
}

static int gadgett_jmp(uchar *b, uchar *s, uchar *e, void **d) {
	uint a, n; void *m;
	*d = m = ref_alloc(e - b);
	for(;;) {
	  if(s == e) break;
	  if(e - s < 2) return -1; a = *(ushort*)s; s += 2;
	  n = a - 0x80;
	  if(n == 0 || n == 1 || n == 5) {
	    if(e - s < 4) return -1; a = *(uint*)s; s += 4;
	    if(n == 1) {
	      if(n = gadgett_next(b, s, e)) { ref_add(m, n); ref_add(m, n + a); }
	    } else ref_add(m, (s - b) + a);
	  } else gadgett_fmt(b, &s, e, 0);
	}
	return 0;
}

static int gadgett_asm_local(FILE *fi, void **m) {
	uint a, n; uchar *s, *b, *e;
	if(!(b = gadgett_load(fi, &n))) return -1;
	m[1] = b; s = b; e = b + n;
	if(n < 13) return -1;
	printf("dd %i, %i, %i\ndb %i",
	  *(uint*)s, *(uint*)(s + 4), *(uint*)(s + 8), *(uchar*)(s + 12));
	s += 13; if(gadgett_str(b, &s, e, 1)) return -1;
	putchar('\n');
	gadgett_jmp(b, s, e, m);
	for(;;) {
	  a = s - b; if(ref_check(*m, a)) printf("_x%04X:\n", a);
	  if(s == e) break;
	  if(e - s < 2) return -1; a = *(ushort*)s; s += 2;
	  printf("m0 0x%03X", a);
	  if(a == 0x81) {
	    if(e - s < 4) return -1; a = *(uint*)s; s += 4;
	    n = gadgett_next(b, s, e);
	    printf(", _x%04X-_x%04X", n + a, n);
	  } else if(gadgett_fmt(b, &s, e, 1)) printf("\n%%error");
	  putchar('\n');
	}
	return 0;
}

static int gadgett_get_local(FILE *fi, void **m) {
	uint a, n; uchar *s, *b, *e;
	if(!(b = gadgett_load(fi, &n))) return -1;
	*m = b; s = b; e = b + n;
	if(n < 13) return -1; s += 13;
	printf("%04i *%02X", 12, *(uchar*)(s - 1));
	if(gadgett_str(b, &s, e, 2)) return -1; putchar('\n');
	for(;;) {
	  if(s == e) break;
	  if(e - s < 2) return -1; a = *(ushort*)s; s += 2;
	  if(gadgett_fmt(b, &s, e, 2)) printf("# error\n");
	}
	return 0;
}

static int gadgett_asm(FILE *fi) {
	uint a, *m[2] = { 0, 0 };
	if(a = gadgett_asm_local(fi, m)) printf("\n%%error");
	mem_free(m[0]); mem_free(m[1]);
	return a;
}

static int gadgett_get(FILE *fi) {
	uint a, *m = 0;
	if(a = gadgett_get_local(fi, &m)) printf("\n# error");
	mem_free(m);
	return a;
}

static int gadgett_put(FILE *fi, FILE *fo) {
	uint a, i, n, p = 0, x = 0, k, l; void *m = 0, *r[2] = { 0, 0 };
	for(;;) {
	  if(!x) x = text_num();
	  // printf("replace %08X\n", x + n);
	  while(p != x) {
	    if((a = fgetc(fi)) == EOF) goto end; p++; fputc(a, fo);
	  }
	  k = 0; if(x >= 14) { k = ftell(fo); fputc(0, fo); }
	  i = 1; for(;;) {
	    if((a = text_getc()) > -3) break;
	    fputc(a, fo); if(!a) i++;
	  }
	  fputc(0, fo);
	  n = 1; if(k) {
	    n = ftell(fo);
	    if(fseek(fo, k, SEEK_SET)) return -1;
	    fputc(i, fo);
	    if(fseek(fo, n, SEEK_SET)) return -1;
	    if((n = fgetc(fi)) == EOF) goto end; p++;
	  }
	  x = -2 - a;

	  if(n) do {
	    do { if((a = fgetc(fi)) == EOF) goto end; p++; } while(a);
	  } while(--n);

	  reloc_add(r, p, ftell(fo) - p);
	}
end:	if(r[0]) {
	  // gadgett_fix(fi, fo, r[1], &m);
	  // mem_free(m);
	  blk_destroy(r[0]);
	}
	return 0;
}
