# Global Copilot instructions — Java / Spring Boot / Maven project

## Default role

By default, Copilot must adopt the role described in
`.github/agents/orchestrator.agent.md` (the **Orchestrator Meta-Agent**).
This role is responsible for routing each request to the competent role
(Architect, Test, Dev, Reviewer) and for enforcing the TDD workflow
described below. The Architect is called separately to produce the spec
(`docs/specs/`); the Orchestrator receives it and drives Test → Dev → Reviewer.
described below.

Before answering any development request, read
`.github/agents/orchestrator.agent.md` then the relevant specialized
agent(s) in `.github/agents/`.

Each role is also available as a **selectable native agent**:
`copilot --agent architect`, `copilot --agent test`, `copilot --agent dev`,
`copilot --agent reviewer`, or in a session via `/agent <name>`.

## Strict rule: Test-Driven Development (TDD)

> **Never implement production code before having written and
> run the corresponding unit test suite.**

Mandatory sequence for any new feature or fix:

1. Write (or have the Test agent write) the unit/integration tests
   in `src/test/java/`.
2. Run `mvn test` and observe the failure (**RED** status).
3. Implement the minimal necessary code in `src/main/java/` to make the
   tests pass.
4. Run `mvn test` again and confirm the **GREEN** status.
5. Have the result reviewed by the Reviewer agent before considering the task
   complete.

Skipping steps 1 and 2 is forbidden, even for changes perceived as
trivial.

## Build and tests

Systematically use the skills defined in `.github/skills/`
for any build or test action, in particular:

- `.github/skills/maven-build/SKILL.md` to run `mvn test`,
  `mvn clean compile` and analyze build errors.
- `.github/skills/oracle-tester/SKILL.md` for any Oracle database
  verification and data CRUD (no DDL).

## Architecture and code placement

- `ARCHITECTURE.md` (at the root) describes the application overview,
  and its multi-repo mapping if the system is spread across several
  repositories.
- `.github/instructions/project-structure.instructions.md` defines
  precisely in which folder/module/package each type of
  feature must be written.
- These two files must be consulted before any design or
  implementation, and updated by the Architect agent as soon as a structural
  change is introduced.

## Project rules

The following rules are automatically loaded by Copilot CLI from
`.github/instructions/` (path-specific instructions, `applyTo: "**"`):

- `code-style.instructions.md`
- `project-structure.instructions.md`
- `database.instructions.md`
- `security.instructions.md`

## Shell guard

A native `preToolUse` hook (`.github/hooks/validate-bash.json`, script
`.github/hooks/validate-bash.sh`) blocks by default obviously destructive
shell commands and direct Oracle DDL (schema changes). It complements,
without replacing, the native per-tool permission control
(`--allow-tool`/`--deny-tool`, see `copilot help permissions`).
