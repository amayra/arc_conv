
#define WILL_ROR2(a) (uchar)((a << 6) + (a >> 2))

static int will_ror2(FILE *fi, FILE *fo) {
	uint a;
	for(;;) { LODSB; fputc(WILL_ROR2(a), fo); }
	return 0;
}

static int will_read(FILE *fi, uchar *m, uint n) {
	uint a, i;
	READ(m, n);
	for(i = 0; i < n; i++) { a = m[i]; m[i] = WILL_ROR2(a); }
	return 0;
}

static int will_asmstr(FILE *fi, uint *p) {
	uint a, x = 0;
	printf(", {");
	for(;;) {
	  LODSB; (*p)++; if(!a) break;
	  a = WILL_ROR2(a);
	  asmchar(&x, a);
	}
	asmchar(&x, -1);
	putchar('}');
	return 0;
}

static int will_skipstr(FILE *fi, uint *p) {
	uint a;
	do { LODSB; (*p)++; } while(a);
	return 0;
}

static int will_str(FILE *fi, FILE *fo, uint *p) {
	uint a;
	if(!fo) printf("%04i ", *p);
	for(;;) {
	  LODSB; (*p)++;
	  if(!a) break;
	  a = WILL_ROR2(a);
	  if(fo) fputc(a, fo);
	  else text_putc(a);
	}
	if(fo) fputc(0, fo);
	else putchar('\n');
	return 0;
}

static void will_printf(uchar *src, uchar *fmt) {
	uint a;
	while(a = *fmt++) {
	  if(a == '1') { printf(", 0x%02X", *src++); }
	  else if(a == '2') { printf(", 0x%04X", *(ushort*)src); src += 2; }
	  else if(a == '4') { printf(", 0x%08X", *(uint*)src); src += 4; }
	  else if(a == 'x') { printf(", _x%04X", *(uint*)src); src += 4; }
	}
}

#define WILL_READ(t,n) if(will_read(fi, t, n)) return -1; p += n

static int will_get_local(FILE *fi, uchar *tab) {
	uint a, b, n, p = 0; uchar t[32];
	for(;;) {
	  LODSB; p++; a = WILL_ROR2(a);
	  b = tab[a]; if(b & 0x1F) WILL_READ(t, b & 0x1F); b >>= 5;

	  switch(a) {

	  case 0x02:
	    n = t[0];
	    if(n) do {
	      WILL_READ(t, 2);
	      if(will_str(fi, 0, &p)) return -1;
	      WILL_READ(t, 4);
	      if((a = t[3]) == 3) {
	        WILL_READ(t, 7);
	      } else if(a == 6) {
	        WILL_READ(t, 5);
	      } else if(a == 7) {
	        if(will_skipstr(fi, &p)) return -1;
	      }
	    } while(--n);
	    break;

	  case 0x42:
	    if(will_str(fi, 0, &p)) return -1;
	  case 0x41: case 0xB6:
	    if(will_str(fi, 0, &p)) return -1;
	    b = 6; break;
	  }

	  if(!b) { LODSB; p++; }
	  else if(b == 4) if(will_skipstr(fi, &p)) return -1;
	}
	return 0;
}

static int will_fix(FILE *fi, FILE *fo, void *m, uchar *tab) {
	uint a, b, n, p = 0, x; uchar t[32];

	if(fseek(fi, 0, SEEK_SET)) return -1;
	for(;;) {
	  if((a = fgetc(fi)) == EOF) break; p++; a = WILL_ROR2(a);
	  b = tab[a]; if(b & 0x1F) WILL_READ(t, b & 0x1F); b >>= 5;

	  switch(a) {

	  case 0x01:	  // relative jump
	    a = *(uint*)(t + 5); b = p + 1;
	    goto jmp;

	  case 0x06:	  // absolute jump
	    a = *(uint*)t; b = 0;

jmp:	    x = b; if(b) x = reloc_fix(m, b);
	    if((x = reloc_fix(m, a + b) - x) != a) {
	      a = reloc_fix(m, p - 4);
	      // printf("change %08X %08X\n", a, x);
	      if(fseek(fo, a, SEEK_SET)) return -1;
	      a = 0xFCFCFCFC; a = ((x << 2) & a) + ((x >> 6) & (~a));
	      fwrite(&a, 1, 4, fo);
	    }
	    break;

	  case 0x02:
	    n = t[0];
	    if(n) do {
	      WILL_READ(t, 2);
	      if(will_skipstr(fi, &p)) return -1;
	      WILL_READ(t, 4);
	      if((a = t[3]) == 3) {
	        WILL_READ(t, 7);
	      } else if(a == 6) {
	        WILL_READ(t, 5);
	      } else if(a == 7) {
	        if(will_skipstr(fi, &p)) return -1;
	      }
	    } while(--n);
	    break;

	  case 0x42:
	    if(will_skipstr(fi, &p)) return -1;
	    break;
	  }

	  if(!b) { LODSB; p++; }
	  else if(b == 4) if(will_skipstr(fi, &p)) return -1;
	}
	return 0;
}

