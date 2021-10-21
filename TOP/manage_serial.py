import serial
import random

# arty9
usb_num = 17
ser = serial.Serial("/dev/ttyUSB"+str(usb_num), baudrate=115200)

# Reading random values from file, passing them to FPGA and saving the output to an external file
with open("input_vectors.txt", "r") as f_in:
    with open("results_vectors.txt", "w") as f_out:
        lines = f_in.readlines()
        for line in lines:
            i = int(line)
            i = i+64
            # write() and read() because the serial port can represent 8bit data,
            # while a printable character is represented by 7bit data,
            # so this is an exploit to use that extra 1bit
            ser.write(chr(i))
            d = ser.read()
            # ord(d) => integer that represents the character d
#            print(ord(d))
            f_out.write(str(ord(d)-64)+"\n")