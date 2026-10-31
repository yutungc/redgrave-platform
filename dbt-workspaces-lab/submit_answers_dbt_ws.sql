-- AFC Redgrave · dbt Workspaces lab (RED-202) · write your answers in YOUR Snowflake account
-- Replace each <...> with your answer (keep the $$ on both sides), then Run All.
-- You can run this file again: it replaces your previous answers for this lab.

USE ROLE SYSADMIN;
USE WAREHOUSE REDGRAVE_WH;
CREATE SCHEMA IF NOT EXISTS REDGRAVE.LAB;
CREATE TABLE IF NOT EXISTS REDGRAVE.LAB.ANSWERS (
    lab VARCHAR, question VARCHAR, answer VARCHAR, submitted_at TIMESTAMP_TZ);

-- Let your instructor see the deployed project and the task of step 8 (tables and views are already shared).
-- Error "role REDGRAVE_GRADER does not exist"? Run 05_grant_instructor_access.sql of the ingestion lab first.
GRANT MONITOR ON ALL DBT PROJECTS IN SCHEMA REDGRAVE.DBT TO ROLE REDGRAVE_GRADER;
GRANT MONITOR ON ALL TASKS IN SCHEMA REDGRAVE.DBT TO ROLE REDGRAVE_GRADER;

DELETE FROM REDGRAVE.LAB.ANSWERS WHERE lab = 'RED-202';

INSERT INTO REDGRAVE.LAB.ANSWERS VALUES
('RED-202', 'NAME', $$<YU-TUNG CHENG>$$, CURRENT_TIMESTAMP()),
('RED-202', 'Q1', $$<Q1:  Silver views store no data and stay up-to-date automatically. Gold tables store precomputed results so dashboards can query them quickly without recomputing aggregations.>$$, CURRENT_TIMESTAMP()),
('RED-202', 'Q2', $$<Q2: source() references raw database tables outside dbt control, while ref() references other dbt models built inside the project to form the DAG dependencies.>$$, CURRENT_TIMESTAMP()),
('RED-202', 'Q3', $$<Q3: accepted_values_silver_orders_status failed due to the PENDING status. dbt skipped 14 downstream nodes to stop corrupt data from reaching gold models and dashboards.>$$, CURRENT_TIMESTAMP()),
('RED-202', 'Q4', $$<Q4: It checked how recently raw bronze data was loaded using _loaded_at. It triggers WARN if the newest record is older than 24 hours.>$$, CURRENT_TIMESTAMP()),
('RED-202', 'Q5', $$<Q5: silver_order_lines, gold_daily_sales, and gold_revenue_by_channel (all models that ref() silver_orders).>$$, CURRENT_TIMESTAMP()),
('RED-202', 'Q6', $$<Q6: 1. dbt Projects run natively in Snowflake Workspaces without local Python setup. 2. Native integration allows deploying and scheduling tasks directly in Snowflake without external tools.>$$, CURRENT_TIMESTAMP()),
('RED-202', 'GIT', $$<https://github.com/yutungc/redgrave-platform.git>$$, CURRENT_TIMESTAMP());

SELECT question, answer FROM REDGRAVE.LAB.ANSWERS WHERE lab = 'RED-202' ORDER BY question;


