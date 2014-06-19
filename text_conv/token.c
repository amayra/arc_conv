
#define TOKEN_CHECK READ(t, 0x10); if(memcmp(t, "TOKENSET", 8)) return -1

static int token_cmp(FILE *fi, uchar *s) {
	uint a, b = (s == 0);
	do {
	  LODSB; if(!b) b = a - *s++;
	} while(a);
	return b;
}

#define TOKEN READ(t, 5); j[0]++; j[1] += t[4] == 0x83

// LogVoice(id = "Two", text = "xxx");
// V_TWO_0002, V_MAY_0051

static int token_next(FILE *fi, uint *j) {
	uint a; uchar t[5];
	for(;;) {
	  TOKEN;
loop:	  if(t[4] != 0x81) { token_cmp(fi, 0); continue; }
	  if(token_cmp(fi, "text")) continue;
	  TOKEN;
	  if(t[4] != 0x85) goto loop;
	  if(token_cmp(fi, "=")) continue;
	  TOKEN;
	  if(t[4] != 0x83) goto loop;
	  j[2]++;
	  break;  
	}
	return 0;
}

#undef TOKEN

static int token_get(FILE *fi) {
	int i = -1, a, j[3] = { -1, -1, -1 }; uchar t[0x10];
	TOKEN_CHECK;
	for(;;) {
	  if(token_next(fi, j)) break;
	  printf("%03u ", j[1]);
	  for(;;) {
	    LODSB; if(!a) break;
	    text_putc(a);
	  }
	  putchar('\n'); a = 0;
	}
	return 0;
}

static char *token_conv_tab[] = { "%04u ", "%03u ", "%02u " };

static int token_conv(FILE *fi, uint i, uint d) {
	int x, a, j[3] = { -1, -1, -1 }; uchar t[0x10];
	TOKEN_CHECK;
	for(;;) {
	  x = text_num();
	  do {
	    if(token_next(fi, j)) return -1;
	    token_cmp(fi, 0);
	  } while(j[i] != x);
	  printf(token_conv_tab[d], j[d]);
	  do {
	    if((a = getchar()) == EOF) return -1;
	    putchar(a);
	  } while(a != '\n');
	}
	return 0;
}

static int token_put(FILE *fi, FILE *fo) {
	int i = -1, n, a, x = 0; uchar t[0x10];
	TOKEN_CHECK;
	fwrite(t, 1, 0x10, fo);
	for(;;) {
	  if(!x) x = text_num();
	  for(;;) {
	    READ(t, 5); fwrite(t, 1, 5, fo);
	    if(t[4] == 0x83) if(++i == x) break;
	    do { LODSB; fputc(a, fo); } while(a);
	  }
	  x = text_copy(fo); fputc(0, fo);
	  do LODSB; while(a);
	}
	return 0;
}

static int quartett_voice_put(FILE *fi, FILE *fo) {
	int i = -1, n, a, x = 0; uchar t[0x10];
	TOKEN_CHECK;
	fwrite(t, 1, 0x10, fo);
	for(;;) {
	  if(!x) x = text_num();
	  for(;;) {
	    READ(t, 5); fwrite(t, 1, 5, fo);
	    if(t[4] == 0x83) if(++i == x) break;
	    do { LODSB; fputc(a, fo); } while(a);
	  }
	  fprintf(fo, "<SOUND src='Voice/"); x = text_copy(fo); fprintf(fo, ".wav'>");
	  do { LODSB; fputc(a, fo); } while(a);
	}
	return 0;
}

// 0x80 - number
// 0x81 - string
// 0x83 - quoted string
// 0x85 - literal

static int tkn2txt(FILE *fi) {
	uint a, i = 1; uchar x, t[0x10];
	TOKEN_CHECK;
	for(;;) {
	  READ(t, 5); a = i; i = *(uint*)t;
	  a = i - a; a = a < 0 ? 0 : (a > 50 ? 50 : a);
	  if(a) do putchar('\n'); while(--a);

	  if(t[4] == 0x83) putchar('\"');
	  for(;;) {
	    x = a; LODSB; if(!a) break;
	    putchar(a);
	  }
	  if(t[4] == 0x83) putchar('\"');
	  if(t[4] == 0x85 && (x == '#' || x == '@' || x == '(')) continue;
	  if(t[4] == 0x80 || t[4] == 0x83) continue;
	  putchar(' ');
	}
	return 0;
}

#undef TOKEN_CHECK
