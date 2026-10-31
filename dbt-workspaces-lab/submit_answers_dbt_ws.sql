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
('RED-202', 'NAME', $$<first name and last name>$$, CURRENT_TIMESTAMP()),
('RED-202', 'Q1', $$<Q1: why are silver models views and gold models tables?>$$, CURRENT_TIMESTAMP()),
('RED-202', 'Q2', $$<Q2: what is the difference between source() and ref()?>$$, CURRENT_TIMESTAMP()),
('RED-202', 'Q3', $$<Q3: which test failed in step 7, and why did dbt skip 14 nodes?>$$, CURRENT_TIMESTAMP()),
('RED-202', 'Q4', $$<Q4: what did source freshness answer, and what would make it WARN?>$$, CURRENT_TIMESTAMP()),
('RED-202', 'Q5', $$<Q5: in the DAG, which models break if silver_orders is renamed?>$$, CURRENT_TIMESTAMP()),
('RED-202', 'Q6', $$<Q6: give two differences between running dbt Core on your laptop and dbt Projects on Snowflake>$$, CURRENT_TIMESTAMP()),
('RED-202', 'GIT', $$<bonus: URL of your redgrave-platform repository, or leave empty>$$, CURRENT_TIMESTAMP());

SELECT question, answer FROM REDGRAVE.LAB.ANSWERS WHERE lab = 'RED-202' ORDER BY question;
