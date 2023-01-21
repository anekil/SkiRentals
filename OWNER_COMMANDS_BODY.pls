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
  
  PROCEDURE VIEW_RENTALS AS
  rent_id number;
  cust_id number;
  rent_ids rented_id_type;
  s_date date;
  e_date date;
  cur cur_type;
  BEGIN
    open cur for select rental_id, customer_id, rented_ids, rental_start_date, rental_end_date from rentals;
        loop
            fetch cur into rent_id, cust_id, rent_ids, s_date, e_date;
            exit when cur%notfound;
            dbms_output.put_line('rantal id: ' || rent_id);
            dbms_output.put_line('customer id: ' || cust_id);
            dbms_output.put('list of rentals: ');
            for i in rent_ids.first..rent_ids.last loop
                dbms_output.put(rent_ids(i) || ' ');
            end loop;
            dbms_output.put_line('');
            dbms_output.put_line('start date: ' || s_date);
            dbms_output.put_line('end date: ' || e_date);
            dbms_output.put_line('');
        end loop;
    close cur;
  END VIEW_RENTALS;

END OWNER_COMMANDS;