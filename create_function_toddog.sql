prompt create library using libtoddog.so
CREATE OR REPLACE LIBRARY libtoddog AS  '${ORACLE_HOME}/lib/libtoddog.so';
/
show err

prompt create function f_metrictoddog
CREATE OR REPLACE FUNCTION f_metrictoddog ( 
  name   IN VARCHAR2,
  metric IN BINARY_INTEGER,
  kind   IN VARCHAR2,
  tag    IN VARCHAR2)  
RETURN VARCHAR2 AS LANGUAGE C 
NAME "metrictoddog" 
LIBRARY libtoddog
WITH CONTEXT 
PARAMETERS ( 
  CONTEXT,  
  name    STRING,  
  name    INDICATOR short,  
  metric  INT,  
  metric	INDICATOR short,  
  kind    STRING,  
  kind    INDICATOR short,  
  tag     STRING,  
  tag     INDICATOR short,  
  RETURN  INDICATOR short,  
  RETURN  LENGTH short,  
  RETURN  STRING); 
/
show err

prompt create function f_eventtoddog
CREATE OR REPLACE FUNCTION f_eventtoddog ( 
  title IN VARCHAR2,
  text  IN VARCHAR2,
  tag   IN VARCHAR2)  
RETURN VARCHAR2 AS LANGUAGE C 
NAME "eventtoddog" 
LIBRARY libtoddog
WITH CONTEXT 
PARAMETERS ( 
  CONTEXT,  
  title   STRING,  
  title   INDICATOR short,  
  text    STRING,  
  text 	  INDICATOR short,  
  tag     STRING,  
  tag     INDICATOR short,  
  RETURN  INDICATOR short,  
  RETURN  LENGTH short,  
  RETURN  STRING); 
/
show err

CREATE OR REPLACE FUNCTION f_gaugetoddog(
  name IN VARCHAR2,
  metric IN number,
  tag IN VARCHAR2)
RETURN VARCHAR2 IS
BEGIN
  return f_metrictoddog(name,metric,'g',tag);
END;
/
show err

CREATE OR REPLACE FUNCTION f_counttoddog(
  name IN VARCHAR2,
  metric IN number,
  tag IN VARCHAR2)
RETURN VARCHAR2 IS
BEGIN
  return f_metrictoddog(name,metric,'c',tag);
END;
/
show err

prompt grant access and create public synonym

GRANT EXECUTE ON f_metrictoddog TO public;
GRANT EXECUTE ON f_eventtoddog TO public;
GRANT EXECUTE ON f_gaugetoddog TO public;
GRANT EXECUTE ON f_counttoddog TO public;

CREATE OR REPLACE PUBLIC SYNONYM f_metrictoddog FOR SYS.f_gaugetoddog;
CREATE OR REPLACE PUBLIC SYNONYM f_eventtoddog FOR SYS.f_gaugetoddog;
CREATE OR REPLACE PUBLIC SYNONYM f_gaugetoddog FOR SYS.f_gaugetoddog;
CREATE OR REPLACE PUBLIC SYNONYM f_counttoddog FOR SYS.f_gaugetoddog;
show err

prompt calling function from pl/sql block
set serveroutput on

declare
  name varchar2(50);
  metric int(10);
  tag varchar2(50);
  result varchar2(10);
  err_num NUMBER;
  err_msg VARCHAR2(100);
begin
  name := 'sample.gauge';
  metric := 15;
  tag := 'source:plsql';
  result := f_gaugetoddog(name,metric,tag);
  dbms_output.put_line(result);
EXCEPTION
  WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SUBSTR(SQLERRM, 1, 100);
    raise_application_error(err_num, err_msg);
END;
/
show err

declare
  name varchar2(50);
  metric int(10);
  tag varchar2(50);
  result varchar2(10);
  err_num NUMBER;
  err_msg VARCHAR2(100);
begin
  name := 'sample.count';
  metric := 15;
  tag := 'source:plsql';
  result := f_counttoddog(name,metric,tag);
  dbms_output.put_line(result);
  EXCEPTION
    WHEN OTHERS THEN
      err_num := SQLCODE;
      err_msg := SUBSTR(SQLERRM, 1, 100);
      raise_application_error(err_num, err_msg);
END;
/
show err

declare
  title varchar2(50);
  text varchar2(50);
  tag varchar2(50);
  result varchar2(10);
  err_num NUMBER;
  err_msg VARCHAR2(100);
begin
  title := 'title of event';
  text := 'text for event';
  tag := 'source:plsql';
  result := f_eventtoddog(title,text,tag);
  dbms_output.put_line(result);
EXCEPTION
  WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SUBSTR(SQLERRM, 1, 100);
    raise_application_error(err_num, err_msg);
END;
/
show err

exit
