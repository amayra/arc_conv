
#define N 0x400

static int sukisyo2_part(FILE *fi, uchar *t, uint *x) {
	uint a, i = 0;
	for(;;) {
	  if((a = fgetc(fi)) == EOF) {
	    if(!i) return -1;
	    a = '\n';
	  }
	  if(a == ' ' || a == '\n') break;
	  if(a != '\r') t[i++] = a;
	  if(i >= N) return -1;
	}
	t[i] = 0;
	*x = a;
	return i;
}

static int sukisyo2(FILE *fi) {
	uint a, i; uchar t[N];

	for(;;) {
	  if((i = sukisyo2_part(fi, t, &a)) == -1) return -1;
	  if(t[0] == '.') t[0] = '/';

	  if(!strcmp(t, "/MES")) {
	    if(a == '\n') continue;
	    if((i = sukisyo2_part(fi, t, &a)) == -1) return -1;
	    while(a != '\n') {
	      if((i = sukisyo2_part(fi, t, &a)) == -1) return -1;
	      printf("%s\n", t);
	    }
	    putchar('\n');
	    continue;
	  }
	  if(!strcmp(t, "/SELECT")) {
	    if(a == '\n') continue;
	    if((i = sukisyo2_part(fi, t, &a)) == -1) return -1;
	    while(a != '\n') {
	      if((i = sukisyo2_part(fi, t, &a)) == -1) return -1;
	      printf("/MENU %s\n", t);
	    }
	    printf("/SELECT\n"); continue;
	  }
	  if(a == '\n' && (!strcmp(t, "/DISP") || !strcmp(t, "/BLEND"))) {
	    printf("%s 0\n", t); continue;
	  }
	  if(!strcmp(t, "/SCT") || !strcmp(t, "/INIT")) {
	    while(a != '\n') {
	      if((i = sukisyo2_part(fi, t, &a)) == -1) return -1;
	    }
	    continue;
	  }

	  if(!strcmp(t, "/TITLE")) {
	    if(a == '\n') continue;
	    if((i = sukisyo2_part(fi, t, &a)) == -1) return -1;
	    strcpy(t, "/TITLE");
	  }
	  printf("%s", t); putchar(a);
	  while(a != '\n') {
	    if((i = sukisyo2_part(fi, t, &a)) == -1) return -1;
	    printf("%s", t); putchar(a);
	  }
	}
	return 0;
}

#undef N
