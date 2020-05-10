import Foundation

/**
# DataType
[As per the specification](https://maxmind.github.io/MaxMind-DB/)

Each output data field has an associated type, and that type is encoded as a
number that begins the data field. Some types are variable length. In those
cases, the type indicator is also followed by a length. The data payload
always comes at the end of the field.

All binary data is stored in big-endian format.

Note that the *interpretation* of a given data type's meaning is decided by
higher-level APIs, not by the binary format itself.

## pointer - 1

A pointer to another part of the data section's address space. The pointer
will point to the beginning of a field. It is illegal for a pointer to point
to another pointer.

Pointer values start from the beginning of the data section, *not* the
beginning of the file.

## UTF-8 string - 2

A variable length byte sequence that contains valid utf8. If the length is
zero then this is an empty string.

## double - 3

This is stored as an IEEE-754 double (binary64) in big-endian format. The
length of a double is always 8 bytes.

## bytes - 4

A variable length byte sequence containing any sort of binary data. If the
length is zero then this a zero-length byte sequence.

This is not currently used but may be used in the future to embed non-text
data (images, etc.).

## integer formats

Integers are stored in variable length binary fields.

We support 16-bit, 32-bit, 64-bit, and 128-bit unsigned integers. We also
support 32-bit signed integers.

A 128-bit integer can use up to 16 bytes, but may use fewer. Similarly, a
32-bit integer may use from 0-4 bytes. The number of bytes used is determined
by the length specifier in the control byte. See below for details.

A length of zero always indicates the number 0.

When storing a signed integer, the left-most bit is the sign. A 1 is negative
and a 0 is positive.

The type numbers for our integer types are:

* unsigned 16-bit int - 5
* unsigned 32-bit int - 6
* signed 32-bit int - 8
* unsigned 64-bit int - 9
* unsigned 128-bit int - 10

The unsigned 32-bit and 128-bit types may be used to store IPv4 and IPv6
addresses, respectively.

The signed 32-bit integers are stored using the 2's complement representation.

## map - 7

A map data type contains a set of key/value pairs. Unlike other data types,
the length information for maps indicates how many key/value pairs it
contains, not its length in bytes. This size can be zero.

See below for the algorithm used to determine the number of pairs in the
hash. This algorithm is also used to determine the length of a field's
payload.

## array - 11

An array type contains a set of ordered values. The length information for
arrays indicates how many values it contains, not its length in bytes. This
size can be zero.

This type uses the same algorithm as maps for determining the length of a
field's payload.

## data cache container - 12

This is a special data type that marks a container used to cache repeated
data. For example, instead of repeating the string "United States" over and
over in the database, we store it in the cache container and use pointers
*into* this container instead.

Nothing in the database will ever contain a pointer to this field
itself. Instead, various fields will point into the container.

The primary reason for making this a separate data type versus simply inlining
the cached data is so that a database dumper tool can skip this cache when
dumping the data section. The cache contents will end up being dumped as
pointers into it are followed.

## end marker - 13

The end marker marks the end of the data section. It is not strictly
necessary, but including this marker allows a data section deserializer to
process a stream of input, rather than having to find the end of the section
before beginning the deserialization.

This data type is not followed by a payload, and its size is always zero.

## boolean - 14

A true or false value. The length information for a boolean type will always
be 0 or 1, indicating the value. There is no payload for this field.

## float - 15

This is stored as an IEEE-754 float (binary32) in big-endian format. The
length of a float is always 4 bytes.

This type is provided primarily for completeness. Because of the way floating
point numbers are stored, this type can easily lose precision when serialized
and then deserialized. If this is an issue for you, consider using a double
instead.
*/
public enum DataType: UInt8 {
  case pointer            = 1
  case utf8String         = 2
  case double             = 3
  case bytes              = 4
  case uInt16             = 5
  case uInt32             = 6
  case map                = 7
  case int32              = 8
  case uInt64             = 9
  case uInt128            = 10
  case array              = 11
  case dataCacheContainer = 12
  case endMarker          = 13
  case boolean            = 14
  case float              = 15
}
