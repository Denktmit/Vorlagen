/**********************************************************************
  Template for a Stored Procedure
  Last change: 2019-01-21 17:13

  SP-Name : TestSP                                              -- TODO
  Purpose :                                                     -- TODO
  Returns : -x  - Error at called procedure                     -- TODO
            0   - Completed successfully
            1   - Incorrect input
            2   - Error at end of procedure
            3   - (1062)  Found duplicate key
            4   - (45000) User defined error
            5   - (1106)  Unknown procedure
            6   - (1122)  Unknown function
  Hints   :                                                     -- TODO
            - needs following DB-objects:
              ->  spInsertHistorie()
              ->  spRaise_Error()
              ->  spGet_Last_Error()
              ->  fnXY
              ->  spXY()
  History :                                                     -- TODO
            - 2019.01.15, VD, Creation of the template
**********************************************************************/

USE TestDB;                                                     -- TODO
DROP PROCEDURE IF EXISTS TestSP;                                -- TODO

DELIMITER //
CREATE PROCEDURE TestSP (                                       -- TODO
    IN    nUserId       INT             --  Is mandatory
  --
  , IN    nInValue      INT                                     -- TODO
  , OUT   szOutValue    NVARCHAR(200)                           -- TODO
  , INOUT nInoutValue   INT                                     -- TODO
  --
  , IN    nNoResultset  INT             --  <>0:  select no resultset
  , OUT   nError        INT             --  stores the error-code
  , OUT   szError       NVARCHAR(1000)  --  stores the error-message
  , IN    nDebug        INT             --  <>0:  create debug-output
 )
BEGIN
  initialPart:BEGIN
    --  Start: Declaration of local variables (only in procedure)   -- TODO
    DECLARE szProcedureName   NVARCHAR(50)    DEFAULT N'TestSP';-- TODO
    DECLARE nErrorCall        INT             DEFAULT 0;
<<<<<<< HEAD
    DECLARE szErrorCall       NVARCHAR(1000)  DEFAULT N'';
=======
    DECLARE szErrorCall       NVARCHAR(1000)  DEFAULT '';
>>>>>>> master
    DECLARE nRowCount         INT             DEFAULT 0;
    --  -End-: Declaration of local variables (only in procedure)
    --  Start: Setting of global variables (stay alive after procedure)   -- TODO
    SET @szTestValue  = N'*St.Comment*_TestValue';
    SET @nTestValue   = 42;
    --  -End-: Setting of global variables (stay alive after procedure)
    --  Start: Set default values                               -- TODO
    SET nInValue      = IFNULL(nInValue,      1);
    SET nInoutValue   = IFNULL(nInoutValue,   2);
    --
    SET nNoResultset  = IFNULL(nNoResultset,  0);
    SET nError        = IFNULL(nError,        0);
    SET szError       = IFNULL(szError,       N'*St.Comment*_NO ERROR');
    --  -End-: Set default values
    --  Start: Create and clean Debug-table
    DROP TABLE IF EXISTS tblDebug;
    CREATE TEMPORARY TABLE tblDebug (
        nId       INT             NOT NULL PRIMARY KEY AUTO_INCREMENT
      , dtTime    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
      , szComment NVARCHAR(1000)  NOT NULL DEFAULT N'*St.Comment*_Missing debug comment...'
      );
    --  -End-: Create and clean Debug-table
    --  Start: Debug output at procedure start                  -- TODO
    IF nDebug <> 0 THEN
      INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'Starting Procedure ', szProcedureName, N':'));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'       with nUserId = ', nUserId));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'       with nInValue = ', nInValue));          -- TODO
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'       with nOutValue = ', nOutValue));        -- TODO
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'       with nInoutValue = ', nInoutValue));    -- TODO
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'       with nNoResultset = ', nNoResultset));
      INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
      INSERT INTO tblDebug (szComment) VALUE (N'');
    END IF;
    --  -End-: Debug output at procedure start
    --  Start: Check inputs                                     -- TODO
    IF IFNULL(nUserId, -1) < 1 THEN
      SET nError  = 1;
      SET szError = N'Input UserId was incorrect.';
    END IF;
    --  -End-: Check inputs
  END initialPart;
  -- ----------------------------------
  --  Main part
  -- ----------------------------------
  mainPart:BEGIN
    --  Start: Error check at beginning of main part
    IF IFNULL(nError, 0) <> 0 THEN
      LEAVE mainPart;
    END IF;
    --  -End-: Error check at beginning of main part
    --  Start: Declaration of handlers
    DECLARE EXIT      HANDLER FOR 1062      -- ER_DUP_ENTRY
        SET nError = 3;
    DECLARE EXIT      HANDLER FOR 45000     -- User defined error
        SET nError = 4;
    DECLARE EXIT      HANDLER FOR 1106      -- ER_UNKNOWN_PROCEDURE
        SET nError = 5;
    DECLARE EXIT      HANDLER FOR 1122      -- ER_CANT_FIND_UDF
        SET nError = 6;
    --  -End-: Declaration of handlers



    -- -------------------------------------------------
    -- -------------------------------------------------
    --  Start: Example of update                                -- TODO
    UPDATE  tblTestOne
    SET     szString  = N'*St.Comment*_Vierzehn'
    WHERE   nId       = 14;
    --  -End-: Example of update
    --  Start: Evaluation
    SET nRowCount   = ROW_COUNT();
    --  -End-: Evaluation
    --  Start: Debug                                            -- TODO
    IF nDebug <> 0 THEN
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'Example of update', N'')); -- TODO
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     nRowCount   : ', nRowCount));
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     nErrorCall  : ', nErrorCall));
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     szErrorCall : ', szErrorCall));
    END IF;
    --  -End-: Debug
    --  Start: Error check
    IF IFNULL(nErrorCall, -1) <> 0 THEN
      IF nErrorCall < 0 THEN
        SET nError = nErrorCall-100;
      END IF;
      IF nErrorCall > 0 THEN
        SET nError = nErrorCall+100;
      END IF;
      LEAVE mainPart;
    END IF;
    --  -End-: Error check



    -- -------------------------------------------------
    -- -------------------------------------------------
    --  Start: Example of calling a procedure                   -- TODO
    set @nInt       = 492;
    set @szString   = N'*St.Comment*_Test-Call-String';
    set @nDebug     = 1;
    set @nNoResultset= 0;
    CALL TestSP_simple(
        @nInt
      , @szString
      , @nDebug
      , @nNoResultset
      , nErrorCall
      , szErrorCall
      );
    --  -End-: Example of calling a procedure
    --  Start: Debug                                            -- TODO
    IF nDebug <> 0 THEN
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'Example of update', N'')); -- TODO
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     nRowCount   : ', nRowCount));
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     nErrorCall  : ', nErrorCall));
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     szErrorCall : ', szErrorCall));
    END IF;
    --  -End-: Debug
    --  Start: Error check
    IF IFNULL(nErrorCall, -1) <> 0 THEN
      IF nErrorCall < 0 THEN
