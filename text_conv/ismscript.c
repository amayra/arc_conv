
static uint ismscript_check(uchar *m, uint n, uint i, uint *x) {
	uint j, a;

	if(i + 2 > n) return 0;
	if(m[i] != 0x33) return 0;
	j = m[i + 1]; a = 2;
	if(j == 0xFF) {
	   if(i + 4 > n) return 0;
	   j = *(uint*)(m + i + 2); a += 4;
	}
	if(i + a + j > n) return 0;
	*x = j;
	return a;
}

static uint ismscript_str(uchar *m, uint n, uint i, uint f) {
	uint a, x = 0, j;

	if(i + 2 > n) return i;
	if(m[i] != 0x33) return i;
	j = m[i + 1]; i += 2;
	if(j == 0xFF) {
	   if(i + 4 > n) return i;
	   j = *(uint*)(m + i); i += 4;
	}
	if(i + j > n) return i;

	if(f) printf(", {");
	if(j) do {
	  a = m[i++];
	  if(f) asmchar(&x, a);
	  else text_putc(a);
	} while(--j);
	if(f) { asmchar(&x, -1); putchar('}'); }
	else putchar('\n');
	return i;
}

static uint ismscript_puts(FILE *fo, uint i, uchar *s, uint n) {
	char x;

	x = ~i; if(!x) x = -1;
	putc(0x33, fo); i += 2;
	if(n < 0xFF) {
	  putc(n, fo);
	} else {
	  putc(0xFF, fo); fwrite(&n, 1, 4, fo); i += 4;
	}
	i += n;
	if(n) do {
	  putc(*s++ ^ x, fo);
	} while(--n);
	return i;
}

static int ismscript_code(uint a) {
	switch(a) {
	  // null
	  case 0x05: case 0x0B: case 0x0C: case 0x0D: case 0x0E: case 0x10: case 0x11: case 0x12: case 0x13: case 0x14:
	  case 0x15: case 0x16: case 0x17: case 0x18: case 0x19: case 0x1A: case 0x1B: case 0x1C: case 0x1D: case 0x1E:
	  case 0x1F: case 0x25: case 0x28: case 0x29: case 0x2C: case 0x2D: case 0x2E: case 0x2F:
	  case 0x40: case 0x41: case 0x43: case 0x44: case 0x46: case 0x47: case 0x50: case 0x52:
	  case 0x83: case 0x84: case 0x86: case 0x88: case 0x89: case 0x8B: case 0x8C: case 0x8E: case 0x8F: case 0x91: case 0x92: case 0x94:
	  case 0xA0: case 0xB0: case 0xB1: case 0xB2: case 0xC0: case 0xC1: case 0xD0: case 0xD2:
	  case 0xE0: case 0xE1: case 0xE2: case 0xE3: case 0xF0: case 0xF1: case 0xF2: case 0xF4: case 0xF5: case 0xF7: case 0xFC: case 0xFD: case 0xFE:
	    return 0;

	  // offset abs
	  case 0x45:
	    return 1;

	  // offset rel
	  case 0x20: case 0x21: case 0x24:
	    return 2;

	  // int32
	  case 0x23: case 0x30: case 0x31: case 0x38: case 0x3A: case 0x3E:
	    return 3;

	  // string
	  case 0x33:
	    return 4;

	  // switch
	  case 0x0F:
	    return 5;

	  // int8 + int32
	  case 0x39: case 0x3B:
	    return 6;

	  // int8
	  case 0xF3:
	    return 7;
	}
	return -1;
}

// 100017A0 load
// 10033420 opcode table

static void* ismscript_load(FILE *fi) {
	uint a, n, h[8]; uchar *m = 0;

	if(fread(h, 1, 0x20, fi) != 0x20) return m;
	if(memcmp(h, "ISM SCRIPT\x00\x00", 12)) return m;
	n = h[3];
	if(h[4] >= n) return m;
	if(h[4] < 0x20 + h[7] * 0xC + 0xC) return m;

	if(m = mem_alloc(n)) {
	  n -= 0x20;
	  memcpy(m, h, 0x20);
	  if(fread(m + 0x20, 1, n, fi) != n) { mem_free(m); m = 0; }
	}
	return m;
}

