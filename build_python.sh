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
sed '/MULTIARCH=\t/d' ./Makefile > temp && mv temp Makefile
echo "Remove configs in ./pyconfig.h"
sed '/#define\sHAVE_GCC_ASM_FOR_X87\s1/d' ./pyconfig.h > temp && mv temp pyconfig.h

UNISTDH=`which emcc | xargs dirname`/system/include/libc/unistd.h
echo "Remove posix_close declaration from $UNISTDH"
sed '/int\sposix_close(int,\sint);/d' $UNISTDH > temp && mv temp $UNISTDH

emmake make
cp ../Python-2.7.5-native/Parser/pgen ./Parser/pgen
chmod +x Parser/pgen
emmake make

llvm-link libpython2.7.so Modules/python.o -o python.bc
emcc -O2 python.bc -o a.out.js
node a.out.js -S -c "print 'Congratulations'"

cd ..

