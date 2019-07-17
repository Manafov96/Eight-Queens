-----------------------------------------------Eight Queens Solution-----------------------------------------------------------------
The eight queens puzzle is the problem of placing eight chess queens on an 8x8 chessboard so that no two queens threaten each other; 
thus, a solution requires that no two queens share the same row, column, or diagonal.

This is SQL realization using database Firebird 2.5.

After execute the script you must use this query for seen result:

-- This is query for find all variants of queens and set board
select
  SB.COL_1, SB.COL_2, SB.COL_3, SB.COL_4,
  SB.COL_5, SB.COL_6, SB.COL_7, SB.COL_8
from
  SET_ON_BOARD SB 