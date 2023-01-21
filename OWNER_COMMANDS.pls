CREATE OR REPLACE 
PACKAGE OWNER_COMMANDS AS 
  
  PROCEDURE ADD_ITEM(eq_item in eq_t);
  PROCEDURE UPDATE_ITEM(update_id in number, eq_item in eq_t);
  PROCEDURE DEL_ITEM(del_id in number);
  PROCEDURE VIEW_ITEM(view_id in number);
  PROCEDURE VIEW_RENTALS(view_id in number);

END OWNER_COMMANDS;