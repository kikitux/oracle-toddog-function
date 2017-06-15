set serveroutput on

declare
  name varchar2(50);
  tag varchar2(50);
  result varchar2(10);
  cursor c_table is
    select count(sysdate) as c from dual;
  errorsysdate EXCEPTION;
  err_num NUMBER;
  err_msg VARCHAR2(100);
  event_rmsg VARCHAR2(100);
begin
  for t in c_table loop
    result := t.c;
    if result<2 then
      RAISE errorsysdate;
    end if;
  end loop;
EXCEPTION
  WHEN errorsysdate THEN
    event_rmsg := eventtoddog('sample event','sample: error counting sysdate, expected 2 or more','sample');
    raise_application_error(-20101, 'error counting from sysdate, event to ddog:' || event_rmsg);
  WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SUBSTR(SQLERRM, 1, 100);
    raise_application_error(err_num, err_msg);
END;
/
show err

exit
