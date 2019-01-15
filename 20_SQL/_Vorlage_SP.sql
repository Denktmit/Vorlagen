-- ----------------------------------------
/* 
 Template for a Stored Procedure
 
 SP-Name: TestSP
 
 Purpose: 
 
 History:
            - 2019.01.15, VD, Creation of the template
*/
-- ----------------------------------------

USE TestDB;
DROP PROCEDURE IF EXISTS TestSP;

DELIMITER //
CREATE PROCEDURE TestSP (
    IN    nInValue      INT
  , OUT   nOutValue     INT
  , INOUT nInoutValue   INT
 
  , IN    nUserId       INT
  , IN    nDebug        INT
 )
BEGIN

  DECLARE TABLE tblDebug ( nId INT PRIMARY KEY NOT NULL AUTO_INCREMENT, szComment NVARCHAR(1000) NOT NULL );
  IF nDebug <> 0 BEGIN
    set @szDebugInsert = N'Debug-Insert-Test';
    INSERT tblDebug (szComment) VALUE (@szDebugInsert);
  END;
  
  
  
  
  
  IF nDebug <> 0 BEGIN
    SELECT * FROM @tblDebug;
  END;
  
END; //
DELIMITER ;

/* Test-Call
set @nIn = 2;
set @nOut = 0;
set @nInout = 3;
set @nUserId = 492;
set @nDebug = 1;
CALL TestSP(
    nInValue =    @nIn
  , nOutValue =   @nOut
  , nInoutValue = @nInout
  , nUserId =     @nUserId
  , nDebug =      @nDebug
  );
select  @nIn
      , @nOut
      , @nInout
      , @nUserId;
*/



