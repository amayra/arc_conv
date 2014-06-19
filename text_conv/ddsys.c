
/*
 daylight.exe
 0040EF41 vm
 0040BF40 read_exp
 0040C560 read_str
 0040F410 read_tab
*/

static int ddsys_check(FILE *fi, uchar *t) {
	READ(t, 0x10);
	return strcmp(t, "DDSxSpt") && strcmp(t, "SHSysSC");
}

static int ddsys_code(uint a) {

	switch(a) {
	  case 0x00:	// 0040F570
	  case 0x05:	// 004109B0
	  case 0x07:	// 00411EF0
	  case 0x09:	// 004128A0
	  case 0x0B:	// 00410EE0
	  case 0x19:	// 0040BF40 return %1
	  case 0x1A:	// 00412780
	  case 0x1B:	// 00410E90
	  case 0x1D:	// 00410D30
	  case 0x23:	// 00410490
	  case 0x24:	// 00413C60
	  case 0x25:	// 00410A10
	  case 0x33:	// 00410B20
	  case 0x3C:	// 0040F710
	  case 0x40:	// 00411910
	  case 0x4F:	// 00411ED0 Sleep(%1)
	  case 0x5C:	// 00410440
	    return 0x1;

	  case 0x02:	// 0040F6B0
	    return 0x43;

	  case 0x03:	// 004108F0
	    return 0x31;

	  case 0x06:	// 00410840
	    return 0x3112;

	  case 0x0F:	// 00410180
	  case 0x31:	// 0040F890
	  case 0x48:	// 00411970
	  case 0x63:	// 00414C60
	    return 0x7;

	  case 0x10:	// 00410120 CreateFont(...)
	    return 0x7121;

	  case 0x11:
	    return 0x12121;
	
	  case 0x12:	// 0040F7E0
	  case 0x60:	// 00413EF0
	    return 0x71;

	  case 0x0E:	// 0040FED0
	  case 0x15:	// 004102C0
	    return 0x77;

	  case 0x16:	// 004111C0
	    return 0x777;

	  case 0x17:	// 0040FFC0
	    return 0x72111;

	  case 0x26:	// 0040F580 if(%1) goto %2
	  case 0x27:	// 0040F5F0 if(!%1) goto %2
	    return 0x41;

	  case 0x28:	// 0040F5B0 if(%1) goto %2; else goto %3 
	    return 0x441;

	  case 0x29:	// 0040F620 goto %1
	    return 0x4;

	  case 0x2A:	// 0040F650 switch(%1)
	    return 0x51;

	  case 0x2C:	// 0040F770
	  case 0x2D:	// 00412250
	  case 0x59:	// 00410F40
	    return 0x1121;

	  case 0x2E:	// 00411110
	    return 0x121;

	  case 0x32:	// 00411E10
	    return 0x712;

	  case 0x36:	// 00412C40
	    return 0x61;

	  case 0x0D:	// 00413370
	  case 0x14:	// 00413420
	  case 0x18:	// 0040FF70
	  case 0x2F:	// 004101C0
	  case 0x3A:	// 00413490
	  case 0x3B:	// 00410210
	  case 0x44:	// 00412000
	  case 0x4B:	// 00411DD0
	  case 0x4C:	// 00412F90
	  case 0x5F:	// 00413DA0
	    return 0x111;

	  case 0x45:	// 00413300
	    return 0x211;

	  case 0x4D:	// 00412540
	    return 0x222;

	  case 0x55:	// 0040FC40
	    return 0x1112;

	  case 0x41:	// 004117C0
	  case 0x58:	// 00412FF0
	  case 0x64:	// 00414CC0
	    return 0x12;

	  case 0x42:	// 004115D0
	  case 0x53:	// 0040FB40
	  case 0x5E:	// 004116E0
	    return 0x22;

	  case 0x01:	// 00411FD0
	  case 0x04:	// 00411080
	  case 0x0C:	// 00412940
	  case 0x1C:	// 004120A0
	  case 0x1F:	// 00410B90
	  case 0x35:	// 00410A50
	  case 0x38:	// 004110D0
	  case 0x43:	// 00410450
	  case 0x46:	// 004115D0
	  case 0x47:	// 00413290
	  case 0x49:	// 00411F90
	  case 0x4A:	// 00413D60
	  case 0x4E:	// 0040F820
	  case 0x50:	// 0040F900
	    return 0x11;

	  case 0x13:	// 004113D0
	  case 0x3E:	// 004122C0
	  case 0x52:	// 0040F9D0
	  case 0x54:	// 0040F950
	  case 0x56:	// 0040FBB0
	  case 0x5A:	// 00412200
	  case 0x61:	// 00414C20
	  case 0x65:	// 00414D60
	    return 0x21;

	  case 0x08:	// 004133C0
	  case 0x2B:	// 00410E20
	  case 0x34:	// 00410B10	
	  case 0x37:	// 00411600
	  case 0x3D:	// 00410E00
	  case 0x57:	// 0040FB60
	  case 0x62:	// 00414C40
	    return 0x2;

	  case 0x5B:	// 004125E0
	    return 0x711;

	  case 0x0A:	// 00411E80
	  case 0x1E:	// 00410CB0
	  case 0x20:	// 00410F00
	  case 0x21:	// 00410260
	  case 0x22:	// 004132B0
	  case 0x30:	// 00413C20
	  case 0x39:	// 00410DF0
	  case 0x3F:	// 00412140
	  case 0x51:	// 00411E70
	  case 0x5D:	// 00410820
	  case 0xFF:	// 0040CC10 return
	    return 0;
	}
	return -1;
}