static int will_put_local(FILE *fi, FILE *fo, uchar *tab) {
	uint a, i, p = 0, x = 0; void *r[2] = { 0, 0 };

	for(;;) {
	  if(!x) x = text_num();
	  // printf("replace %08X\n", x);
	  while(p != x) {
	    if((a = fgetc(fi)) == EOF) goto end; p++; fputc(a, fo);
	  }
	  for(;;) {
	    if((a = text_getc()) > -3) break;
	    fputc((uchar)((a << 2) + (a >> 6)), fo);
	  }
	  x = -2 - a;

	  do { if((a = fgetc(fi)) == EOF) goto end; p++; } while(a);
	  fputc(0, fo);

	  if(tab) reloc_add(r, p, ftell(fo) - p);
	}
end:	if(r[0]) {
	  will_fix(fi, fo, r[1], tab);
	  blk_destroy(r[0]);
	}
	return 0;
}

static int will_jmp(FILE *fi, uint *m, uint x, uchar *tab) {
	uint a, b, n, i = 1, p = 0; uchar t[32];
	*m = i;
	for(;;) {
	  if((a = fgetc(fi)) == EOF) break; p++; a = WILL_ROR2(a);
	  b = tab[a]; if(b & 0x1F) WILL_READ(t, b & 0x1F); b >>= 5;

	  switch(a) {

	  case 0x01:	  // relative jump
	    a = *(uint*)(t + 5) + p + 1;
	    goto jmp;

	  case 0x06:	  // absolute jump
	    a = *(uint*)t;
jmp:	    if(i == x) break;
	    if(x) m[i] = a; i++; *m = i;
	    break;

	  case 0x02:
	    n = t[0];
	    if(n) do {
	      WILL_READ(t, 2);
	      if(will_skipstr(fi, &p)) return -1;
	      WILL_READ(t, 4);
	      if((a = t[3]) == 3) {
	        WILL_READ(t, 7);
	      } else if(a == 6) {
	        WILL_READ(t, 5);
	      } else if(a == 7) {
	        if(will_skipstr(fi, &p)) return -1;
	      }
	    } while(--n);
	    break;

	  case 0x42:
	    if(will_skipstr(fi, &p)) return -1;
	    break;
	  }

	  if(!b) { LODSB; p++; }
	  else if(b == 4) if(will_skipstr(fi, &p)) return -1;
	}
	return 0;
}

#include "will_vm.c"

static int bloodycall_asm(FILE *fi) {
	uint a; uint *m = 0;
	if(a = bloodycall_asm_local(fi, &m)) printf("\n%%error");
	if(m) free(m);
	return a;
}

static int bloodycall_get(FILE *fi) {
	return will_get_local(fi, bloodycall_tab);
}

static int bloodycall_put(FILE *fi, FILE *fo) {
	return will_put_local(fi, fo, bloodycall_tab);
}

static int laughter_asm(FILE *fi) {
	uint a; uint *m = 0;
	if(a = laughter_asm_local(fi, &m)) printf("\n%%error");
	if(m) free(m);
	return a;
}

static int laughter_get(FILE *fi) {
	return will_get_local(fi, laughter_tab);
}

static int laughter_put(FILE *fi, FILE *fo) {
	return will_put_local(fi, fo, laughter_tab);
}

static int yumemiru_asm(FILE *fi) {
	uint a; uint *m = 0;
	if(a = yumemiru_asm_local(fi, &m)) printf("\n%%error");
	if(m) free(m);
	return a;
}

