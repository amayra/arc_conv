
/*
 VERS	4-"Daibanchou -Big Bang Age-", 5-"Sengoku Rance", 6-"Rance02"
 KEYC	0 if VERS==5
 CODE
 FUNC
 GLOB
 GSET
 STRT
 MSG0	string list
 MAIN
 MSGF
 HLL0
 SWI0
 GVER
 STR0	string list
 FNAM	string list
 OJMP
 FNCT
 OBJG	string list
*/

static int rance_tag(FILE *fi, uchar *t, uchar x[5]) {
	uint i, p = ftell(fi);
	READ(t, 8);
	printf("# %08X %c%c%c%c %08X\n", p, t[0], t[1], t[2], t[3], *(uint*)(t+4));
	if(x) for(i = 0; i < 4; i++) if(t[i] != x[i]) return -1;
	return 0;
}

static int rance_str(FILE *fi, FILE *fo, uint *i) {
	uint a;
	if(i) {
	  i[0] += 1;
	  if(fo) {
	    if(!i[1]) i[1] = text_num();
	    if(i[0] == i[1]) {
	      i[1] = text_copy(fo); fputc(0, fo);
	      do LODSB; while(a);
	      return 0;
	    }
	  } else printf("%05i ", *i);
	}
	for(;;) {
	  LODSB;
	  if(!a) break;
	  if(fo) fputc(a, fo);
	  else if(i) text_putc(a);
	}
	if(i) {
	  if(fo) fputc(0, fo);
	  else putchar('\n');
	}
	return 0;
}

#define RANCE_TAG(x) if(rance_tag(fi, t, x)) return -1; n = *(uint*)(t + 4)
#define RANCE_SKIP i++; if(rance_str(fi, 0, 0)) return -1
#define RANCE_COPY if(rance_str(fi, 0, &i)) return -1

static int rance_get(FILE *fi) {
	uint a, n, i = -1, j, v; uchar t[0x18];

	RANCE_TAG("VERS"); v = n;
	if((uint)(n - 4) > 3) return -1;

	RANCE_TAG("KEYC");

	RANCE_TAG("CODE");
	if(fseek(fi, n, SEEK_CUR)) return -1;

	RANCE_TAG("FUNC");
	if(n) do {
	  READ(&a, 4);		// code offset
	  RANCE_SKIP;
	  READ(t, 0x18);	// ?, ?, ?, ?, params, hash
	  j = *(uint*)(t + 0x10);
	  if(j) do {
	    RANCE_SKIP; READ(t, 0x0C);
	  } while(--j);
	} while(--n);

	RANCE_TAG("GLOB"); j = v < 5 ? 0xC : 0x10;
	if(n) do {
	  RANCE_SKIP; READ(t, j);
	} while(--n);

	RANCE_TAG("GSET");
	if(n) do {
	  READ(t, 8);
	  a = *(uint*)(t + 4);
	  if(a == 0xC) { RANCE_SKIP; }
	  else READ(t, 4);
	} while(--n);

	RANCE_TAG("STRT");
	if(n) do {
	  RANCE_SKIP; READ(t, 0xC);
	  j = *(uint*)(t + 8);
	  if(j) do {
	    RANCE_SKIP; READ(t, 0xC);
	  } while(--j);
	} while(--n);

	RANCE_TAG("MSG0");
	if(n) do { RANCE_COPY; } while(--n);

	RANCE_TAG("MAIN");

	RANCE_TAG("MSGF");

	RANCE_TAG("HLL0");
	if(n) do {
	  RANCE_SKIP; READ(&j, 4);
	  if(j) do {
	    RANCE_SKIP; READ(t, 8);
	    a = *(uint*)(t + 4);
	    if(a) do {
	      RANCE_SKIP; READ(t, 4);
	    } while(--a);
	  } while(--j);
	} while(--n);

	RANCE_TAG("SWI0");
	if(n) do {
	  READ(t, 0xC);
	  j = *(uint*)(t + 8);
	  if(j) do READ(t, 8); while(--j);
	} while(--n);

	RANCE_TAG("GVER");

	RANCE_TAG("STR0");
	if(n) do { RANCE_COPY; } while(--n);

	RANCE_TAG("FNAM");
	if(n) do { RANCE_COPY; } while(--n);

	RANCE_TAG("OJMP");

	RANCE_TAG("FNCT");
	if(fseek(fi, n - 4, SEEK_CUR)) return -1;

	RANCE_TAG("OBJG");
	if(n) do { RANCE_COPY; } while(--n);

	RANCE_TAG(0);
	return 0;
}

