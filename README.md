# Database Systems Exercises

Course exercises covering Oracle SQL and Python database integration.

## Structure

```
db-exercises/
├── sql/
│   └── oracle_exercises.sql   # Oracle SQL exercises
└── python/
    └── csv_to_mysql.py        # CSV to MySQL importer
```

## SQL Exercises (`sql/oracle_exercises.sql`)

Oracle SQL exercises covering:

- **DDL** - CREATE TABLE, ALTER TABLE, DROP, FLASHBACK
- **DML** - INSERT, UPDATE, DELETE
- **SELECT** - filtering, sorting, aggregation, GROUP BY, HAVING
- **Joins** - INNER JOIN, LEFT JOIN, self-join, subqueries
- **Views** - CREATE VIEW, WITH CHECK OPTION
- **Window functions** - LAG, LEAD, RANK, DENSE_RANK, ROW_NUMBER, SUM OVER, AVG OVER

### Schema

```
regions → countries → locations → departments ↔ employees → job_history
                                                    ↓
                                                  jobs
```

## Python Script (`python/csv_to_mysql.py`)

Reads CSV files from a `csv1/` folder and loads them into MySQL.

### Table structure

```sql
CREATE TABLE pomiary (
    dzien    DATE,
    godzina  TIME,
    v1       DOUBLE,
    v2       DOUBLE
);
```

### CSV format

```
20240101,8,12.5,7.3
20240101,9,13.1,6.8
```

Columns: `YYYYMMDD`, `hour (0-23)`, `v1`, `v2`

### Requirements

```bash
pip install mysqlclient numpy
```

### Usage

1. Create `csv1/` folder and place CSV files inside
2. Configure MySQL credentials in the script
3. Run:

```bash
python csv_to_mysql.py
```

Processed files are moved to the `przetworzone/` folder automatically.

## Requirements

- Oracle Database (SQL exercises)
- Python 3.x + MySQL (Python script)
- Libraries: `mysqlclient`, `numpy`
