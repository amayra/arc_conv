
/*
  "Shinkon-san (Trial)"
  shinkon.exe
  00411200 vm
*/

static int lcse_asm(FILE *fi) {
	uint a, p = 0, n, t[3], x;
	READ(t, 8);
	if(n = t[0]) do {
	  READ(t, 0xC);
	  if(t[0] == 0x11 && t[1] == 2) {
	    printf("m1 0x%02X, %i, _s%04X-_s\n", t[0], t[1], t[2]);
	  } else {
	    printf("m1 0x%02X, 0x%08X, 0x%08X\n", t[0], t[1], t[2]);
	  }
	} while(--n);
	printf("_s:\n");

	for(;;) {
	  if(fread(&n, 1, 4, fi) != 4) break;
	  printf("m2 _s%04X, {", p); p += n + 4;
	  x = 0;
	  if(!n) printf("\n%%error"); else {
	    if(--n) do { LODSB; asmchar(&x, a); } while(--n);
	    LODSB; if(a) printf("\n%%error");
	  }
	  asmchar(&x, -1); printf("}\n");
	}
	printf("_e:\n");
	return 0;
}

static int lcse_get(FILE *fi) {
	uint a, i = 0, n, t[2];
	READ(t, 8);
	a = t[0] * 0xC + 8;
	if(fseek(fi, a, SEEK_SET)) return -1;
	for(;;) {
	  if(fread(&n, 1, 4, fi) != 4) break;
	  printf("%03i ", i++);
	  if(!n) printf("# error"); else {
	    if(--n) do { LODSB; text_putc(a); } while(--n);
	    LODSB; if(a) printf("\n# error");
	  }
	  putchar('\n');
	}
	return 0;
}

static int lcse_fix(FILE *fi, FILE *fo, void *m) {
	uint n, t[3];
	if(fseek(fi, 0, SEEK_SET)) return -1;
	if(fseek(fo, 0, SEEK_SET)) return -1;
	READ(t, 8);
	t[1] = reloc_fix(m, t[1]);
	fwrite(t, 1, 8, fo);
	if(n = t[0]) do {
	  READ(t, 0xC);
	  if(t[0] == 0x11 && t[1] == 2) t[2] = reloc_fix(m, t[2]);
	  fwrite(t, 1, 0xC, fo);
	} while(--n);
	return 0;
}

static int lcse_put(FILE *fi, FILE *fo) {
	uint a, i = 0, n, t[3], x = 0, k, p; void *r[2] = { 0, 0 };
	READ(t, 8);
	fwrite(t, 1, 8, fo);
	p = k = t[0] * 0xC + 8;
	if(n = t[0]) do {
	  READ(t, 0xC);
	  fwrite(t, 1, 0xC, fo);
	} while(--n);

	for(;;) {
	  if(!x) x = text_num();
	  if(fread(&n, 1, 4, fi) != 4) break;
	  fwrite(&n, 1, 4, fo);
	  if(i == x) {
	    if(n) do if((a = fgetc(fi)) == EOF) goto end; while(--n);
	    for(;;) {
	      n++; if((a = text_getc()) > -3) break;
	      fputc(a, fo);
	    }
	    x = -2 - a;
	    fputc(0, fo);
	    fseek(fo, p, SEEK_SET);
	    fwrite(&n, 1, 4, fo); p += n + 4;
	    fseek(fo, p, SEEK_SET);

	    a = ftell(fi);
	    reloc_add(r, a - k, p - a);
	  } else {
	    p += n + 4;
	    if(n) do { if((a = fgetc(fi)) == EOF) goto end; fputc(a, fo); } while(--n);
	  }
	  i++;
	}

end:	if(r[0]) {
	  lcse_fix(fi, fo, r[1]);
	  blk_destroy(r[0]);
	}
	return 0;
}