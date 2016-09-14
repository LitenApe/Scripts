import sys, requests, bs4, json
from os import path

# file to store data and link to fetch data from
FILE_DATA = path.join(path.dirname(path.realpath(__file__)), "cruiser_prices.txt")
URL = "http://boardshop.no/skate?category=1%2FSkate%2FCruiser%20%26%20longboard&category=2%2FSkate%2FCruiser%20%26%20longboard%2FKomplett%20"
# array to store data
results = []

# main function for argument handling
def main(argv):
    ## args handling
    write_data = True
    printing = False
    board = "Longboard"

    # if there's no arguments, run normally
    if len(argv) == 1:
        fetch_data(write_data,board)
    else:
        for args in argv[1:]:
            if args == "-d":
                write_data = False
            elif args == "-p":
                printing = True
            elif args == "-l":
                board = "Longboard"
            elif args == "-c":
                board = "Cruiser"
            else:
                print("USAGE:\n -p = print results\n -d = don't save result\n -l = Longboards\n -c = Cruiser\n -h = help")
                sys.exit()
        # start fetching data
        fetch_data(write_data,board)

        # print data
        if printing:
            print_result()

def fetch_data(write_data,boardType):
    try:
        print("======= FETCHING DATA ======")
        # fetch html
        r = requests.get(URL + boardType)
        soup = bs4.BeautifulSoup(r.text, 'html.parser')

        print("======= PARSING DATA =======")
        # retrieve script tags and retrieve the json
        res = soup.find_all("script")[9].string
        data = res.split("//")
        jsonData = data[2].split("var navInitData = ")

        print("====== FORMATING DATA ======")
        # prepare for action!
        js = json.loads(jsonData[1])
        js = js["result"]["items"]

        print("======= CACHING DATA =======")
        # iterate through the data
        for i in js:
            for j in i["products"]:
                results.append(i["title"] + " = " + j["price"])

        if write_data:
            write_to_file()

    except:
        print("I were not able to fetch data")

def write_to_file():
    try:
        print("======= WRITING DATA =======")
        # open file
        f = open(FILE_DATA, 'w+')

        # write results to the file
        for i in results:
            f.write(i + "\n")

        # close file
        f.close()

        print("======= DONE WRITING =======")
    except:
        print("An error occured while writing data to file")

def print_result():
    print("====== PRINTING RESULT =====")
    for i in results:
        print(i)

if __name__ == "__main__":
    main(sys.argv)
