
static int sysadv_code(uint a) {

	// 0x01 - code
	// 0x05 - string
	// 0x1D - checkpoint
	// 0x1E - linenumber
	// 0x1A - offset

	switch(a) {
	  case 0x01: case 0x02: case 0x03: case 0x04:
	  case 0x1A: case 0x1C: case 0x1D: case 0x1E:
	    return 1;
	  case 0x00: case 0x06: case 0x07: case 0x11: case 0x14: case 0x15: case 0x19:
	    return 0;
	  case 0x05:
	    return 2;
	}
	return -1;
}

static void* sysadv_load(FILE *fi) {
	uint a, n, h[4]; uchar *m = 0;
	if((a = fgetc(fi)) == EOF) return m;
	if((uchar)a != 0xFF) return m;
	if(fread(h, 1, 0xC, fi) != 0xC) return m;
	if(h[1] & 3) return m;

	if(fseek(fi, 0, SEEK_END)) return m;
	n = ftell(fi) - 0xD;
	if(fseek(fi, 0xD, SEEK_SET)) return m;
	if((h[1] | h[2]) >> 28) return m;
	a = h[1] + h[2];
	if(n < a) return m;
	h[3] = n - a;
	if(m = mem_alloc(n + 0x10)) {
	  memcpy(m, h, 0x10);
	  if(fread(m + 0x10, 1, n, fi) != n) { mem_free(m); m = 0; }
	  a = 0x10 + h[1];
	  for(n = a + h[2]; a < n; a++) m[a] ^= 0xFF;
	}
	return m;
}

static void sysadv_label(uchar *m, uint p) {
	uint i, j, n, x; uchar *d;
	d = (uchar*)(m + 0x10 + *(uint*)(m + 4) + *(uint*)(m + 8));
	x = *(uint*)(m + 0xC);
	if(x > 4) {
	  n = *(uint*)d; i = 4;
	  if(n) do {
	    if((i += 5) > x) break;
	    j = d[i - 5]; if((i += j) > x) break;
	    if(p == (*(uint*)(d + i - 4) >> 2)) {
	      if(j) do text_putc(d[i - 4 - j]); while(--j);
	      return;
	    }
	  } while(--n);
	}
	printf("%i", p);
}

static int sysadv_asm(FILE *fi) {
	uint a, i, p, j, n, x, *s; uchar *m, *d; void *r;
	if(!(m = sysadv_load(fi))) return -1;

	r = ref_alloc(*(uint*)(m + 4) >> 2);
	d = (uchar*)(m + 0x10 + *(uint*)(m + 4) + *(uint*)(m + 8));
	x = *(uint*)(m + 0xC);

	if(x > 4) {
	  n = *(uint*)d; i = 4;
	  if(n) do {
	    if((i += 5) > x) break;
	    i += d[i - 5]; if(i > x) break;
	    ref_add(r, *(uint*)(d + i - 4) >> 2);
	  } while(--n);
	}
	s = (uint*)(m + 0x10); n = *(uint*)(m + 4) >> 2;
	p = 0; while(p < n) {
	  j = sysadv_code(a = s[p++]);
	  if(j == -1) j = 0;
	  if((p += j) > n) break;
	  if(a == 0x1A || a == 0x1C) ref_add(r, s[p - 1] >> 2);
	}

	d = (uchar*)(s + n); x = *(uint*)(m + 8);
	p = 0; while(p < n) {
	  if(ref_check(r, p)) { putchar(':'); sysadv_label(m, p); putchar('\n'); }
	  j = sysadv_code(a = s[p++]);
	  switch(a) {
	    case 0x01: printf("call"); break;
	    case 0x05: printf("push"); break;
	    case 0x1A: printf("goto"); break;
	    default: printf("x%02X", a); break;
	  }
	  if(j == -1) { j = 0; printf("\n# error"); }
	  if((p + j) > n) { printf("\n# error\n"); break; }

	  switch(a) {
	    case 0x05:
	      if((i = s[p++]) != -1) printf("x %i", i);
	    case 0x01:
	      putchar(' ');
	      i = s[p++];
	      while(i < x) {
	        if(!(a = d[i++])) break;
	        text_putc(a);
	      }
	      break;

	    case 0x1A: case 0x1C:
	      putchar(' ');
	      sysadv_label(m, s[p++] >> 2);
	      break;

	    default:
	      if(j) do printf(" %i", s[p++]); while(--j);
	      break;
	  }
	  putchar('\n');
	}
	mem_free(r); mem_free(m);
	return 0;
}
