import sys

def sort(args):
    lst = [int(i) for i in args]

    for i in range(len(lst)-1, 0, -1):
        for j in range(i):
            if lst[j] > lst[j+1]:
                tmp = lst[j]
                lst[j] = lst[j+1]
                lst[j+1] = tmp

    return lst

def main(args):
    args.pop(0)
    print(sort(args))

main(sys.argv)
