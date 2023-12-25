# Copyright 2023-2024 Mitchell. See LICENSE.

regex.so: lregex.cpp ; g++ -std=c++17 -g -fPIC -shared -o $@ -I/usr/include/lua5.4 $<
clean: ; rm -f regex.so

test: ; lua test.lua
