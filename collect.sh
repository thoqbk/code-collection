
. ./copy.sh

HOME_DIRECTORY=`pwd`

cd ~
USER_DIRECTORY=`pwd`

cd $HOME_DIRECTORY

LIB_DIRECTORY="$HOME_DIRECTORY"/lib

if [ "$MODE" != "test" ]; then

	echo "-----"
	
	read -p "1. Enter the full path of source directory (ex: $USER_DIRECTORY/.m2/repository): " sourceDirectory

	if [ ! -d "$sourceDirectory" ]; then
		echo "\""$sourceDirectory"\" is not a valid directory"
		exit
	fi

	read -p "2. Enter the pattern of files you want to collect (ex: *Mapper.xml): " pattern

	read -p "3. Enter the full path of destination directory (ex: $USER_DIRECTORY/code-collection/target): " destinationDirectory

	if [ ! -d "$destinationDirectory" ]; then
		echo "\""$destinationDirectory"\" is not a valid directory"
		exit
	fi

	read -p "4. Enter the max deep of destination directory: " maxDestinationDirectoryDeep

fi

echo "Begin scan for suitable files and copy them to the destination directory"
echo ">> Source: " $sourceDirectory
echo ">> Pattern: " $pattern
echo ">> Destination: " $destinationDirectory
echo ">> Max deep of destination directory: " $maxDestinationDirectoryDeep

totalCopiedFiles=0

startTime=`date`

cd $sourceDirectory

for resultFile in `find . -type f -name "$pattern"`; do
	copyResultFile $resultFile $destinationDirectory $maxDestinationDirectoryDeep
	totalCopiedFiles=$((totalCopiedFiles+1))
done

endTime=`date`

echo "-----"
echo "Finished copying "$totalCopiedFiles" file(s) to destination directory. Start Time: " $startTime ". End Time: " $endTime
echo "-----"




