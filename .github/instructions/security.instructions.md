---
applyTo: "**"
---

# Security rules

## Secrets management

- **Never** hard-code a secret (password, API key, token, full connection
  string) in source code, versioned configuration files
  (`application.yml`, `application.properties`) or comments.
- Use environment variables or a secrets manager
  (Vault, AWS Secrets Manager, Azure Key Vault, etc.) referenced via
  placeholders (`${DB_PASSWORD}`).
- The file `.github/skills/oracle-tester/query-config.env` must contain
  **no real committed secret**: use example values
  or references to environment variables.
- Add any real `.env` file containing secrets to `.gitignore`.

## Input validation

- All user input (REST API, incoming Camel messages, query
  parameters) must be validated before processing:
  - use `jakarta.validation` (`@NotNull`, `@Size`, `@Pattern`, etc.)
    on DTOs,
  - validate types, formats and bounds before any business use,
  - explicitly reject (HTTP 400) any invalid input with a clear but
    non-verbose error message (do not expose internal details).
- Never build SQL queries by concatenating strings with
  user input: always use parameterized queries
  (JPA/Hibernate, `PreparedStatement`).
- Escape/validate any user data re-injected into logs, HTML
  responses or shell commands.

## Other guidelines

- Do not log (`log.info`, `log.debug`, etc.) any sensitive data
  (password, token, unnecessary personal data).
- Apply the principle of least privilege to every service account
  (database, external APIs).
- Keep dependencies up to date and check for known CVEs before
  adding a new Maven dependency.
- Any executed script must remain consistent with the guard defined in
  `.github/hooks/validate-bash.json`.
