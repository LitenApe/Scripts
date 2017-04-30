from random import randint

def roll_dice():
    diceRoll = randint(1, 6)

    for i in range(100000):
        print(i%6, end="\r")
    print(diceRoll)

while(True):
    roll_dice()
    cmd = input("Do you want to roll again? (y/n): ")
    if(cmd != "y"):
        break
