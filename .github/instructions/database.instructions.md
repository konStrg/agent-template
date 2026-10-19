---
applyTo: "**"
---

# Règles d'interaction avec la base de données Oracle

## Principe général : lecture seule

Toute interaction automatisée (agents, scripts, compétences) avec la base
Oracle de ce projet doit se faire en **mode lecture seule strict**, sauf
autorisation explicite et documentée de l'utilisateur.

## Règles

1. **Aucune exécution de DDL** (`CREATE`, `ALTER`, `DROP`, `TRUNCATE`) par
   un agent, en aucune circonstance.
2. **Aucune exécution de DML de modification** (`INSERT`, `UPDATE`,
   `DELETE`, `MERGE`) directement en base par un agent. Ces opérations ne
   doivent passer que par le code applicatif validé (JPA/Hibernate, Spring
   Data) et testé selon le workflow TDD.
3. Les requêtes de vérification/diagnostic doivent être des `SELECT`
   uniquement, idéalement limitées (`FETCH FIRST n ROWS ONLY`) pour éviter
   de charger des volumes excessifs.
4. Ne jamais exposer d'identifiants Oracle en clair dans le code, les
   fichiers de configuration versionnés, ou les logs (voir
   `.github/instructions/security.instructions.md`).
5. Toute requête de vérification doit être écrite de façon **optimisée** :
   - utiliser les index existants (vérifier le plan d'exécution si doute),
   - éviter les `SELECT *`, préférer la liste explicite des colonnes,
   - éviter les jointures inutiles ou les sous-requêtes non filtrées.
6. L'accès aux requêtes de vérification se fait via la compétence
   `.github/skills/oracle-tester/SKILL.md`, configurée par
   `.github/skills/oracle-tester/query-config.env`.

## Couches applicatives

- Les accès en écriture transitent exclusivement par les repositories
  Spring Data JPA (ou équivalent), eux-mêmes couverts par des tests
  (unitaires avec mocks, intégration avec base de test/H2/Testcontainers).
- Ne jamais utiliser de `JdbcTemplate`/SQL natif pour contourner les
  couches de persistance sans validation explicite de l'Architecte et du
  Reviewer.
