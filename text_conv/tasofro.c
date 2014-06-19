
// griefsyndrome.exe 005366F4 vm

static int tasofro_str(FILE *fi) {
	uint a, n, x = 0;
	READ(&a, 4);
	if(a != 0x8000010) {
	  printf("dd 0x%08X", a);
	  if(a == 0x1000001) putchar('\n');
	  else if(a == 0x5000002) {
	    READ(&a, 4);
	    printf(", %i\n", a);
	  } else return -1;
	  return 0;
	}
	printf("m1 ");
	READ(&n, 4);
	if(n) do {
	  LODSB; asmchar(&x, a);
	} while(--n);
	asmchar(&x, -1);
	putchar('\n');
	return 0;
}

static int tasofro_part(FILE *fi) {
	uint a, x = 0;
	READ(&a, 4);
	if(a != 0x50415254) return -1;
	printf("m2\n");
	return 0;
}

static uchar cv4head[] = { 0xFA, 0xFA, 'R', 'I', 'Q', 'S', 1, 0, 0, 0 };

static int tasofro_asm_local(FILE *fi, void **m) {
	uint a, i, n, h[8], t[3], j = 0; uchar *s, *p; void *r;

	READ(t, 0xA);
	if(memcmp(t, cv4head, 0xA)) return -1;

	for(;;) {
	  READ(&a, 4);
	  if(a == 0x5441494C) { printf("db \"LIAT\"\n"); break; }
	  if(a != 0x50415254) return -1;
	  printf("f%i:\nm2\n", j++);
	  if(tasofro_str(fi)) return -1;
	  if(tasofro_str(fi)) return -1;
	  if(tasofro_part(fi)) return -1;
	  READ(h, 0x20);
	  printf("dd %i, %i, %i, %i, %i, %i, (.e-.x)/8, %i", h[0], h[1], h[2], h[3], h[4], h[5], h[7]);
	  putchar('\n');

	  // strings
	  if(tasofro_part(fi)) return -1;
	  for(i = 0; i < h[0]; i++) {	
	    printf("; %i\n", i);
	    if(tasofro_str(fi)) return -1;
	  }

	  // input
	  if(tasofro_part(fi)) return -1;
	  if(n = h[1]) do {
	    if(tasofro_str(fi)) return -1;
	  } while(--n);

	  if(tasofro_part(fi)) return -1;
	  if(n = h[2]) return -1;

	  if(tasofro_part(fi)) return -1;
	  if(n = h[3]) do {
	    if(tasofro_str(fi)) return -1;
	    READ(t, 0xC); printf("dd %i, %i, %i\n", t[0], t[1], t[2]);
	  } while(--n);

 	  // line numbers
	  if(tasofro_part(fi)) return -1;
	  if(n = h[4]) do {
	    READ(t, 8); printf("dd %i, %i\n", t[0], t[1]);
	  } while(--n);

	  if(tasofro_part(fi)) return -1;
	  if(n = h[5]) do {
	    READ(t, 4); printf("dd %i\n", t[0]);
	  } while(--n);

	  // code
	  if(tasofro_part(fi)) return -1;

	  if(n = h[6]) {
	    if(n >> 28) return -1;
	    if(!(s = mem_alloc(n << 3))) return -1;
	    m[1] = s;
	    READ(s, n << 3);

	    *m = r = ref_alloc(n);
	    p = s; do {
	      a = p[4];
	      if((uint)(a - 24) < 3 || (uint)(a - 43) < 2) {
	        i = (p - s) + 8 + *(uint*)p * 8;
	        ref_add(r, (int)i >> 3);
	      }
	      p += 8;
	    } while(--n);
	  }

	  printf(".x:\n");
	  p = s; if(n = h[6]) do {
	    a = (p - s) >> 3; if(ref_check(r, a)) printf(".x%i:\n", a);
	    a = p[4];
	    if(a == 3) printf("m3 0x%08X", *(uint*)p);
	    // if(a == 3) printf("m3 %.9e", *(float*)p);
	    else if(a == 34) printf("m3 %i + (%i << 16)", *(ushort*)p, *(ushort*)(p + 2));
	    else if((uint)(a - 24) < 3 || (uint)(a - 43) < 2) {
	      i = (p - s) + 8 + *(uint*)p * 8;
	      printf("m4 .x%i", (int)i >> 3);
	    } else printf("m3 %i", *(uint*)p);
	    printf(", ");
	    switch(a) {
	      case 1: printf("_str"); break;
	      case 2: printf("_int"); break;
	      case 3: printf("_flt"); break;
	      case 6: printf("_call"); break;
	      case 9: printf("_item"); break;
	      case 13: printf("_set"); break;
	      // 15,16 cmpe cmpne
	      case 17: printf("_arith"); break;
              case 18: printf("_bitop"); break;
	      case 19: printf("_ret"); break;
	      case 22: printf("_bool"); break;
	      case 24: printf("_goto"); break;
	      case 38: printf("_inc"); break;
	      case 40: printf("_cmp"); break;
	      default: printf("%i", a);
	    }

	    printf(", %i, %i, ", p[5], p[6]);

	    i = p[7];
	    if(a == 17 || a == 34) switch(i) {
	      case 37: printf("_mod"); break;
	      case 42: printf("_mul"); break;
	      case 43: printf("_add"); break;
	      case 45: printf("_sub"); break;
	      case 47: printf("_div"); break;
	      default: printf("%i", i);
	    } else if(a == 18) switch(i) {
	      case 0: printf("_and"); break;
	      case 2: printf("_or"); break;
	      case 3: printf("_xor"); break;
	      case 4: printf("_shl"); break;
	      case 5: printf("_sar"); break;
	      case 6: printf("_shr"); break;
	      default: printf("%i", i);
	    } else if(a == 40) switch(i) {
	      case 0: printf("_setg"); break;
	      case 2: printf("_setge"); break;
	      case 3: printf("_setl"); break;
	      case 4: printf("_setle"); break;
	      default: printf("%i", i);
	    } else printf("%i", i);
	    printf("\n");
	    p += 8;
	  } while(--n);
	  printf(".e:\n");

	  if(r) { mem_free(r); *m = 0; r = 0; }
	  if(s) { mem_free(s); m[1] = 0; s = 0; }

	  if(tasofro_part(fi)) return -1;
	  i = ftell(fi);
	  for(;;) {
	    READ(&a, 4);
	    if((ushort)a > 0x7F) { if(fseek(fi, i, SEEK_SET)) return -1; break; }
	    READ(&n, 2);
	    printf("dw %i, %i, %i\n", (ushort)a, a >> 16, (ushort)n);
	    i += 6;
	  }
	  putchar('\n');
	}

	return 0;
}

static int tasofro_asm(FILE *fi) {
	uint a, *m[2] = { 0, 0 };
	if(a = tasofro_asm_local(fi, m)) printf("\n%%error");
	mem_free(m[0]); mem_free(m[1]);
	return a;
}
