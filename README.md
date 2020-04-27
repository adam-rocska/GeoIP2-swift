# GeoIP2-swift

A decoupled Swift wrapper for 
[MaxMind's](https://www.maxmind.com/en/home) [GeoIP database's](https://dev.maxmind.com/geoip/geoip2/geolite2/)
[C Library](https://github.com/maxmind/libmaxminddb).

Inspiration, and initial state of repository from 
[lexrus's](https://github.com/lexrus) [MMDB-Swift](https://github.com/lexrus/MMDB-Swift) 
repository.

## Disclaimers

1. I'm no C guru.
2. I'm no Swift guru.
3. I have no idea what I'm doing.
4. For my purposes the lib' works as is, but be super cautious because of items 1-3.

## Version Infos

### 1. [libmaxminddb](https://github.com/maxmind/libmaxminddb) : [1.3.2](https://github.com/maxmind/libmaxminddb/releases/tag/1.3.2)

The current latest version is 
[1.4.2](https://github.com/maxmind/libmaxminddb/releases/tag/1.4.2), however I 
got `MMDB_INVALID_DATA_ERROR`s, and other issues for the current latest GeoLite2
database.    
The earliest version with which I could get GeoLite2 working was 
[1.3.2](https://github.com/maxmind/libmaxminddb/releases/tag/1.3.2)

### 2. [Swift & Swift Package Manager](https://swift.org) : [5.0.*](https://github.com/apple/swift/releases/tag/swift-5.0.3-RELEASE)

Currently that's the newest version which is supported by 
[JetBrains's CLion](https://www.jetbrains.com/clion/), our IDE of choice for 
all sorts of cool stuff.    
The library is supposed to behave properly with newer versions. 

## Usage

I won't bother providing a usage doc' just yet, because the API will 100% change.  
Right now I'm working on hammering it into a production environment, so 
eventually it'll become stable, and I will bother providing a proper API 
documentation, and a proper 1.0.0 release will be made.

For now **THIS IS ALL WORK IN PROGRESS IN MASTER** by design. 

### How To Clone 🙂

`git clone --recurse-submodules` instead of the standard git 
clone, since [libmaxminddb](https://github.com/maxmind/libmaxminddb) is 
introduced as a git submodule.