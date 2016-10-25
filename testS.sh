# make directories
mkdir -p pascal/resLogs/scannerLog
mkdir -p pascal/resLogs/parserLog
mkdir -p pascal/resLogs/checkerLog
# mkdir -p pascal/resLogs/scannerRes

# flag
mode="-testchecker"

# set flag
if [[ ${#@} > 0 ]]; then
    if [[ $1 == "-s" ]]; then
        mode="-testscanner"
    elif [[ $1 == "-p" ]]; then
        mode="-testparser"
    elif [[ $1 == "-c" ]]; then
        mode="-testchecker"
    fi
fi

# get current path
curPath=$(pwd)

# compile the source file
ant jar

# iterate through the pascal files
for f in $(find pascal/testFiles -type f -name '*.pas'); do
  java -jar pascal2016.jar $mode $f; echo ' '
done

# move log files in testFiles directory to a seperate folder
if [[ $mode == "-testscanner" ]]; then
    mv $curPath/pascal/testFiles/*.log $curPath/pascal/resLogs/scannerLog/
elif [[ $mode == "-testparser" ]]; then
    mv $curPath/pascal/testFiles/*.log $curPath/pascal/resLogs/parserLog/
elif [[ $mode == "-testchecker" ]]; then
    mv $curPath/pascal/testFiles/*.log $curPath/pascal/resLogs/checkerLog/
fi
