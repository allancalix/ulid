#include <stdio.h>
#include <stdbool.h>

#include "postgres.h"
#include "fmgr.h"
#include "utils/uuid.h"

#include "ulid.h"

#ifdef PG_MODULE_MAGIC
PG_MODULE_MAGIC;
#endif

PG_FUNCTION_INFO_V1(pg_generate_ulid);

Datum
pg_generate_ulid(PG_FUNCTION_ARGS)
{
	pg_uuid_t  *uuid = palloc0(sizeof(pg_uuid_t));

  char buffer[sizeof(pg_uuid_t)];
  generate_ulid(&buffer);
  memmove(uuid, buffer, sizeof(pg_uuid_t));

	PG_RETURN_UUID_P(uuid);
}
