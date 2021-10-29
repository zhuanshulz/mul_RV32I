#!/bin/bash
# set -x

AS="riscv64-unknown-linux-gnu-as"
CC="riscv64-unknown-linux-gnu-gcc"
LD="riscv64-unknown-linux-gnu-ld"
OBJCOPY="riscv64-unknown-linux-gnu-objcopy"
OBJDUMP="riscv64-unknown-linux-gnu-objdump"

# FLAGS="-mabi=ilp32 -march=rv32i"
FLAGS="-mabi=ilp32 -march=rv32im"

name=test
# name=${TEST}

if [ -f ${name}".lst" ]; then
  rm $name".lst"
fi
if [ -f ${name}".elf" ]; then
  rm $name".elf"
fi

#echo assemble $name

if [ "$0" == "S2Elf.sh" ]; then
  path=.
 else
  path=`dirname $0`
fi

${AS} ${FLAGS} ${name}.s -o ${name}.o
# ${CC} -march=rv32i -c *.c -o *.o

# ${LD} ${FLAGS} --discard-none -T $path/link.ld -o ${name}.linux-gnu ${name}.o

if [ -f ${name}.o ]; then
  riscv32-unknown-linux-gnu-ld --discard-none -T $path/link.ld -o ${name}.elf ${name}.o
fi

if [ -f ${name}.elf ]; then
  ${OBJCOPY} -O verilog --only-section ".text*" --set-start=0x0 ${name}.elf ${name}.p.hex
  ${OBJCOPY} -O verilog --only-section ".data*" --only-section ".rodata*" ${name}.elf ${name}.p.hex
  
  rm -f ${name}.d.hex
  rm -f ${name}.p.hex
  
  ${OBJDUMP} -d $name".elf" >$name".lst"
  
  rm ${name}".o"
  echo "Success!"
fi

