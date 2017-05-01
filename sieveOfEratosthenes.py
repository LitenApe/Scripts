max = 10000000 # 10 000 000

list = [True] * max
list[0] = list[1] = False

for i, val in enumerate(list):
    if val:
        for j in range(i*i, max, i):
            list[j] = False

list = [idx for idx, val in enumerate(list) if val]

cmd = input("Choose a number between 0 and {0}: ".format(len(list)))

print("The {0}th prime number is {1}".format(cmd, list[int(cmd)]))
