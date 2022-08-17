output = ""
times = input("Amount of statments")
mul = input("Multiplyer")

print("Generating...\n")
for i in range(1,int(times)):
    x = 0x01+i
    output += "\tcmp edx, {}\n\tje .cpy{}\n".format(str(x), str(x))
print(output)