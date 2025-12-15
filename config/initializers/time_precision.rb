# Fact 1): Postgres stores timestamps with microsecond precision
# Fact 2): Ruby Time stores timestamps with nanosecond precision
#
# ISN'T THAT JUST FUN
#
# This can cause comparison mismatches when pulling timestamps from the database.

MICROSECOND_PRECISION = 6

ActiveSupport::JSON::Encoding.time_precision = MICROSECOND_PRECISION