static int ddsys_exp(FILE *fi, uint *p, uint f) {
	int a, n, i = 0; uchar t[4];
	if(f == 1) printf("{");
	for(;;) {
	  LODSB; (*p)++;
	  if(a == 0xFF) break;
	  if(f == 1) { if(i) printf(", "); i++; printf("0x%02X", a); }
	  if(a >= 0x40) continue;
	  n = a & 0xF;
	  if(a & 0x30) n -= 0xD;
	  else { n -= 0xC; if(n == 3) n++; }
	  if(n <= 0) continue;
	  READ(t, n); *p += n;
	  if(f != 1) continue;
	  if(n == 1) printf(",0x%02X", t[0]);
	  else if(n == 2) printf(",0x%04X", (t[0] << 8) + t[1]);
	  else if(n == 4) printf(",0x%08X", (t[0] << 24) + (t[1] << 16) + (t[2] << 8) + t[3]);
	}
	if(f == 1) putchar('}');
	return 0;
}

static int ddsys_print_str(FILE *fi, uint *p, uint f) {
	uint a, x = 0; uchar t[4];
	if(f == 1) printf("{");
	LODSB; (*p)++;
	if(a && a < 0x20) {
	  if(f == 1) printf("0x%02X,", a);
	  if(a < 6) {
	    READ(t, 1); *p += 1;
	    if(f == 1) printf("0x%02X", t[0]);
	  } else if(a < 0xC)  {
	    READ(t, 2); *p += 2;
	    if(f == 1) printf("0x%04X", (t[0] << 8) + t[1]);
	  } else if(ddsys_exp(fi, p, f)) return -1;
	} else if(f != 2) {
	  if(a) do {
	    if(f) asmchar(&x, a);
	    LODSB; (*p)++;
	  } while(a);
	  if(f) asmchar(&x, -1);
	} else {
	  printf("%04i ", *p - 1);
	  if(a) do {
	    text_putc(a);
	    LODSB; (*p)++;
	  } while(a);
	  putchar('\n');
	}
	if(f == 1) putchar('}');
	return 0;
}

static int ddsys_jmp(FILE *fi, uint *m, uint x) {
	uint a, i = 1, p = 0x10, n, fmt; uchar t[4];
	*m = i;
	for(;;) {
	  if((a = fgetc(fi)) == EOF) break; p++;
	  fmt = ddsys_code(a);

	  if(fmt != -1) while(fmt) {
	    a = fmt & 0xF; fmt >>= 4;
	    if(a == 1) {
	      if(ddsys_exp(fi, &p, 0)) return -1;
	    } else if(a == 2) {
	      if(ddsys_print_str(fi, &p, 0)) return -1;
	    } else if(a == 3) {
	      for(;;) {
	        LODSB; p++;
	        if(!a) break;
	        if(a == 1) { if(ddsys_print_str(fi, &p, 0)) return -1; }
	        else if(a == 2) { if(ddsys_exp(fi, &p, 0)) return -1; }
	      }
	    } else if(a == 4) {
	      READ(t, 3); p += 3;
	      a = (t[0] << 16) + (t[1] << 8) + t[2];
	      if(i == x) return 0;
	      if(x) m[i] = a; i++; *m = i;
	    } else if(a == 5) {
	      READ(t, 2); p += 2;
	      n = (t[0] << 8) + t[1];
	      if(n) do {
	        READ(t, 3); p += 3;
	        a = (t[0] << 16) + (t[1] << 8) + t[2];
	        if(i == x) return 0;
	        if(x) m[i] = a; i++; *m = i;
	      } while(--n);
	    } else if(a == 6) {
	      LODSB; p++;
	      if(a) { if(ddsys_print_str(fi, &p, 0)) return -1; }
	      else { if(ddsys_exp(fi, &p, 0)) return -1; }
	    } else if(a == 7) {
	      if(ddsys_exp(fi, &p, 0)) return -1;
	      if(ddsys_exp(fi, &p, 0)) return -1;
	      if(ddsys_exp(fi, &p, 0)) return -1;
	      if(ddsys_exp(fi, &p, 0)) return -1;
	    }
	  }
	}
	return 0;
}

