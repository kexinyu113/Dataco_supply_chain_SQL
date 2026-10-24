# DataCo Supply Chain SQL Analysis

SQL analysis of the DataCo Smart Supply Chain dataset: customer behavior, product profitability, regional demand, and delivery performance, answered with ten queries.

**Course project attribution:** Group project (Group 4A). Team: Ernesto Mata, Alice Sun, Chris Nott, Kexin Yu. My contribution: all SQL queries in this repository (Q1–Q10, the Queries & Results section of the project presentation), plus adjustments to the ER diagram. The rest of the database design (relational data model, dependency diagram) and the business background sections were my teammates' work.

## Dataset

DataCo Smart Supply Chain, covering three years of data (2015–2018), 180,521 rows and 53 columns. Source: [DataCo SMART SUPPLY CHAIN FOR BIG DATA ANALYSIS, Mendeley Data](https://data.mendeley.com/datasets/8gx2fvg2k6/5) (also mirrored on [Kaggle](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis)). Source file: `DataCoSupplyChainDataset.csv`. The queries in this repository run against the `SUPPLYCHAIN` table loaded from that CSV.

Note: the dataset CSV itself is not included in this repository because of its size. Download `DataCoSupplyChainDataset.csv` from the public source, load it as a table named `SUPPLYCHAIN`, and the queries will run as written.

Note: the queries analyze the source `SUPPLYCHAIN` table directly; they do not query the normalized tables from the project's design section.

## Contents

- `dataco-sql-queries.sql`: all ten queries, each answering one business question
- `dataco-sql-queries-with-results.sql`: the same ten queries with sample results attached as comments (first 10 rows shown for long outputs; full lists for the short aggregate queries), plus a clearly marked October 2026 extension section (E1–E4) using CTEs, subqueries, window functions and aggregate functions — these are later additions, not original course work

| # | Question | SQL technique |
| --- | --- | --- |
| Q1 | High-value customers (single orders over 1000) | WHERE filtering |
| Q2 | Top customers by total sales | GROUP BY, SUM, ORDER BY, LIMIT |
| Q3 | Regional demand (order count by region) | GROUP BY, COUNT, ORDER BY |
| Q4 | Orders above the average sale | Subquery (AVG) |
| Q5 | Profitability by product category | GROUP BY, AVG, ORDER BY |
| Q6 | Multi-product orders | GROUP BY, HAVING |
| Q7 | Product pairs bought together | Self-join |
| Q8 | Customers with multiple orders | Self-join |
| Q9 | Late deliveries | WHERE filtering |
| Q10 | High-value product pairs | Self-join + subquery |

## Key findings (from the query results)

- Regional demand is led by Central America (28,341 orders), followed by Western Europe (27,108).
- Computers is the most profitable category by average profit per order (157.59), ahead of Garden (69.10).
- The top customer by total sales is Mary Smith (4,771,645.88).
- Late deliveries are concentrated in South and East Asia in the sampled results.

## How to run

1. Download `DataCoSupplyChainDataset.csv` from the public source.
2. Convert the file to UTF-8 before importing: the source CSV contains non-ASCII characters stored in Latin-1, which makes MySQL Workbench's import wizard fail with an ascii codec error. Convert it first, for example with:
   ```
   iconv -f ISO-8859-1 -t UTF-8 DataCoSupplyChainDataset.csv > DataCo_utf8.csv
   ```
   Then import the converted file.
3. Load the converted CSV into your database as a table named `SUPPLYCHAIN`.
4. Run `dataco-sql-queries.sql` top to bottom. The queries use backticked column names (e.g. `` `Customer Fname` ``) because the source headers contain spaces.
