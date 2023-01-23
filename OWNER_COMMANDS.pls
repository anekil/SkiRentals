CREATE OR REPLACE 
PACKAGE OWNER_COMMANDS AS 
  
  PROCEDURE ADD_CUSTOMER(fname in varchar2, lname in varchar2, phone in number, email in varchar2, address in address_object, height in number);
  PROCEDURE ADD_ITEM(eq_item in eq_t);
  PROCEDURE UPDATE_ITEM(update_id in number, eq_item in eq_t);
  PROCEDURE DEL_ITEM(del_id in number);
  PROCEDURE VIEW_ITEM(view_id in number);
  Type cur_type is ref cursor;
  PROCEDURE VIEW_RENTALS;
  FUNCTION CHECK_CONSTRAINTS(eq_item in eq_t) return number;
  FUNCTION CHECK_ID_EXIST(tocheck_id in number) return number;
  FUNCTION DEL_AVAIL(del_id in number) return number;
  ex EXCEPTION;

END OWNER_COMMANDS;
