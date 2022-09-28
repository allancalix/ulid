CREATE FUNCTION generate_ulid() RETURNS uuid
     AS '/usr/include/lib_pgulid.so', 'pg_generate_ulid'
     LANGUAGE C STRICT PARALLEL SAFE;
