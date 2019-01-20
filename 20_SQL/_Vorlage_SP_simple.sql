






USE TestDB;
DROP PROCEDURE IF EXISTS TestSP_simple;

DELIMITER //
CREATE PROCEDURE TestSP_simple (
    INOUT nInt          INT
  , INOUT szString      NVARCHAR(100)
  , IN    nDebug        INT
  , IN    nNoResultSet  INT
  , OUT   nError        INT
  , OUT   szError       NVARCHAR(200)
 )
BEGIN
    -- declaration of local variables
    DECLARE szDeclaredString  NVARCHAR(50)    DEFAULT N'TestDeclare';
    DECLARE nDeclaredInt      INT             DEFAULT 5951561;

    -- Set default values
    SET @nSetInt      = IFNULL(@nSetInt,      1);
    SET @szSetString  = IFNULL(@szSetString,       N'Test@@@@');



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
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'Starting Procedure TestSP_simple:'));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     with nInt:      ', nInt));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     with szString:  ', szString));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     with nDeclaredInt:      ', nDeclaredInt));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     with szDeclaredString:  ', szDeclaredString));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     with @nSetInt:      ', @nSetInt));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     with @szSetString:  ', @szSetString));
      INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
      INSERT INTO tblDebug (szComment) VALUE (N'');
    END IF;

  mainPart:BEGIN


    INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'set new values to 1111', N'#'));
    set nInt                =  3333;
    set szString            =  N'3333';
    set nDeclaredInt        =  3333;
    set szDeclaredString    =  N'3333';
    set @nSetInt            =  3333;
    set @szSetString        =  N'3333';



    -- Start Debug
    IF nDebug <> 0 THEN
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     new nInt:      ', nInt));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     new szString:  ', szString));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     new nDeclaredInt:      ', nDeclaredInt));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     new szDeclaredString:  ', szDeclaredString));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     new @nSetInt:      ', @nSetInt));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     new @szSetString:  ', @szSetString));
    END IF;
    -- End Debug
    /* INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'select new values to 2222', N'#'));
    select nInt                =  2222;
    select szString            =  N'2222';
    select nDeclaredInt        =  2222;
    select szDeclaredString    =  N'2222';
    select @nSetInt            =  2222;
    select @szSetString        =  N'2222';

    -- Start Debug
    IF nDebug <> 0 THEN
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     new nInt:      ', nInt));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     new szString:  ', szString));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     new nDeclaredInt:      ', nDeclaredInt));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     new szDeclaredString:  ', szDeclaredString));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     new @nSetInt:      ', @nSetInt));
      INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'     new @szSetString:  ', @szSetString));
    END IF;
    -- End Debug */

    IF nNoResultSet = 0 THEN
      SELECT * FROM tblTestOne WHERE nId <= 10;
    END IF;

    SET nError  = 0;
    SET szError = N'No Error...';


  END mainPart;
  -- ----------------------------------
  -- Error part
  -- ----------------------------------
  errorPart:BEGIN
    INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'No error created...', N'#'));
  END errorPart;
  -- ----------------------------------
  -- End part
  -- ----------------------------------
  endPart:BEGIN
    IF nDebug <> 0 THEN
        INSERT INTO tblDebug (szComment) VALUE (N'');
        INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
        INSERT INTO tblDebug (szComment) VALUE (CONCAT(N'Ending Procedure TestSP_simple.'));
        INSERT INTO tblDebug (szComment) VALUE (N'---------------------------------------------------');
        SELECT * FROM tblDebug;
    END IF;
  END endPart;

END; //
DELIMITER ;

/* Test-Call
use TestDB;
set @nInt         = 492;
set @szString     = N'Test-Call-String';
set @nDebug       = 1;
set @nNoResultSet = 0;
set @nError       = 0;
set @szError      = N'';
CALL TestSP_simple(
    @nInt
  , @szString
  , @nDebug
  , @nNoResultSet
  , @nError
  , @szError
  );
select  @nInt
      , @szString
      , @nError
      , @szError;
select nInt;
select szString;
select nDeclaredInt;
select szDeclaredString;
select @nSetInt;
select @szSetString;

*/


