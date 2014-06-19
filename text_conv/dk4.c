
/*
  004AA570 vm_start
  004AA9F0 vm_loop
  004A9EC0 -> 004A9EC0 vm_byte

  004ACD40 0x01, 0x02, 0x12, 0x13
  0043DB20 x < 0x20
  0040BFC0 vm_expr
  0040BE30 vm_pop
  004ABFF0 vm_push
  004AA5B0 vm_list

  if((a < 0x81 || a > 0x9F) && a + 0x20 > 0xF && a + 6 > 2) ...
*/

static int dk4_code(uint a) {

// 1 - u8, 2 - u16, 3 - u32, 4 - exp, 5 - offset
// 6 - list1, 7 - list2, 8 - string

	switch(a) {
	  case 0x00:
	    return 0;

	  case 0x13:
	    return 1;

	  case 0x01:
	    return 8;

	  case 0x04: case 0x16:
	    return 0x61;

	  case 0x03: case 0x09:
	    return 0x62;

	  case 0x05:
	    return 0x64;

	  case 0x06: case 0x07: case 0x08:
	    return 0x614;

	  case 0x0B: case 0x14: case 0x1C:
	    return 0x54;

	  case 0x10:
	    return 0x57;

	  case 0x0C:
	    return 5;

	  case 0x0D:
	    return 0x74;

	  case 0x0E: case 0x0F: case 0x11: case 0x12:
	  case 0x15: case 0x1B: case 0x1D:
	    return 7;

	  case 0x17: case 0x1F:
	    return 3;
	}
	return 9;
}

static int dk4_exp(FILE *fi, uint *p, uint f) {
	uint a, i = 0;
	if(f == 1) printf("{");
	for(;;) {
	  LODSB; (*p)++;
	  if(a == 0xFF) break;
	  if(f == 1) { if(i) printf(", "); i++; printf("0x%02X", a); }
	  switch(a - 0x80) {
	    case 0x00: case 0x20: case 0x40: case 0x78: case 0x79:
	      LODSB; (*p)++; if(f == 1) printf(",0x%02X", a);
	      break;
	    case 0x71: case 0x73: case 0x76:
	      READ(&a, 2); *p += 2; if(f == 1) printf(",0x%04X", (ushort)a);
	      break;
	    case 0x72:
	      READ(&a, 4); *p += 4; if(f == 1) printf(",0x%08X", a);
	      break;
	  }
	}
	if(f == 1) putchar('}');
	return 0;
}

static int dk4_str(FILE *fi, uint *p, uint f) {
	uint a, x = 0;
	if(f != 2) {
	  if(f) putchar('{');
	  for(;;) {
	    LODSB; (*p)++;
	    if(!a) break;
	    if(f) asmchar(&x, a);
	  }
	  if(f) { asmchar(&x, -1); putchar('}'); }
	} else {
	  printf("%05i ", *p);
	  for(;;) {
	    LODSB; (*p)++;
	    if(!a) break;
	    text_putc(a);
	  }
	  putchar('\n');
	}
	return 0;
}

static int dk4_printf(FILE *fi, uint *p, uint f, uint s) {
	uint a, i;
	while(s) {
	  a = s & 0xF; s >>= 4;	
	  if(f == 1) printf(", ");
	  if(a == 1) {
	    LODSB; (*p)++;
	    if(f == 1) printf("0x%02X", a);
	  } else if(a == 2) {
	    READ(&a, 2); *p += 2;
	    if(f == 1) printf("0x%04X", (ushort)a);
	  } else if(a == 3) {
	    READ(&a, 4); *p += 4;
	    if(f == 1) printf("0x%08X", a);
	  } else if(a == 4) {
	    if(dk4_exp(fi, p, f)) return -1;
	  } else if(a == 5) {
	    READ(&a, 4); *p += 4;
	    if(f == 1) printf("_x%04X", a);	// offset
	  } else if(a == 6) {
	    if(f == 1) putchar('{');
	    i = 0; do {
	      if(f == 1) { if(i) printf(", "); i++; }
	      if(dk4_exp(fi, p, f)) return -1;
	      LODSB; (*p)++;
	      if(a >= 2) { if(f == 1) printf("\n%%error\n"); }
	    } while(a);
	    if(f == 1) putchar('}');
	  } else if(a == 7) {
	    if(f == 1) putchar('{');
	    i = 0; for(;;) {
	      LODSB; (*p)++;
	      if(a == 0) break;
	      if(f == 1) { if(i) printf(", "); i++; printf("%i", a); }
	      if(a == 2) { if(f == 1) putchar(','); if(dk4_exp(fi, p, f)) return -1; }
	      else if(a != 1) { if(f == 1) printf("\n%%error\n"); }
	      else { if(f == 1) putchar(','); if(dk4_str(fi, p, f)) return -1; }
	    }
	    if(f == 1) putchar('}');
	  } else if(a == 8) {
	    if(dk4_str(fi, p, f)) return -1;
	  } else if(f == 1) printf("\n%%error");
	}
	return 0;
}