static int yumemiru_get(FILE *fi) {
	return will_get_local(fi, yumemiru_tab);
}

static int yumemiru_put(FILE *fi, FILE *fo) {
	return will_put_local(fi, fo, yumemiru_tab);
}

static int enzai_get_local(FILE *fi, uchar *tab) {
	uint a, b, n, p = 0; uchar t[32];
	for(;;) {
	  LODSB; p++; a = WILL_ROR2(a);
	  b = tab[a]; if(b & 0x1F) WILL_READ(t, b & 0x1F); b >>= 5;

	  switch(a) {

	  case 0x02:
	    n = t[0];
	    if(n) do {
	      WILL_READ(t, 2);
	      if(will_str(fi, 0, &p)) return -1;
	      WILL_READ(t, 1);
	      if((a = t[0]) == 3) {
	        WILL_READ(t, 7);
	      } else if(a == 6) {
	        WILL_READ(t, 5);
	      } else if(a == 7) {
	        if(will_skipstr(fi, &p)) return -1;
	      }
	    } while(--n);
	    break;

	  case 0x42:
	    if(will_str(fi, 0, &p)) return -1;
	  case 0x41: case 0xB6:
	    if(will_str(fi, 0, &p)) return -1;
	    b = 6; break;
	  }

	  if(!b) { LODSB; p++; }
	  else if(b == 4) if(will_skipstr(fi, &p)) return -1;
	}
	return 0;
}

static int enzai_fix(FILE *fi, FILE *fo, void *m, uchar *tab) {
	uint a, b, n, p = 0, x; uchar t[32];

	if(fseek(fi, 0, SEEK_SET)) return -1;
	for(;;) {
	  if((a = fgetc(fi)) == EOF) break; p++; a = WILL_ROR2(a);
	  b = tab[a]; if(b & 0x1F) WILL_READ(t, b & 0x1F); b >>= 5;

	  switch(a) {

	  case 0x01:	  // relative jump
	    a = *(uint*)(t + 5); b = p + 1;
	    goto jmp;

	  case 0x06:	  // absolute jump
	    a = *(uint*)t; b = 0;

jmp:	    x = b; if(b) x = reloc_fix(m, b);
	    if((x = reloc_fix(m, a + b) - x) != a) {
	      a = reloc_fix(m, p - 4);
	      // printf("change %08X %08X\n", a, x);
	      if(fseek(fo, a, SEEK_SET)) return -1;
	      a = 0xFCFCFCFC; a = ((x << 2) & a) + ((x >> 6) & (~a));
	      fwrite(&a, 1, 4, fo);
	    }
	    break;

	  case 0x02:
	    n = t[0];
	    if(n) do {
	      WILL_READ(t, 2);
	      if(will_skipstr(fi, &p)) return -1;
	      WILL_READ(t, 1);
	      if((a = t[0]) == 3) {
	        WILL_READ(t, 7);
	      } else if(a == 6) {
	        WILL_READ(t, 5);
	      } else if(a == 7) {
	        if(will_skipstr(fi, &p)) return -1;
	      }
	    } while(--n);
	    break;

	  case 0x42:
	    if(will_skipstr(fi, &p)) return -1;
	    break;
	  }

	  if(!b) { LODSB; p++; }
	  else if(b == 4) if(will_skipstr(fi, &p)) return -1;
	}
	return 0;
}

static int enzai_put_local(FILE *fi, FILE *fo, uchar *tab) {
	uint a, i, p = 0, x = 0; void *r[2] = { 0, 0 };

	for(;;) {
	  if(!x) x = text_num();
	  // printf("replace %08X\n", x);
	  while(p != x) {
	    if((a = fgetc(fi)) == EOF) goto end; p++; fputc(a, fo);
	  }
	  for(;;) {
	    if((a = text_getc()) > -3) break;
	    fputc((uchar)((a << 2) + (a >> 6)), fo);
	  }
	  x = -2 - a;

	  do { if((a = fgetc(fi)) == EOF) goto end; p++; } while(a);
	  fputc(0, fo);

	  if(tab) reloc_add(r, p, ftell(fo) - p);
	}
end:	if(r[0]) {
	  enzai_fix(fi, fo, r[1], tab);
	  blk_destroy(r[0]);
	}
	return 0;
}

