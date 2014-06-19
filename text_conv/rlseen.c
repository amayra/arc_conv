
static void* rlseen_load(FILE *fi) {
	uint a = 0, n = 0; uchar *m = 0, t[0x2C];

	if(fread(t, 1, 0x2C, fi) != 0x2C) return m;
	for(n = 0; n < 11; n++) a |= t[n];
	if(a >> 26) return m;

	a = *(uint*)t;
	if(a != 0x1D0 || *(uint*)(t + 0x28)) return m;
	if(a != *(uint*)(t + 8)) return m;
	n = *(uint*)(t + 0x10); a += n;
	if((n >> 2) != *(uint*)(t + 0xC) || a != *(uint*)(t + 0x14)) return m;
	n = *(uint*)(t + 0x1C); a += n;
	if(a != *(uint*)(t + 0x20)) return m;
	n = a + *(uint*)(t + 0x24);

	if(m = mem_alloc(n)) {
	  n -= 0x2C;
	  memcpy(m, t, 0x2C);
	  if(fread(m + 0x2C, 1, n, fi) != n) { mem_free(m); m = 0; }
	}
	return m;
}

#define RLSEEN_READ(n) if((c -= n) < 0) return -1; s += n

static uchar rlseen_eol[] = "\x72\x82\x85\x82\x85\x82\x8E\x82\x64\x82\x8E\x82\x84"
	          "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF"
	          "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF";

static int rlseen_jmp(uchar *p, void **d) {
	uint a, n; int c, j = 0, k = 0; uchar *s; void *m;

	c = *(uint*)(p + 0x24);
	s = p + *(uint*)(p + 0x20);
	*d = m = ref_alloc(c);

	for(;;) {
	  if(!c) break; c--; a = *s++;
	  if((uchar)(a - 0x81) < 0x7C && (uchar)(a - 0xA0) >= 0x40) {
	    RLSEEN_READ(1);
	    continue;
	  }

	  switch(a) {

	  case 0x0A:	// eol
	  case 0x21:	// entry
	  case 0x40:	// string
	    RLSEEN_READ(2);
	    break;

	  case 0x22:
	    do {
	      RLSEEN_READ(1); a = *(uchar*)(s - 1);
	    } while(a != 0x22);
	    break;

	  case 0x24:
	    RLSEEN_READ(1); a = *(uchar*)(s - 1);
	    if(a == 0xFF) { RLSEEN_READ(4); }
	    break;

	  case 0x5C:
	  case 0x61:	// array part
	    RLSEEN_READ(1);
	    break;

	  case 0x23:	// call
	    RLSEEN_READ(7);
	    j = 0; a = *(uchar*)(s - 7 + 1); k = *(ushort*)(s - 7 + 2);
	    if(a == 1 && k < 10) {
	      if(k >= 5) k -= 5;
	      if(k == 2) k--;
	      if(!k) {
	        RLSEEN_READ(4);
	        ref_add(m, *(uint*)(s - 4));
	        k = -1;
	      }
	    } else k = -1;
	    break;

	  case 0x28:
	    j++;
	    break;

	  case 0x29:
	    j--;
	    if(!j && (k == 1 || k == 5)) {
	      RLSEEN_READ(4);
	      ref_add(m, *(uint*)(s - 4));
	      if(k == 1) k = -1;
	    }
	    break;

	  case 0x7B:
	    if(k == 4) k++;
	    break;

	  case 0x7D:
	    k = -1;
	    break;
	  }
	}
	return 0;
}

static int rlseen_names(uchar *m, uint n, int c) {
	uint a, k, x, i = 0; uchar *s;
	s = m;
	if(n) do {
	  if((c -= 4) < 0) return -1;
	  k = *(uint*)s; s += 4;
	  if((c -= k) < 0) return -1;

	  printf("m3 "); x = 0;
	  if(!k) printf("\n%%error"); else {
	    if(--k) do { a = *s++; asmchar(&x, a); } while(--k);
	    asmchar(&x, -1);
	    a = *s++; if(a) printf("\n%%error");
	  }
	  putchar('\n');
	} while(--n);
	if(c) return -1;
	return 0;
}

