
static void promia_str(uint p, uint *l, uint *mc, uchar *ms, uint ns) {
	uint a, i;

	i = mc[p];
	if(!i) return;
	if(i < 0x10 || i >= ns) { printf("# error, str 0x%08X\n", i); return; }
	if(i > *l) printf("# skip 0x%08X\n", *l);

	printf("%06i ", p);
	while(i < ns) {
	  a = ms[i++];
	  if(!a) break;
	  text_putc(a);
	}
	putchar('\n');
	if(!ms[i]) i++;
	if(i > *l) *l = i;
}

static int promia_get_local(uint *mc, uint nc, uchar *ms, uint ns) {
	uint a, p, l = 0x10;
	nc >>= 2;

	// 004022F0 vm_str

	// 0x00500302
	// 0x01002303

	for(p = 8; p < nc; p++) {
	  a = mc[p];
	  switch(a) {
	    case 0x01000D02:	// 1
	      if(p + 1 >= nc) break;
	      promia_str(p + 1, &l, mc, ms, ns);
	      p += 1;
	      break;

	    case 0x01010203:	// 2
	      if(p + 2 >= nc) break;
	      promia_str(p + 1, &l, mc, ms, ns);
	      p += 2;
	      break;

	    case 0x03000303:	// 2
	      if(p + 2 >= nc) break;
	      promia_str(p + 2, &l, mc, ms, ns);
	      p += 2;
	      break;

	    case 0x80000307:	// 6
	      if(p + 4 >= nc) break;
	      promia_str(p + 2, &l, mc, ms, ns);
	      promia_str(p + 3, &l, mc, ms, ns);
	      p += 4;
	      break;

	    case 0x80000406:	// 5
	      if(p + 3 >= nc) break;
	      promia_str(p + 2, &l, mc, ms, ns);
	      promia_str(p + 3, &l, mc, ms, ns);
	      p += 3;
	      break;
	  }
	}
	return 0;
}

static int promia_get(CHAR *fc, CHAR *fs) {
	uint nc, ns, *mc; uchar *ms;

	mc = fmap(fc, &nc);
	ms = fmap(fs, &ns);
	if(mc && ms) promia_get_local(mc, nc, ms, ns);
	mem_free(ms); mem_free(mc);
	return 0;
}

#define N 0x1000

static int promia_put_local(uint *mc, uint nc, FILE *fo) {
	uint a, i, x, p = 0x10; uchar t[N]; void *h[2] = { 0, 0 };
	nc >>= 2;

	hashstr_alloc(h, 0x4000, 0x20000);
	fwrite("PJADV_TF0001\x7C\x81\x00\x00", 1, p, fo);

	for(;;) {
	  if((x = text_num()) == -1) break;
	  i = N - 2; text_buf(t, &i);
	  a = hashstr_add(h, p, t, i);
	  if(a == p) { t[i] = 0; t[i + 1] = 0; i += 2; fwrite(t, 1, i, fo); p += i; }
	  if(x < nc) mc[x] = a;
	}
	blk_destroy(h[0]);
	return 0;
}

#undef N

static int promia_put(CHAR *fc, CHAR *fs, FILE *fo) {
	uint nc, *mc;

	if(mc = fmap(fc, &nc)) promia_put_local(mc, nc, fo);
	if(fo = FOPENW(fs)) { fwrite(mc, 1, nc, fo); fclose(fo); }
	mem_free(mc);
	return 0;
}