static int ddsys_asm_local(FILE *fi, uint **m) {
	uint a, i, p = 0x10, n, fmt; uchar t[0x10];

	if(ddsys_check(fi, t)) return -1;
	printf("m0 \"%s\"\n", t);

	ddsys_jmp(fi, &i, 0);
	if(!(*m = malloc(i << 2))) return -1;
	**m = i; if(i > 1) {
	  if(fseek(fi, 0x10, SEEK_SET)) return -1;
	  ddsys_jmp(fi, *m, i);
	}
	if(fseek(fi, 0x10, SEEK_SET)) return -1;

	for(;;) {
	  for(n = **m, i = 1; i < n; i++) if((*m)[i] == p) { printf("_x%06X:\n", p); break; }
	  if((a = fgetc(fi)) == EOF) break; p++;
	  fmt = ddsys_code(a);
	  printf("m1 0x%02X,0x%X", a, fmt);

	  if(fmt != -1) while(fmt) {
	    printf(", ");
	    a = fmt & 0xF; fmt >>= 4;
	    if(a == 1) {
	      if(ddsys_exp(fi, &p, 1)) return -1;
	    } else if(a == 2) {
	      if(ddsys_print_str(fi, &p, 1)) return -1;
	    } else if(a == 3) {
	      i = 0;
	      printf("{");
	      for(;;) {
	        if(i) printf(", "); i++;
	        LODSB; p++;
	        printf("0x%02X", a);
	        if(!a) break;
	        putchar(',');
	        if(a == 1) { if(ddsys_print_str(fi, &p, 1)) return -1; }
	        else if(a == 2) { if(ddsys_exp(fi, &p, 1)) return -1; }
	        else printf("\n%%error\n");
	      }
	      putchar('}');
	    } else if(a == 4) {
	      READ(t, 3); p += 3;
	      printf("_x%06X", (t[0] << 16) + (t[1] << 8) + t[2]);
	    } else if(a == 5) {
	      i = 0;
	      READ(t, 2); p += 2;
	      n = (t[0] << 8) + t[1];
	      printf("0x%04X,{", n);
	      if(n) do {
	        if(i) printf(", "); i++;
	        READ(t, 3); p += 3;
	        printf("_x%06X", (t[0] << 16) + (t[1] << 8) + t[2]);
	      } while(--n);
	      putchar('}');
	    } else if(a == 6) {
	      LODSB; p++;
	      printf("0x%02X,", a);
	      if(a) { if(ddsys_print_str(fi, &p, 1)) return -1; }
	      else { if(ddsys_exp(fi, &p, 1)) return -1; }
	    } else if(a == 7) {
	      if(ddsys_exp(fi, &p, 1)) return -1;
	      printf(", ");
	      if(ddsys_exp(fi, &p, 1)) return -1;
	      printf(", ");
	      if(ddsys_exp(fi, &p, 1)) return -1;
	      printf(", ");
	      if(ddsys_exp(fi, &p, 1)) return -1;
	    }
	  } else printf("\n%%error");
	  putchar('\n');
	}
	printf("_e:\n");
	return 0;
}

static int ddsys_asm(FILE *fi) {
	uint a; uint *m = 0;
	a = ddsys_asm_local(fi, &m);
	if(m) free(m);
	if(a) printf("\n%%error");
	return a;
}