static int rlseen_strlen(uchar *s, uint n) {
	uchar a; uint i = 0;
	while(i < n) {
	  a = s[i];
	  if((uchar)(a - 0x41) < 0x1A || (uchar)(a - 0x30) < 10 || a == '_' || a == '?') i++;
	  else if(a >= 0x80) {
	    if((uchar)(a - 0x81) < 0x7C && (uchar)(a - 0xA0) >= 0x40) { if(++i >= n) return i; } i++;
	  } else if(a == 0x22) {
	    do if(++i >= n) return i; while(s[i] != 0x22); i++;
	  } else break;
	}
	return i;
}

static int rlseen_asm_local(FILE *fi, void **m) {
	uint a, i, n; int c, j = 0, k = 0, x; uchar *s, *p;

	if(!(p = rlseen_load(fi))) return -1;
	m[1] = (uint*)p;

	printf("dd 0x%08X, 0x%08X\n", *(uint*)p, *(uint*)(p + 4));
	printf("dd _d, (_n-_d)/4, _n-_d\n");
	printf("dd _n, %i, _x-_n\n", *(uint*)(p + 0x18));
	printf("dd _x, _e-_x, 0");

	rlseen_jmp(p, m);
	for(j = 0; j < 105; j++) {
	  a = ((uint*)(p + 0x2C))[j];
	  if(j & 3) printf(", _x%04X", a);
 	  else printf("\nm2 _x%04X", a);
	  ref_add(*m, a);
	}

	printf("\n_d:");
	s = p + *(uint*)(p + 0x8);
	n = *(uint*)(p + 0xC);
	for(j = 0; j < n; j++) {
	  a = *(uint*)(s + j * 4);
	  if(j & 3) printf(", 0x%08X", a);
 	  else printf("\ndd 0x%08X", a);
	}

	printf("\n_n:\n");
	s = p + *(uint*)(p + 0x14);
	if(rlseen_names(s, *(uint*)(p + 0x18), *(uint*)(p + 0x1C))) printf("%%error\n");

	printf("_x:\n");
	c = *(uint*)(p + 0x24);
	p += *(uint*)(p + 0x20);
	s = p;
	for(;;) {
	  a = s - p; if(ref_check(*m, a)) printf("_x%04X:\n", a);

	  if(!c) break;
	  if(i = rlseen_strlen(s, c)) {
	    if(*s == 0x82 && i >= 0x2E) if(!strcmp(s + 1, rlseen_eol)) {
	      printf("m9\n"); c -= 0x2F; s += 0x2F; continue;
	    }
	    printf("db "); c -= i; x = 0;
	    do asmchar(&x, *s++); while(--i);
	    asmchar(&x, -1); putchar('\n');
	    continue;
	  }
	  a = *s++; c--;

	  printf("m1 0x%02X", a);
	  switch(a) {

	  case 0x0A:	// eol
	  case 0x21:	// entry
	  case 0x40:	// string
	    RLSEEN_READ(2);
	    printf(", 0x%04X", *(ushort*)(s - 2));
	  case 0x00: case 0x2C: case 0x5B: case 0x5D:
	    break;

	  case 0x24:
	    RLSEEN_READ(1); a = *(uchar*)(s - 1);
	    printf(", 0x%02X", a);
	    if(a == 0xFF) {
	      RLSEEN_READ(4);
	      printf(", 0x%08X", *(uint*)(s - 4));
	    }
	    break;

	  case 0x5C:
	  case 0x61:	// array part
	    RLSEEN_READ(1);
	    a = *(uchar*)(s - 1);
	    printf(", 0x%02X", a);
	    break;

	  case 0x23:	// call
	    RLSEEN_READ(7);
	    j = 0; a = *(uchar*)(s - 7 + 1); k = *(ushort*)(s - 7 + 2);
	    printf(", 0x%02X, 0x%02X, 0x%04X, 0x%04X, 0x%02X",
	      *(uchar*)(s - 7), a, k, *(ushort*)(s - 7 + 4), *(uchar*)(s - 7 + 6));
	    if(a == 1 && k < 10) {
	      if(k >= 5) k -= 5;
	      if(k == 2) k--;
	      if(!k) {
	        RLSEEN_READ(4);
	        printf("\nm2 _x%04X", *(uint*)(s - 4));
	        k = -1;
	      }
	    } else k = -1;
	    break;

	  case 0x28:
	    j++;
	    break;

	  case 0x29:
	    j--;
	    if(!j && (k == 1 || k == 5)) {
	      RLSEEN_READ(4);
	      printf("\nm2 _x%04X", *(uint*)(s - 4));
	      if(k == 1) k = -1;
	    }
	    break;

	  case 0x7B:
	    if(k == 4) k++;
	    break;

	  case 0x7D:
	    k = -1;
	    break;

	  default:
	    printf("\n%%error");
	  }
	  putchar('\n');
	}
	printf("_e:\n");
	return 0;
}

