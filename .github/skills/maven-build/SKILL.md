---
name: maven-build
description: Instructions for running mvn test, mvn clean compile and mvn clean verify, and analyzing build/test errors. Use for any build or test action on the project.
---

# Skill : maven-build

## Objectif

Provide a reliable procedure to compile the project and run the Maven test
suite, then analyze the results to determine the RED/GREEN status of the
TDD workflow.

## Main commands

### Run the tests

```bash
mvn test
```

- Used by the **Test** agent to confirm the **RED** status (tests expected
  to fail) before implementation.
- Used by the **Dev** agent to confirm the **GREEN** status (all tests
  pass) after implementation.

### Compile without running the tests

```bash
mvn clean compile
```

- Used to quickly check that there are no compilation errors in
  `src/main/java/`.

### Full build (with tests)

```bash
mvn clean verify
```

- To be used before a complete finalization/review (Reviewer step).

## Error analysis

1. Read the Maven output primarily in the following sections:
   - `[ERROR]` for compilation errors,
   - `Tests run: X, Failures: Y, Errors: Z, Skipped: W` for the test
     summary.
2. For each failing test, check the associated stack trace
   (`target/surefire-reports/*.txt`) to identify the exact cause.
3. Distinguish between:
   - a **compilation error** (the code does not compile at all),
   - an **assertion failure** (the test runs but the result differs),
   - a **runtime error** (unhandled exception during the test).
4. Never ignore a failing test without understanding the root cause.

## Best practices

- Always run `mvn test` from the project root (where `pom.xml` is located).
- Use `mvn -q test` to reduce noise if only the final result matters, but
  switch back to verbose mode (`mvn test`) on failure to get the details.
- Never run a destructive Maven command (e.g. deployment) without explicit
  user validation.
