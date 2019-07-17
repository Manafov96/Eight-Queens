SET SQL DIALECT 3;

SET NAMES UTF8;

CREATE DATABASE 'D:\DataBases\QUEENS.FDB'
USER 'SYSDBA' PASSWORD 'masterkey'
PAGE_SIZE 16384
DEFAULT CHARACTER SET UTF8 COLLATION UTF8;

/******************************************************************************/
/***                                Domains                                 ***/
/******************************************************************************/

CREATE DOMAIN DM_PK AS
BIGINT
NOT NULL;

CREATE DOMAIN DM_STR1 AS
CHAR(1);

/******************************************************************************/
/***                           Stored procedures                            ***/
/******************************************************************************/

SET TERM ^ ;

CREATE PROCEDURE EIGHT_QUEENS
RETURNS (
    BOARDS CHAR(8))
AS
BEGIN
  SUSPEND;
END^

CREATE PROCEDURE SET_ON_BOARD
RETURNS (
    COL_1 VARCHAR(5),
    COL_2 VARCHAR(5),
    COL_3 VARCHAR(5),
    COL_4 VARCHAR(5),
    COL_5 VARCHAR(5),
    COL_6 VARCHAR(5),
    COL_7 VARCHAR(5),
    COL_8 VARCHAR(5))
AS
BEGIN
  SUSPEND;
END^

SET TERM ; ^

/******************************************************************************/
/***                                 Tables                                 ***/
/******************************************************************************/

CREATE TABLE BOARD (
    ROW    DM_PK,
    COL_1  DM_STR1,
    COL_2  DM_STR1,
    COL_3  DM_STR1,
    COL_4  DM_STR1,
    COL_5  DM_STR1,
    COL_6  DM_STR1,
    COL_7  DM_STR1,
    COL_8  DM_STR1
);


INSERT INTO BOARD (ROW, COL_1, COL_2, COL_3, COL_4, COL_5, COL_6, COL_7, COL_8) VALUES (1, '-   ', '-   ', '-   ', '-   ', '-   ', '-   ', '-   ', '-   ');
INSERT INTO BOARD (ROW, COL_1, COL_2, COL_3, COL_4, COL_5, COL_6, COL_7, COL_8) VALUES (2, '-   ', '-   ', '-   ', '-   ', '-   ', '-   ', '-   ', '-   ');
INSERT INTO BOARD (ROW, COL_1, COL_2, COL_3, COL_4, COL_5, COL_6, COL_7, COL_8) VALUES (3, '-   ', '-   ', '-   ', '-   ', '-   ', '-   ', '-   ', '-   ');
INSERT INTO BOARD (ROW, COL_1, COL_2, COL_3, COL_4, COL_5, COL_6, COL_7, COL_8) VALUES (4, '-   ', '-   ', '-   ', '-   ', '-   ', '-   ', '-   ', '-   ');
INSERT INTO BOARD (ROW, COL_1, COL_2, COL_3, COL_4, COL_5, COL_6, COL_7, COL_8) VALUES (5, '-   ', '-   ', '-   ', '-   ', '-   ', '-   ', '-   ', '-   ');
INSERT INTO BOARD (ROW, COL_1, COL_2, COL_3, COL_4, COL_5, COL_6, COL_7, COL_8) VALUES (6, '-   ', '-   ', '-   ', '-   ', '-   ', '-   ', '-   ', '-   ');
INSERT INTO BOARD (ROW, COL_1, COL_2, COL_3, COL_4, COL_5, COL_6, COL_7, COL_8) VALUES (7, '-   ', '-   ', '-   ', '-   ', '-   ', '-   ', '-   ', '-   ');
INSERT INTO BOARD (ROW, COL_1, COL_2, COL_3, COL_4, COL_5, COL_6, COL_7, COL_8) VALUES (8, '-   ', '-   ', '-   ', '-   ', '-   ', '-   ', '-   ', '-   ');

COMMIT WORK;

/******************************************************************************/
/***                              Primary keys                              ***/
/******************************************************************************/

ALTER TABLE BOARD ADD CONSTRAINT PK_BOARD PRIMARY KEY (ROW);


