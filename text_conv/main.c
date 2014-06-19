
#define UNICODE
#define WIN32_LEAN_AND_MEAN
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <windows.h>

#undef getc
#undef putc
#undef getchar
#undef putchar

typedef unsigned char uchar;
typedef unsigned short ushort;
typedef unsigned int uint;

static void asmchar(int *x, int a) {
	int j = *x;
	if((a < 0x20)||(a == 0x22)) {
	  if(j == 1) putchar(0x22); if(a < 0) return;
	  if(j) putchar(0x2C); *x = -1; printf("%i", a);
	} else {
	  if(j < 1) { if(j) putchar(0x2C); putchar(0x22); *x = 1; }
	  putchar(a);
	}
}

#include "blk_alloc.c"

struct hashstritem { struct hashstritem *n; uint h, i, p; uchar s[]; };
struct hashstrblk { uint n; struct hashstritem *h[]; };

static void* hashstr_alloc(void **b, int n, uint x) {
	struct hashstrblk *m = 0; void *r[2] = { 0, 0 };

	if(!b[0]) b[0] = blk_create(x);
	if(n > 0) if(m = blk_alloc(b[0], sizeof(int) + n * sizeof(char*))) {
	  m->n = n - 1; memset(m->h, 0, n << 2); b[1] = m;
	}
	return (void*)m;
}

static uint hashstr_add(void **b, uint p, uchar *s, uint n) {
	uint a, i = 0, h = 0; struct hashstrblk *x; struct hashstritem *m;

	if(!b || !(x = b[1])) return p;
	for(;;) {
	  if(i >= n) break;
	  a = s[i]; if(n == -1 && !a) break;
	  i++; h = h * 25 + a;
	}
	n = h & x->n;
	m = x->h[n];
	while(m) {
	  if(m->h == h && m->i == i) if(!memcmp(s, m->s, i)) return m->p;
	  m = m->n;
	}
	if(m = blk_alloc(b[0], sizeof(void*) + 3 * sizeof(int) + i * sizeof(char))) {
	  m->h = h; m->i = i; m->p = p;
	  memcpy(m->s, s, i);
	  m->n = x->h[n]; x->h[n] = m;
	}
	return p;
}

struct refblk { uint n; uchar b[]; };

static void* ref_alloc(uint n) {
	struct refblk *m = 0; uint a = (n >> 3) + 1;
	if((int)n > 0) if(m = mem_alloc(a + sizeof(int))) {
	  m->n = n; memset(m->b, 0, a);
	}
	return (void*)m;
}

static uint ref_add(struct refblk *m, uint a) {
	if(!m || a > m->n) return -1;
	m->b[a >> 3] |= 1 << (a & 7);
	return a;
}

static uint ref_check(struct refblk *m, uint a) {
	if(!m || a > m->n) return 0;
	return m->b[a >> 3] & 1 << (a & 7);
}

struct reloc { struct reloc *n; int p, a; };

static uint reloc_fix(void *r, uint a) {
	struct reloc *m = r;
	while(m) {
	  if(a >= m->p) return a + m->a;
	  m = m->n;
	}
	return a;
}

static void reloc_add(void **b, uint p, uint a) {
	uint i = 0; struct reloc *m, *x = b[1];
	if(!b[0]) b[0] = blk_create(0x1000);
	if(x) i = x->a;
	if(i != a) if(m = blk_alloc(b[0], sizeof(struct reloc))) {
	  m->n = x; m->p = p; m->a = a; b[1] = m;
	  // printf("reloc %08X %08X\n", p, a);
	}
}

#define LODSB if((a = getchar()) == EOF) return -1

static int text_hex(uint a) {
	a -= 0x30;
	if(a >= 10) {
	  a = (a | 0x20) - 0x31;
	  if(a >= 6) return -1;
	  a += 10;
	}
	return a;
}

static void text_putc(uint a) {
	a = (uchar)(a);
	if(a >= 0x20 && a != '*') putchar(a);
	else printf("*%02X", a);
}

static int text_copy(FILE *fo) {
	uint a, b, c, d;
	for(;;) {
	  LODSB;
	  if(a == '\n') return 0;
	  if(a == '*') {
	    LODSB;
	    if((c = text_hex(a)) == -1) { fputc('*', fo); ungetc(a, stdin); }
	    else {
	      b = a; LODSB;
	      if((d = text_hex(a)) == -1) { fputc('*', fo); fputc(b, fo); ungetc(a, stdin); }
	      else fputc((c << 4) + d, fo);
	    }
	  } else if(a != '\r') fputc(a, fo);
	}
}

static uint text_getc() {
	uint a, b, c, d;
	for(;;) {
	  LODSB;
	  if(a == '\n') return -2;
	  if(a == '*') {
	    LODSB;
	    if((c = text_hex(a)) == -1) ungetc(a, stdin);
	    else {
	      b = a; LODSB;
	      if((d = text_hex(a)) == -1) { ungetc(a, stdin); return b; }
	      else return (c << 4) + d;
	    }
	  } else if(a != '\r') return a;
	}
}

