
/*
 00 file_size
 04 header_size = 0x14 | 0x1C | 0x24
 08 code_size
 0C string_index_size
 10 string_size
 14 data_byte
 18 data_word
 1C byte * 2, offset
 20 names
*/

static void* liar_load(FILE *fi, uint *h) {
	uint a, n, *m = 0;
	if(fread(h, 1, 0x14, fi) != 0x14) return m;

	if(h[0] < h[1] || h[3] & 3) return m;
	if((h[0] | h[2] | h[3] | h[4]) >> 26) return m;
	n = h[1] - 0x14;
	if(n > 0x24 - 0x14) return m;
	if(n) if(fread(h + 5, 1, n, fi) != n) return m;

	if(fseek(fi, 0, SEEK_END)) return m;
	n = ftell(fi); h[9] = n; n -= h[1];
	if(fseek(fi, h[1], SEEK_SET)) return m;
	a = h[2] + h[3] + h[4];
	if(n < a) return m;
	if(m = mem_alloc(n)) {
	  if(fread(m, 1, n, fi) != n) { mem_free(m); m = 0; }
	}
	return m;
}

static int liar_str(FILE *fo, uchar *m, uint n, uint p) {
	uint a, i;
	for(i = p; i < n; i++) {
	  if(!(a = m[i])) break;
	  if(fo) fputc(a, fo);
	  else text_putc(a);
	}
	return i - p;
}

static int liar_get(FILE *fi) {
	uint i, n, h[10], *t; uchar *m, *s;
	if(!(m = liar_load(fi, h))) return -1;
	n = h[3] >> 2; t = (uint*)(m + h[2]);
	s = m + h[2] + h[3];

	for(i = 0; i < n; i++) {
	  printf("%03i ", i);
	  liar_str(0, s, h[4], t[i]);
	  putchar('\n');
	}
	mem_free(m);
	return 0;
}

static int liar_put(FILE *fi, FILE *fo) {
	uint i = -1, n, h[10], x = 0, a, b = 0, *t; uchar *m, *s;
	if(!(m = liar_load(fi, h))) return -1;
	n = h[3] >> 2; t = (uint*)(m + h[2]);
	s = m + h[2] + h[3];

	fwrite(h, 1, h[1], fo);
	fwrite(m, 1, h[2] + h[3], fo);

	for(i = 0; i < n; i++) {
	  if(!x) x = text_num();
	  if(i == x) {
	    a = ftell(fo);
	    x = text_copy(fo);
	    a = ftell(fo) - a;
	  }
	  else a = liar_str(fo, s, h[4], t[i]);
	  fputc(0, fo);
	  t[i] = b;
	  b += a + 1;
	}
	n = h[1] + h[2] + h[3] + h[4];
	a = ftell(fo) - n;

	fwrite(m + n - h[1], 1, h[9] - n, fo);
	if(!fseek(fo, h[1] + h[2], SEEK_SET)) fwrite(m + h[2], 1, h[3], fo);

	h[0] += a; h[4] += a;
	if(!fseek(fo, 0, SEEK_SET)) fwrite(h, 1, h[1], fo);
	mem_free(m);
	return 0;
}
