# Copyright 2023 Mitchell. See LICENSE.

regex.so: lregex.cpp
	g++ -g -fPIC -shared -o $@ -I/usr/include/lua5.4 $<
clean: ; rm -f regex.so

test: ; lua test.lua