static int text_num() {
	uint a, i;
	for(;;) {
	  LODSB;
	  if((uint)(a - '0') < 10) {
	    i = 0; do {
	      if(i >= 0xCCCCCCD) break;
	      i = i * 10 + a - '0';
	      if(i >> 31) break;
	      LODSB;
	    } while((uint)(a - '0') < 10);
	    if(a == ' ') break;
	  }
	  do LODSB; while(a != '\n');
	}
	return i;
}

static int text_buf(uchar *t, uint *x) {
	uint a, i = 0, n = *x;
	while((a = text_getc()) < -2) {
	  if(i < n) t[i++] = a;
	}
	*x = i;
	return (-2 - a);
}

#undef LODSB

#define READ(d,c) if(fread(d, 1, c, fi) != c) return -1
#define LODSB if((a = fgetc(fi)) == EOF) return -1

#ifdef UNICODE
#define FOPENR(f) _wfopen(f, L"rb")
#define FOPENW(f) _wfopen(f, L"wb")
#define CHAR wchar_t
#else
#define FOPENR(f) fopen(f, "rb")
#define FOPENW(f) fopen(f, "wb")
#define CHAR char
#endif

static CHAR *in_file = 0;

static int cmps(CHAR *s, uchar *d) {
	uint a, b;
	do {
	  a = *d++; b = *s++;
	  if(a != b) return (a - b);
	} while(a);
	return 0;
}

static CHAR* getpathname(CHAR *s) {
	CHAR *d = s; uint a;
	do {
	  a = *s;
	  if((uint)(a - 0x41) < 0x1A) *s = a + 0x20;
	  if(a == '\\') { a = '/'; *s = a; }
	  s++; if(a == '/') d = s;
	} while(a);
	return d;
}

static CHAR* getpathext(CHAR *s) {
	CHAR *d; uint a, i;
#ifdef UNICODE
	i = wcslen(s);
#else
	i = strlen(s);
#endif
	d = s + i;
	if(i) do {
	  a = s[i];
	  if(a == '.') return s + i;
	  if(a == '\\' || a == '/') break;
	  if((uint)(a - 0x41) < 0x1A) s[i] = a + 0x20;
	} while(--i);
	return d;
}

void* fmap(CHAR *name, uint *d) {
	FILE *fi; int n = 0; uchar *m = 0;
	if(fi = FOPENR(name)) {
	  do {
	    if(fseek(fi, 0, SEEK_END)) break;
	    if((n = ftell(fi)) <= 0) break;
	    if(fseek(fi, 0, SEEK_SET)) break;
	    if(!(m = mem_alloc(n))) break;
	    if(fread(m, 1, n, fi) != n) { mem_free(m); m = 0; }
	  } while(0);
	  fclose(fi);
	}
	*d = m ? n : 0;
	return m;
}

#include "clover.c"
#include "token.c"
#include "sjisenc.c"
#include "voice.c"
#include "liar.c"
#include "rance.c"
#include "biniku.c"
#include "dk4.c"
#include "baldr.c"
#include "sukisyo.c"
#include "glnk.c"
#include "will.c"
#include "ego.c"
#include "majiro.c"
#include "ddsys.c"
#include "lcse.c"
#include "rlseen.c"
#include "aliceacx.c"
#include "kogado.c"
#include "gadgett.c"
#include "tasofro.c"
#include "promia.c"
#include "sysadv.c"
#include "ismscript.c"
#include "hadaka.c"
#include "fortissimo.c"

typedef void (*text_get) (FILE *fi);
typedef void (*text_put) (FILE *fi, FILE *fo);

static int null_get(FILE *fi) { return -1; }
static int null_put(FILE *fi, FILE *fo) { return -1; }

