---
applyTo: "**"
---

# Règles de placement du code (structure projet / modules)

> Objectif : garantir que chaque type de fonctionnalité est toujours écrit
> **au même endroit**, quel que soit l'agent (Architect, Dev) ou le
> développeur humain qui intervient. Ce fichier est la **source de vérité**
> pour "où écrire quoi". Il complète `ARCHITECTURE.md` (vue macro) avec des
> règles précises et actionnables.

## 1. Principe

- Avant d'écrire un fichier, l'agent Dev **doit** déterminer son
  emplacement à partir de ce document, pas par analogie avec un fichier
  voisin.
- Si une fonctionnalité ne correspond à aucune règle existante, l'agent
  Dev doit remonter la question à l'Architecte (via l'Orchestrateur) plutôt
  que d'inventer un nouvel emplacement.
- Toute nouvelle convention de placement doit être ajoutée ici par
  l'Architecte, et répercutée dans `ARCHITECTURE.md` si elle change la
  structure macro.

## 2. Structure monolithe / module unique

| Type de code | Dossier | Package | Convention de nommage |
|---|---|---|---|
| Contrôleurs REST | `src/main/java/.../<domaine>/api/` | `....<domaine>.api` | `<Nom>Controller` |
| Logique métier (services) | `src/main/java/.../<domaine>/service/` | `....<domaine>.service` | `<Nom>Service` (+ `<Nom>ServiceImpl` si interface séparée) |
| Accès données | `src/main/java/.../<domaine>/repository/` | `....<domaine>.repository` | `<Nom>Repository` |
| Entités JPA | `src/main/java/.../<domaine>/model/` | `....<domaine>.model` | `<Nom>` (nom métier, pas de suffixe) |
| DTOs / contrats d'échange | `src/main/java/.../<domaine>/dto/` | `....<domaine>.dto` | `<Nom>Request`, `<Nom>Response`, `<Nom>Dto` |
| Routes Apache Camel | `src/main/java/.../<domaine>/route/` | `....<domaine>.route` | `<Nom>Route` |
| Configuration Spring | `src/main/java/.../<domaine>/config/` ou `.../config/` (transverse) | `....<domaine>.config` | `<Nom>Config` |
| Mappers (MapStruct/manuel) | `src/main/java/.../<domaine>/mapper/` | `....<domaine>.mapper` | `<Nom>Mapper` |
| Exceptions métier | `src/main/java/.../<domaine>/exception/` | `....<domaine>.exception` | `<Nom>Exception` |
| Tests unitaires | `src/test/java/.../<domaine>/<couche>/` | miroir exact du package testé | `<Nom>Test` |
| Tests d'intégration | `src/test/java/.../<domaine>/integration/` | `....<domaine>.integration` | `<Nom>IT` |

`<domaine>` = sous-package métier (ex. `facturation`, `client`,
`commande`). Chaque domaine suit la même structure interne
(`api/service/repository/model/dto/route/...`), ce qui garantit une
organisation "par fonctionnalité" plutôt que "par couche technique" au
niveau racine.

## 3. Structure multi-module Maven

> À activer si le projet est découpé en modules Maven (`pom.xml` parent +
> sous-modules). Compléter le tableau en fonction des modules réels du
> projet (voir aussi `ARCHITECTURE.md`, section 3).

| Fonctionnalité / Domaine | Module Maven | Remarque |
|---|---|---|
| `<domaine-1>` | `<module-domaine-1>` | |
| Code partagé (DTOs communs, utilitaires) | `<module>-common` | Aucune dépendance vers les autres modules métier |
| Point d'entrée application (bootstrap Spring Boot) | `<module>-app` / `<module>-bootstrap` | Dépend de tous les modules métier nécessaires |

Règles :
- Un module métier ne dépend jamais d'un autre module métier directement :
  passer par `*-common` ou par une interface exposée.
- Aucune dépendance cyclique entre modules (vérifier avec
  `mvn dependency:tree` si doute).
- Le module `*-common` ne contient que du code générique et stable
  (DTOs partagés, exceptions transverses, utilitaires) — jamais de logique
  métier spécifique à un domaine.

## 4. Système multi-repo

> Si l'application fait partie d'un système à plusieurs dépôts Git, se
> référer à `ARCHITECTURE.md` section 2 pour savoir **dans quel repo**
> une fonctionnalité doit être développée, avant d'appliquer les règles
> de placement internes (sections 2/3 ci-dessus) **dans le bon repo**.

Critères pour décider du bon repo (à adapter/compléter par l'Architecte) :
- Un repo = une responsabilité métier ou technique clairement délimitée
  (bounded context).
- Ne jamais dupliquer une logique métier déjà exposée par un autre repo :
  consommer son contrat d'interface (API REST / événements) plutôt que de
  réimplémenter.
- Toute nouvelle fonctionnalité transverse à plusieurs repos doit être
  découpée en sous-tâches par repo, chacune suivant son propre cycle TDD
  complet (specs → tests → implémentation → review).

## 5. Mise à jour de ce document

Ce fichier doit être mis à jour par l'agent **Architect** dès qu'un nouveau
domaine, module ou type de composant est introduit. Le Reviewer vérifie
lors de l'étape 4 que le code produit respecte bien ces règles de
placement.
