MODE="test"

HOME_TEST_DIRECTORY=`pwd`/test


sourceDirectory="$HOME_TEST_DIRECTORY"/source
destinationDirectory="$HOME_TEST_DIRECTORY"/target

rm -rf $destinationDirectory/*

. `pwd`/extract-jars.sh

#Case 1: package: com.google.common.cache must contains 22 files
case1BaseMessage="Package: com.google.common.cache must contains 22 files"
if [ `find $HOME_TEST_DIRECTORY/target/guava-19.0/com/google/common/cache | wc -l` = "22" ]; then
	echo "PASS: " "$case1BaseMessage" 
else
	echo "FAIL: " "$case1BaseMessage"
fi

#Case 2: there's no .class file
case2BaseMessage="There is no .class file"
if [ `find $HOME_TEST_DIRECTORY/target/guava-19.0 -name \"*.class\" | wc -l` = "0" ]; then
	echo "PASS: " "$case2BaseMessage"
else
	echo "FAIL: " "$case2BaseMessage" 
fi

#Case 3: pom.xml file
case3BaseMessage="POM.xml"
if [ -f "$HOME_TEST_DIRECTORY/target/guava-19.0/META-INF/maven/com.google.guava/guava/pom.xml" ]; then
	echo "PASS: " "$case3BaseMessage"
else
	echo "FAIL: " "$case3BaseMessage" 
fi

rm -rf $destinationDirectory/*

cd $HOME_TEST_DIRECTORY/..