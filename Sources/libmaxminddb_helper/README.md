# libmaxminddb_helper

## Why this module exists?

**There are 2 reasons :** 
* maxminddb_typecast.c & h
* maxminddb-compat-util.h

## maxminddb_typecast.c

Since [libmaxminddb](https://github.com/maxmind/libmaxminddb) operates with all 
sorts of pointer tricks, it's not too comfortable to acquire results from the C 
API in Swift. So we need a simple solution to represent these values in a more 
digestible way.

Kudos once again go to [lexrus](https://github.com/lexrus)'s 
[MMDB-Swift](https://github.com/lexrus/MMDB-Swift) where this whole repository
started from. Original sources : 
* [maxminddb_unions.c](https://github.com/lexrus/MMDB-Swift/blob/639b0d811694a27eab6cc6834a968888f666972d/Sources/libmaxminddb/maxminddb_unions.c)
* [maxminddb_unions.h](https://github.com/lexrus/MMDB-Swift/blob/639b0d811694a27eab6cc6834a968888f666972d/Sources/libmaxminddb/maxminddb_unions.h) 

## maxminddb-compat-util.h

Again, another case of "I have no idea what I'm doing 🙂". Sorry.  
So, [libmaxminddb](https://github.com/maxmind/libmaxminddb) depends on a few 
functions which are included in its source, however Swift Package Manager for 
whatever reason couldn't resolve it. I assume it's because the header file is in 
the `src` directory, and so far I had the impression, that Swift Package Manager 
(quite rightfully) prefers to keep things separated.

Anyho', it's here, and it compiles. There's another catch though. Why do I have 
only a header file and in the include dir. Another case of 
**I have no idea what I'm doing**. When I separated the definitions from the 
source in seperate C and header files, compilation failed with only one function 
definition being undefined (which isn't undefined imho...)

```
Undefined symbols for architecture x86_64:
  "_mmdb_strndup", referenced from:
      _$s6GeoIP2AAC9getString024_01864207E763388F378F6E4G7DD973A2LLySSSpySo22MMDB_entry_data_list_sVGF in GeoIP2.swift.o
ld: symbol(s) not found for architecture x86_64
```

In its current state it helps [libmaxminddb](https://github.com/maxmind/libmaxminddb)
compile.