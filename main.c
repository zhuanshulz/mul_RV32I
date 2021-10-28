#include<stdio.h>
#include<my_printf.h>

int main(){
unsigned int mul_a = 0xff012300;
unsigned int mul_b = 0xff012303;
asm volatile("add x10,x0,%0"::"r"(mul_a));
asm volatile("add x11,x0,%0"::"r"(mul_b));
asm volatile("jal x1, mul_asm");

my_printf("hello world!\n");
asm volatile("call break_run");
return 0;
}

void break_run(){

asm volatile("li x3, 0x13000000");
asm volatile("addi x5, x0, 0x4");
asm volatile("sb x5, 0(x3)");

}