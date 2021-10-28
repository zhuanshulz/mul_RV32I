# this is the name of the program
export TEST=test

GCC=riscv32-unknown-linux-gnu-gcc
LD=riscv32-unknown-linux-gnu-ld
AS=riscv32-unknown-linux-gnu-as
FLAGS=-mabi=ilp32 -march=rv32im
src1 = $(wildcard ./*.c)
src2 = $(wildcard ./*.s)
obj1 = $(patsubst %.c, %.o, $(src1))
obj2 = $(patsubst %.s, %.o, $(src2))

%.o: %.c
	$(GCC) $(FLAGS) -c -o $@ $<

%.o: %.s
	$(AS) $(FLAGS) $< -o $@


all: clean link run

link:$(obj1) $(obj2)
	$(LD) --discard-none -T link.ld -o $(TEST).elf $(obj1) $(obj2)
	
run:$(TEST).elf
	spike --isa=rv32g --log-commits -l --log=trace.tarmac ${TEST}.elf

clean:
	rm -rf ./*.o ./$(TEST).elf ./*.tarmac ./*.lst
