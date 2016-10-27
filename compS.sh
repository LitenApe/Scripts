function diffFiles {
    curPath=$(pwd)

    # set path for directories
    fasPath="$curPath/pascal/testFF/$1/"
    resPath="$curPath/pascal/resLogs/$2/"

    # retrieve log files
    resultater=$(ls $resPath)
    fasit=$(ls $fasPath)

    # split files into an array
    resultater=$resultater | cut -d ' ' -f 1,2,3,4,5,6
    fasit=$fasit | cut -d ' ' -f 1,2,3,4,5,6

    echo ""
    echo "TESTING $3 LOGS:"
    # iterate and diff the files
    for fas in $fasit; do
        for res in $resultater; do
            if [[ $res == $fas ]]; then
                tester="$(diff -b "$resPath$res" "$fasPath$fas")"
                if [[ ${#tester} -eq 0 ]]; then
                    echo "Passed:" $fas
                else
                    echo "Failed:" $fas
                fi
            fi
        done
    done
}
diffFiles scanner scannerLog SCANNER
diffFiles parser parserLog PARSER
diffFiles checker checkerLog CHECKER
