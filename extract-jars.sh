
HOME_DIRECTORY=`pwd`

cd ~
USER_DIRECTORY=`pwd`

cd $HOME_DIRECTORY

LIB_DIRECTORY="$HOME_DIRECTORY"/lib

cfrFile="$LIB_DIRECTORY"/cfr_0_110.jar

foundJava=`type -p java`
if [ "`type -p java`" = "" ]; then
	echo "Command \"java\" not found. You may not install JDK on your machine."
	exit
fi

if [ "`type -p jar`" = "" ]; then
	echo "Command \"jar\" not found. You may not install JDK on your machine."
	exit
fi

echo "-----"
echo "Tool for extracting all .war and .jar files"
read -p "1. Enter the source directory (ex: $USER_DIRECTORY/.m2/repository): " sourceDirectory

if [ ! -d "$sourceDirectory" ]; then
	echo "\""$sourceDirectory"\" is not a valid directory"
	exit
fi

read -p "2. Enter the destination directory (ex: $USER_DIRECTORY/code-collection/target): " destinationDirectory

if [ ! -d "$destinationDirectory" ]; then
	echo "\""$destinationDirectory"\" is not a valid directory"
	exit
fi

echo "Begin scan for jar files and extract them to the destination directory"
echo ">> Source: " $sourceDirectory
echo ">> Destination: " $destinationDirectory

cd $sourceDirectory

jarFilesInString=`find . -type f -name '*.jar' -o -name '*.war'`

totalJarFiles=0

startTime=`date`

while IFS=' ' read -ra jarFiles; do
	for jarFile in "${jarFiles[@]}"; do

		#Extract this jar file
      	jarFileWithExtension=`basename $jarFile`
      	#Directory
      	jarFileRegex="(.*).(jar|war)"
      	[[ $jarFileWithExtension =~ $jarFileRegex ]]
	    extractDirectory="${BASH_REMATCH[1]}"
	    fileExtension="${BASH_REMATCH[2]}"
	    targetDirectory=$destinationDirectory/$extractDirectory

	    #Extract
	    echo "Begin extracting file: " $jarFileWithExtension " to directory " $targetDirectory
	    if [ ! -d "$targetDirectory" ]; then
	    	mkdir -p $targetDirectory
		fi

        cd $sourceDirectory
        cp $jarFile $targetDirectory
        cd $targetDirectory
        jar xf $jarFileWithExtension

        rm $jarFileWithExtension

        #decompile
        if [ "$fileExtension" = "jar" ]; then
        	#use decompile tool
        	echo "Begin decomplining jar file: " $jarFile
        	cd $sourceDirectory
			java -jar $cfrFile $jarFile --outputdir $targetDirectory --comments false
        fi

        #remove .class files
        cd $targetDirectory
        find . -type f -name "*.class" -exec rm {} +

		totalJarFiles=$((totalJarFiles+1))
	done
done <<< "$jarFilesInString"

endTime=`date`


echo "-----"
echo "Finished extract "$totalJarFiles" jar file(s) to destination directory. Start Time: " $startTime ". End Time: " $endTime
echo "-----"
