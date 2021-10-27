#####################################################
#function description:
#	32bits unsigned multiply using RV32I ISA
#
#register usage:

#x1:compare return address
#x2:pass data address
#x3:exit address 0x13000000
#x4:fail data address
#x5:print string
#x29:line_feed data address
#x30:tag_test data address

#x6-x9:x0,x31 

#funtion reg consumptions
#x10-x11: multiply function parameters
#x18-x19: multiply function returns
#x20-x21: actual multiply result
#x23: function instruction consumption

#x28: temp reg

#####################################################

.section .text
.global _start
_start:

#   initialize TUBE address as DAMI
   li x3,   0x13000000
   li x10,  0xff012303
   li x11,  0xff012300

   la x2, pass_msg #load pass_msg
   la x4, fail_msg #load pass_msg
   la x29, line_feed #load line_feed
#   la x30, tag_test #tag_test

	mul x20, x10,x11
	mulhu x21, x10, x11

#   initialize register

#   lable pc

part:
	
     lui x18, 0			#set x18 = 0x0
     lui x19, 0			#set x19 = 0x0
     add  x13, x0, x0		#set x13 = 0 
     addi x14, x0, 32		#set x14 = 32
     addi x12, x0, 1		#set x12 = 0x1
# initial done

# judge zero parameter
	beq x0, x10, 2f		#if x10 == 0 then break, result = 0
	beq x0, x11, 2f		#if x11 == 0 then braek, result = 0
# judge zero parameter done


1:	# origin: multiple add. new: shift add
     	# x10 x11 origin unsinged num
	# x12,x15 used to calculate which bit is 1
	# x13 low bits index
	# x14 high bits index
     	# x16 temp low bits
	# x17 temp high bits
	# x18 x19 calculated result, high 32 bits in x19

# judge the bit of multiplicand if it is 0x1 or 0x0
	and x15,x12,x11
	beq x15,x0,4f
# judge done

# compute logic shift values
	sll x16,x10,x13
	srl x17,x10,x14
# compute done

# accumulate
	add x18,x18,x16
	add x19,x19,x17
# accumulate done

# judge if accumulate carry out
	bltu x18,x16,5f
# judge done

# jump to update mask
     jal x0, 4f
# jump done

2:     	
     jal x1, 3f

     jal x0, _finish

#   compare calculated value with the actual value
3:
     # la x30, tag_test #tag_test
     # addi x30, x30, 0
	bne x18,x20,fail
	beq x19,x21,pass
	jal x0,fail

4:	# for every bit, calculate down, then judge condition and selfadd index
	# update index
	addi x13,x13,1
	addi x14,x14,-1
	# update mask
	add x12,x12,x12
	# update down

	# judge index edge	
	beq x14,x0,2b		# if index x14 == 0, then calculate done.
	jal x0,1b		# else continue
	# judge done

5:	# selfadd for upper bits of mul accumulator
	addi x19,x19,1
	jal x0,4b
	# selfadd done back to index & mask update

#test_passed
pass:
  
1:   lb x5, 0(x2)
     sb x5, 0(x3)
     addi x2, x2, 1
     bnez x5, pass

# 2:   lb x5, 0(x30)
#     sb x5, 0(x3)

3:   lb x5, 0(x29)
     sb x5, 0(x3)

4:   la x2, pass_msg	#initialize
     # la x30, tag_test   #tag_test

5:   jalr x0, x1, 0


#test_failed
fail:

1:   lb x5, 0(x4)
     sb x5, 0(x3)
     addi x4, x4, 1
     bnez x5, fail

2:   
     lb x5, 0(x30)
     sb x5, 0(x3)

3:   lb x5, 0(x29)
     sb x5, 0(x3)

4:   la x4, fail_msg	#initialize 
     # la x30, tag_test   #tag_test

5:   jalr x0, x1, 0

  
_finish:
    li x3, 0x13000000
#   send CTRL+D to TUBE to indicate finish test
    addi x5, x0, 0x4
    sb x5, 0(x3)
#   dead loop
    beq x0, x0, _finish
#.rept 100
#    nop
#.endr
#    nop
.section .rodata
pass_msg:
.string "------PASS------"
.byte 0
fail_msg:
.string "------FAIL------"
.byte 0
tag_test:
.string "123456789abcdef"
line_feed:
.string "\n"
.byte 0 
