all: emsdk python_src build_python build_python_js
	

build_python_js: python.bc
	emcc -O2 python.bc -s NO_EXIT_RUNTIME=1 -o a.out.js
	emcc -O2 python.bc -s NO_EXIT_RUNTIME=1 --shell-file ./shell.html -o python.html
	node a.out.js -S -c "print 'Congratulations!'"

build_python: build_python.sh
	./build_python.sh

python_src: Python-2.7.5
	wget https://www.python.org/ftp/python/2.7.5/Python-2.7.5.tgz
	tar zxvf Python-2.7.5.tgz
	mv -R Python-2.7.5/ Python-2.7.5-native/
	tar zxvf Python-2.7.5.tgz

emsdk: emsdk_portable
	wget wget https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz
	tar zxvf emsdk-portable.tar.gz
	cd emsdk_portable; ./emsdk update; ./emsdk install latest; ./emsdk activate latest; source ./emsdk_env.sh
	
