output = ""
label = input("Label to jump to")
times = input("Amount of statments")
mul = input("Multiplyer")

print("Generating...\n")
for i in range(1,int(times)):
    x = i*int(mul)
    output += "\tcmp edx, {}\n\tje {}\n".format(x, label)
print(output)