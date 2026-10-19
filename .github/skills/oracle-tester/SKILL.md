---
name: oracle-tester
description: Exécute des requêtes SQL de vérification en lecture seule sur une base Oracle (SELECT uniquement). Utiliser pour diagnostiquer/valider un schéma ou des données de référence, jamais pour modifier la base.
---

# Skill : oracle-tester

## Objectif

Permettre d'exécuter des requêtes SQL de **vérification en lecture seule**
sur une base Oracle, afin de valider des hypothèses (ex. : structure d'une
table, présence de données de référence) sans jamais modifier l'état de la
base.

> ⚠️ Voir impérativement `.github/instructions/database.instructions.md` :
> aucune opération DDL/DML n'est autorisée via cette compétence.

## Configuration

La configuration de connexion se trouve dans
`.github/skills/oracle-tester/query-config.env`. Ce fichier ne doit
contenir **aucun secret réel** — utiliser des variables d'environnement
pour les valeurs sensibles (voir `.github/instructions/security.instructions.md`).

Charger la configuration avant exécution :

```bash
set -a
source .github/skills/oracle-tester/query-config.env
set +a
```

## Exécution d'une requête de vérification

Exemple avec `sqlplus` (adapter selon l'outil disponible dans
l'environnement, ex. `sqlcl`, un client JDBC en ligne de commande, etc.) :

```bash
echo "SELECT * FROM (${ORACLE_TEST_QUERY}) WHERE ROWNUM <= ${ORACLE_MAX_ROWS};" \
  | sqlplus -S "${ORACLE_USER}/${ORACLE_PASSWORD}@${ORACLE_CONNECT_STRING}"
```

## Règles d'exécution

1. Vérifier que la requête commence bien par `SELECT` avant toute
   exécution ; rejeter toute requête contenant `INSERT`, `UPDATE`,
   `DELETE`, `MERGE`, `CREATE`, `ALTER`, `DROP`, `TRUNCATE`, `GRANT`,
   `REVOKE`.
2. Toujours limiter le nombre de lignes retournées
   (`ROWNUM <= ${ORACLE_MAX_ROWS}` ou `FETCH FIRST n ROWS ONLY`).
3. Ne jamais afficher les identifiants de connexion dans les logs ou la
   sortie de commande.

## Cas d'usage typiques

- Vérifier qu'une table/vue attendue existe et contient des colonnes
  conformes aux specs de l'Architecte.
- Vérifier la présence de données de référence nécessaires à un test
  d'intégration.
- Diagnostiquer un écart entre le modèle JPA et le schéma réel.
