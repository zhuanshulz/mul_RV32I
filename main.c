#include<stdio.h>

int main(){
unsigned int mul_a = 0xff012300;
unsigned int mul_b = 0xff012303;
asm volatile("add x10,x0,%0"::"r"(mul_a));
asm volatile("add x11,x0,%0"::"r"(mul_b));
asm volatile("jal x1, mul_asm");

// printf("%h \n %h",mul_a, mul_b);
// printf("%h \n %h",mul_aa,mul_bb);
return 0;
}
