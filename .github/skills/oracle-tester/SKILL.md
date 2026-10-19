---
name: oracle-tester
description: Runs SQL queries on an Oracle database (SELECT and data CRUD: INSERT/UPDATE/DELETE/MERGE). Use to diagnose/validate a schema or data; structure changes (DDL) are never allowed.
---

# Skill : oracle-tester

## Objectif

Allow running SQL queries on an Oracle database, in order to validate
hypotheses (e.g. table structure, presence of reference data) and to
read or modify **data** (CRUD), without ever modifying the **structure**
of the database.

> ⚠️ See `.github/instructions/database.instructions.md` without fail:
> no DDL operation (schema change) is allowed through this skill.

## Configuration

The connection configuration is located in
`.github/skills/oracle-tester/query-config.env`. This file must contain
**no real secret** — use environment variables for sensitive values (see
`.github/instructions/security.instructions.md`).

Load the configuration before execution:

```bash
set -a
source .github/skills/oracle-tester/query-config.env
set +a
```

## Running a query

Example with `sqlplus` (adapt to the tool available in the environment,
e.g. `sqlcl`, a command-line JDBC client, etc.):

```bash
echo "SELECT * FROM (${ORACLE_TEST_QUERY}) WHERE ROWNUM <= ${ORACLE_MAX_ROWS};" \
  | sqlplus -S "${ORACLE_USER}/${ORACLE_PASSWORD}@${ORACLE_CONNECT_STRING}"
```

For data changes, send the `INSERT`/`UPDATE`/`DELETE`/`MERGE` statement
instead, followed by an explicit `COMMIT;` (or `ROLLBACK;`).

## Execution rules

1. Allowed statements: `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `MERGE`.
   Reject any query containing `CREATE`, `ALTER`, `DROP`, `TRUNCATE`,
   `RENAME`, `GRANT`, `REVOKE`.
2. Always limit the number of rows returned by a `SELECT`
   (`ROWNUM <= ${ORACLE_MAX_ROWS}` or `FETCH FIRST n ROWS ONLY`).
3. `UPDATE` and `DELETE` must always have a precise `WHERE` clause; use
   bind values / explicit literals, never unvalidated user input.
4. Never display connection credentials in logs or command output.

## Typical use cases

- Check that an expected table/view exists and has columns matching the
  Architect's specs.
- Check the presence of reference data required by an integration test.
- Insert/update/delete test or reference data when needed.
- Diagnose a discrepancy between the JPA model and the actual schema.