static int ddsys_get(FILE *fi) {
	uint a, i, p = 0x10, n, fmt; uchar t[0x10];

	if(ddsys_check(fi, t)) return -1;
	for(;;) {
	  if((a = fgetc(fi)) == EOF) break; p++;
	  fmt = ddsys_code(a);

	  if(fmt != -1) while(fmt) {
	    a = fmt & 0xF; fmt >>= 4;
	    if(a == 1) {
	      if(ddsys_exp(fi, &p, 2)) return -1;
	    } else if(a == 2) {
	      if(ddsys_print_str(fi, &p, 2)) return -1;
	    } else if(a == 3) {
	      for(;;) {
	        LODSB; p++;
	        if(!a) break;
	        if(a == 1) { if(ddsys_print_str(fi, &p, 2)) return -1; }
	        else if(a == 2) { if(ddsys_exp(fi, &p, 2)) return -1; }
	      }
	    } else if(a == 4) {
	      READ(t, 3); p += 3;
	    } else if(a == 5) {
	      READ(t, 2); p += 2;
	      n = (t[0] << 8) + t[1];
	      if(n) do {
	        READ(t, 3); p += 3;
	      } while(--n);
	    } else if(a == 6) {
	      LODSB; p++;
	      if(a) { if(ddsys_print_str(fi, &p, 2)) return -1; }
	      else { if(ddsys_exp(fi, &p, 2)) return -1; }
	    } else if(a == 7) {
	      if(ddsys_exp(fi, &p, 2)) return -1;
	      if(ddsys_exp(fi, &p, 2)) return -1;
	      if(ddsys_exp(fi, &p, 2)) return -1;
	      if(ddsys_exp(fi, &p, 2)) return -1;
	    }
	  }
	}
	return 0;
}

static int ddsys_fix_local(FILE *fi, FILE *fo, void *m, uint p) {
	uint a, x; uchar t[4];

	READ(t, 3);
	a = (t[0] << 16) + (t[1] << 8) + t[2];
	if((x = reloc_fix(m, a)) != a) {
	  t[0] = x >> 16; t[1] = x >> 8; t[2] = x;
	  if(fseek(fo, reloc_fix(m, p), SEEK_SET)) return -1;
	  fwrite(t, 1, 3, fo);
	}
	return 0;
}

static int ddsys_fix(FILE *fi, FILE *fo, void *m) {
	uint a, i = 1, p = 0x10, n, fmt; uchar t[4];

	if(fseek(fi, 8, SEEK_SET)) return -1;
	if(ddsys_fix_local(fi, fo, m, 8)) return -1;
	if(fseek(fi, 0x10, SEEK_SET)) return -1;

	for(;;) {
	  if((a = fgetc(fi)) == EOF) break; p++;
	  fmt = ddsys_code(a);

	  if(fmt != -1) while(fmt) {
	    a = fmt & 0xF; fmt >>= 4;
	    if(a == 1) {
	      if(ddsys_exp(fi, &p, 0)) return -1;
	    } else if(a == 2) {
	      if(ddsys_print_str(fi, &p, 0)) return -1;
	    } else if(a == 3) {
	      for(;;) {
	        LODSB; p++;
	        if(!a) break;
	        if(a == 1) { if(ddsys_print_str(fi, &p, 0)) return -1; }
	        else if(a == 2) { if(ddsys_exp(fi, &p, 0)) return -1; }
	      }
	    } else if(a == 4) {
	      if(ddsys_fix_local(fi, fo, m, p)) return -1; p += 3;
	    } else if(a == 5) {
	      READ(t, 2); p += 2;
	      n = (t[0] << 8) + t[1];
	      if(n) do {
	        if(ddsys_fix_local(fi, fo, m, p)) return -1; p += 3;
	      } while(--n);
	    } else if(a == 7) {
	      if(ddsys_exp(fi, &p, 0)) return -1;
	      if(ddsys_exp(fi, &p, 0)) return -1;
	      if(ddsys_exp(fi, &p, 0)) return -1;
	      if(ddsys_exp(fi, &p, 0)) return -1;
	    }
	  }
	}
	return 0;
}

static int ddsys_put(FILE *fi, FILE *fo) {
	uint a, i, p = 0x10, x = 0; uchar t[0x10]; void *r[2] = { 0, 0 };

	if(ddsys_check(fi, t)) return -1;
	fwrite(t, 1, 0x10, fo);
	for(;;) {
	  if(!x) x = text_num();
	  // printf("replace %08X\n", x);
	  while(p != x) {
	    if((a = fgetc(fi)) == EOF) goto end; p++; fputc(a, fo);
	  }
	  x = text_copy(fo);
	  do { if((a = fgetc(fi)) == EOF) goto end; p++; } while(a);
	  fputc(0, fo);

	  reloc_add(r, p, ftell(fo) - p);
	}
end:	if(r[0]) {
	  ddsys_fix(fi, fo, r[1]);
	  blk_destroy(r[0]);
	}
	return 0;
}
