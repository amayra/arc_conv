
static int voice_skipnum(FILE *fi) {
	uint a, b = 0;
	LODSB;
	if((uint)(a - '0') >= 10) {
	  if(a == '/') {
	    LODSB;
	    if(a != '/') return -1;
	  } else if(a != '#') return -1;
	  LODSB;
	  if(a == ' ') LODSB;
	  b = 1;
	}
	if((uint)(a - '0') >= 10) return -1;
	do LODSB; while((uint)(a - '0') < 10);
	if(a != ' ') return -1;
	return b;
}

#define N 0x400

static int voice_cmp(FILE *fi) {
	uint a, b, x, i, j; uchar t[N], s[N], v[N];
	for(;;) {
	  do {
	    j = 0;
	    LODSB;
	    if((uint)(a - '0') >= 10) break; putchar(a);
	    do { LODSB; putchar(a); } while((uint)(a - '0') < 10);
	    if(a != ' ') break;
	    do {
	      if((a = fgetc(fi)) == EOF) break;
	      if(a == '\n') break;
	      if(a != '\r') t[j++] = a;
	    } while(j < N);
	    b = a;
	  } while(0);

	  if(!j) {
	    if(a == EOF) return -1; if(a != '\r') putchar(a);
	    if(a != '\n') do { LODSB; if(a != '\r') putchar(a); } while(a != '\n');
	    continue;
	  }

	  for(;;) {
	    if((a = voice_skipnum(stdin)) == -1) goto end;
	    if(!a) break;
	    do if((a = getchar()) == EOF) goto end; while(a != '\n');
	  }

	  i = 0; do {
	    if((x = getchar()) == EOF) break;
	    if(x == '\n') break;
	    s[i++] = x;
	  } while(i < N);

	  if(j < N || i < N) if(i == j) if(!memcmp(t, s, j)) {

	    x = getchar();
	    if((uint)(x - '0') < 10) { ungetc(x, stdin); x = '\n'; goto skip; }
	    if(x == '/') {
	      if((x = getchar()) != '/') goto skip;
	    } else if(x != '#') goto skip;

	    if((x = getchar()) != ' ') goto skip;

	    x = getchar(); do {
	      if((uint)(x - '0') >= 10) goto skip;
	      x = getchar();
	    } while(x != ' ');

	    do { 
	      if((a = getchar()) == EOF) { putchar('\n'); goto last; }
	      if(a != '\r') putchar(a);
	    } while(a != '\n');
	    continue;
	  }

skip:	  if(b == -1 || x == -1) break;
	  if(x != '\n') do if((a = getchar()) == EOF) goto end; while(a != '\n');
	  for(i = 0; i < j; i++) putchar(t[i]);
	  if(b == '\n') putchar(b);
	  else do { LODSB; putchar(a); } while(a != '\n');
	}

end:	for(i = 0; i < j; i++) putchar(t[i]);
	if(b != -1) {
	  if(b == '\n') putchar(b);
last:	  for(;;) { LODSB; putchar(a); }
	}
	return 0;
}

#undef N