#undef RANCE_TAG
#undef RANCE_SKIP
#undef RANCE_COPY

#define RANCE_TAG(x) if(rance_tag(fi, t, x)) return -1; n = *(uint*)(t + 4); fwrite(t, 1, 8, fo)
#define RANCE_READ(t, x) READ(t, x); fwrite(t, 1, x, fo);
#define RANCE_COPY if(rance_str(fi, fo, i)) return -1

static int rance_put(FILE *fi, FILE *fo) {
	uint a, n, i[2] = { -1, 0 }, j, v; uchar t[0x18];

	RANCE_TAG("VERS"); v = n;
	if((uint)(n - 4) > 3) return -1;

	RANCE_TAG("KEYC");

	RANCE_TAG("CODE");
	if(n) do { LODSB; fputc(a, fo);	} while(--n);

	RANCE_TAG("FUNC");
	if(n) do {
	  RANCE_READ(&a, 4);		// code offset
	  RANCE_COPY;
	  RANCE_READ(t, 0x18);	// ?, ?, ?, ?, params, hash
	  j = *(uint*)(t + 0x10);
	  if(j) do {
	    RANCE_COPY; RANCE_READ(t, 0x0C);
	  } while(--j);
	} while(--n);

	RANCE_TAG("GLOB"); j = v < 5 ? 0xC : 0x10;
	if(n) do {
	  RANCE_COPY; RANCE_READ(t, j);
	} while(--n);

	RANCE_TAG("GSET");
	if(n) do {
	  RANCE_READ(t, 8);
	  a = *(uint*)(t + 4);
	  if(a == 0xC) { RANCE_COPY; }
	  else { RANCE_READ(t, 4); }
	} while(--n);

	RANCE_TAG("STRT");
	if(n) do {
	  RANCE_COPY; RANCE_READ(t, 0xC);
	  j = *(uint*)(t + 8);
	  if(j) do {
	    RANCE_COPY; RANCE_READ(t, 0xC);
	  } while(--j);
	} while(--n);

	RANCE_TAG("MSG0");
	if(n) do { RANCE_COPY; } while(--n);

	RANCE_TAG("MAIN");

	RANCE_TAG("MSGF");

	RANCE_TAG("HLL0");
	if(n) do {
	  RANCE_COPY; RANCE_READ(&j, 4);
	  if(j) do {
	    RANCE_COPY; RANCE_READ(t, 8);
	    a = *(uint*)(t + 4);
	    if(a) do {
	      RANCE_COPY; RANCE_READ(t, 4);
	    } while(--a);
	  } while(--j);
	} while(--n);

	RANCE_TAG("SWI0");
	if(n) do {
	  RANCE_READ(t, 0xC);
	  j = *(uint*)(t + 8);
	  if(j) do { RANCE_READ(t, 8); } while(--j);
	} while(--n);

	RANCE_TAG("GVER");

	RANCE_TAG("STR0");
	if(n) do { RANCE_COPY; } while(--n);

	RANCE_TAG("FNAM");
	if(n) do { RANCE_COPY; } while(--n);

	RANCE_TAG("OJMP");

	RANCE_TAG("FNCT");
	if((int)(n -= 4) > 0) do { LODSB; fputc(a, fo);	} while(--n);

	RANCE_TAG("OBJG");
	if(n) do { RANCE_COPY; } while(--n);

	RANCE_TAG(0);
	return 0;
}

#undef RANCE_TAG
#undef RANCE_READ
#undef RANCE_COPY
