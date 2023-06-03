# Lua-std-regex

This is a simple Lua module that wraps C++11's regular expression (regex) capabilities to implement
regex versions of Lua's `string.find()`, `string.gmatch()`, `string.gsub()`, and `string.match()`.

It only requires a C++ compiler and runtime that support's the C++11 standard's regex features.

## Compiling

There is a simple Makefile that builds a *regex.so* shared library on Linux by running
`make`. You can also include *lregex.h* and/or *lregex.cpp* in your Lua-scripted application's
build system. `luaopen_regex` is the module's C entry point.

## Documentation

- `regex.find(s, re[, init=1])`: Searches string *s* for regex string *re* starting at position
*init*, and returns the start and end positions of the match followed by any string values
captured by *re*. Returns `nil` if no match was found.

- `regex.gmatch(s, re[, init=1])`: Returns an iterator that can be used in a `for` loop to iterate
over all occurrences of regex string *re* in string *s* starting at position *init*. If *re* has
captures, the captured values are assigned to loop variables. Otherwise, the entire match is used.

- `regex.gsub(s, re, replacement[, n=0])`: Returns a copy of string *s* where all (or the first
*n*) instances of regex string *re* are replaced by string *replacement*, and also returns the
number of replacements made. *replacement* may contain "$*d*" sequences, which represent the
*d*-th value captured by *re*. *replacement* may also be a table or function. If it is a table,
and the match or first capture exists as a key, that key's value is the replacement text. If
*replacement* is a function, that function is called with either the captured values or the
entire match as arguments.  If the function returns a string or number, that result is the
replacement text.

- `regex.match(s, re[, init=1])`: Searches string *s* for regex string *re* starting at position
*init*, and returns either the values captured by *re* or the entire match itself. Returns
`nil` if no match was found.

## Usage

```
Lua 5.4.4  Copyright (C) 1994-2022 Lua.org, PUC-Rio
> re = require('regex')
> re.find('foo', 'o')
2	2
> for char in re.gmatch('foo', '.', 2) do print(char) end
o
o
> re.gsub('foo', '.', string.upper, 1)
Foo	1
> re.match('foo', 'fo+')
foo
```
