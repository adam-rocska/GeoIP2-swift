# libmaxminddb_config

## Why this module exists?

[libmaxminddb](https://github.com/maxmind/libmaxminddb) is build using 
[automake](https://www.gnu.org/software/automake/).  
The tool 
[autoreconf](https://www.gnu.org/software/autoconf/manual/autoconf-2.68/html_node/autoreconf-Invocation.html)
ran as `autoreconf -fiv` will generate the
[configure script](https://developer.gnome.org/anjuta-build-tutorial/stable/create-autotools.html.en)
necessary for building libmaxminddb, which will also produce a configuration 
header file called `maxminddb_config.h`.

In order for us to keep the library decoupled, as a git submodule, we need a way 
to either build the project via Swift Package Manager, either inject a 
configuration header file. At the time of writing **Swift Package Manager** is 
not able to solve this problem, so we need to opt in to some automated injection.

This is where this clumsy module comes into play.

## Redundant definitions in header & c file

I know.  
Sadly there was no way around via Swift Package Manager at the time of writing. 