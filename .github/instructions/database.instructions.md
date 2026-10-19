---
applyTo: "**"
---

# Oracle database interaction rules

## General principle: data CRUD allowed, structure changes forbidden

Agents, scripts and skills may read and modify **data** (CRUD) in this
project's Oracle database. Any change to the **structure** (schema) is
forbidden.

## Rules

1. **No DDL execution** (`CREATE`, `ALTER`, `DROP`, `TRUNCATE`, `RENAME`,
   `GRANT`, `REVOKE`) by an agent, under any circumstances: tables, columns,
   indexes, constraints and other schema objects must never be altered.
2. Data operations (`SELECT`, `INSERT`, `UPDATE`, `DELETE`, `MERGE`) are
   allowed. Keep them targeted (always a precise `WHERE` clause on
   `UPDATE`/`DELETE`) and prefer the application code (JPA/Hibernate, Spring
   Data) tested according to the TDD workflow for anything that is part of
   the product behavior.
3. Verification/diagnostic queries should be limited
   (`FETCH FIRST n ROWS ONLY`) to avoid loading excessive volumes. The
   (`ROWNUM <= n` / `FETCH FIRST n ROWS ONLY`) to avoid loading excessive volumes.
   The `oracle-tester` skill allows `SELECT` and data CRUD, never DDL.
4. Never expose Oracle credentials in clear text in code, versioned
   configuration files, or logs (see
   `.github/instructions/security.instructions.md`).
5. Every verification query must be written in an **optimized** way:
   - use existing indexes (check the execution plan if in doubt),
   - avoid `SELECT *`, prefer an explicit column list,
   - avoid unnecessary joins or unfiltered subqueries.
6. Access to verification queries goes through the skill
   `.github/skills/oracle-tester/SKILL.md`, configured by
   `.github/skills/oracle-tester/query-config.env`.

## Exception: H2 test DDL

The DDL ban applies to the **Oracle database**. For tests running on an
in-memory H2 database, the schema is defined **once for the whole
application** in a shared script at the repository root:

- `sql/schema.sql` (tables, indexes, constraints) and, if needed,
  `sql/data.sql` (reference data).
- Sub-modules never define their own table DDL: they consume this shared
  script. The parent `pom.xml` exposes `sql/` as a test resource
  directory (`<testResources>` with
  `${maven.multiModuleProjectDirectory}/sql`), then each module loads it
  via `spring.sql.init.schema-locations` / `@Sql("/schema.sql")`.
- A table is added or changed in this single file only, so the schema stays
  consistent across modules.
- These scripts must never be run against Oracle (no `sqlplus`/`sqlcl`/
  `oracle-tester` on them).
- Keep them aligned with the real Oracle schema; use H2 Oracle-compatibility
  mode (`MODE=Oracle`) where possible.
- No schema script is allowed in `src/main/` or anywhere else.

## Application layers

- Application write access goes through Spring Data JPA repositories
  (or equivalent), themselves covered by tests
  (unit tests with mocks, integration tests with a test database/H2/Testcontainers).
- Never use `JdbcTemplate`/native SQL to bypass the persistence
  layers without explicit validation by the Architect and the
  Reviewer.
