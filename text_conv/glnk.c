
static uchar* glnk_init(FILE *fi) {
	uint n, g = 0xE; uchar t[0x14], *m = 0;
	if(fread(t, 1, g, fi) != g) return m;
	if(!memcmp(t, "HMO \x64\x00", 6)) {
	  if(fread(t + g, 1, 4, fi) != 4) return m; g += 4;
	} else if(!memcmp(t, "BTMD\x64\x00", 6)) return m;
	n = *(uint*)(t + g - 8);
	m = malloc(n * 4 + g + 4);
	*(uint*)m = g;
	if(m) {
	  memcpy(m + 4, t, g);
	  if(fread(m + g + 4, 1, n * 4, fi) != n * 4) { free(m); m = 0; }
	}
	return m;
}

static int glnk_get_local(FILE *fi, uchar *m) {
	uint a, i, n, j, p, g = *(uint*)m;
	n = *(uint*)(m + 4 + g - 8); p = n * 4 + g;
	for(i = 0; i < n; i++) {
	  printf("%04i ", i);
	  if(fseek(fi, *(uint*)(m + 4 + g + i * 4) + p, SEEK_SET)) return -1;
	  READ(&j, 4);
	  if(j) do { LODSB; text_putc(~a); } while(--j);
	  putchar('\n');
	}
	return 0;
}

static int glnk_put_local(FILE *fi, FILE *fo, uchar *m) {
	uint a, i, n, j, p, x = 0, k, g = *(uint*)m;
	n = *(uint*)(m + 4 + g - 8); p = n * 4 + g;
	fwrite(m + 4, 1, p, fo);

	for(i = 0; i < n; i++) {
	  if(!x) x = text_num();
	  k = ftell(fo);
	  if(i == x) {
	    j = 0; fwrite(&j, 1, 4, fo);
	    for(;;) {
	      if((a = text_getc()) > -3) break;
	      fputc(~a, fo); j++;
	    }
	    x = -2 - a;
	    fseek(fo, k, SEEK_SET);
	    fwrite(&j, 1, 4, fo);
	    fseek(fo, k + j + 4, SEEK_SET);
	  } else {
	    if(fseek(fi, *(uint*)(m + 4 + g + i * 4) + p, SEEK_SET)) return -1;
	    READ(&j, 4); fwrite(&j, 1, 4, fo);
	    if(j) do { LODSB; fputc(a, fo); } while(--j);
	  }
	  *(uint*)(m + 4 + g + i * 4) = k - p;
	}
	*(uint*)(m + 4 + g - 4) = ftell(fo) - p;
	fseek(fo, 0, SEEK_SET);
	fwrite(m + 4, 1, p, fo);
	return 0;
}

static int glnk_get(FILE *fi) {
	uint a; uchar *m;
	if(!(m = glnk_init(fi))) return -1;
	a = glnk_get_local(fi, m);
	free(m);
	return a;
}

static int glnk_put(FILE *fi, FILE *fo) {
	uint a; uchar *m;
	if(!(m = glnk_init(fi))) return -1;
	a = glnk_put_local(fi, fo, m);
	free(m);
	return a;
}
