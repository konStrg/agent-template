---
applyTo: "**"
---

# Règles de sécurité

## Gestion des secrets

- **Jamais** de secret (mot de passe, clé API, token, chaîne de connexion
  complète) en dur dans le code source, les fichiers de configuration
  versionnés (`application.yml`, `application.properties`) ou les
  commentaires.
- Utiliser des variables d'environnement ou un gestionnaire de secrets
  (Vault, AWS Secrets Manager, Azure Key Vault, etc.) référencés via des
  placeholders (`${DB_PASSWORD}`).
- Le fichier `.github/skills/oracle-tester/query-config.env` ne doit
  contenir **aucun secret réel** committé : utiliser des valeurs d'exemple
  ou des références à des variables d'environnement.
- Ajouter tout fichier `.env` réel contenant des secrets à `.gitignore`.

## Validation des entrées

- Toute entrée utilisateur (API REST, messages Camel entrants, paramètres
  de requête) doit être validée avant traitement :
  - utiliser `jakarta.validation` (`@NotNull`, `@Size`, `@Pattern`, etc.)
    sur les DTOs,
  - valider les types, formats et bornes avant toute utilisation métier,
  - rejeter explicitement (HTTP 400) toute entrée invalide avec un message
    d'erreur clair mais non verbeux (ne pas exposer de détails internes).
- Ne jamais construire de requêtes SQL par concaténation de chaînes avec
  des entrées utilisateur : utiliser systématiquement des requêtes
  paramétrées (JPA/Hibernate, `PreparedStatement`).
- Échapper/valider toute donnée utilisateur réinjectée dans des logs, des
  réponses HTML ou des commandes shell.

## Autres consignes

- Ne journaliser (`log.info`, `log.debug`, etc.) aucune donnée sensible
  (mot de passe, token, données personnelles non nécessaires).
- Appliquer le principe du moindre privilège pour tout compte de service
  (base de données, API externes).
- Garder les dépendances à jour et vérifier l'absence de CVE connues avant
  d'ajouter une nouvelle dépendance Maven.
- Tout script exécuté doit rester cohérent avec le garde-fou défini dans
  `.github/hooks/validate-bash.json`.
