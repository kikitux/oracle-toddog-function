prompt create function eventtoddog
CREATE OR REPLACE FUNCTION eventtoddog ( 
  title IN VARCHAR2,
  text  IN VARCHAR2,
  tag   IN VARCHAR2)  
RETURN VARCHAR2 IS
BEGIN
  return 'done';
END;
/
show err

CREATE OR REPLACE FUNCTION gaugetoddog(
  name IN VARCHAR2,
  metric IN number,
  tag IN VARCHAR2)
RETURN VARCHAR2 IS
BEGIN
  return 'done';
END;
/
show err

CREATE OR REPLACE FUNCTION counttoddog(
  name IN VARCHAR2,
  metric IN number,
  tag IN VARCHAR2)
RETURN VARCHAR2 IS
BEGIN
  return 'done';
END;
/
show err

prompt grant access and create public synonym

GRANT EXECUTE ON eventtoddog TO public;
--GRANT EXECUTE ON f_metrictoddog TO public;
GRANT EXECUTE ON gaugetoddog TO public;
GRANT EXECUTE ON counttoddog TO public;

CREATE OR REPLACE PUBLIC SYNONYM eventtoddog FOR SYS.eventtoddog;
--CREATE OR REPLACE PUBLIC SYNONYM f_metrictoddog FOR SYS.f_metrictoddog;
CREATE OR REPLACE PUBLIC SYNONYM gaugetoddog FOR SYS.gaugetoddog;
CREATE OR REPLACE PUBLIC SYNONYM counttoddog FOR SYS.counttoddog;
show err

exit
