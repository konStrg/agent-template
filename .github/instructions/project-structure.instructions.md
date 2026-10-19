---
applyTo: "**"
---

# Code placement rules (project structure / modules)

> Goal: ensure that each type of feature is always written
> **in the same place**, regardless of the agent (Architect, Dev) or
> human developer involved. This file is the **source of truth**
> for "what to write where". It complements `ARCHITECTURE.md` (macro view) with
> precise, actionable rules.

## 1. Principle

- Before writing a file, the Dev agent **must** determine its
  location from this document, not by analogy with a neighboring
  file.
- If a feature matches no existing rule, the Dev agent
  must escalate the question to the Architect (via the Orchestrator) rather than
  inventing a new location.
- Any new placement convention must be added here by
  the Architect, and reflected in `ARCHITECTURE.md` if it changes the
  macro structure.

## 2. Monolith / single-module structure

| Code type | Folder | Package | Naming convention |
|---|---|---|---|
| REST controllers | `src/main/java/.../<domain>/api/` | `....<domain>.api` | `<Name>Controller` |
| Business logic (services) | `src/main/java/.../<domain>/service/` | `....<domain>.service` | `<Name>Service` (+ `<Name>ServiceImpl` if separate interface) |
| Data access | `src/main/java/.../<domain>/repository/` | `....<domain>.repository` | `<Name>Repository` |
| JPA entities | `src/main/java/.../<domain>/model/` | `....<domain>.model` | `<Name>` (business name, no suffix) |
| DTOs / exchange contracts | `src/main/java/.../<domain>/dto/` | `....<domain>.dto` | `<Name>Request`, `<Name>Response`, `<Name>Dto` |
| Apache Camel routes | `src/main/java/.../<domain>/route/` | `....<domain>.route` | `<Name>Route` |
| Spring configuration | `src/main/java/.../<domain>/config/` or `.../config/` (cross-cutting) | `....<domain>.config` | `<Name>Config` |
| Mappers (MapStruct/manual) | `src/main/java/.../<domain>/mapper/` | `....<domain>.mapper` | `<Name>Mapper` |
| Business exceptions | `src/main/java/.../<domain>/exception/` | `....<domain>.exception` | `<Name>Exception` |
| Unit tests | `src/test/java/.../<domain>/<layer>/` | exact mirror of the tested package | `<Name>Test` |
| Integration tests | `src/test/java/.../<domain>/integration/` | `....<domain>.integration` | `<Name>IT` |
| H2 test DDL / data (common to the whole application, never run on Oracle) | `sql/` at the repository root | n/a | `schema.sql`, `data.sql` (single shared schema, no per-module DDL) |

`<domain>` = business sub-package (e.g. `billing`, `customer`,
`order`). Each domain follows the same internal structure
(`api/service/repository/model/dto/route/...`), which guarantees an
organization "by feature" rather than "by technical layer" at the
root level.

## 3. Maven multi-module structure

> To be enabled if the project is split into Maven modules (parent `pom.xml` +
> submodules). Complete the table according to the project's actual modules
> (see also `ARCHITECTURE.md`, section 3).

| Feature / Domain | Maven module | Note |
|---|---|---|
| `<domain-1>` | `<module-domain-1>` | |
| Shared code (common DTOs, utilities) | `<module>-common` | No dependency on the other business modules |
| Application entry point (Spring Boot bootstrap) | `<module>-app` / `<module>-bootstrap` | Depends on all required business modules |

Rules:
- A business module never depends directly on another business module:
  go through `*-common` or an exposed interface.
- No cyclic dependencies between modules (check with
  `mvn dependency:tree` if in doubt).
- The `*-common` module only contains generic, stable code
  (shared DTOs, cross-cutting exceptions, utilities) — never business logic
  specific to a domain.

## 4. Multi-repo system

> If the application is part of a system with several Git repositories, refer
> to `ARCHITECTURE.md` section 2 to know **in which repo**
> a feature must be developed, before applying the internal
> placement rules (sections 2/3 above) **in the right repo**.

Criteria for deciding on the right repo (to be adapted/completed by the Architect):
- One repo = one clearly delimited business or technical responsibility
  (bounded context).
- Never duplicate business logic already exposed by another repo:
  consume its interface contract (REST API / events) rather than
  reimplementing it.
- Any new feature spanning several repos must be
  split into sub-tasks per repo, each following its own complete TDD cycle
  (specs → tests → implementation → review).

## 5. Updating this document

This file must be updated by the **Architect** agent whenever a new
domain, module or component type is introduced. The Reviewer checks
at step 4 that the produced code complies with these placement
rules.