static int enzai_jmp(FILE *fi, uint *m, uint x, uchar *tab) {
	uint a, b, n, i = 1, p = 0; uchar t[32];
	*m = i;
	for(;;) {
	  if((a = fgetc(fi)) == EOF) break; p++; a = WILL_ROR2(a);
	  b = tab[a]; if(b & 0x1F) WILL_READ(t, b & 0x1F); b >>= 5;

	  switch(a) {

	  case 0x01:	  // relative jump
	    a = *(uint*)(t + 5) + p + 1;
	    goto jmp;

	  case 0x06:	  // absolute jump
	    a = *(uint*)t;
jmp:	    if(i == x) break;
	    if(x) m[i] = a; i++; *m = i;
	    break;

	  case 0x02:
	    n = t[0];
	    if(n) do {
	      WILL_READ(t, 2);
	      if(will_skipstr(fi, &p)) return -1;
	      WILL_READ(t, 1);
	      if((a = t[0]) == 3) {
	        WILL_READ(t, 7);
	      } else if(a == 6) {
	        WILL_READ(t, 5);
	      } else if(a == 7) {
	        if(will_skipstr(fi, &p)) return -1;
	      }
	    } while(--n);
	    break;

	  case 0x42:
	    if(will_skipstr(fi, &p)) return -1;
	    break;
	  }

	  if(!b) { LODSB; p++; }
	  else if(b == 4) if(will_skipstr(fi, &p)) return -1;
	}
	return 0;
}

static int enzai_asm(FILE *fi) {
	uint a; uint *m = 0;
	if(a = enzai_asm_local(fi, &m)) printf("\n%%error");
	if(m) free(m);
	return a;
}

static int enzai_get(FILE *fi) {
	return enzai_get_local(fi, enzai_tab);
}

static int enzai_put(FILE *fi, FILE *fo) {
	return enzai_put_local(fi, fo, enzai_tab);
}

static int will_put(FILE *fi, FILE *fo) {
	return will_put_local(fi, fo, 0);
}

static int will_strtest(FILE *fi, uint *i, uint a, uchar *t) {
	if(a == 0x41) {
	  if(will_read(fi, t, 3)) return -1;
	} else if(a == 0x42) {
	  if(will_read(fi, t, 4)) return -1;
	} else if(a == 0xB6) {
	  if(will_read(fi, t, 2)) return -1;
	} else if(a == 0x02) {
	  if(will_read(fi, t, 2)) return -1;
	  if(t[0] < 1 || t[1]) return -1;
	  if(will_read(fi, t, 2)) return -1;
	}
	if((uint)(*(ushort*)t - *i - 1) < 3) { *i = *(ushort*)t; return 0; }
	return -1;
}

static int will_get(FILE *fi) {
	uint a = 0, b, i = -1, p = 0, n; uchar t[8];
	for(;;) {
	  b = a; LODSB; p++; a = WILL_ROR2(a);

	  if(!b) switch(a) {

	  case 0x02:
	    if(will_strtest(fi, &i, a, t)) goto err;
	    if(fseek(fi, p, SEEK_SET)) return -1;
	    WILL_READ(t, 2);
	    n = t[0];
	    if(n) do {
	      WILL_READ(t, 2); i = *(ushort*)t;
	      if(will_str(fi, 0, &p)) return -1;
	      WILL_READ(t, 4);
	      if((a = t[3]) == 3) {
	        WILL_READ(t, 7);
	      } else if(a == 6) {
	        WILL_READ(t, 5);
	      } else if(a == 7) {
	        if(will_skipstr(fi, &p)) return -1;
	      }
	    } while(--n);
	    a = 0; break;

	  case 0x41:
	    if(will_strtest(fi, &i, a, t)) goto err; p += 3;
	    goto str;

	  case 0x42:
	    if(will_strtest(fi, &i, a, t)) goto err; p += 4;
	    if(will_str(fi, 0, &p)) return -1;
	    goto str;

	  case 0xB6:
	    if(will_strtest(fi, &i, a, t)) goto err; p += 2;
str:	    if(will_str(fi, 0, &p)) return -1;
	    a = 0; break;

err:	    if(fseek(fi, p, SEEK_SET)) return -1;
	    break;
	  }
	}
	return 0;
}

#undef WILL_READ
#undef WILL_ROR2
