set serveroutput on 

CREATE OR REPLACE PROCEDURE proc_rowcount_toddog AS
  name varchar2(150);
  tag varchar2(150);
  result varchar2(10);
  cursor c_table is
    select TABLE_NAME, NUM_ROWS, OWNER
      from all_tables where OWNER = 'HR';
  errorinloop EXCEPTION;
  err_num NUMBER;
  err_msg VARCHAR2(100);
begin
  name := 'sample.rowcount';
  for t in c_table loop
    tag := 'table_name:' || t.table_name || ',schema:' || t.owner || ',dbname:' || sys_context('USERENV','DB_NAME');
    result := gaugetoddog(name,t.num_rows,tag);
    IF result != 'done' THEN
      RAISE errorinloop;
   END IF;
  end loop;
EXCEPTION
  WHEN errorinloop THEN
    raise_application_error(-20101, 'error inside loop on samples/rowcount_job.sql');
  WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SUBSTR(SQLERRM, 1, 100);
    raise_application_error(err_num, err_msg);
END;
/
show err

begin
proc_rowcount_toddog;
end;
/
show err

declare
   job_doesnt_exist EXCEPTION;
   PRAGMA EXCEPTION_INIT( job_doesnt_exist, -27475 );
begin
   dbms_scheduler.drop_job(job_name => 'job_rowcount_toddog');
exception when job_doesnt_exist then
   null;
end;
/
show err

BEGIN
DBMS_SCHEDULER.create_job (
  job_name        => 'job_rowcount_toddog',
  job_type        => 'PLSQL_BLOCK',
  job_action      => 'BEGIN proc_rowcount_toddog; END;',
  start_date      => SYSTIMESTAMP,
  repeat_interval => 'FREQ=MINUTELY;INTERVAL=15;',
  end_date        => NULL,
  enabled         => TRUE,
  comments        => 'Job defined entirely by the CREATE JOB procedure.');
END;
/
show err

prompt check if job enabled
SELECT ENABLED as E FROM DBA_SCHEDULER_JOBS where JOB_NAME = UPPER('job_rowcount_toddog');

set lines 110
prompt check last runs
select status, ACTUAL_START_DATE from DBA_SCHEDULER_JOB_RUN_DETAILS
where job_name = UPPER('job_rowcount_toddog')
order by ACTUAL_START_DATE DESC
FETCH FIRST 5 ROWS ONLY
;


exit

