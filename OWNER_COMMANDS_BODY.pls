CREATE OR REPLACE
PACKAGE BODY OWNER_COMMANDS AS

  PROCEDURE ADD_ITEM(eq_item in eq_t) AS
  BEGIN
    insert into eq_tab values(eq_item);
  END ADD_ITEM;
  
  PROCEDURE UPDATE_ITEM(update_id in number, eq_item in eq_t) AS
  BEGIN
    DEL_ITEM(update_id);
    ADD_ITEM(eq_item);
  END UPDATE_ITEM;
  
  PROCEDURE DEL_ITEM(del_id in number) AS
  
  BEGIN
    delete from eq_tab e where e.id = (select id from eq_tab eq where eq.id = del_id);
  END DEL_ITEM;
  
  PROCEDURE VIEW_ITEM(view_id in number) AS
  result varchar2(256);
  BEGIN
    select eq.show() into result from eq_tab eq where eq.id = view_id;
    dbms_output.put_line(result);
  END VIEW_ITEM;
  
  PROCEDURE VIEW_RENTALS(view_id in number) AS
  BEGIN
    NULL;
  END VIEW_RENTALS;

END OWNER_COMMANDS;