
static int baldrbin_get(FILE *fi) {
	uint a, i, n;
	READ(&n, 4);
	if(fseek(fi, n * 8 + 4, SEEK_SET)) return -1;
	READ(&n, 4);
	for(i = 0; i < n; i++) {
	  printf("%03i ", i);
	  for(;;) {
	    LODSB;
	    if(!a) break;
	    text_putc(a);
	  }
	  putchar('\n');
	}
	return 0;
}

static int baldrbin_put(FILE *fi, FILE *fo) {
	uint a, i, n, x = 0, t[2];

	READ(&n, 4); fwrite(&n, 1, 4, fo);
	for(i = 0; i < n; i++) {
	  READ(t, 8); fwrite(t, 1, 8, fo);
	}
	READ(&n, 4); fwrite(&n, 1, 4, fo);

	for(i = 0; i < n; i++) {
	  if(!x) x = text_num();
	  if(i == x) {
	    x = text_copy(fo);
	    fputc(0, fo);
	    do LODSB; while(a);
	  } else do {
	    LODSB; fputc(a, fo);
	  } while(a);
	}
	for(;;) { LODSB; fputc(a, fo); }
	return 0;
}

static int baldrconf_get_local(FILE *fi, uint *m, uint n) {
	uint a, i, p = 0;
	READ(m, n << 2);
	for(;;) for(i = 0; i < n; i++) switch(m[i]) {
	  case 1:
	    LODSB;
	    printf("%03i ", p++);
	    if(a) do { text_putc(a); LODSB; } while(a);
	    putchar('\n');
	    break;

	  case 2:
	    READ(&a, 4);
	    break;

	  default:
	    return -1;
	}
	return 0;
}

static int baldrconf_get(FILE *fi) {
	uint a; uint *m;
	READ(&a, 4);
	if(!a) return 0;
	if(!(m = malloc(a << 2))) return -1;
	a = baldrconf_get_local(fi, m, a);
	free(m);
	return a;
}

static int baldrconf_put_local(FILE *fi, FILE *fo, uint *m, uint n) {
	uint a, i, p = 0, x = 0;
	READ(m, n << 2); fwrite(m, 1, n << 2, fo);
	for(;;) for(i = 0; i < n; i++) switch(m[i]) {
	  case 1:
	    if(!x) x = text_num();
	    if(p++ == x) {
	      x = text_copy(fo);
	      fputc(0, fo);
	      do LODSB; while(a);
	    } else do {
	      LODSB; fputc(a, fo);
	    } while(a);
	    break;

	  case 2:
	    READ(&a, 4); fwrite(&a, 1, 4, fo);
	    break;

	  default:
	    return -1;
	}
	return 0;
}

static int baldrconf_put(FILE *fi, FILE *fo) {
	uint a; uint *m;
	READ(&a, 4); fwrite(&a, 1, 4, fo);
	if(!a) return 0;
	if(!(m = malloc(a << 2))) return -1;
	a = baldrconf_put_local(fi, fo, m, a);
	free(m);
	return a;
}

static int baldrwaz_put(FILE *fi, FILE *fo) {
	uint a, p = 0, x = 0;

	for(;;) {
	  if(!x) x = text_num();
	  // printf("replace %08X\n", x);
	  while(p != x) {
	    if((a = fgetc(fi)) == EOF) return 0; p++; fputc(a, fo);
	  }
	  x = text_copy(fo);
	  do { if((a = fgetc(fi)) == EOF) return 0; p++; } while(a);
	  fputc(0, fo);
	}
	return 0;
}

static int baldr_str(FILE *fi, uint *p) {
	uint a;
	printf("%05i ", *p);
	for(;;) {
	  LODSB; (*p)++; if(!a) break;
	  text_putc(a);
	}
	putchar('\n');
	return 0;
}

static int baldrwaz_test(FILE *fi) {
	uint a, n = 0;
	for(;;) {
	  LODSB; n++;
	  if(a < 0x20) {
	    if(!a) break;
	    if(a != '\t' && a != '\n' && a != '\r') return 0;
	  } else if(a > 0x7F) {
	    if((uint)(a - 0x81) >= 0x7C) return 0;
	    if((uint)(a - 0xA0) >= 0x40) {
	      LODSB; n++;
	      if((uint)(a - 0x40) >= 0xBD || a == 0x7F) return 0;
	    } else if(a == 0xA0) return 0;
	  }
	}
	return n;
}

