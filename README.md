# code-collection

##How to use

Checkout project, open the terminal and change directory to code-collection directory by typing:

```
cd /full-path/to/code-collection
```

Run `extract-jars.sh` to decompile all jar and war files which are stored in a sepcific directory
```
bash extract-jars.sh
```
For example, to decompile all java libaries in .m2/repository/com and save source code in directory all-com-library-source-code

![extract jars](https://github.com/thoqbk/code-collection/blob/master/resource/extract-jars.png)

After decompiling all library files, we can collect all specific files (`.html`, `.js` file, for example) by using tool `collect.sh`

For example, to collect all `.html` file from source code directory and store them in `all-html-files`directory:

![collect](https://github.com/thoqbk/code-collection/blob/master/resource/collect.png)

Note that: 

1. If set `max deep of destination directory` to `-1`, the structure of destination directory (`all-html-files`) will be keep the same with the `all-com-library-source-code` directory.

2. If set `max deep of destination` directory to `0`, all found files will be store in `all-html-files` directory. If a file name has already existed, it will be suffix by a number (ex: `package-1.html`)


## System requirements
1. JDK 1.7 + (for java and jar command)
2. Bash 3.0+

## Author and contact
[ThoQ Luong](https://github.com/thoqbk/)

Email: thoqbk@gmail.com

## License
The MIT License (MIT)