static int dk4_jmp(FILE *fi, uint *m, uint x) {
	uint a, i = 1, p = 0;
	*m = i;
	for(;;) {
	  if((a = fgetc(fi)) == EOF) break; p++;
	  a = dk4_code(a);

	  if((a >> 4) == 5) {
	    if(dk4_printf(fi, &p, 0, a & 0xF)) return -1;
	    a >>= 4;
	  }
	  if(a == 5) {
	    READ(&a, 4); p += 4;
	    if(i == x) return 0;
	    if(x) m[i] = a; i++; *m = i;
	  } else if(dk4_printf(fi, &p, 0, a)) return -1;
	}
	return 0;
}

static int dk4_asm_local(FILE *fi, uint **m) {
	uint a, i, n, p = 0;

	READ(&n, 4);
	printf("dd %i", n);
	for(i = 0; i < n; i++) {
	  READ(&a, 4);
	  if(i & 3) printf(", _x%04X", a);
	  else printf("\nm2 _x%04X", a);
	}
	printf("\n_x:\n");

	a = ftell(fi);
	dk4_jmp(fi, &i, 0);
	if(!(*m = malloc((i + n) << 2))) return -1;
	**m = i; if(i > 1) {
	  if(fseek(fi, a, SEEK_SET)) return -1;
	  dk4_jmp(fi, *m, i);
	}
	if(n) {
	  if(fseek(fi, 4, SEEK_SET)) return -1;
	  i = **m; **m = i + n;
	  READ(*m + i, n << 2);
	}
	if(fseek(fi, a, SEEK_SET)) return -1;

	for(;;) {
	  for(n = **m, i = 1; i < n; i++) if((*m)[i] == p) { printf("_x%04X:\n", p); break; }
	  if((a = fgetc(fi)) == EOF) break; p++;

	  printf("m1 0x%02X", a);
	  dk4_printf(fi, &p, 1, dk4_code(a));
	  putchar('\n');
	}
	return 0;
}

static int dk4_asm(FILE *fi) {
	uint a; uint *m = 0;
	a = dk4_asm_local(fi, &m);
	if(m) free(m);
	if(a) printf("\n%%error");
	return a;
}

static int dk4_get(FILE *fi) {
	uint a, p = 0;
	READ(&a, 4);
	if(fseek(fi, a * 4 + 4, SEEK_SET)) return -1;
	for(;;) {
	  if((a = fgetc(fi)) == EOF) break; p++;
	  dk4_printf(fi, &p, 2, dk4_code(a));
	}
	return 0;
}

static int dk4_fix(FILE *fi, FILE *fo, void *m) {
	uint a, i, n, p = 0, x;

	if(fseek(fi, 0, SEEK_SET)) return -1;
	if(fseek(fo, 4, SEEK_SET)) return -1;
	READ(&n, 4);
	for(i = 0; i < n; i++) {
	  READ(&a, 4); a = reloc_fix(m, a);
	  fwrite(&a, 1, 4, fo);
	}
	n = n * 4 + 4;

	for(;;) {
	  if((a = fgetc(fi)) == EOF) break; p++;
	  a = dk4_code(a);

	  if((a >> 4) == 5) {
	    if(dk4_printf(fi, &p, 0, a & 0xF)) return -1;
	    a >>= 4;
	  }
	  if(a == 5) {
	    READ(&a, 4);
	    if((x = reloc_fix(m, a)) != a) {
	      a = n + reloc_fix(m, p);
	      // printf("change %08X %08X\n", a, x);
	      if(fseek(fo, a, SEEK_SET)) return -1;
	      fwrite(&x, 1, 4, fo);
	    }
	    p += 4;
	  } else if(dk4_printf(fi, &p, 0, a)) return -1;
	}
	return 0;
}

static int dk4_put(FILE *fi, FILE *fo) {
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
	  x = text_copy(fo);
	  do { if((a = fgetc(fi)) == EOF) goto end; p++; } while(a);
	  fputc(0, fo);

	  reloc_add(r, p, ftell(fo) - p - n);
	}
end:	if(r[0]) {
	  dk4_fix(fi, fo, r[1]);
	  blk_destroy(r[0]);
	}
	return 0;
}