/******************************************************************************/
/***                           Stored procedures                            ***/
/******************************************************************************/

SET TERM ^ ;

ALTER PROCEDURE EIGHT_QUEENS
RETURNS (
    BOARDS CHAR(8))
AS
begin
  for
    with recursive
      POSITIONS(i) as (
        select cast(1 as int) from RDB$DATABASE
        union all 
		select 
        i+1 from POSITIONS where i < 8
        ),
      QUEENS(BOARDS, NQUEENS) as (
        select
          cast('' as varchar(8)), cast(1 as int)
        from
          RDB$DATABASE
        union all
        select
          substring(BOARDS from  1 for NQUEENS - 1) || PS.i, NQUEENS + 1 as NQUEENS
        from
          POSITIONS as PS, QUEENS
        where
          NQUEENS <= 8
        and not exists (
          select
            first 1 cast(1 as int)
          from
            POSITIONS as CHECKPOS
          where
            CHECKPOS.i < NQUEENS and
            (cast(substring(BOARDS from CHECKPOS.i for 1) as int) = PS.i or
             abs(cast(substring(BOARDS from CHECKPOS.i for 1) as int) - PS.i) = abs(NQUEENS - CHECKPOS.i))
        )
      )
      select
        boards
      from
        QUEENS
      where
        NQUEENS = 9
      into 
	    :BOARDS
  do
  begin
    suspend;
  end
end^

ALTER PROCEDURE SET_ON_BOARD
RETURNS (
    COL_1 VARCHAR(5),
    COL_2 VARCHAR(5),
    COL_3 VARCHAR(5),
    COL_4 VARCHAR(5),
    COL_5 VARCHAR(5),
    COL_6 VARCHAR(5),
    COL_7 VARCHAR(5),
    COL_8 VARCHAR(5))
AS
declare variable FIRST_QUEEN varchar(32);
declare variable SECOND_QUEEN varchar(32);
declare variable THIRD_QUEEN varchar(32);
declare variable FOURTH_QUEEN varchar(32);
declare variable FIVE_QUEEN varchar(32);
declare variable SIX_QUEEN varchar(32);
declare variable SEVEN_QUEEN varchar(32);
declare variable EIGHT_QUEEN varchar(32);
declare variable STMT varchar(2000);
begin
  STMT = 'UPDATE BOARD
			SET COL_1 = ''-'',
			COL_2 = ''-'',
			COL_3 = ''-'',
			COL_4 = ''-'',
			COL_5 = ''-'',
			COL_6 = ''-'',
			COL_7 = ''-'',
			COL_8 = ''-''
		  WHERE (0 = 0);';
  execute statement STMT;
  STMT = '';
  for
    select
      substring(Q.BOARDS from 1 for 1) FIRST_QUEEN,
      substring(Q.BOARDS from 2 for 1) SECOND_QUEEN,
      substring(Q.BOARDS from 3 for 1) THIRD_QUEEN,
      substring(Q.BOARDS from 4 for 1) FOURTH_QUEEN,
      substring(Q.BOARDS from 5 for 1) FIVE_QUEEN,
      substring(Q.BOARDS from 6 for 1) SIX_QUEEN,
      substring(Q.BOARDS from 7 for 1) SEVEN_QUEEN,
      substring(Q.BOARDS from 8 for 1) EIGHT_QUEEN
    from
      EIGHT_QUEENS Q
    into 
	  :FIRST_QUEEN, :SECOND_QUEEN, :THIRD_QUEEN,
      :FOURTH_QUEEN, :FIVE_QUEEN, :SIX_QUEEN,
      :SEVEN_QUEEN, :EIGHT_QUEEN
  do
  begin
    STMT = 'update BOARD set COL_' || :FIRST_QUEEN || '= ''Q''' || ' where (ROW = 1);';
    execute statement STMT;
    STMT = '';

    STMT = 'update BOARD set COL_' || :SECOND_QUEEN || '= ''Q''' || ' where (ROW = 2);';
    execute statement STMT;
    STMT = '';

    STMT = 'update BOARD set COL_' || :THIRD_QUEEN || '= ''Q''' || ' where (ROW = 3);';
    execute statement STMT;
    STMT = '';

    STMT = 'update BOARD set COL_' || :FOURTH_QUEEN || '= ''Q''' || ' where (ROW = 4);';
    execute statement STMT;
    STMT = '';

    STMT = 'update BOARD set COL_' || :FIVE_QUEEN || '= ''Q''' || ' where (ROW = 5);';
    execute statement STMT;
    STMT = '';

    STMT = 'update BOARD set COL_' || :SIX_QUEEN || '= ''Q''' || ' where (ROW = 6);';
    execute statement STMT;
    STMT = '';

    STMT = 'update BOARD set COL_' || :SEVEN_QUEEN || '= ''Q''' || ' where (ROW = 7);';
    execute statement STMT;
    STMT = '';

    STMT = 'update BOARD set COL_' || :EIGHT_QUEEN || '= ''Q''' || ' where (ROW = 8);';
    execute statement STMT;
    STMT = '';

    for
      select
        B.COL_1, B.COL_2, B.COL_3, B.COL_4,
        B.COL_5, B.COL_6, B.COL_7, B.COL_8
      from
        BOARD B
      into
        :COL_1, :COL_2, :COL_3, :COL_4,
        :COL_5, :COL_6, :COL_7, :COL_8
    do
      suspend;
      STMT = 'UPDATE BOARD
                SET
                COL_1 = ''-'',
                COL_2 = ''-'',
                COL_3 = ''-'',
                COL_4 = ''-'',
                COL_5 = ''-'',
                COL_6 = ''-'',
                COL_7 = ''-'',
                COL_8 = ''-''
              WHERE (0 = 0);';
      execute statement STMT;
      STMT = '';
      COL_1 = '!!!!!';
      COL_2 = '!!!!!';
      COL_3 = '!!!!!';
      COL_4 = '!!!!!';
      COL_5 = '!!!!!';
      COL_6 = '!!!!!';
      COL_7 = '!!!!!';
      COL_8 = '!!!!!';
      suspend;
  end
