static int aliceacx_get_local(FILE *fi, uint *m, uint n) {
	uint a, i, p = 0;
	READ(m, n * 4 + 4);
	for(;;) for(i = 0; i < n; i++) switch(m[i]) {
	  case 0:
	    READ(&a, 4);
	    break;

	  case 2:
	    LODSB;
	    printf("%03i ", p++);
	    if(a) do { text_putc(a); LODSB; } while(a);
	    putchar('\n');
	    break;

	  default:
	    return -1;
	}
	return 0;
}

static int aliceacx_get(FILE *fi) {
	uint a; uint *m;
	READ(&a, 4);
	if(!a) return 0;
	if(!(m = malloc(a * 4 + 4))) return -1;
	a = aliceacx_get_local(fi, m, a);
	free(m);
	return a;
}

static int aliceacx_put_local(FILE *fi, FILE *fo, uint *m, uint n) {
	uint a, i, p = 0, x = 0;
	a = n * 4 + 4;
	READ(m, a); fwrite(m, 1, a, fo);
	if(!n) return 0;

	for(;;) for(i = 0; i < n; i++) switch(m[i]) {
	  case 0:
	    READ(&a, 4); fwrite(&a, 1, 4, fo);
	    break;

	  case 2:
	    if(!x) x = text_num();
	    if(p++ == x) {
	      x = text_copy(fo);
	      fputc(0, fo);
	      do LODSB; while(a);
	    } else do {
	      LODSB; fputc(a, fo);
	    } while(a);
	    break;

	  default:
	    return -1;
	}
	return 0;
}

static int aliceacx_put(FILE *fi, FILE *fo) {
	uint a; uint *m;
	READ(&a, 4); fwrite(&a, 1, 4, fo);
	if(!(m = malloc(a * 4 + 4))) return -1;
	a = aliceacx_put_local(fi, fo, m, a);
	free(m);
	return a;
}
