
static void* hadaka_load(FILE *fi, uint *x) {
	uint a, n; uchar *m = 0, h[0x12];

	if(fread(h, 1, 0x12, fi) != 0x12) return m;
	if(memcmp(h, "HSL \x64\x00\x12\x00\x00\x00", 10)) return m;
	a = *(uint*)(h + 10);
	n = *(uint*)(h + 14);
	if(a < 0x12 || a > n || (n - a) & 3) return m;
	do {
	    if(fseek(fi, 0, SEEK_END)) break;
	    if((n = ftell(fi)) <= 0) break;
	    if(fseek(fi, 0, SEEK_SET)) break;
	    if(!(m = mem_alloc(n))) break;
	    if(fread(m, 1, n, fi) != n) { mem_free(m); m = 0; }
	} while(0);

	if(m) {
	  if(*(uint*)(h + 14) > n) { mem_free(m); m = 0; }
	  else memcpy(m, h, 0x12);
	}
	*x = n;
	return m;
}

// 00435AF5 opcode_read

static int hadaka_code(uint a) {

	switch(a) {
	  case 0x0085: case 0x00CB: case 0x0102: case 0x010A: case 0x012D: case 0x012E:
	  case 0x0132: case 0x0134: case 0x0135: case 0x0136: case 0x0137: case 0x0162: case 0xFFFF:
	    return 0;

	  case 0x0001: case 0x0081: case 0x0082: case 0x0083: case 0x0084: case 0x0086: case 0x0087: case 0x0088: case 0x008C:
	  case 0x0093: case 0x0094: case 0x0095: case 0x00A3: case 0x00FB: case 0x00FF:
	  case 0x0103: case 0x0112: case 0x0116: case 0x0127: case 0x0129: case 0x0133: case 0x0138: case 0x0161:
	    return 1;

	  case 0x0002: case 0x0003: case 0x008D:
	  case 0x0090: case 0x0096: case 0x0098: case 0x0099: case 0x009C: case 0x009E:
	  case 0x00A0: case 0x00A2: case 0x00A6: case 0x00CA: case 0x00D6: case 0x00D9: case 0x00FA:
	  case 0x0104: case 0x0107: case 0x0111: case 0x011D: case 0x0121: case 0x012F: case 0x015E: case 0x0190:
	    return 2;

	  case 0x00C9: case 0x00D5: case 0x00D7: case 0x00DA:
	  case 0x00FC: case 0x00FE: case 0x0109: case 0x0126: case 0x0131:
	    return 3;

	  case 0x0004: case 0x0005: case 0x0089: case 0x008A: case 0x008E: case 0x008F:
	  case 0x00A4: case 0x00D4: case 0x0110: case 0x0118: case 0x0120: case 0x0123: case 0x015F: case 0x0160:
	    return 4;

	  case 0x0092:
	    return 5;

	  case 0x008B: case 0x0100: case 0x011C:
	    return 6;

	  case 0x00C8: case 0x00D0: case 0x010E: case 0x0113: case 0x0119:
	  case 0x011A: case 0x011B: case 0x0128:
	    return 7;

	  case 0x011E: case 0x011F: case 0x012A: case 0x012B:
	    return 8;
	}
	return -1;
}

static int hadaka_jmp(uchar *m, uint n, void *r) {
	uint a, i = 0, k;

	while(i + 2 <= n) {
	  a = *(ushort*)(m + i); i += 2;
	  if(a == 0x80) { i += 4; continue; }

	  k = hadaka_code(a);
	  if(k == -1) continue;
 	  if(k) do {
	    if(i >= n) return -1;
	    a = m[i++];

	    if(a != 2) {
	      if(i + 4 > n) return -1;
	      if(a == 0x40) ref_add(r, *(uint*)(m + i));
	      i += 4;
	    } else {
	      if(i + 2 > n) return -1;
	      a = *(ushort*)(m + i); i += a + 2;
	    }
	  } while(--k);
	}
	return 0;
}

static int hadaka_blk(uchar *m, uint n, void *r) {
	uint a, i = 0, j, k, x;

	hadaka_jmp(m, n, r);

	while(i + 2 <= n) {
	  if(ref_check(r, i)) printf(".x%04X:\n", i);

	  a = *(ushort*)(m + i); i += 2;
	  if(a == 0x80) {
	    if(i + 4 > n) return -1;
	    printf("m2 %i\n", *(uint*)(m + i)); i += 4;
	    continue;
	  }

	  printf("m1 0x%04X", a);
	  k = hadaka_code(a);
	  if(k == -1) printf(" %%error");
 	  else if(k) do {
	    if(i >= n) return -1;
	    a = m[i++];
	    printf(", %i", a);

	    if(a == 0 || a == 1 || a == 3 || a == 5 || a == 6) {
	      if(i + 4 > n) return -1;
	      printf(",0x%08X", *(uint*)(m + i)); i += 4;

	    } else if(a == 2) {
	      if(i + 2 > n) return -1;
	      j = *(ushort*)(m + i); i += 2;
	      if(i + j > n) return -1;
	      x = 0; printf(",{");
	      if(j) do {
	        a = m[i++];
	        asmchar(&x, a);
	      } while(--j);
	      asmchar(&x, -1);
	      printf("}");

	    } else if(a == 0x40) {
	      if(i + 4 > n) return -1;
	      printf(",.x%04X", *(uint*)(m + i)); i += 4;

	    } else printf("%%error");

	  } while(--k);
	  printf("\n");
	}
	return 0;
}

static int hadaka_names(uchar *m) {
	uint a, i = 0x12, j, x, n;

	n = *(uint*)(m + 10);
	if(i + 2 > n) return -1;
	j = *(ushort*)(m + i); i += 2;
	if(i + j > n) return -1;
	x = 0; printf("m3 ");
	if(j) do {
	  a = m[i++]; asmchar(&x, a);
	} while(--j);
	asmchar(&x, -1); putchar('\n');

	if(i + 4 > n) return -1;
	printf("dd %i\n", *(uint*)(m + i)); i += 4;

	while(i + 2 <= n) {
	  j = *(ushort*)(m + i); i += 2;
	  if(i + j > n) return -1;
	  x = 0; printf("m3 ");
	  if(j) do {
	    a = m[i++]; asmchar(&x, a);
	  } while(--j);
	  asmchar(&x, -1); putchar('\n');
	}
	return 0;
}

static int hadaka_asm(FILE *fi) {
	uint a, i, n; uchar *m, *s; void *r;

	if(!(m = hadaka_load(fi, &n))) return -1;
	hadaka_names(m);

	printf("_t:\n");
	a = *(uint*)(m + 10);
	i = (*(uint*)(m + 14) - a) >> 2;
	s = m + a;
	if(i) do {
	  printf("dd _x%06X\n", *(uint*)s); s += 4;
	} while(--i);

	printf("_x:\n");
	a = *(uint*)(m + 14);
	s = m + a; n -= a;
	for(;;) {
	  if(n < 4) break; n -= 4;
	  printf("_x%06X:\ndd .e-.x\n.x:\n", s - m);
	  a = *(uint*)s; s += 4;
	  if(n < a) break;

	  r = ref_alloc(a);
	  hadaka_blk(s, a, r); n -= a; s += a;
	  mem_free(r);
	  printf(".e:\n");
	}
	mem_free(m);
	return 0;
}