struct {
   char *name;
   void (*get) (FILE *fi);
   void (*put) (FILE *fi, FILE *fo);
} text_tab[] = {
	{ "sjisenc", sjisenc, null_put },
	{ "vietenc", vietenc, null_put },

	{ "clover", clover_get, clover_put },
	{ "token", token_get, token_put },
	{ "liar", liar_get, liar_put },
	{ "rance", rance_get, rance_put },
	{ "biniku_asm", biniku_asm, null_put },
	{ "biniku", biniku_get, biniku_put },
	{ "dk4_asm", dk4_asm, null_put },
	{ "dk4", dk4_get, dk4_put },
	{ "baldr", baldr_get, baldr_put },
	{ "glnk", glnk_get, glnk_put },

	{ "will", will_get, will_put },
	{ "laughter_asm", laughter_asm, null_put },
	{ "laughter", laughter_get, laughter_put },
	{ "yumemiru_asm", yumemiru_asm, null_put },
	{ "yumemiru", yumemiru_get, yumemiru_put },
	{ "bloodycall_asm", bloodycall_asm, null_put },
	{ "bloodycall", bloodycall_get, bloodycall_put },
	{ "enzai_asm", enzai_asm, null_put },
	{ "enzai", enzai_get, enzai_put },

	{ "ego_asm", ego_asm, null_put },
	{ "ego", ego_get, ego_put },
	{ "afdat", afdat_get, afdat_put },
	{ "majiro_asm", majiro_asm, null_put },
	{ "majiro", majiro_get, majiro_put },
	{ "ddsys_asm", ddsys_asm, null_put },
	{ "ddsys", ddsys_get, ddsys_put },
	{ "lcse_asm", lcse_asm, null_put },
	{ "lcse", lcse_get, lcse_put },
	{ "rlseen_asm", rlseen_asm, null_put },
	{ "rlseen", rlseen_get, rlseen_put },
	{ "aliceacx", aliceacx_get, aliceacx_put },
	{ "kogado", kogado_get, kogado_put },
	{ "gadgett_asm", gadgett_asm, null_put },
	{ "gadgett", gadgett_get, gadgett_put },
	{ "tasofro_asm", tasofro_asm, null_put },
	{ "sysadv_asm", sysadv_asm, null_put },
	{ "ismscript_asm", ismscript_asm, null_put },
	{ "ismscript", ismscript_get, ismscript_put },
	{ "hadaka_asm", hadaka_asm, null_put },
	{ "fortissimo_asm", fortissimo_asm, null_put },
	{ "fortissimo", fortissimo_get, fortissimo_put },

	{ "quartett_voice", quartett_voice_get, quartett_voice_put },
	{ "clover_voice", clover_voice_get, clover_voice_put },
	{ "tkn2txt", tkn2txt, null_put },
	{ "clover_dc", clover_dc, null_put },
	{ "voice_cmp", voice_cmp, null_put },
	{ "sukisyo2", sukisyo2, null_put },
	{ "will_ror2", null_get, will_ror2 },
	{ 0, 0, 0 } };

#define N 0x200

static int filetest(CHAR *s) {
	CHAR t[N];
	FILE *fi;
	int a, x = 0, i, j = 0, k, l;
	do {
	  if(j >= N) return -1;
	  a = s[j]; t[j++] = a;
	} while(a && a != '*');
	if(!a) j = 0;
	else j--;

	for(;;) {
	  if(x == EOF) break;
	  if(text_num() == -1) break;
	  i = j; do {
	    if((a = getchar()) == EOF) break;
	    if(a != '\r' && i < N) t[i++] = a;
	  } while(a != '\n');
	  x = a; if(i >= N) continue;
	  i -= (a == '\n'); if(!i) break;

	  l = i; k = j + (s[j] == '*'); do {
	    a = s[k++];
	    t[i++] = a;
	  } while(a && i < N);
	  if(i >= N) continue;

	  // printf("# %S\n", t);

	  if(fi = FOPENR(t)) fclose(fi);
	  else {
	    for(i = j; i < l; i++) putchar(t[i]);
	    putchar('\n');
	  }
	}
	return 0;
}

#undef N

#ifdef UNICODE
int wmain(int argc, wchar_t **argv) {
#else
int main(int argc, char **argv) {
#endif
	FILE *fi, *fo; uint i, j;

	if(argc < 2) return 0;
	if(!cmps(argv[1], "diff")) return diff(argc - 2, argv + 2);
	else if(!cmps(argv[1], "addcomment")) {
	  if(argc != 4) return 0;
	  if(fi = FOPENR(argv[3])) { addcomment(fi, argv[2]); fclose(fi); }
	}
	else if(!cmps(argv[1], "clover_conv")) {
	  if(argc != 5) return 0;
	  if((uint)(i = argv[2][0] - '0') > 1) return 0;
	  if(argv[2][1]) return 0;
	  if((uint)(j = argv[3][0] - '0') > 1) return 0;
	  if(argv[3][1]) return 0;
	  if(fi = FOPENR(argv[4])) { clover_conv(fi, i, j); fclose(fi); }
	}
	else if(!cmps(argv[1], "token_conv")) {
	  if(argc != 5) return 0;
	  if((uint)(i = argv[2][0] - '0') > 2) return 0;
	  if(argv[2][1]) return 0;
	  if((uint)(j = argv[3][0] - '0') > 2) return 0;
	  if(argv[3][1]) return 0;
	  if(fi = FOPENR(argv[4])) { token_conv(fi, i, j); fclose(fi); }
	}
	else if(!cmps(argv[1], "promia")) {
	  if((uint)(argc - 4) >= 2) return 0;
	  if(argc == 4) promia_get(argv[2], argv[3]);
	  else if(fo = FOPENW(argv[4])) { promia_put(argv[2], argv[3], fo); fclose(fo); }
	}

	if(!cmps(argv[1], "filetest")) {
	  if(argc != 3) return 0;
	  filetest(argv[2]);
	}
	else for(i = 0; text_tab[i].name; i++) if(!cmps(argv[1], text_tab[i].name)) {
	  if((uint)(argc - 3) < 2) if(fi = FOPENR(argv[2])) {
	    in_file = argv[2];
	    if(argc == 3) text_tab[i].get(fi);
	    else if(fo = FOPENW(argv[3])) { text_tab[i].put(fi, fo); fclose(fo); }
	    fclose(fi);
	  }
	  return 0;
	}
	return 0;
}