static uint ismscript_codesize(uint *h, void *r) {
	uint a, n, i = 0, j, x, size; uchar *m;

	if(r) {
	  for(i = 0; i < h[7]; i++) ref_add(r, h[8 + i * 3]);
	}

	size = n = h[3] - h[4];
	m = ((uchar*)h) + h[4];
	for(;;) {
	  if(i + 1 > n) return i;
	  a = m[i];
	  switch(a = ismscript_code(a)) {

	    case 1:	// offset abs
	      if(i + 5 > n) return i;
	      a = *(uint*)(m + i + 1);
	      if(!ismscript_check(m, i, a, &j)) return i;
	      ref_add(r, *(uint*)(m + i + 1));
	      i += 5; break;

	    case 2:	// offset rel
	      if(i + 5 > n) return i;
	      ref_add(r, *(uint*)(m + i + 1) + i);
	      i += 5; break;

	    case 3:	// int32
	      if(i + 5 > n) return i;
	      i += 5; break;

	    case 4:	// string
	      if(i + 2 > n) return i;
	      a = m[i + 1];
	      x = ~i; if((uchar)x == 0) x = -1;
	      j = 2;
	      if(a == 0xFF) {
	        if(i + 6 > n) return i;
	        a = *(uint*)(m + i + 2);
	        j += 4;
	      }
	      if(i + j + a > n) return i;
	      i += j;
	      if(a) do m[i++] ^= x; while(--a);
	      break;

	    case 5:	// switch
	      if(i + 9 > n) return i;
	      x = *(uint*)(m + i + 1);
	      j = *(uint*)(m + i + 5);
	      if(x < n) n = x;
	      if(x + 8 > size) return i;
	      ref_add(r, x);
	      ref_add(r, *(uint*)(m + x + 4) + i);

	      a = *(uint*)(m + x);
	      if(a == 0xFF000000) {
	        a = 4; if(x + 0xC + j * 4 > size) return i;
	      } else if(a == 0xFE000000) {
	        a = 8; if(x + 8 + j * 8 > size) return i;
	      } else return i;

	      if(j) do {
	        ref_add(r, *(uint*)(m + x + 0xC) + i);
	        x += a;
	      } while(--j);
	      i += 9; break;

	    case 6:	// int8 + int32
	      if(i + 6 > n) return i;
	      i += 6; break;

	    case 7:	// int8
	      if(i + 2 > n) return i;
	      i += 2; break;

	    default:
	      i++; break;
	  }
	}
}

static int ismscript_asm(FILE *fi) {
	uint a, n, i = 0, j, size, *h; uchar *m; void *r;

	if(!(h = ismscript_load(fi))) return -1;
	r = ref_alloc(h[3] - h[4]);
	m = ((uchar*)h) + h[4];
	size = ismscript_codesize(h, r);

	while(i < size) {
	  if(ref_check(r, i)) printf("_x%04X:\n", i);
	  j = ismscript_code(a = m[i]);
	  printf("m%i 0x%02X", j == -1 ? 0 : j, a);

	  switch(j) {
	    case 1:	// offset abs, string ptr
	      printf(", _x%04X", *(uint*)(m + i + 1));
	      i += 5; break;

	    case 2:	// offset rel
	      printf(", _x%04X", *(uint*)(m + i + 1) + i);
	      i += 5; break;

	    case 3:	// int32
	      printf(", 0x%08X", *(uint*)(m + i + 1));
	      i += 5; break;

	    case 4:	// string
	      i = ismscript_str(m, size, i, 1);
	      break;

	    case 5:	// switch
	      printf(", _x%04X, 0x%08X", *(uint*)(m + i + 1), *(uint*)(m + i + 5));
	      i += 9; break;

	    case 6:	// int8 + int32
	      printf(", 0x%02X, 0x%08X", m[i + 1], *(uint*)(m + i + 2));
	      i += 6; break;

	    case 7:	// int8
	      printf(", 0x%02X", m[i + 1]);
	      i += 2; break;

	    default:
	      i++; if(j) printf("\n# error"); break; 
	  }
	  putchar('\n');
	}
	mem_free(r); mem_free(h);
	return 0;
}

static int ismscript_get(FILE *fi) {
	uint a, n, i = 0, j, size, *h; uchar *m;

	if(!(h = ismscript_load(fi))) return -1;
	m = ((uchar*)h) + h[4];
	size = ismscript_codesize(h, 0);

	while(i < size) {
	  j = ismscript_code(a = m[i]);
	  switch(j) {

	    case 1:	// offset abs, string ptr
	      // printf("%05i ", i);
	      // ismscript_str(m, size, *(uint*)(m + i + 1), 0);
	      i += 5; break;

	    case 2:	// offset rel
	      i += 5; break;

	    case 3:	// int32
	      i += 5; break;

	    case 4:	// string
	      printf("%05i ", i);
	      i = ismscript_str(m, size, i, 0);
	      break;

	    case 5:	// switch
	      i += 9; break;

	    case 6:	// int8 + int32
	      i += 6; break;

	    case 7:	// int8
	      i += 2; break;

	    default:
	      i++; if(j) printf("\n# error"); break; 
	  }
	}
	mem_free(h);
	return 0;
}

