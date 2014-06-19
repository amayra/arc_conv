
#ifndef WC_NO_BEST_FIT_CHARS
#define WC_NO_BEST_FIT_CHARS      0x00000400  // do not use best fit chars
#endif

static uint utype = 0;

static int uread(FILE *fi) {
	uchar t[2], a;
	if(utype < 3) {
	  READ(t, 2);
	  if(utype == 2) return (t[0] << 8) + t[1];
	  else return *(ushort*)t;
	} else {
	  READ(t, 1); a = t[0];
	  if(a <= 0x7F) return a;
	  if((uchar)(a - 0xC0) >= 0x30) return -1;
	  READ(t, 1 + (a >= 0xE0));
	  if((t[0] >> 6) != 2) return -1;
	  if(a < 0xE0) return ((a & 0x1F) << 6) + (t[0] & 0x3F);
	  if((t[1] >> 6) != 2) return -1;
	  return ((a & 0xF) << 12) + ((t[0] & 0x3F) << 6) + (t[1] & 0x3F);
	}
}

static int udetect(FILE *fi) {
	uint a = 0;
	READ(&a, 2);
	if(a == 0xFEFF) return 1;
	else if(a == 0xFFFE) return 2;
	else if(a == 0xBBEF) {
	  READ(&a, 1);
	  if((uchar)a == 0xBF) return 3;
	}
	fseek(fi, 0, SEEK_SET);
	return 3;
}

// for %%i in (*.tkn) do main.exe tkn2txt "%%~fi" > "%%~dpni.txt"

static int sjisenc(FILE *fi) {
	uint a, b, x, n; uchar t[2];

	utype = udetect(fi);
	while((a = uread(fi)) != -1) {
	  if(a <= 0x7F) { if(a != '\r') putchar(a); continue; }
	  if(a == 0xFEFF) continue;

	  n = WideCharToMultiByte(932, WC_NO_BEST_FIT_CHARS, (ushort*)&a, 1, t, 2, 0, &x);
	  if(x) switch(b = a >> 8) {
	    case 0x1E:
	      b = 2;
	    case 0x00:
	    case 0x01:
	      a = (b << 8) + (a & 0xFF);
	      b = 0xF0 + a / 0xBC; a %= 0xBC; a += 0x40 + (a >= 0x3F);
	      putchar(b); putchar(a);
	      break;
	    default:
	      putchar('?');
	      break;
	  } else if(n) { putchar(t[0]); if(n > 1) putchar(t[1]); }
	}
	return 0;
}

uchar vietenc_tab[] = {
0x00,0x01,0x02,0x03,0x08,0x09,0x0A,0x0C,0x0D,
0x12,0x13,0x14,0x15,0x19,0x1A,0x1B,0x1D,
0x20,0x21,0x22,0x23,0x28,0x29,0x2A,0x2C,0x2D,
0x32,0x33,0x34,0x35,0x39,0x3A,0x3B,0x3D,
0x42,0x43,0x50,0x51,0x68,0x69,0xA8,0xA9,0xE0,0xE1,0xEF,0xF0 };

int vietenc(FILE *fi) {
	uint a, i;

	utype = udetect(fi);
	while((a = uread(fi)) != -1) {
	  if(a <= 0x7F) { if(a != '\r') putchar(a); continue; }

	  i = a - 0x1EA0;
	  if(i >= 0x5A) {
	    a -= 0xC0;
	    if(a >> 8) { putchar(0x3F); continue; }
	    if(a == 0x10) a += 0x40;	// 0x00D0 -> 0x0110
	    for(i = 0; i < 0x2E; i++) if(vietenc_tab[i] == a) break;
	    if(i >= 0x2E) { putchar(0x3F); continue; }
	    i += 0x5A;
	  }
	  a = i - 0x80 + ((i >> 3) & 0x10);
	  putchar(a);
	}

	return 0;
}

// for %%i in (*.txt) do main.exe addcomment "//" "%%~fi" < "%%~fi" > "new\%%~nxi"

static int addcomment(FILE *fi, CHAR *s) {
	uint a, b = 0, x, i;
	for(;;) {
	  LODSB; if(a == '\r' || a == '\n') continue;
	  x = a - '0';
	  if(x < 10 && b != EOF) {
	    for(;;) {
	      do b = getchar(); while(b == '\r' && b == '\n');
	      if(b == EOF) goto skip;
	      if((uint)(b - '0') < 10) break;
	      do b = getchar(); while(b != '\n');
	    }
	    for(i = 0; s[i]; i++) putchar(s[i]);
	    do {
	      if(b != '\r') putchar(b);
	      b = getchar();
	    } while(b != '\n' && b != EOF);
	    putchar('\n');
	  }
skip:	  putchar(a);
	  do {
	    LODSB;
	    if(a != '\r') putchar(a);
	  } while(a != '\n');
	  if(x < 10) putchar('\n');
	}
	return 0;
}

static int diff(uint n, CHAR **argv) {
	FILE *f[16]; int a, i, p = 0, b[16], x = 1;

	if(n >= 16) return x;
	for(i = 0; i < n; i++) f[i] = 0;
	for(i = 0; i < n; i++) if(!(f[i] = FOPENR(argv[i]))) goto end;
	for(;;) {
	  for(i = 0; i < n; i++) {
	    if(!f[i]) a = EOF;
	    else if((a = fgetc(f[i])) == EOF) { fclose(f[i]); f[i] = 0; }
	    b[i] = a;
	  }
	  a = b[0]; for(i = 1; i < n; i++) if(a != b[i]) break;
	  if(i != n) {
	    printf("%08x:", p);
	    for(i = 0; i < n; i++) {
	      if(b[i] == EOF) printf(" ??");
	      else printf(" %02x", b[i]);
	    }
	    putchar('\n');
	  } else if(a == EOF) { printf("%08x:", p); break; }
	  p++;
	}
	x = 0;
end:	for(i = 0; i < n; i++) if(f[i]) fclose(f[i]);
	return x;
}
