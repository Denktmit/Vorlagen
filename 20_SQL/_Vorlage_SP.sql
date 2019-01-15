-- ----------------------------------------
/* 
 Template for a Stored Procedure
 
 SP-Name: TestSP                                -- TODO
 
 Purpose:                                       -- TODO
 
 History:                                       -- TODO
            - 2019.01.15, VD, Creation of the template
*/
-- ----------------------------------------

USE TestDB;
DROP PROCEDURE IF EXISTS TestSP;                -- TODO

DELIMITER //
CREATE PROCEDURE TestSP (
    IN    nInValue      INT                     -- TODO
  , OUT   nOutValue     INT                     -- TODO
  , INOUT nInoutValue   INT                     -- TODO
 
  , IN    nUserId       INT
  , IN    nDebug        INT
 )
BEGIN
    -- TODO: Set default values
    SET @szProcedureName = N'TestSP';           -- TODO
    SET nInValue = IFNULL(nInValue, 1);         -- TODO
    SET nOutValue = IFNULL(nOutValue, 2);       -- TODO
    SET nInoutValue = IFNULL(nInoutValue, 3);   -- TODO
    
    DROP TABLE IF EXISTS tblDebug;
    CREATE TEMPORARY TABLE tblDebug ( nId INT PRIMARY KEY NOT NULL AUTO_INCREMENT, dtTime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, szComment NVARCHAR(1000) NOT NULL DEFAULT N'*St.Comment*_Missing debug comment...');
    IF nDebug <> 0 THEN
        INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'Starting Procedure ', @szProcedureName, N':'));
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'       with nInValue = ', nInValue));              -- TODO
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'       with nOutValue = ', nOutValue));            -- TODO
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'       with nInoutValue = ', nInoutValue));        -- TODO
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'       with nUserId = ', nUserId));                -- TODO
        INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
        INSERT INTO tblDebug (szComment) VALUE (N'');
    END IF;
    -- ----------------------------------
    -- Main part
    -- ----------------------------------
    
    
    
    
    set nOutValue = 15 * nInValue;
    set nInoutValue = nInoutValue * nOutValue;
    insert into tblDebug (szComment) value (N'Test-Debug-Insert');
    -- Start Debug
    IF nDebug <> 0 THEN
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'new outputvalue: ', nOutValue));
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'new inoutputvalue: ', nInoutValue));
    END IF;
    -- End Debug
    
    
    
    -- ----------------------------------
    -- End part
    -- ----------------------------------
    IF nDebug <> 0 THEN
        INSERT INTO tblDebug (szComment) VALUE (N'');
        INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'Ending Procedure ', @szProcedureName, N'.'));
        INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
        SELECT * FROM tblDebug;
    END IF;
  
END; //
DELIMITER ;

/* Test-Call
use TestDB;
set @nInValue = 2;
set @nOutValue = 0;
set @nInoutValue = 3;
set @nUserId = 492;
set @nDebug = 1;
CALL TestSP(
    @nInValue
  , @nOutValue
  , @nInoutValue
  , @nUserId
  , @nDebug
  );
select  @nInValue
      , @nOutValue
      , @nInoutValue
      , @nUserId;
*/