#define N 0x1000

static int ismscript_put(FILE *fi, FILE *fo) {
	uint a, n, i = 0, j, size, *h, x = 0, p = 0; uchar *m;
	uchar t[N], *s; void *r[2] = { 0, 0 }; void *hash[2] = { 0, 0 };

	if(!(h = ismscript_load(fi))) return -1;
	m = ((uchar*)h) + h[4];
	size = ismscript_codesize(h, 0);
	fwrite(h, 1, h[4], fo);
	hashstr_alloc(hash, 0x1000, 0x8000);

	while(i < size) {
	  if(!x) x = text_num();
	  switch(ismscript_code(a = m[i])) {

	    case 1:	// offset abs, string ptr
	      j = *(uint*)(m + i + 1);
	      a = ismscript_check(m, size, j, &n);
	      s = m + j + a; j = 5;
	      goto str;

	    case 2:	// offset rel
	      j = 5; break;

	    case 3:	// int32
	      j = 5; break;

	    case 4:	// string
	      a = ismscript_check(m, size, i, &n);
	      s = m + i + a; j = a + n;
str:	      if(i == x) {
	        n = N; x = text_buf(t, &n); s = t;
	      }
	      a = hashstr_add(hash, p, s, n);
	      if(a == p) { p = ismscript_puts(fo, p, s, n); }
	      else { putc(0x45, fo); fwrite(&a, 1, 4, fo); p += 5; }
	      i += j; reloc_add(r, i, p - i);
	      j = 0; break;

	    case 5:	// switch
	      j = 9; break;

	    case 6:	// int8 + int32
	      j = 6; break;

	    case 7:	// int8
	      j = 2; break;

	    default:
	      j = 1; break;
	  }
	  if(j) { fwrite(m + i, 1, j, fo); i += j; p += j; }
	}
	blk_destroy(hash[0]);

	i = 0;
	while(i < size) {
	  switch(ismscript_code(a = m[i])) {

	    case 1:	// offset abs, string ptr
	      j = 5; break;

	    case 2:	// offset rel
	      j = 5; a = *(uint*)(m + i + 1);
	      x = reloc_fix(r[1], i);
	      if((n = reloc_fix(r[1], i + a) - x) != a) {
	        x += h[4] + 1;
	        // printf("change %08X %08X\n", x, n);
	        if(!fseek(fo, x, SEEK_SET)) fwrite(&n, 1, 4, fo);
	      }
	      break;

	    case 3:	// int32
	      j = 5; break;

	    case 4:	// string
	      a = ismscript_check(m, size, i, &n);
	      j = a + n; break;

	    case 5:	// switch
	      j = *(uint*)(m + i + 1);
	      if((x = reloc_fix(r[1], j)) != j) {
	        a = h[4] + reloc_fix(r[1], i + 1);
	        // printf("change %08X %08X\n", a, x);
	        if(!fseek(fo, a, SEEK_SET)) fwrite(&x, 1, 4, fo);
	      }
	      x = reloc_fix(r[1], i);
	      n = *(uint*)(m + i + 5);
	      *(uint*)(m + j + 4) = reloc_fix(r[1], *(uint*)(m + j + 4) + i) - x;

	      a = *(uint*)(m + j) << 7;
	      a = a ? 4 : 8;
	      if(n) do {
	        *(uint*)(m + j + 0xC) = reloc_fix(r[1], *(uint*)(m + j + 0xC) + i) - x;
	        j += a;
	      } while(--n);
	      j = 9; break;

	    case 6:	// int8 + int32
	      j = 6; break;

	    case 7:	// int8
	      j = 2; break;

	    default:
	      j = 1; break;
	  }
	  i += j;
	}

	a = h[3] - h[4] - size;
	if(!fseek(fo, h[4] + p, SEEK_SET)) fwrite(((uchar*)h) + (h[3] - a), 1, a, fo);

	h[3] = h[3] - size + p;
	for(i = 0; i < h[7]; i++) {
	  a = 8 + i * 3;
	  h[a] = reloc_fix(r[1], h[a]);
	}

	a = 0x20 + h[7] * 0xC + 0xC;
	m = (uchar*)h;
	size = h[4];
	n = *(uint*)(m + a - 0xC);

	for(i = 0; i < n; i++) {
	  if(a + 0xD > size) break;
	  *(uint*)(m + a) = reloc_fix(r[1], *(uint*)(m + a));
	  j = m[a + 0xC];
	  if((a += j + 0xE) > size) break;
	}
	if(!fseek(fo, 0, SEEK_SET)) fwrite(h, 1, h[4], fo);

	blk_destroy(r[0]);
	return 0;
}

#undef N