static int rlseen_get_local(FILE *fi, uint **m) {
	uint a, i, n; int c, j = 0, k = 0; uchar *s, *p;

	if(!(p = rlseen_load(fi))) return -1;
	*m = (uint*)p;

	c = *(uint*)(p + 0x24);
	s = p + *(uint*)(p + 0x20);
	for(;;) {
	  if(!c) break;
	  if(i = rlseen_strlen(s, c)) {
	    if(*s == 0x82 && i >= 0x2E) if(!strcmp(s + 1, rlseen_eol)) {
	      c -= 0x2F; s += 0x2F; continue;
	    }
	    c -= i; printf("%05i ", s - p);
	    a = i; do text_putc(*s++); while(--a);
	    putchar('\n');
	    if(c >= 5 + i && (*(uint*)s << 8) == 0x402C2900 && !memcmp(s - i, s + 5, i)) {
	      i += 5; s += i; c -= i;
	    }
	    continue;
	  }
	  a = *s++; c--;

	  switch(a) {

	  case 0x0A:	// eol
	  case 0x21:	// entry
	  case 0x40:	// string
	    RLSEEN_READ(2);
	  case 0x00: case 0x2C: case 0x5B: case 0x5D:
	    break;

	  case 0x24:
	    RLSEEN_READ(1); a = *(uchar*)(s - 1);
	    if(a == 0xFF) { RLSEEN_READ(4); }
	    break;

	  case 0x5C:
	  case 0x61:	// array part
	    RLSEEN_READ(1);
	    break;

	  case 0x23:	// call
	    RLSEEN_READ(7);
	    j = 0; a = *(uchar*)(s - 7 + 1); k = *(ushort*)(s - 7 + 2);
	    if(a == 1 && k < 10) {
	      if(k >= 5) k -= 5;
	      if(k == 2) k--;
	      if(!k) {
	        RLSEEN_READ(4);
	        k = -1;
	      }
	    } else k = -1;
	    break;

	  case 0x28:
	    j++;
	    break;

	  case 0x29:
	    j--;
	    if(!j && (k == 1 || k == 5)) {
	      RLSEEN_READ(4);
	      if(k == 1) k = -1;
	    }
	    break;

	  case 0x7B:
	    if(k == 4) k++;
	    break;

	  case 0x7D:
	    k = -1;
	    break;

	  default:
	    printf("\n# error");
	  }
	}
	return 0;
}

