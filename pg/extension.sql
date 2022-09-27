CREATE FUNCTION generate_uuid() RETURNS uuid
     AS '<EXTENSION_LIB_PATH>', 'pg_generate_ulid'
     LANGUAGE C STRICT PARALLEL SAFE;
