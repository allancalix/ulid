ARG PG_VERSION=14.5

FROM postgres:${PG_VERSION}

COPY zig-out/lib/libext_pg_ulid.so /usr/include/lib_pgulid.so
