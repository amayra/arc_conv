
static const char clover_balloon[] = "reateBalloon";

static int clover_char(FILE *fi) {
	uint a;
	do {
	  LODSB; if(a == '/') {
	    LODSB; if(a == '/') do LODSB; while(a != '\n');
	    else if(a == '*') for(;;) {
	      LODSB; if(a != '*') continue;
	      LODSB; if(a == '/') break;
	    }
	  }
	} while(a == ' ' || a == '\t' || a == '\r' || a == '\n');
	return a;
}

static int clover_param(FILE *fi) {
	uint a;
	if((a = clover_char(fi)) == -1) return -1;
	if(a == '\"') {
	  do {
	    LODSB;
	    if((uint)(a - 0x81) < 0x1F || (uint)(a - 0xE0) < 0x1D) { LODSB; }
	    else if(a == '\\') { LODSB; a = ' '; }
	  } while(a != '\"');
	  a = clover_char(fi);
	} else do LODSB; while(a != ',');
	return a;
}

static int clover_next(FILE *fi) {
	int a, b, i;
	for(;;) {
	  if((a = clover_char(fi)) == -1) return -1;
	  if(a == '\"') {
	    ungetc(a, fi); a = clover_param(fi);
	  }
	  if(a != 'C') continue;
	  i = 0; do {
	    if(!(b = clover_balloon[i++])) break;
	    LODSB;
	  } while(a == b);

	  if(i == 6) {
	    if(a == 'T') {
	      LODSB; if(a != 'e') { ungetc(a, fi); continue; }
	      LODSB; if(a != 'x') { ungetc(a, fi); continue; }
	      LODSB; if(a != 't') { ungetc(a, fi); continue; }
 	    }
	    b = 6;
	  } else if(b) {
	    ungetc(a, fi); continue;
	  } else {
	    LODSB;
	    if(a == 'B') {
	      LODSB; if(a != 'i') { ungetc(a, fi); continue; }
	      LODSB; if(a != 'e') { ungetc(a, fi); continue; }
	      LODSB;
 	    }
	    if(a == 'E') {
	      LODSB; if(a != 'x') { ungetc(a, fi); continue; }
	    } else ungetc(a, fi);
	    b = 8;
	  }

	  if((a = clover_char(fi)) == -1) return -1;
	  if(a != '(') { ungetc(a, fi); continue; }
	  for(i = 0; i < b; i++) {
	    if((a = clover_param(fi)) == -1) return -1;
	    if(a != ',') break;
	  }
	  if(a != ',') { ungetc(a, fi); continue; }

	  if((a = clover_char(fi)) == -1) return -1;
	  if(a != '\"') { ungetc(a, fi); continue; }
	  break;
	}
	return 0;
}

static int clover_get(FILE *fi) {
	int a;
	for(;;) {
	  if(clover_next(fi)) return -1;
	  printf("%05u ", ftell(fi));
	  for(;;) {
	    LODSB; if(a == '\"') break;
	    text_putc(a);
	    if((uint)(a - 0x81) < 0x1F || (uint)(a - 0xE0) < 0x1D) { LODSB; if(a == '\"') break; text_putc(a); }
	    else if(a == '\\') { LODSB; text_putc(a); }
	  }
	  putchar('\n');
	}
	return 0;
}

static int clover_conv(FILE *fi, uint i, uint d) {
	int x, a, j[2] = { -1, -1 };
	for(;;) {
	  x = text_num();
	  do {
	    if(clover_next(fi)) return -1;
	    j[0] = ftell(fi); j[1]++;
 	    // printf("%i %i %i\n", x, j[0], j[1]);
	    do {
	      LODSB;
	      if((uint)(a - 0x81) < 0x1F || (uint)(a - 0xE0) < 0x1D) { LODSB; }
	      else if(a == '\\') { LODSB; a = ' '; }
	    } while(a != '\"');
	  } while(j[i] != x);

	  printf(d ? "%02u " : "%05u ", j[d]);
	  do {
	    if((a = getchar()) == EOF) return -1;
	    putchar(a);
	  } while(a != '\n');
	}
	return 0;
}

static int clover_put(FILE *fi, FILE *fo) {
	int a, i = 0, x = 0;
	for(;;) {
	  if(!x) x = text_num();
	  while(i != x) { LODSB; i++; fputc(a, fo); }
	  x = text_copy(fo);
	  do {
	    LODSB; i++;
	    if((uint)(a - 0x81) < 0x1F || (uint)(a - 0xE0) < 0x1D) { LODSB; i++; }
	    else if(a == '\\') { LODSB; i++; a = ' '; }
	  } while(a != '\"');
	  fputc(a, fo);
	}
	return 0;
}

#include "clover_tab.c"

static int clover_dc_char(FILE *fi, uint a, uint x, uint n, ushort *t) {
	uint b = a - x;
	LODSB;
	if((uint)(a - 0x41) < 0x1A) a -= 0x41;
	else if((uint)(a - 0x61) < 0x1A) a -= 0x61 - 0x1A;
	else { ungetc(a, fi); return 0; }
	b = b * 0x34 + a;
	if(b >= n) { ungetc(a, fi); return 0; }
	a = t[b]; putchar(a & 0xFF); putchar(a >> 8);
	return 1;
}

