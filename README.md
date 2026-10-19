# Template Java / Spring Boot / Maven — TDD + Agents Copilot

Template de projet orienté **TDD strict** et **orchestration multi-agents
native GitHub Copilot CLI**, pour des applications Java 21 / Spring Boot 3 /
Apache Camel / Maven.

## Démarrage rapide

```bash
cd mon-projet
copilot
```

`.github/copilot-instructions.md` est chargé automatiquement : Copilot
adopte par défaut le rôle d'**Orchestrateur** et applique le workflow TDD
décrit plus bas. Il suffit de décrire la feature voulue :

```
Ajoute une fonctionnalité de recherche de client par email.
```

## Workflow TDD en 4 étapes

L'Orchestrateur délègue systématiquement à 4 rôles, dans cet ordre :

1. **Architect** — analyse le besoin, consulte `ARCHITECTURE.md` et
   `project-structure.instructions.md`, produit les specs/DTOs/contrats
   dans `docs/specs/`.
2. **Test** — écrit les tests (JUnit 5, AssertJ, Mockito) dans
   `src/test/java/`, exécute `mvn test` et confirme le statut **ROUGE**.
3. **Dev** — implémente le code minimal dans `src/main/java/` pour passer
   au statut **VERT**.
4. **Reviewer** — vérifie qualité, sécurité et conformité aux règles avant
   validation finale.

> Règle absolue : aucun code de production n'est écrit avant que son test
> existe et échoue.

## Utiliser un rôle précis directement

Chaque rôle est aussi un agent Copilot natif, invocable isolément :

```bash
copilot --agent architect   # ou: test, dev, reviewer, orchestrator
```

ou en session interactive : `/agent architect`.

## Structure du template

```
.github/
├── copilot-instructions.md   # instructions globales (rôle par défaut + TDD)
├── mcp.json                  # configuration des serveurs MCP
├── copilot/
│   └── settings.json         # réglages repo (permissions, agents custom)
├── agents/                   # 5 agents natifs (*.agent.md)
│   ├── orchestrator.agent.md
│   ├── architect.agent.md
│   ├── test.agent.md
│   ├── dev.agent.md
│   └── reviewer.agent.md
├── instructions/              # règles auto-injectées (*.instructions.md)
│   ├── code-style.instructions.md
│   ├── project-structure.instructions.md
│   ├── database.instructions.md
│   └── security.instructions.md
├── skills/                    # compétences (build, vérifications SQL)
│   ├── maven-build/SKILL.md
│   └── oracle-tester/SKILL.md (+ query-config.env)
└── hooks/                     # garde-fou shell (preToolUse)
    ├── validate-bash.json
    └── validate-bash.sh

ARCHITECTURE.md       # vue d'ensemble, cartographie multi-repo
.copilot-agents.md    # carte d'identité lisible des agents (doc humaine)
docs/specs/           # specs produites par l'Architect
src/main/java/        # code de production
src/test/java/        # tests
```

## Règles clés à connaître

- **`.github/instructions/project-structure.instructions.md`** : où placer
  chaque type de code (contrôleur, service, repository, DTO, route Camel...)
  par domaine/module/repo. Consultée et mise à jour par l'Architect.
- **`.github/instructions/database.instructions.md`** : accès Oracle en
  lecture seule stricte, aucun DDL/DML direct par un agent.
- **`.github/instructions/security.instructions.md`** : pas de secrets en
  dur, validation systématique des entrées.
- **`ARCHITECTURE.md`** : à compléter dès l'import du template dans un
  projet réel (domaines, modules Maven, cartographie multi-repo si
  applicable).

## À adapter à l'import dans un nouveau projet

1. Remplir les sections vides d'`ARCHITECTURE.md` (vue d'ensemble, modules,
   repos liés).
2. Compléter les tableaux de
   `.github/instructions/project-structure.instructions.md` avec les
   domaines réels du projet.
3. Mettre à jour `.github/skills/oracle-tester/query-config.env` avec la
   configuration de connexion réelle (jamais de secret en clair committé).
4. Vérifier la détection avec :
   ```bash
   copilot instruction list
   copilot skill list
   ```

## Vérifié avec Copilot CLI

Les 5 agents, les 4 fichiers d'instructions et les 2 compétences ont été
testés et sont correctement détectés/exécutables nativement (`copilot
instruction list`, `copilot skill list`, `copilot --agent <nom>`).
