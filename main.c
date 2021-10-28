#include<stdio.h>
#include<my_printf.h>
#include<config.h>
unsigned int return_values[2];


void call_mul_asm(unsigned int mul_a, unsigned int mul_b){
    // input parameters x10, x11
    // output parameters x18, x19. x19 is the higher bits.

// store envirement
    asm volatile("addi    sp, sp, -32");
    asm volatile("sw      ra, 28(sp)");
	asm volatile("sw      s0, 24(sp)");
    asm volatile("addi    s0, sp, 32");
    asm volatile("sw      a0, -20(s0)");
    asm volatile("sw      a1, -24(s0)");
// store done

// data input
    asm volatile("add x10,x0,%0"::"r"(mul_a));
    asm volatile("add x11,x0,%0"::"r"(mul_b));
// data input done
    
// function call
    asm volatile("jal x1, mul_asm");
// function call done
    
// data output
    asm volatile("add %0,x0,x18":"=r"(return_values[0]));
    asm volatile("add %0,x0,x19":"=r"(return_values[1]));
// data output done

// restore envirement
    asm volatile("lw      s0, 24(sp)");
    asm volatile("lw      ra, 28(sp)");
    asm volatile("addi    sp, sp, 32");
// restore done
}

void break_run_asm(){
    asm volatile("li x3, 0x13000000");
    asm volatile("addi x5, x0, 0x4");
    asm volatile("sb x5, 0(x3)");
}

void main(){
    // unsigned int mul_a = 0xf5679300;
    // unsigned int mul_b = 0xff012303;
    
    for(int i = 0; i < test_time; i++){
        my_printf("test condition %d: mul_a = %X, mul_b = %X \n", i,  mul_a[i], mul_b[i]);

        call_mul_asm(mul_a[i], mul_b[i]);

        my_printf("computed results %d: higher_bits = %X, lower_bits = %X \n",i, return_values[1], return_values[0]);
    }
    
    break_run_asm();
}

