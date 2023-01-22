CREATE OR REPLACE 
PACKAGE OWNER_COMMANDS AS 
  
  PROCEDURE ADD_ITEM(eq_item in eq_t);
  PROCEDURE UPDATE_ITEM(update_id in number, eq_item in eq_t);
  PROCEDURE DEL_ITEM(del_id in number);
  PROCEDURE VIEW_ITEM(view_id in number);
  Type cur_type is ref cursor;
  PROCEDURE VIEW_RENTALS;
  FUNCTION CHECK_CONSTRAINTS(eq_item in eq_t) return number;
  FUNCTION CHECK_ID_EXIST(tocheck_id in number) return number;
  ex EXCEPTION;

END OWNER_COMMANDS;
