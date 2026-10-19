---
applyTo: "**"
---

# Règles de style de code — Java 21 / Spring Boot / Lombok / Apache Camel

## Java 21

- Utiliser les **records** pour les DTOs immuables.
- Utiliser le **pattern matching** (`instanceof`, `switch` expressions) pour
  simplifier les conditions.
- Utiliser les **text blocks** (`"""`) pour les chaînes multilignes (SQL,
  JSON de test, etc.).
- Préférer `var` uniquement quand le type est évident à la lecture.
- Activer et respecter les règles du compilateur (`-Werror` recommandé en
  CI si configuré).

## Spring Boot

- **Injection par constructeur uniquement** (jamais de `@Autowired` sur un
  champ). Utiliser Lombok `@RequiredArgsConstructor` pour générer le
  constructeur.
- Annoter clairement les couches : `@RestController`, `@Service`,
  `@Repository`, `@Configuration`.
- Les contrôleurs ne contiennent **aucune logique métier** : ils délèguent
  aux services.
- Utiliser `@Valid` / `jakarta.validation` sur les DTOs d'entrée des
  endpoints.
- Centraliser la gestion des erreurs via `@ControllerAdvice` /
  `@ExceptionHandler`.

## Lombok

- Utiliser `@Getter`, `@Setter`, `@Builder`, `@RequiredArgsConstructor`,
  `@Slf4j` pour réduire le boilerplate.
- Éviter `@Data` sur les entités JPA (risque de boucle `equals`/`hashCode`
  sur les relations) ; préférer des annotations explicites.
- Ne jamais utiliser `@SneakyThrows` sauf cas exceptionnel documenté.

## Apache Camel

- Définir les routes dans des classes dédiées héritant de
  `RouteBuilder`, une route par flux métier.
- Nommer les routes de façon explicite (`from("...").routeId("nomExplicite")`).
- Isoler la logique métier dans des beans/services injectés, pas directement
  dans les routes (`.bean(...)` plutôt que du code inline complexe).
- Gérer les erreurs via `onException(...)` plutôt que des try/catch
  dispersés.

## Général

- Nommage des packages : `com.<organisation>.<projet>.<domaine>`.
- Classes, méthodes et variables en anglais, noms explicites.
- Pas de code mort, pas de `TODO` non justifié.
- Limiter la complexité cyclomatique des méthodes (extraire si > ~10).
