all: emsdk build_python_js
	

build_python_js: build_python python.bc
	emcc -O2 python.bc -s NO_EXIT_RUNTIME=1 -o a.out.js
	emcc -O2 python.bc -s NO_EXIT_RUNTIME=1 --shell-file ./shell.html -o python.html
	node a.out.js -S -c "print 'Congratulations!'"

build_python: build_python.sh python_src
	./build_python.sh

python_src: Python-2.7.5.tgz
	tar zxvf Python-2.7.5.tgz
	mv Python-2.7.5/ Python-2.7.5-native/
	tar zxvf Python-2.7.5.tgz

Python-2.7.5.tgz:
	wget https://www.python.org/ftp/python/2.7.5/Python-2.7.5.tgz
	touch Python-2.7.5.tgz

emsdk: emsdk-portable.tar.gz
	tar zxvf emsdk-portable.tar.gz
	cd emsdk_portable; ./emsdk update; ./emsdk install latest; ./emsdk activate latest; source ./emsdk_env.sh
	
emsdk-portable.tar.gz:
	wget https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz -O emsdk-portable.tar.gz

clean:
	touch python && rm -rf python*
	touch Python && rm -rf Python*
	touch emsdk* && rm -rf emsdk*

