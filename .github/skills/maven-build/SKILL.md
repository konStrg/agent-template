---
name: maven-build
description: Instructions pour exécuter mvn test, mvn clean compile et mvn clean verify, et analyser les erreurs de build/tests. Utiliser pour toute action de build ou de test du projet.
---

# Skill : maven-build

## Objectif

Fournir une procédure fiable pour compiler le projet et exécuter la suite de
tests Maven, puis analyser les résultats pour déterminer le statut
ROUGE/VERT du workflow TDD.

## Commandes principales

### Exécuter les tests

```bash
mvn test
```

- Utilisée par l'agent **Test** pour valider le statut **ROUGE** (tests en
  échec attendu) avant implémentation.
- Utilisée par l'agent **Dev** pour valider le statut **VERT** (tous les
  tests passent) après implémentation.

### Compiler sans exécuter les tests

```bash
mvn clean compile
```

- Utilisée pour vérifier rapidement l'absence d'erreurs de compilation
  dans `src/main/java/`.

### Build complet (avec tests)

```bash
mvn clean verify
```

- À utiliser avant une finalisation/review complète (étape Reviewer).

## Analyse des erreurs

1. Lire la sortie Maven en priorité dans les sections :
   - `[ERROR]` pour les erreurs de compilation,
   - `Tests run: X, Failures: Y, Errors: Z, Skipped: W` pour le résumé des
     tests.
2. Pour chaque test en échec, consulter la stack trace associée
   (`target/surefire-reports/*.txt`) afin d'identifier la cause exacte.
3. Distinguer :
   - une **erreur de compilation** (le code ne compile pas du tout),
   - un **échec d'assertion** (le test s'exécute mais le résultat diffère),
   - une **erreur d'exécution** (exception non gérée pendant le test).
4. Ne jamais ignorer un test en échec sans comprendre la cause racine.

## Bonnes pratiques

- Toujours exécuter `mvn test` depuis la racine du projet (là où se trouve
  `pom.xml`).
- Utiliser `mvn -q test` pour réduire le bruit si seul le résultat final
  importe, mais repasser en mode verbeux (`mvn test`) en cas d'échec pour
  obtenir le détail.
- Ne jamais exécuter de commande Maven destructrice (ex. déploiement) sans
  validation explicite de l'utilisateur.