static int baldrwaz_get(FILE *fi) {
	uint a, i, p = 0; uchar t[0x20];
	for(;;) {
	  LODSB; p++;
loop:	  if(a != 1) continue;
	  LODSB; p++; if(a) goto loop;
	  LODSB; p++; if(a) goto loop;
	  LODSB; p++; if(a) goto loop;

	  if(baldrwaz_test(fi) > 1 && baldrwaz_test(fi) > 1) {
	    if(fseek(fi, p, SEEK_SET)) return -1;
	    if(baldr_str(fi, &p)) return -1;
	    if(baldr_str(fi, &p)) return -1;
	  } else {
	    if(fseek(fi, p, SEEK_SET)) return -1;
	  }
	}
	return 0;
}

static int baldrmek_fix(FILE *fo, void *m, uint *h) {
	uint i;

	if(fseek(fo, 0, SEEK_SET)) return -1;
	for(i = 1; i < 6; i++) h[i] = reloc_fix(m, h[i]);
	fwrite(h, 1, 0x18, fo);
	return 0;
}

static int baldrmek_put(FILE *fi, FILE *fo) {
	uint a, i, p = 0x18, x = 0; uint h[6]; void *r[2] = { 0, 0 };

	READ(h, 0x18); if(h[0] != 0x18) return -1;

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
	  baldrmek_fix(fo, r[1], h);
	  blk_destroy(r[0]);
	}
	return 0;
}

static int baldrmek_get(FILE *fi) {
	uint i, n, p = 0x18; uint h[6]; uchar t[0x4C];

	READ(h, 0x18); if(h[0] != 0x18) return -1;

	printf("# 0\n");
	for(i = 0; i < 5; i++) if(baldr_str(fi, &p)) return -1;

	p = h[2];
	if(fseek(fi, p, SEEK_SET)) return -1;
	READ(&n, 4); p += 4;
	for(i = 0; i < n; i++) {
	  printf("# 2,%i\n", i);
	  READ(t, 4); p += 4;
	  if(*(uint*)t != 1) printf("%error\n");
	  if(baldr_str(fi, &p)) return -1;
	  if(baldr_str(fi, &p)) return -1;
	  if(baldr_str(fi, &p)) return -1;
	  READ(t, 0x4C); p += 0x4C;
	}

	p = h[3];
	if(fseek(fi, p, SEEK_SET)) return -1;
	printf("# 3\n");
	READ(t, 4); p += 4;
	if(baldr_str(fi, &p)) return -1;
	if(baldr_str(fi, &p)) return -1;

	p = h[4];
	if(fseek(fi, p, SEEK_SET)) return -1;
	READ(t, 4); p += 4;
	for(i = 0; i < 2; i++) {
	  READ(&n, 4); p += 4;
	  if(n) {
	    printf("# 4,%i\n", i); n <<= 1;
	    do if(baldr_str(fi, &p)) return -1; while(--n);
	  }
	}
	return 0;
}

static int baldr_get(FILE *fi) {
	CHAR *ext = getpathext(in_file);
	if(!cmps(ext, ".bin")) return baldrbin_get(fi);
	if(!cmps(ext, ".dat")) return baldrconf_get(fi);
	if(!cmps(ext, ".waz")) return baldrwaz_get(fi);
	if(!cmps(ext, ".mek")) return baldrmek_get(fi);
	return -1;
}

static int baldr_put(FILE *fi, FILE *fo) {
	CHAR *ext = getpathext(in_file);
	if(!cmps(ext, ".bin")) return baldrbin_put(fi, fo);
	if(!cmps(ext, ".dat")) return baldrconf_put(fi, fo);
	if(!cmps(ext, ".waz")) return baldrwaz_put(fi, fo);
	if(!cmps(ext, ".mek")) return baldrmek_put(fi, fo);
	return -1;
}
