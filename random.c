#include<stdio.h>
#include<stdlib.h>

void gen_random(){
	unsigned int a=rand();
	unsigned int b=rand();
	asm volatile("add x10,x0,%0"::"r"(a));
    asm volatile("add x11,x0,%0"::"r"(b));	
}

