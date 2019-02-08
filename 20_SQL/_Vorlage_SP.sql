/**********************************************************************
* Template for a Stored Procedure
* Last change: 2019-01-27 20:51                                 -- TODO
*
* SP-Name : TestSP                                              -- TODO
* Purpose :                                                     -- TODO
* Returns : -x  - Error at called procedure                     -- TODO
*           0   - Completed successfully
*           1   - Incorrect input
*           2   - Error at end of procedure
*           3   - (1062)  Found duplicate key
*           4   - (45000) User defined error
*           5   - (1106)  Unknown procedure
*           6   - (1122)  Unknown function
* Hints   :                                                     -- TODO
*           - needs following DB-objects:
*             ->  spInsertHistorie()
*             ->  fnXY
*             ->  spXY()
* History :                                                     -- TODO
*           - 2019.01.25, VD, spInsertHistorie added
*           - 2019.01.15, VD, Creation of the template
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
  , IN    nResultset    INT             --  <>0:  select no resultset
  , OUT   nError        INT             --  stores the error-code
  , OUT   szError       NVARCHAR(1000)  --  stores the error-message
  , IN    nDebug        INT             --  <>0:  create debug-output
 )
BEGIN
  -- initialPart:BEGIN
    --  Start: Declaration of local variables (only in procedure)   -- TODO
    DECLARE szProcedureName   NVARCHAR(50)    DEFAULT N'TestSP';-- TODO
    DECLARE nErrorCall        INT             DEFAULT 0;
    DECLARE szErrorCall       NVARCHAR(1000)  DEFAULT N'';
    DECLARE nRowCount         INT             DEFAULT 0;
    DECLARE nSuccess          INT             DEFAULT 1;
    --  -End-: Declaration of local variables (only in procedure)
    --  Start: Setting of global variables (stay alive after procedure)   -- TODO
    SET @szTestValue  = N'*St.Comment*_TestValue';
    SET @nTestValue   = 42;
    --  -End-: Setting of global variables (stay alive after procedure)
    --  Start: Set default values                               -- TODO
    SET nInValue      = IFNULL(nInValue,      1);
    SET nInoutValue   = IFNULL(nInoutValue,   2);
    --
    SET nResultset    = IFNULL(nResultset,  0);
    SET nError        = IFNULL(nError,        0);
    SET szError       = IFNULL(szError,       N'');
    --  -End-: Set default values
    --  Start: Create Debug-table if necessary
    CREATE TEMPORARY TABLE IF NOT EXISTS tblDebug (
        nId       INT             NOT NULL PRIMARY KEY AUTO_INCREMENT
      , dtTime    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
      , szComment NVARCHAR(1000)  NOT NULL DEFAULT N'*St.Comment*_Missing debug comment...'
      );
    --  -End-: Create Debug-table if necessary
    --  Start: Debug output at procedure start                  -- TODO
    IF nDebug <> 0 THEN
      INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'Starting Procedure ', szProcedureName, N':'));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'       with nUserId = ', nUserId));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'       with nInValue = ', nInValue));          -- TODO
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'       with nOutValue = ', nOutValue));        -- TODO
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'       with nInoutValue = ', nInoutValue));    -- TODO
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'       with nResultset = ', nResultset));
      INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
      INSERT INTO tblDebug (szComment) VALUE (N'');
    END IF;
    --  -End-: Debug output at procedure start
    --  Start: Check inputs                                     -- TODO
    SET szError = N'ERROR at input: ';
    IF IFNULL(nUserId, -1) < 0 THEN
      SET nError  = 1;
      SET szError = CONCAT(szError, N'Input UserId was incorrect. (', nUserId, N')');
    END IF;
    IF IFNULL(nInValue, -1) < 1 THEN
      SET nError  = 1;
      SET szError = CONCAT(szError, N'; Input nInValue was incorrect. (', nInValue, N')');
    END IF;
    --  -End-: Check inputs
  -- END initialPart;
  -- ----------------------------------
  --  Main part
  -- ----------------------------------
  mainPart:BEGIN
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
    --  Start: Error check at beginning of main part
    IF IFNULL(nError, 0) <> 0 THEN
      SET nSuccess = 0;
      LEAVE mainPart;
    END IF;
    IF nError = 0 THEN
      SET szError = N'';
    END IF;
    --  -End-: Error check at beginning of main part



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
    IF IFNULL(nRowCount, -1) < 1 THEN
      SET nError = 2;
      SET szError = N'Couldnt update tblTestOne. RowCount to low.';
      SET nSuccess  = 0;
      LEAVE mainPart;
    END IF;
    --  -End-: Error check



    -- -------------------------------------------------
    -- -------------------------------------------------
    --  Start: Example of calling a procedure                   -- TODO
    set @nInt       = 492;
    set @szString   = N'*St.Comment*_Test-Call-String';
    set @nDebug     = 1;
    set @nResultset = 0;
    CALL TestSP_simple(
        @nInt
      , @szString
      , @nDebug
      , @nResultset
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
        SET nError = nErrorCall-100;
      END IF;
      IF nErrorCall > 0 THEN
        SET nError = nErrorCall+100;
      END IF;
      SET nSuccess  = 0;
      LEAVE mainPart;
    END IF;
    --  -End-: Error check





    -- Start: Secure and evaluate errors
    IF IFNULL(szOutValue, N'') = N'' THEN
      SET nError  = 2;
      SET szError = N'*St.Comment*_Error at end of procedure';
      SET nSuccess  = 0;
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
    set nSuccess = 0;
    --  Start: Call spInsertHistorie                            -- TODO
    call spInsertHistorie( 0               /* calling nUserId -> 0:System */
    /*  szInTable     */    , N'tblTestOne'
    /*  nInTableId    */    , -1
    /*  nInError      */    , nError
    /*  szInKommentar */    , concat(N'Failed ', N'test ', N'Kommentar: ', szError)
    /*  nInArt        */    , 8
    /*  nInUserId     */    , nUserId);
    --  -End-: Call spInsertHistorie
    --  Start: Debug
    IF nDebug <> 0 THEN
        INSERT INTO tblDebug (szComment) VALUE (N'');
        INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'Finished with errors', N'.'));
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'   nError :  ', nError));
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'   szError: ', szError));
        SELECT * FROM tblDebug;
    END IF;
    --  -End-: Debug
  END errorPart;
  -- ----------------------------------
  -- End part
  -- ----------------------------------
  endPart:BEGIN
    --  Start: Call spInsertHistorie                            -- TODO
    IF  nError   = 0
    AND nSuccess = 1 THEN
      call spInsertHistorie( 0               /* calling nUserId -> 0:System */
      /*  szInTable     */    , N'tblTestOne'
      /*  nInTableId    */    , nOutValue
      /*  nInError      */    , nError
      /*  szInKommentar */    , concat(N'successfull ', N'test ', N'Kommentar: ', szError)
      /*  nInArt        */    , 8
      /*  nInUserId     */    , nUserId);
    END IF;
    --  -End-: Call spInsertHistorie
    --  Start: Build resultset
    IF nResultset <> 0 THEN
      select nOutPersonId as result;
    END IF;
    --  -End-: Build resultset
    --  Start: Debug
    IF nDebug <> 0 THEN
        INSERT INTO tblDebug (szComment) VALUE (N'');
        INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'Ending Procedure ', szProcedureName, N'.'));
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

set @nResultset   = 1;
set @nError       = 0;
set @szError      = N'';
set @nDebug       = 1;
CALL TestSP(
    @nUserId
  , @nInValue
  , @szOutValue
  , @nInoutValue
  , @nResultset
  , @nError
  , @szError
  , @nDebug
  );
select  @nUserId
      , @nInValue
      , @szOutValue
      , @nInoutValue
      , @nResultset
      , @nError
      , @szError
      , @nDebug;
select * from tblTestOne;
select * from tblHistorie order by nHistorieId desc;
*/




