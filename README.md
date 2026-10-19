# Java / Spring Boot / Maven Template — TDD + Copilot Agents

Project template focused on **strict TDD** and **native GitHub Copilot CLI
multi-agent orchestration**, for Java 21 / Spring Boot 3 / Apache Camel /
Maven applications.

## Quick start

```bash
cd my-project
copilot
```

`.github/copilot-instructions.md` is loaded automatically: Copilot adopts
the **Orchestrator** role by default, which applies the TDD workflow
described below from a **spec** produced upstream by the Architect.

## Workflow: spec (Architect) then TDD (Orchestrator)

### Phase 0 — Specification (Architect, dedicated session)

The Architect is called separately to generate the feature spec:

```bash
copilot --agent architect
```

```
Add a feature to search for a customer by email.
```

**Architect** — analyzes the need, consults `ARCHITECTURE.md` and
`project-structure.instructions.md`, produces the specs/DTOs/contracts in
`docs/specs/`. It writes neither tests nor production code.

### Phase 1 — Implementation (Orchestrator)

The spec is then given to the Orchestrator (default agent):

```
Implement the spec docs/specs/<feature>.md
```

The Orchestrator systematically delegates to 3 roles, in this order:

1. **Test** — writes the tests (JUnit 5, AssertJ, Mockito) in
   `src/test/java/` from the spec, runs `mvn test` and confirms the
   **RED** status.
2. **Dev** — implements the minimal code in `src/main/java/` to reach the
   **GREEN** status.
3. **Reviewer** — checks quality, security and compliance with the rules
   before final approval.

If no spec is provided, the Orchestrator asks for one to be generated
first with the Architect.

> Absolute rule: no production code is written before its test exists and
> fails.

## Using a specific role directly

Each role is also a native Copilot agent, which can be invoked on its own:

```bash
copilot --agent architect   # or: test, dev, reviewer, orchestrator
```

or in an interactive session: `/agent architect`.

## Template structure

```
.github/
├── copilot-instructions.md   # global instructions (default role + TDD)
├── mcp.json                  # MCP server configuration
├── copilot/
│   └── settings.json         # repo settings (permissions, custom agents)
├── agents/                   # 5 native agents (*.agent.md)
│   ├── orchestrator.agent.md
│   ├── architect.agent.md
│   ├── test.agent.md
│   ├── dev.agent.md
│   └── reviewer.agent.md
├── instructions/              # auto-injected rules (*.instructions.md)
│   ├── code-style.instructions.md
│   ├── project-structure.instructions.md
│   ├── database.instructions.md
│   └── security.instructions.md
├── skills/                    # skills (build, SQL checks)
│   ├── maven-build/SKILL.md
│   └── oracle-tester/SKILL.md (+ query-config.env)
└── hooks/                     # shell safeguard (preToolUse)
    ├── validate-bash.json
    └── validate-bash.sh

ARCHITECTURE.md       # overview, multi-repo map
.copilot-agents.md    # human-readable agent identity card (human doc)
docs/specs/           # specs produced by the Architect
src/main/java/        # production code
src/test/java/        # tests
```

## Key rules to know

- **`.github/instructions/project-structure.instructions.md`**: where to
  place each type of code (controller, service, repository, DTO, Camel
  route...) per domain/module/repo. Consulted and updated by the
  Architect.
- **`.github/instructions/database.instructions.md`**: Oracle data CRUD
  allowed, no DDL (schema changes) by an agent.
- **`.github/instructions/security.instructions.md`**: no hardcoded
  secrets, systematic input validation.
- **`ARCHITECTURE.md`**: to be completed as soon as the template is
  imported into a real project (domains, Maven modules, multi-repo map if
  applicable).

## To adapt when importing into a new project

1. Fill in the empty sections of `ARCHITECTURE.md` (overview, modules,
   linked repos).
2. Complete the tables in
   `.github/instructions/project-structure.instructions.md` with the
   project's real domains.
3. Update `.github/skills/oracle-tester/query-config.env` with the real
   connection configuration (never commit a plain-text secret).
4. Check detection with:
   ```bash
   copilot instruction list
   copilot skill list
   ```

## Verified with Copilot CLI

The 5 agents, the 4 instruction files and the 2 skills have been tested
and are correctly detected/executable natively (`copilot
instruction list`, `copilot skill list`, `copilot --agent <name>`).
