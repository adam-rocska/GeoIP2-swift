#ifndef GEOIP2_SWIFT_MAXMINDDB_TYPECAST_H
#define GEOIP2_SWIFT_MAXMINDDB_TYPECAST_H

#include <maxminddb.h>
#include <stdint.h>
#include <stdbool.h>

const char *MMDB_get_entry_data_char(MMDB_entry_data_s *ptr);

uint32_t *MMDB_get_entry_data_uint32(MMDB_entry_data_s *ptr);

bool MMDB_get_entry_data_bool(MMDB_entry_data_s *ptr);

#endif //GEOIP2_SWIFT_MAXMINDDB_TYPECAST_H
