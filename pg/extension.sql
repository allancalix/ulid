CREATE FUNCTION generate_ulid() RETURNS uuid
--     AS '/Users/allancalix/acx/src/github.com/allancalix/ulid/zig-out/lib/libpg_ulid.0.1.0.dylib', 'pg_generate_ulid'
     AS '/Users/allancalix/acx/src/github.com/allancalix/ulid/pg_ulid.so', 'pg_generate_ulid'
     LANGUAGE C STRICT PARALLEL SAFE;
