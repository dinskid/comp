# comp

A semi-complete toy compiler for the C programming language. It is developed as a part of the course work of CSPC41.
It implements lexical analysis, syntax analysis, semantic analysis and intermediate code generation for a part of the language.

### Steps to run it
```
# run make to create the binaries
make
# bin/comp < test/file_name
bin/comp < test/in6
```
### To install dependencies
```
# works on debian/ubuntu based systems
sudo apt-get install flex bison make gcc binutils
```
