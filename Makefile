# this is the name of the program
export TEST=test

TESTTIME = 10

GCC=riscv32-unknown-linux-gnu-gcc
LD=riscv32-unknown-linux-gnu-ld
AS=riscv32-unknown-linux-gnu-as
FLAGS=-mabi=ilp32 -march=rv32im
lib = $(wildcard ./lib/*.o)
src1 = $(wildcard ./*.c)
src2 = $(wildcard ./*.s)
obj1 = $(patsubst %.c, %.o, $(src1))
obj2 = $(patsubst %.s, %.o, $(src2))
obj3 = $(patsubst %.h, %.o, $(lib))

%.o: %.c
	$(GCC) $(FLAGS) -I./lib/ -c -o $@ $< 

./lib/%.o: ./lib/%.h
	$(GCC) $(FLAGS) -c -o $@ $< 

%.o: %.s
	$(AS) $(FLAGS) $< -o $@


all: clean reconfig link sim clean_interm_files

link:$(obj3)$(obj2) $(obj1) 
	$(LD) --discard-none  -T link.ld -o $(TEST).elf $(obj1) $(obj2) -static -L./lib/
	
sim:$(TEST).elf
	spike --isa=rv32g --log-commits -l --log=trace.tarmac ${TEST}.elf

reconfig:
	python3 ./random_.py $(TESTTIME)

clean:
	rm -rf ./*.o ./$(TEST).elf ./*.tarmac ./*.lst ./lib/*.o

clean_interm_files:
	rm -rf ./*.o