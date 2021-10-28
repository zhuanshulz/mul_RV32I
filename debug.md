## BUG 日志

***20211027：***
    
    条件： carry out from lowerbits

    现象： 运算错误
    
    原因： carry out from lowerbits
    
    debug: add higher bits selfadd logic when lower bits carry out.

***20211028：***
    
    条件： x10 = 0xFF012300, x11 = 0xFF012303

    现象： 运算错误
    
    原因： 当x11的最低位为1时，需要将x10左移0位，送入低位的累加寄存器，并将x10右移32位并送入高位的累加寄存器。但是对于SLL, SRL, SRA来说， 其只使用rd寄存器的低五位完成移位，对于右移32位来说，rd目标寄存器的值为32，其二进制表示为0x0010_0000，其低五位全为0，执行的效果就变成了逻辑右移0位，进而出现了错误。
    
    debug: 将最低位的判断和运算单独从循环里提取出来单独执行。执行时不用逻辑移动，直接进行加法操作。