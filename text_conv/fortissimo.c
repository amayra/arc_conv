// 004244B0 opcode_exec

int fortissimo_get(FILE *fi) {
	uint a, p = 2; uchar t[8];

	READ(t, 4); a = *(uint*)t;
	if(fseek(fi, 6 + a * 4, SEEK_SET)) return -1;
	for(;;) {
	  LODSB; p++;
	  if(a < 0x29) {
	    READ(t, 2); p += 2;
	  } else if(a < 0x2F) {
	    LODSB; p++;
	    do { LODSB; p++; } while(a);
	  } else if(a < 0x4A) {
	    do { LODSB; p++; } while(a);
#if 0
	    printf("%05i ", p - 1);
	    for(;;) {
	      LODSB; p++; if(!a) break;
	      text_putc(a);
	    }
	    putchar('\n');
#endif
	  } else if(a < 0x4E) {
	    printf("%05i ", p - 1);
	    for(;;) {
	      LODSB; p++; if(!a) break;
	      a = (uchar)(a + 0x20);
	      if(!a) a = 0x20;
	      text_putc(a);
	    }
	    putchar('\n');
	  } else if(a <= 0x7F) {
	    READ(t, 8); p += 8;
	  }
	}
	return 0;
}

static int fortissimo_fix(FILE *fi, FILE *fo, void *m) {
	uint a, i, n;

	if(fseek(fi, 0, SEEK_SET)) return -1;
	if(fseek(fo, 4, SEEK_SET)) return -1;
	READ(&n, 4);
	for(i = 0; i < n; i++) {
	  READ(&a, 4); a = reloc_fix(m, a);
	  fwrite(&a, 1, 4, fo);
	}
	return 0;
}

int fortissimo_put(FILE *fi, FILE *fo) {
	uint a, i, n, p = 0, x = 0; void *r[2] = { 0, 0 };

	READ(&n, 4); fwrite(&n, 1, 4, fo);
	for(i = 0; i < n; i++) {
	  READ(&a, 4); fwrite(&a, 1, 4, fo);
	}
	n = n * 4 + 4;

	for(;;) {
	  if(!x) x = text_num();
	  // printf("replace %08X\n", x + n);
	  while(p != x) {
	    if((a = fgetc(fi)) == EOF) goto end; p++; fputc(a, fo);
	  }
	  if((a = fgetc(fi)) == EOF) goto end; p++; fputc(a, fo);

	  if(a < 0x4A) {
	    if(a < 0x2F) {
	      if((a = fgetc(fi)) == EOF) goto end; p++;
	      fputc(a, fo);
	    }
	    x = text_copy(fo);
	  } else {
	    for(;;) {
	      if((a = text_getc()) > -3) break;
	      if(a == 0x20) a = 0;
	      fputc(a - 0x20, fo);
	    }
	    x = -2 - a;
	  }
	  do { if((a = fgetc(fi)) == EOF) goto end; p++; } while(a);
	  fputc(0, fo);
	  reloc_add(r, p, ftell(fo) - p - n);
	}
end:	if(r[0]) {
	  fortissimo_fix(fi, fo, r[1]);
	  blk_destroy(r[0]);
	}
	return 0;
}

int fortissimo_asm_local(FILE *fi, void **d) {
	uint a, n, p = 2, x; uchar t[8]; void *r;

	if(fseek(fi, 0, SEEK_END)) return -1;
	if((a = ftell(fi)) <= 0) return -1;
	if(fseek(fi, 0, SEEK_SET)) return -1;

	READ(t, 4); n = *(uint*)t;
	*d = r = ref_alloc(a - 4 - n * 4);
	printf("_t:\n", n);
	if(n) do {
	  READ(t, 4); a = *(uint*)t;
	  printf("m2 _x%04X\n", a);
	  ref_add(r, a);
	} while(--n);

	READ(t, 2);
	printf("_x:\ndw 0x%04X\n", *(ushort*)t);

	for(;;) {
	  if(ref_check(r, p)) printf("_x%04X:\n", p);
	  LODSB; p++;
	  printf("m1 0x%02X", a);

	  if(a < 0x29) {
	    READ(t, 2); p += 2;
	    printf(", 0x%04X", *(ushort*)t);
	  } else if(a < 0x2F) {
	    LODSB; p++;
	    printf(", 0x%02X, {", a);
	    biniku_asmstr(fi, &p); printf("}");
	  } else if(a < 0x4A) {
	    printf(", {"); biniku_asmstr(fi, &p); printf("}");
	  } else if(a < 0x4E) {
	    printf(", {"); x = 0;
	    for(;;) {
	      LODSB; p++; if(!a) break;
	      a = (uchar)(a + 0x20);
	      if(!a) a = 0x20;
	      asmchar(&x, a);
	    }
	    asmchar(&x, -1); printf("}");
	  } else if(a <= 0x7F) {
	    READ(t, 8); p += 8;
	    printf(", 0x%04X, 0x%04X, 0x%04X, 0x%04X",
	      *(ushort*)t, *(ushort*)(t + 2),
	      *(ushort*)(t + 4), *(ushort*)(t + 6));
	  } else printf("\n%%error");
	  putchar('\n');
	}
	return 0;
}

static int fortissimo_asm(FILE *fi) {
	void *r = 0;
	fortissimo_asm_local(fi, &r);
	mem_free(r);
	return 0;
}
