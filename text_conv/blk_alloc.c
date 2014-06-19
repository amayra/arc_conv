
void* mem_alloc(int n) {
	if(n <= 0) return 0;
	return VirtualAlloc(0, (n + 0xFFF) & -0x1000, MEM_COMMIT, PAGE_READWRITE);
}

int mem_free(void *m) {
	return VirtualFree(m, 0, MEM_RELEASE);
}

void* blk_alloc(void *b, uint n) {
	uint a; void *m, *d, *s, *p = (void**)b + 1;
	if(!b || !n) return 0;
	n = (n + sizeof(int) - 1) & (-sizeof(int));
	do {
	  s = p; if(!(p = *(void**)p)) break;
	  a = *(uint*)((void**)p + 1);
	} while(a < n);
	if(p) d = *(void**)p;
	else {
	  a = *(uint*)((void**)b + 2);
	  if(a - sizeof(void*) < n) {
	    a *= (sizeof(void*) + n + a - 1) / a;
	  }
	  if(!(p = mem_alloc(a))) return 0;
	  d = *(void**)b; *(void**)b = p; *(void**)p = d;
	  p = (void*)((void**)p + 1);
	  a -= sizeof(void*); d = 0;
	}
	m = p; a -= n;
	if(a >= sizeof(void*) + sizeof(uint)) {
	  p = (void**)((char*)m + n);
	  *(void**)p = d; *(uint*)((void**)p + 1) = a;
	  d = p;
	}
	*(void**)s = d;
	return m;
}

void* blk_create(uint n) {
	void *m, *d;
	n = (n + sizeof(int) - 1) & (-sizeof(int));
	if(n < sizeof(void*) * 2 + sizeof(uint) * 2) return 0;
	if(!(m = mem_alloc(n))) return 0;
	d = (void*)((char*)m + (sizeof(void*) * 2 + sizeof(uint)));
	*(void**)m = 0;
	*((void**)m + 1) = d;
	*(uint*)((void**)m + 2) = n;
	*(void**)d = 0;
	*(uint*)((void**)d + 1) = n - (sizeof(void*) * 2 + sizeof(uint));
	return m;
}

void blk_destroy(void *b) {
	void *m;
	while(b) {
	  m = *(void**)b; mem_free(b); b = m;
	}
}
