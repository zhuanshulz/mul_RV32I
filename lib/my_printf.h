#include <stdarg.h>

void printf_num(unsigned int num);
void printf_deci(int dec);
void printf_char(int ch);
void printf_str(char* str);
void printf_hexi(int hex);
void my_printf(char* str,...);

volatile char* outputAddr = (char*)0x13000000;

void printf_num(unsigned int num){
	if(num!=0){
		printf_num(num/10);
		unsigned int num_char=num%10+48;
		*outputAddr=(char)num_char;
		return;
	}
	else{
		return;
	}
	 
}

void printf_deci(int dec){
	if(dec==0){
		*outputAddr='0';
		return;
	}
	if(dec<0){
		*outputAddr='-';
		dec=0 - dec;
	}
	printf_num(dec);
}

void printf_hexi(int hex){
    unsigned int mask = 0x1111;
    unsigned int four_bits;
    *outputAddr=(char)(48);
    *outputAddr=(char)(120);
    for(int i=0; i<=7; i++ ){
        four_bits = 0;
        mask = 0x0000000f << ((7-i)*4);
        four_bits = mask & (unsigned int)(hex);
        four_bits = four_bits >> ((7-i)*4);
        if(four_bits < 10)
            *outputAddr=(char)((four_bits+48));
        else
            *outputAddr=(char)((four_bits+55));
    }
}

void printf_char(int ch){
	*outputAddr=(char)ch;
}

void printf_str(char* str){
	int i=0;
	for(i=0;str[i]!='\0';i++){
		*outputAddr=str[i];
	}
}

void my_printf(char* str, ...){
	va_list va_ptr;
	va_start(va_ptr,str);
	int i;
	for(i=0;str[i]!='\0';i++){
		if(str[i]!='%'){
			*outputAddr=str[i];
			continue;
		}
		switch(str[++i]){
			case 'd':
				printf_deci(va_arg(va_ptr,int));	
				break;
            case 'X':
				printf_hexi(va_arg(va_ptr,int));	
				break;
			case 'c':
				printf_char(va_arg(va_ptr,int));
				break;
			case 's':
				printf_str(va_arg(va_ptr,char*));
				break;
			default:
				break;

		}
	}
	va_end(va_ptr);
}

