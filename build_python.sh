# !/bin/sh
#
echo "Compile native version Parser/pgen"
cd Python-2.7.5-native/
make clean && make distclean
./configure --without-threads --without-pymalloc --enable-shared --disable-ipv6
make
cd ..

cd Python-2.7.5/
make clean && make distclean
CFLAGS='-m32' LDFLAGS='-m32' CXXFLAGS='-m32' emconfigure ./configure --without-threads --without-pymalloc --enable-shared --disable-ipv6
echo "Remove MULTIARCH	"
awk '!/^MULTIARCH=\t$/' ./Makefile > temp && mv temp Makefile
echo "Remove configs in ./pyconfig.h"
awk '!/^#define HAVE_GCC_ASM_FOR_X87 1$/' ./pyconfig.h > temp && mv temp pyconfig.h

UNISTDH=`which emcc | xargs dirname`/system/include/libc/unistd.h
echo "Remove posix_close declaration from $UNISTDH"
awk '!/^int posix_close\(int, int\);$/' $UNISTDH > temp && mv temp $UNISTDH

emmake make
cp ../Python-2.7.5-native/Parser/pgen ./Parser/pgen
chmod +x Parser/pgen
emmake make

llvm-link libpython2.7.so Modules/python.o -o ../python.bc
cd ..

