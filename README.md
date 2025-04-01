# Forecast emission & SQL Test

## Directory Structure

- `src_forecasting/`: Contains the Jupyter notebooks for the forecasting workflow, including:
  - EDA
  - Feature Engineering
  - Modeling
  - Evaluation
  - 2021 and 2022 Forecast

- `src_sql_test/`: Contains script for running and displaying SQL queries and their results.

- `report/`: Contains reports, including:
  - SQL queries
  - Presentation of the forecasting model and evaluation

- `data/`: Contains the dataset used for modeling.


## Setup

### 1. Prepare the Development Environment

Use the `mac-setup` to set up the development environment. This should only be run once.

```bash
make mac-setup
```

This will install Poetry, Pyenv, and necessary dependencies including PostgreSQL.

### 2. PostgreSQL Setup

The following target installs and configures PostgreSQL:

```bash
make postgres-setup
```

This will:
- Install PostgreSQL using Homebrew
- Start the PostgreSQL service
- Verify the installation

### 3. Populate the Database

To populate the database with the required SQL dump:

```bash
make populate-db
```

This will:
- Create a database for the project
- Populate the database with data from an SQL dump file located in `src_sql_test/sql_tech_test.sql`
- Verify data import by running a few queries

### 4. Run Database Queries

To run  SQL queries:

```bash
make run-db-queries
```


## Development Workflow

### Install Dependencies

To install all project dependencies:

```bash
make install
```