static int rlseen_fix(uchar *p, FILE *fo, void *m) {
	uint a, i, n, x; int c, j = 0, k = 0; uchar *s;

	c = *(uint*)(p + 0x24);

	if(fseek(fo, 0, SEEK_SET)) return -1;
	*(uint*)(p + 0x24) = reloc_fix(m, c);
	for(i = 0; i < 105; i++) {
	  ((uint*)(p + 0x2C))[i] = reloc_fix(m, ((uint*)(p + 0x2C))[i]);
	}
	fwrite(p, 1, *(uint*)(p + 8), fo);

	n = *(uint*)(p + 0x20);
	s = p + n;
	for(;;) {
	  if(!c) break; c--; a = *s++;
	  if((uchar)(a - 0x81) < 0x7C && (uchar)(a - 0xA0) >= 0x40) {
	    RLSEEN_READ(1);
	    continue;
	  }

	  switch(a) {

	  case 0x0A:	// eol
	  case 0x21:	// entry
	  case 0x40:	// string
	    RLSEEN_READ(2);
	    break;

	  case 0x22:
	    do {
	      RLSEEN_READ(1); a = *(uchar*)(s - 1);
	    } while(a != 0x22);
	    break;

	  case 0x24:
	    RLSEEN_READ(1); a = *(uchar*)(s - 1);
	    if(a == 0xFF) { RLSEEN_READ(4); }
	    break;

	  case 0x5C:
	  case 0x61:	// array part
	    RLSEEN_READ(1);
	    break;

	  case 0x23:	// call
	    RLSEEN_READ(7);
	    j = 0; a = *(uchar*)(s - 7 + 1); k = *(ushort*)(s - 7 + 2);
	    if(a == 1 && k < 10) {
	      if(k >= 5) k -= 5;
	      if(k == 2) k--;
	      if(!k) {
	        if((c -= 4) < 0) return -1; a = *(uint*)s;
	        if((x = reloc_fix(m, a)) != a) {
	          a = n + reloc_fix(m, (s - p) - n);
	          // printf("change %08X %08X\n", a, x);
	          if(fseek(fo, a, SEEK_SET)) return -1;
	          fwrite(&x, 1, 4, fo);
	        }
	        s += 4; k = -1;
	      }
	    } else k = -1;
	    break;

	  case 0x28:
	    j++;
	    break;

	  case 0x29:
	    j--;
	    if(!j && (k == 1 || k == 5)) {
	      if((c -= 4) < 0) return -1; a = *(uint*)s;
	      if((x = reloc_fix(m, a)) != a) {
	        a = n + reloc_fix(m, (s - p) - n);
	        // printf("change %08X %08X\n", a, x);
	        if(fseek(fo, a, SEEK_SET)) return -1;
	        fwrite(&x, 1, 4, fo);
	      }
	      s += 4; if(k == 1) k = -1;
	    }
	    break;

	  case 0x7B:
	    if(k == 4) k++;
	    break;

	  case 0x7D:
	    k = -1;
	    break;
	  }
	}
	return 0;
}

#undef RLSEEN_READ

#define N 0x800

static int rlseen_put_local(FILE *fi, FILE *fo, uint **m) {
	uint a, i, n, p = 0, x = 0, k, d = -1, c; void *r[2] = { 0, 0 }; uchar *s, t[N];

	if(!(s = rlseen_load(fi))) return -1;
	*m = (uint*)s;

	k = p = *(uint*)(s + 0x20);
	fwrite(s, 1, p, fo);
	n = p + *(uint*)(s + 0x24);

	for(;;) {
	  if(!x) x = text_num();
	  // printf("replace %08X\n", x);
	  if(p != x) {
	    a = n - p; i = x - p;
	    if(i >= a) i = a;
	    fwrite(s + p, 1, i, fo);
	    p += i;
	  }
	  if(p == n) break;
	  i = 0; for(;;) {
	    if((a = text_getc()) > -3) break;
	    if(i < N) t[i++] = a;
	  }
	  x = -2 - a;

	  c = rlseen_strlen(s + p, n - p);
	  d = p; p += c;

	  a = 0;
	  if(!i || i != rlseen_strlen(t, i)) a = 0x22;
	  if(a) fputc(a, fo);
	  fwrite(t, 1, i, fo);
	  if(a) fputc(a, fo);

	  if(n - p >= 5 + c && (*(uint*)(s + p) << 8) == 0x402C2900 && !memcmp(s + p - c, s + p + 5, c)) {
	    fwrite(s + p, 1, 5, fo);
	    p += 5 + c;
	    if(a) fputc(a, fo);
	    fwrite(t, 1, i, fo);
	    if(a) fputc(a, fo);
	  }
	  reloc_add(r, p - k, ftell(fo) - p);
	}
end:	if(r[0]) {
	  rlseen_fix(s, fo, r[1]);
	  blk_destroy(r[0]);
	}
	return 0;
}

#undef N

static int rlseen_asm(FILE *fi) {
	uint a, *m[2] = { 0, 0 };
	if(a = rlseen_asm_local(fi, m)) printf("\n%%error");
	mem_free(m[0]); mem_free(m[1]);
	return a;
}

static int rlseen_get(FILE *fi) {
	uint a, *m = 0;
	if(a = rlseen_get_local(fi, &m)) printf("\n# error");
	mem_free(m);
	return a;
}

static int rlseen_put(FILE *fi, FILE *fo) {
	uint a, *m = 0;
	a = rlseen_put_local(fi, fo, &m);
	mem_free(m);
	return a;
}
