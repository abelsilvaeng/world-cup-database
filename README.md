# World Cup Database

Projeto da certificação **Relational Databases** do freeCodeCamp.

| Arquivo | O que é |
|---|---|
| `worldcup.sql` | dump do banco (`pg_dump -cC --inserts -U freecodecamp worldcup`) |
| `insert_data.sh` | popula `teams` (24 linhas) e `games` (32 linhas) a partir do `games.csv` |
| `queries.sh` | as 12 consultas, saída idêntica ao `expected_output.txt` |
| `games.csv` | dados de origem, fornecidos pelo curso |

Para reconstruir o banco:

```bash
psql -U postgres < worldcup.sql
```
