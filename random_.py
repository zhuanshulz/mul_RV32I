import random
import sys

debug_file = open("./lib/config.h","w")

debug_file.write("#define test_time ")
debug_file.write(sys.argv[1])
debug_file.write("\n")

debug_file.write("unsigned int mul_a [test_time]= {")
debug_file.write("\n")
for i in range(int(sys.argv[1], base=10)):
    debug_file.write(str(hex(random.randrange(0,4294967295))))
    if (i !=  int(sys.argv[1], base=10)-1):
        debug_file.write(",")
    debug_file.write("\t")
debug_file.write("\n};")

debug_file.write("\n\n")

debug_file.write("unsigned int mul_b [test_time]= {")
debug_file.write("\n")
for i in range(int(sys.argv[1], base=10)):
    debug_file.write(str(hex(random.randrange(0,4294967295))))
    if (i !=  int(sys.argv[1], base=10)-1):
        debug_file.write(",")
    debug_file.write("\t")
debug_file.write("\n};")

debug_file.close()