static int clover_dc(FILE *fi) {
	int a, b = ';', x;
	for(;;) {
	  LODSB;
	  if((uint)(a - 0xA8) < 0x38) {
	    x = clover_dc_char(fi, a, 0xA8, 0x710, clover_tab_a8);
	    if(x == -1) return -1;
	    if(x) continue;
	  }
	  if(b == ';' && a == 0x5F) a = '\n';
	  putchar(a); b = a;
	}
	return 0;
}

/*
 BOpa = Opaque
 BDel = Delete
 COlX = CreateOutlineEx
 CWin = CreateWindow
 CCol = CreateColor
 CBll = CreateBalloon
 CBlX = CreateBalloonEx
 CTxt = CreateText
 SPlX = SoundPlayEx
 SPan = SoundPan
 SVol = SoundVolume
 VKey = WaitKey
 WAct = WaitAction
 Xwai = wait
*/

static int clover_voice_get(FILE *fi) {
	int a, b, i;
	for(;;) {
	  LODSB; if(a != '\n') continue;
	  LODSB;
	  if(a == 'C') {
	    LODSB;
	    if(a == 'B') {
	      LODSB; if(a != 'l') { ungetc(a, fi); continue; }
	      LODSB; if(a != 'l' && a != 'X') { ungetc(a, fi); continue; }
	      b = 8;
	    } else if(a == 'T') {
	      LODSB; if(a != 'x') { ungetc(a, fi); continue; }
	      LODSB; if(a != 't') { ungetc(a, fi); continue; }
	      b = 6;
	    } else { ungetc(a, fi); continue; }
 	  } else if(a == 'X') {
	    LODSB; if(a != 'V') { ungetc(a, fi); continue; }
	    LODSB; if(a != 's') { ungetc(a, fi); continue; }
	    LODSB; if(a != 't') { ungetc(a, fi); continue; }
	    b = 1;
	  } else { ungetc(a, fi); continue; }
	  if((a = clover_char(fi)) == -1) return -1;
	  if(a != '(') { ungetc(a, fi); continue; }

	  for(i = 0; i < b; i++) {
	    if((a = clover_param(fi)) == -1) return -1;
	    if(a != ',') break;
	  }
	  if(a != ',') { ungetc(a, fi); continue; }

	  if((a = clover_char(fi)) == -1) return -1;
	  if(a != '\"') { ungetc(a, fi); continue; }
	  if(b == 1) printf("// ");
	  printf("%05u ", ftell(fi));
	  for(;;) {
	    LODSB; if(a == '\"') break;
	    if(b == 1 && a == '.') b = 0;
	    if(b) text_putc(a);
	    if((uint)(a - 0x81) < 0x1F || (uint)(a - 0xE0) < 0x1D) { LODSB; if(a == '\"') break; text_putc(a); }
	    else if(a == '\\') { LODSB; text_putc(a); }
	    continue;
	  }
	  putchar('\n');
	}
	return 0;
}

static int clover_voice_put(FILE *fi, FILE *fo) {
	int a, i = 0, x = 0;
	for(;;) {
	  if(!x) x = text_num();
	  while(i != x) { LODSB; i++; fputc(a, fo); }
	  fprintf(fo, "<SOUND src='V/"); x = text_copy(fo); fprintf(fo, ".wav'>");
	  do {
	    LODSB; i++; fputc(a, fo);
	    if((uint)(a - 0x81) < 0x1F || (uint)(a - 0xE0) < 0x1D) { LODSB; i++; fputc(a, fo); }
	    else if(a == '\\') { LODSB; i++; fputc(a, fo); a = ' '; }
	  } while(a != '\"');
	}
	return 0;
}

static int quartett_voice_get(FILE *fi) {
	int a, b, i;
	for(;;) {
	  if((a = clover_char(fi)) == -1) return -1;
	  if(a == '\"') {
	    ungetc(a, fi); a = clover_param(fi);
	  }
	  if(a == 'i') {
	    LODSB; if(a != 'd') { ungetc(a, fi); continue; }
	    b = -1;
 	  } else if(a == 't') {
	    LODSB; if(a != 'e') { ungetc(a, fi); continue; }
	    LODSB; if(a != 'x') { ungetc(a, fi); continue; }
	    LODSB; if(a != 't') { ungetc(a, fi); continue; }
	    b = 0;
	  } else continue;

	  if((a = clover_char(fi)) == -1) return -1;
	  if(a != '=') continue;
	  if((a = clover_char(fi)) == -1) return -1;
	  if(a != '\"') continue;
	  if(b) printf("// ");
	  printf("%05u ", ftell(fi));
	  for(;;) {
	    LODSB; if(a == '\"') break;
	    text_putc(a);
	    if((uint)(a - 0x81) < 0x1F || (uint)(a - 0xE0) < 0x1D) { LODSB; if(a == '\"') break; text_putc(a); }
	    else if(a == '\\') { LODSB; text_putc(a); }
	    continue;
	  }
	  putchar('\n');
	}
	return 0;
}
