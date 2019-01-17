/**********************************************************************
  Template for a Stored Procedure

  SP-Name : TestSP                                              -- TODO
  Purpose :                                                     -- TODO
  Returns : -x  - Error at called procedure                     -- TODO
            0   - Completed successfully
            1   - (1062)  Found duplicate key
            2   - (45000) User defined error
            3   - (1106)  Unknown procedure
            4   - (1122)  Unknown function
  Hints   :                                                     -- TODO
            - needs following DB-objects:
              ->  spInsertHistorie
              ->  fnXY
              ->  spXY
  History :                                                     -- TODO
            - 2019.01.15, VD, Creation of the template
**********************************************************************/

USE TestDB;                                                     -- TODO
DROP PROCEDURE IF EXISTS TestSP;                                -- TODO

DELIMITER //
CREATE PROCEDURE TestSP (                                       -- TODO
    IN    nUserId       INT

  , IN    nInValue      INT                                     -- TODO
  , OUT   nOutValue     INT                                     -- TODO
  , INOUT nInoutValue   INT                                     -- TODO

  , IN    nNoResultset  INT             --  <>0:  select no resultset
  , INOUT nError        INT             --  stores the error-code
  , INOUT szError       NVARCHAR(1000)  --  stores the error-message
  , IN    nDebug        INT             --  <>0:  create debug-output
 )
BEGIN
  initialPart:BEGIN
    -- Declaration of local variables (only in procedure)
    DECLARE szProcedureName  NVARCHAR(50)    DEFAULT N'TestSP'; -- TODO
    DECLARE nErrorCall       INT             DEFAULT 0;
    DECLARE szErrorCall      NVARCHAR(1000)  DEFAULT '';

    -- Set default values (stay alive after procedure)
    SET nInValue      = IFNULL(nInValue,      1);               -- TODO
    SET nOutValue     = IFNULL(nOutValue,     2);               -- TODO
    SET nInoutValue   = IFNULL(nInoutValue,   3);               -- TODO
    SET nNoResultset  = IFNULL(nNoResultset,  0);
    SET nError        = IFNULL(nError,        0);
    SET szError       = IFNULL(szError,       N'');

    -- Create and clean Debug-table
    DROP TABLE IF EXISTS tblDebug;
    CREATE TEMPORARY TABLE tblDebug (
        nId       INT             NOT NULL PRIMARY KEY AUTO_INCREMENT
      , dtTime    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
      , szComment NVARCHAR(1000)  NOT NULL DEFAULT N'*St.Comment*_Missing debug comment...'
      );
    -- Debug_output_start
    IF nDebug <> 0 THEN
      INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'Starting Procedure ', szProcedureName, N':'));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'       with nUserId = ', nUserId));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'       with nInValue = ', nInValue));              -- TODO
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'       with nOutValue = ', nOutValue));            -- TODO
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'       with nInoutValue = ', nInoutValue));        -- TODO
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'       with nNoResultset = ', nNoResultset));
      INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
      INSERT INTO tblDebug (szComment) VALUE (N'');
    END IF;
  END initialPart;
  -- ----------------------------------
  -- Main part
  -- ----------------------------------
  mainPart:BEGIN
    -- Declaration of handlers
    DECLARE CONTINUE  HANDLER FOR 1062      -- ER_DUP_ENTRY
        SET nError = 1;
    DECLARE EXIT      HANDLER FOR 45000     -- User defined error
        SET nError = 2;
    DECLARE EXIT      HANDLER FOR 1106      -- ER_UNKNOWN_PROCEDURE
        SET nError = 3;
    DECLARE EXIT      HANDLER FOR 1122      -- ER_CANT_FIND_UDF
        SET nError = 4;


-- -------------------------------------------------
--       VD:       V V V   Continue here V V V







    set nOutValue = 15 * nInValue;
    set nInoutValue = nInoutValue * nOutValue;
    insert into tblDebug (szComment) value (N'Test-Debug-Insert');


    -- Start error check
    IF IFNULL(nErrorCall, -1) <> 0 THEN
      IF nErrorCall < 0 THEN
        SET nError = nError-1;
      END IF;
      IF nErrorCall > 0 THEN
        SET nError = nError+100;
      END IF;
      LEAVE mainPart;
    END IF;
    -- End error check
    -- Start Debug
    IF nDebug <> 0 THEN
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'new outputvalue: ', nOutValue));
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'new inoutputvalue: ', nInoutValue));
    END IF;
    -- End Debug














  END mainPart;
  -- ----------------------------------
  -- Error part
  -- ----------------------------------
  errorPart:BEGIN
    IF nDebug <> 0 THEN
        INSERT INTO tblDebug (szComment) VALUE (N'');
        INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'Ending Procedure ', @szProcedureName, N'.'));
        INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
        SELECT * FROM tblDebug;
    END IF;
  END errorPart;
  -- ----------------------------------
  -- End part
  -- ----------------------------------
  endPart:BEGIN
    IF nDebug <> 0 THEN
        INSERT INTO tblDebug (szComment) VALUE (N'');
        INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'Ending Procedure ', @szProcedureName, N'.'));
        INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
        SELECT * FROM tblDebug;
    END IF;
  END endPart;

END; //
DELIMITER ;

/* Test-Call
use TestDB;
set @nUserId = 492;

set @nInValue = 2;
set @nOutValue = 0;
set @nInoutValue = 3;

set @nNoResultset = 0;
set @nError       = 0;
set @szError      = N'';
set @nDebug       = 1;
CALL TestSP(
    @nUserId
  , @nInValue
  , @nOutValue
  , @nInoutValue
  , @nNoResultSet
  , @nError
  , @szError
  , @nDebug
  );
select  @nUserId
      , @nInValue
      , @nOutValue
      , @nInoutValue
      , @nError
      , @szError;
*/




