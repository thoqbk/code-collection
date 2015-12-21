
. ./copy.sh

HOME_DIRECTORY=`pwd`

cd ~
USER_DIRECTORY=`pwd`

cd $HOME_DIRECTORY

LIB_DIRECTORY="$HOME_DIRECTORY"/lib

echo "-----"

read -p "1. Enter the source directory (ex: $USER_DIRECTORY/.m2/repository): " sourceDirectory

if [ ! -d "$sourceDirectory" ]; then
	echo "\""$sourceDirectory"\" is not a valid directory"
	exit
fi

read -p "2. Enter the pattern of files you want to collect (ex: *Mapper.xml): " pattern

read -p "3. Enter the destination directory (ex: $USER_DIRECTORY/code-collection/target): " destinationDirectory

if [ ! -d "$destinationDirectory" ]; then
	echo "\""$destinationDirectory"\" is not a valid directory"
	exit
fi

read -p "4. Enter the max deep of destination directory: " maxDestinationDirectoryDeep

echo "Begin scan for suitable files and copy them to the destination directory"
echo ">> Source: " $sourceDirectory
echo ">> Pattern: " $pattern
echo ">> Destination: " $destinationDirectory
echo ">> Max deep of destination directory: " $maxDestinationDirectoryDeep

cd $sourceDirectory

resultFilesInSring=`find . -type f -name "$pattern"`

totalCopiedFiles=0

startTime=`date`

while IFS=' ' read -ra resultFiles; do
	for resultFile in "${resultFiles[@]}"; do
		copyResultFile $resultFile $destinationDirectory $maxDestinationDirectoryDeep
		totalCopiedFiles=$((totalCopiedFiles+1))
	done
done <<< "$resultFilesInSring"

endTime=`date`

echo "-----"
echo "Finished copying "$totalCopiedFiles" file(s) to destination directory. Start Time: " $startTime ". End Time: " $endTime
echo "-----"