<<<<<<< HEAD
        SET nError = nErrorCall-100;
      END IF;
      IF nErrorCall > 0 THEN
        SET nError = nErrorCall+100;
=======
        SET nError = nError-1;
      END IF;
      IF nErrorCall > 0 THEN
        SET nError = nError+100;
>>>>>>> master
      END IF;
      LEAVE mainPart;
    END IF;
    --  -End-: Error check





    -- Start: Secure and evaluate errors
    IF ISNULL(szOutValue, N'') = N'' THEN
      SET nError  = 2;
      SET szError = N'*St.Comment*_Error at end of procedure';
      LEAVE mainPart;
    END IF;
    -- -End-: Secure and evaluate errors
    -- Start: End of procedure -> everything is ok
    SET nError  = 0;
    SET szError = N'No error occured.';
    -- -End-: End of procedure -> everything is ok
  END mainPart;
  -- ----------------------------------
  -- Error part
  -- ----------------------------------
  errorPart:BEGIN
    --  Start: Check for errors
    IF nError = 0 THEN
      LEAVE errorPart;
    END IF;
    --  -End-: Check for errors
    --  Start: Debug                                            -- TODO
    IF nDebug <> 0 THEN
        INSERT INTO tblDebug (szComment) VALUE (N'');
        INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'Finished with errors', N'.'));
        SELECT * FROM tblDebug;
    END IF;
    --  -End-: Debug
  END errorPart;
  -- ----------------------------------
  -- End part
  -- ----------------------------------
  endPart:BEGIN
    --  Start: Build resultset                                  -- TODO
    select * FROM tblTestOne;
    --  -End-: Build resultset
    --  Start: Debug                                            -- TODO
    IF nDebug <> 0 THEN
        INSERT INTO tblDebug (szComment) VALUE (N'');
        INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'Ending Procedure ', @szProcedureName, N'.'));
        INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
        SELECT * FROM tblDebug;
    END IF;
    --  -End-: Debug
  END endPart;

END; //
DELIMITER ;

/* Test-Call
use TestDB;
set @nUserId = 492;

set @nInValue = 2;
set @szOutValue = N'';
set @nInoutValue = 3;

set @nNoResultset = 0;
set @nError       = 0;
set @szError      = N'';
set @nDebug       = 1;
CALL TestSP(
    @nUserId
  , @nInValue
  , @szOutValue
  , @nInoutValue
  , @nNoResultset
  , @nError
  , @szError
  , @nDebug
  );
select  @nUserId
      , @nInValue
      , @szOutValue
      , @nInoutValue
      , @nNoResultset
      , @nError
      , @szError
      , @nDebug;
*/




