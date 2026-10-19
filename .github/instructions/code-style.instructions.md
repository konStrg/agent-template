---
applyTo: "**"
---

# Code style rules — Java 21 / Spring Boot / Lombok / Apache Camel

## Java 21

- Use **records** for immutable DTOs.
- Use **pattern matching** (`instanceof`, `switch` expressions) to
  simplify conditions.
- Use **text blocks** (`"""`) for multiline strings (SQL,
  test JSON, etc.).
- Prefer `var` only when the type is obvious when reading.
- Enable and respect compiler rules (`-Werror` recommended in
  CI if configured).

## Spring Boot

- **Constructor injection only** (never `@Autowired` on a
  field). Use Lombok `@RequiredArgsConstructor` to generate the
  constructor.
- Clearly annotate layers: `@RestController`, `@Service`,
  `@Repository`, `@Configuration`.
- Controllers contain **no business logic**: they delegate
  to services.
- Use `@Valid` / `jakarta.validation` on endpoint input DTOs.
- Centralize error handling via `@ControllerAdvice` /
  `@ExceptionHandler`.

## Lombok

- Use `@Getter`, `@Setter`, `@Builder`, `@RequiredArgsConstructor`,
  `@Slf4j` to reduce boilerplate.
- Avoid `@Data` on JPA entities (risk of `equals`/`hashCode` loop
  on relations); prefer explicit annotations.
- Never use `@SneakyThrows` except in documented exceptional cases.

## Apache Camel

- Define routes in dedicated classes extending
  `RouteBuilder`, one route per business flow.
- Name routes explicitly (`from("...").routeId("explicitName")`).
- Isolate business logic in injected beans/services, not directly
  in routes (`.bean(...)` rather than complex inline code).
- Handle errors via `onException(...)` rather than scattered
  try/catch blocks.

## General

- Package naming: `com.<organisation>.<project>.<domain>`.
- Classes, methods and variables in English, with explicit names.
- No dead code, no unjustified `TODO`.
- Limit the cyclomatic complexity of methods (extract if > ~10).
