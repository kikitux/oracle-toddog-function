set serveroutput on

declare
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
    tag := 'table_name:' || t.table_name || ',schema:' || t.owner;
    dbms_output.put_line(name || ':' || t.num_rows || ',' || tag);
    result := gaugetoddog(name,t.num_rows,tag);
    IF result != 'done' THEN
      RAISE errorinloop;
   END IF;
  end loop;
EXCEPTION
  WHEN errorinloop THEN
    raise_application_error(-20101, 'error inside loop on samples/rowcount.sql');
  WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SUBSTR(SQLERRM, 1, 100);
    raise_application_error(err_num, err_msg);
END;
/
show err

exit
