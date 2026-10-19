# Instructions globales Copilot — Projet Java / Spring Boot / Maven

## Rôle par défaut

Par défaut, Copilot doit adopter le rôle décrit dans
`.github/agents/orchestrator.agent.md` (le **Meta-Agent Orchestrateur**).
Ce rôle est responsable de router chaque demande vers le rôle compétent
(Architect, Test, Dev, Reviewer) et de faire respecter le workflow TDD
décrit ci-dessous.

Avant de répondre à toute demande de développement, lire
`.github/agents/orchestrator.agent.md` puis le(s) agent(s) spécialisé(s)
concerné(s) dans `.github/agents/`.

Chaque rôle est aussi disponible comme **agent natif sélectionnable** :
`copilot --agent architect`, `copilot --agent test`, `copilot --agent dev`,
`copilot --agent reviewer`, ou en session via `/agent <nom>`.

## Règle stricte : Test-Driven Development (TDD)

> **Ne jamais implémenter de code de production avant d'avoir écrit et
> exécuté la suite de tests unitaires correspondante.**

Séquence obligatoire pour toute nouvelle fonctionnalité ou correctif :

1. Écrire (ou faire écrire par l'agent Test) les tests unitaires/intégration
   dans `src/test/java/`.
2. Exécuter `mvn test` et constater l'échec (statut **ROUGE**).
3. Implémenter le code minimal nécessaire dans `src/main/java/` pour faire
   passer les tests.
4. Exécuter `mvn test` à nouveau et confirmer le statut **VERT**.
5. Faire relire le résultat par l'agent Reviewer avant de considérer la tâche
   terminée.

Il est interdit de sauter l'étape 1 et 2, même pour des changements perçus
comme triviaux.

## Build et tests

Utiliser systématiquement les compétences définies dans `.github/skills/`
pour toute action de build ou de test, notamment :

- `.github/skills/maven-build/SKILL.md` pour exécuter `mvn test`,
  `mvn clean compile` et analyser les erreurs de build.
- `.github/skills/oracle-tester/SKILL.md` pour toute vérification en base
  de données Oracle (lecture seule).

## Architecture et placement du code

- `ARCHITECTURE.md` (à la racine) décrit la vue d'ensemble de l'application,
  et sa cartographie multi-repo si le système est réparti sur plusieurs
  dépôts.
- `.github/instructions/project-structure.instructions.md` définit
  précisément dans quel dossier/module/package chaque type de
  fonctionnalité doit être écrit.
- Ces deux fichiers doivent être consultés avant toute conception ou
  implémentation, et mis à jour par l'agent Architect dès qu'une évolution
  structurelle est introduite.

## Règles de projet

Les règles suivantes sont chargées automatiquement par Copilot CLI depuis
`.github/instructions/` (path-specific instructions, `applyTo: "**"`) :

- `code-style.instructions.md`
- `project-structure.instructions.md`
- `database.instructions.md`
- `security.instructions.md`

## Garde-fou shell

Un hook natif `preToolUse` (`.github/hooks/validate-bash.json`, script
`.github/hooks/validate-bash.sh`) bloque par défaut les commandes shell
manifestement destructrices ou les DDL/DML Oracle directs. Il complète,
sans le remplacer, le contrôle natif de permissions par outil
(`--allow-tool`/`--deny-tool`, voir `copilot help permissions`).