end^

SET TERM ; ^

/******************************************************************************/
/***                              Descriptions                              ***/
/******************************************************************************/

DESCRIBE DOMAIN DM_PK
'Domain for primary key.';

DESCRIBE DOMAIN DM_STR1
'Domain for symbol.';

/******************************************************************************/
/***                              Descriptions                              ***/
/******************************************************************************/

DESCRIBE TABLE BOARD
'This is table for board.';

/******************************************************************************/
/***                              Descriptions                              ***/
/******************************************************************************/

DESCRIBE PROCEDURE EIGHT_QUEENS
'Procedure returns position of queens.';

DESCRIBE PROCEDURE SET_ON_BOARD
'Procedure set on boards all variants of eight queens.';

/******************************************************************************/
/***                          Fields descriptions                           ***/
/******************************************************************************/

DESCRIBE FIELD ROW TABLE BOARD
'Field for ROW idenctificator.';

DESCRIBE FIELD COL_1 TABLE BOARD
'Field for first coloumn on board.';

DESCRIBE FIELD COL_2 TABLE BOARD
'Field for first second on board.';

DESCRIBE FIELD COL_3 TABLE BOARD
'Field for third coloumn on board.';

DESCRIBE FIELD COL_4 TABLE BOARD
'Field for fourth coloumn on board.';

DESCRIBE FIELD COL_5 TABLE BOARD
'Field for five coloumn on board.';

DESCRIBE FIELD COL_6 TABLE BOARD
'Field for six coloumn on board.';

DESCRIBE FIELD COL_7 TABLE BOARD
'Field for seven coloumn on board.';

DESCRIBE FIELD COL_8 TABLE BOARD
'Field for eight coloumn on board.';


-- This is query for find all variants of queens and set board
/*select
  SB.COL_1, SB.COL_2, SB.COL_3, SB.COL_4,
  SB.COL_5, SB.COL_6, SB.COL_7, SB.COL_8
from
  SET_ON_BOARD SB */
