OUTPUT_ARCH( "riscv" )
ENTRY(_start)

SECTIONS
{
  . = 0X00000000;
  .text.trap : { *(.text.trap) }

  . = 0x13000000;
  .tohost : { *(.tohost) }

  . = 0x80000000;
  .text.init : { *(.text.init) }
  . = ALIGN(0x1000);
  .text : { *(.text) }
  . = ALIGN(0x1000);
  .data : { *(.data) }
  .data.string : { *(.data.string) }
  .bss : { *(.bss) }
  _end = .;
}
