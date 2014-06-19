
/*
uchar[4];			// 'SR01'
uint file_size, 4, 0x32C2B241;
// table
uint offset, size, count;	// 0x34, n * 0x20
// code
uint offset, size, 1;
// string
uint offset, size, count;

table:
ushort 20h, 8
uint 4, 1Ah
ushort ?,?
uint 0
uchar[12];

code:
uint fullsize;
uint strsize;
uchar[];
uint size;
*/

static int kogado_get(FILE *fi) {
	uint a, i, n, t[13];
	READ(t, 0x34);
	if(memcmp(t, "SR01", 4)) return -1;
	if(fseek(fi, t[10], SEEK_SET)) return -1;
	for(i = 0; i < t[12]; i++) {
	  if(fread(&a, 1, 2, fi) != 2) break;
	  n = (ushort)a;
	  if(n < 2) break;
	  n -= 2;
	  printf("%03i ", i);
	  if(n) do {
	    LODSB;
	    if(!a && n < 3) break;
	    text_putc(a);
	  } while(--n);
	  if(n == 2) LODSB;
	  putchar('\n');
	}
	return 0;
}

static int kogado_put(FILE *fi, FILE *fo) {
	uint a, i, n, t[13], p, x = 0;
	READ(t, 0x34);
	if(memcmp(t, "SR01", 4)) return -1;
	fwrite(t, 1, 0x34, fo);
	for(i = 0x34; i < t[10]; i++) {
	  LODSB; fputc(a, fo);
	}
	for(i = 0; i < t[12]; i++) {
	  if(!x) x = text_num();
	  if(i == x) {
	    if(fread(&a, 1, 2, fi) != 2) break;
	    n = (ushort)a;
	    if(n < 2) break; n -= 2;
	    if(n) do { LODSB; } while(--n);
	    a = ftell(fo);
	    fwrite(&n, 1, 2, fo);
	    x = text_copy(fo);
	    fputc(0, fo);
	    n = ftell(fo) - a;
	    if(n & 1) { n++; fputc(0, fo); }
	    if(fseek(fo, a, SEEK_SET)) return -1;
	    fwrite(&n, 1, 2, fo);
	    if(fseek(fo, a + n, SEEK_SET)) return -1;
	  } else {
	    if(fread(&a, 1, 2, fi) != 2) break;
	    fwrite(&a, 1, 2, fo);
	    n = (ushort)a;
	    if(n < 2) break; n -= 2;
	    if(n) do { LODSB; fputc(a, fo); } while(--n);
	  }
	}
	a = ftell(fo);
	t[1] = a;
	t[11] = a - t[10];
	if(fseek(fo, 0, SEEK_SET)) return -1;
	fwrite(t, 1, 0x34, fo);
	return 0;
}

