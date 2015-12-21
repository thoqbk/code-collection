# $1: desinationFilePathWoExtension
# $2: suffixNumber
# $3: extension
buildDesinationFilePath(){
	local desinationFilePathWoExtension=$1
	local suffixNumber=$2
	local extension=$3
	retVal=$desinationFilePathWoExtension

	#add suffix
	if [ "$suffixNumber" != "0" ]; then
		retVal=$retVal"-"$suffixNumber
	fi

	#add extension
	if [ "$extension" != "" ]; then
		retVal=$retVal"."$extension
	fi
	eval "$4='$retVal'"
}

# $1: relativeSourceFilePath
# $2: destinationDirectory
# $3: maxDestinationDirectoryDeep
buildDesinationDirectoryPath(){
	local relativeSourceFilePath=$1
	local relativeDirectoryFilePath=`dirname $relativeSourceFilePath`
	local destinationDirectory=$2
	local maxDestinationDirectoryDeep=$3
	
	retVal=""

	if [ "$maxDestinationDirectoryDeep" = "0" ]; then
		retVal=$destinationDirectory
	else
		if [ "$maxDestinationDirectoryDeep" = "-1" ] || [ "$maxDestinationDirectoryDeep" -gt 50 ]; then
			maxDestinationDirectoryDeep="50"
		fi
		regex="(\./)?\.?((/?[^/]+){0,$maxDestinationDirectoryDeep})"
		[[ $relativeDirectoryFilePath =~ $regex ]]
		local relativeDestinationDirectoryPath="${BASH_REMATCH[2]}"

		retVal=$destinationDirectory

		if [ "$relativeDestinationDirectoryPath" != "" ]; then
			retVal=$retVal/$relativeDestinationDirectoryPath
		fi
	fi

	if [ ! -d "$retVal" ]; then
		mkdir -p $retVal
	fi

	eval "$4='$retVal'"
}

# $1: relativeSourceFilePath
# $2: rootDesinationDirectory
# $3: maxDestinationDirectoryDeep
copyResultFile(){
	local relativeSourceFilePath=$1
	local rootDesinationDirectory=$2
	local maxDestinationDirectoryDeep=$3

	#Build desination path
	local fileNameWithExtension=`basename $relativeSourceFilePath`
	local extension="${fileNameWithExtension##*.}"
	local fileNameWoExtension="${fileNameWithExtension%.*}"

	functionRetVal=""
	buildDesinationDirectoryPath $relativeSourceFilePath $rootDesinationDirectory $maxDestinationDirectoryDeep functionRetVal

	local destinationDirectory=$functionRetVal

	local desinationFilePathWoExtension=$destinationDirectory/$fileNameWoExtension

	local suffixNumber=0
	functionRetVal=""
	buildDesinationFilePath $desinationFilePathWoExtension $suffixNumber $extension functionRetVal

	while [ -f $functionRetVal ]; do
		suffixNumber=$((suffixNumber+1))
		buildDesinationFilePath $desinationFilePathWoExtension $suffixNumber $extension functionRetVal
	done

	local destinationFilePath=$functionRetVal
	cp $relativeSourceFilePath $destinationFilePath
	
	echo "Finished copying a file to destination: " $destinationFilePath

}
