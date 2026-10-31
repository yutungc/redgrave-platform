-- AFC Redgrave · dbt Workspaces lab · CATCH-UP SCRIPT
-- Run this ONLY if you did not finish the ingestion lab (REDGRAVE.BRONZE is empty or missing).
-- It builds the same three bronze tables, with exactly the same rows as the Postgres
-- megastore of the ingestion lab: 12 products, 240 orders, 480 order lines, 22,120 GBP.
-- How: Snowsight > Projects > Workspaces > + Add new > SQL File, paste, then "Run All".

USE ROLE SYSADMIN;

CREATE WAREHOUSE IF NOT EXISTS REDGRAVE_WH
    WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE INITIALLY_SUSPENDED = TRUE;
CREATE DATABASE IF NOT EXISTS REDGRAVE;
CREATE SCHEMA IF NOT EXISTS REDGRAVE.BRONZE;
USE WAREHOUSE REDGRAVE_WH;
USE SCHEMA REDGRAVE.BRONZE;

CREATE OR REPLACE TABLE PRODUCTS (
    product_id NUMBER, sku VARCHAR, name VARCHAR, category VARCHAR, price_gbp NUMBER(8,2),
    _source_file VARCHAR, _loaded_at TIMESTAMP_TZ);

INSERT INTO PRODUCTS
SELECT column1, column2, column3, column4, column5, 'catchup/products.csv', CURRENT_TIMESTAMP()
FROM VALUES
    ( 1, 'RDG-HOME-26', 'Home shirt 2026/27',    'Kit',         65.00),
    ( 2, 'RDG-AWAY-26', 'Away shirt 2026/27',    'Kit',         65.00),
    ( 3, 'RDG-KID-HOME','Junior home shirt',     'Kit',         45.00),
    ( 4, 'RDG-SCARF',   'Nelson Lane bar scarf', 'Accessories', 15.00),
    ( 5, 'RDG-BEANIE',  'Redgrave bobble hat',   'Accessories', 12.00),
    ( 6, 'RDG-MUG',     '1897 heritage mug',     'Homeware',     9.00),
    ( 7, 'RDG-FLAG',    'Matchday flag',         'Accessories',  8.00),
    ( 8, 'RDG-TRAIN',   'Training top',          'Training',    40.00),
    ( 9, 'RDG-BALL',    'Size 5 club football',  'Equipment',   20.00),
    (10, 'RDG-PROG',    'Matchday programme',    'Print',        4.00),
    (11, 'RDG-JACKET',  'Rain jacket',           'Training',    55.00),
    (12, 'RDG-KEYRING', 'Crest keyring',         'Accessories',  5.00);

CREATE OR REPLACE TABLE ORDERS (
    order_id NUMBER, customer_ref VARCHAR, channel VARCHAR, status VARCHAR,
    order_ts TIMESTAMP_TZ, updated_at TIMESTAMP_TZ, _source_file VARCHAR, _loaded_at TIMESTAMP_TZ);

-- 240 orders, one every 173 minutes from 1 August 2026 (same rule as the Postgres script).
INSERT INTO ORDERS
SELECT g,
       'C' || LPAD(MOD(g * 37, 90) + 1, 4, '0'),
       DECODE(MOD(g, 3), 0, 'online', 1, 'megastore', 'matchday kiosk'),
       IFF(MOD(g, 20) = 0, 'refunded', 'paid'),
       DATEADD(minute, g * 173, '2026-08-01 09:00:00 +00:00'::TIMESTAMP_TZ),
       DATEADD(minute, g * 173, '2026-08-01 09:00:00 +00:00'::TIMESTAMP_TZ),
       'catchup/orders.csv', CURRENT_TIMESTAMP()
FROM (SELECT SEQ4() + 1 AS g FROM TABLE(GENERATOR(ROWCOUNT => 240)));

CREATE OR REPLACE TABLE ORDER_ITEMS (
    order_id NUMBER, line_no NUMBER, product_id NUMBER, qty NUMBER, unit_price_gbp NUMBER(8,2),
    _source_file VARCHAR, _loaded_at TIMESTAMP_TZ);

-- 1 to 3 lines per order.
INSERT INTO ORDER_ITEMS
SELECT o.order_id, l.line_no, p.product_id, MOD(o.order_id + l.line_no, 3) + 1, p.price_gbp,
       'catchup/order_items.csv', CURRENT_TIMESTAMP()
FROM ORDERS o
JOIN (SELECT SEQ4() + 1 AS line_no FROM TABLE(GENERATOR(ROWCOUNT => 3))) l
  ON l.line_no <= MOD(o.order_id, 3) + 1
JOIN PRODUCTS p ON p.product_id = MOD(o.order_id * 7 + l.line_no * 5, 12) + 1;

-- Expected: 12 | 240 | 480 | 22120.00
SELECT (SELECT COUNT(*) FROM PRODUCTS)    AS products,
       (SELECT COUNT(*) FROM ORDERS)      AS orders,
       (SELECT COUNT(*) FROM ORDER_ITEMS) AS order_lines,
       (SELECT SUM(qty * unit_price_gbp) FROM ORDER_ITEMS) AS gross_revenue_gbp;
