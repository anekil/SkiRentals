CREATE OR REPLACE
PACKAGE BODY OWNER_COMMANDS AS

  PROCEDURE ADD_ITEM(eq_item in eq_t) AS
  BEGIN
    if CHECK_CONSTRAINTS(eq_item) = 1 then
        insert into eq_tab values(eq_item);
    else raise ex;
    end if;
    EXCEPTION
        when ex then
            dbms_output.put_line('cannot add item');
  END ADD_ITEM;
  
  PROCEDURE UPDATE_ITEM(update_id in number, eq_item in eq_t) AS
  BEGIN
    if CHECK_ID_EXIST(update_id) = 1 and CHECK_CONSTRAINTS(eq_item) = 1 then
        DEL_ITEM(update_id);
        ADD_ITEM(eq_item);
    else raise ex;
    end if;
    EXCEPTION
        when ex then
            dbms_output.put_line('cannot update item');
  END UPDATE_ITEM;
  
  PROCEDURE DEL_ITEM(del_id in number) AS
  BEGIN
    if CHECK_ID_EXIST(del_id) = 1 and DEL_AVAIL(del_id) = 1 then
        delete from eq_tab e where e.id = (select id from eq_tab eq where eq.id = del_id);
    else raise ex;
    end if;
    EXCEPTION
        when ex then
            dbms_output.put_line('cannot delete item');
  END DEL_ITEM;
  
  PROCEDURE VIEW_ITEM(view_id in number) AS
  result varchar2(256);
  BEGIN
    if CHECK_ID_EXIST(view_id) = 1 then
        select eq.show() into result from eq_tab eq where eq.id = view_id;
        dbms_output.put_line(result);
    else raise ex;
    end if;
    EXCEPTION
        when ex then
            dbms_output.put_line('cannot view item');
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
  
  FUNCTION CHECK_CONSTRAINTS(eq_item in eq_t) RETURN NUMBER AS
  BEGIN
    case eq_item.get_type()
        when 'ski' then
            if eq_item.get_ski_type NOT IN('allride', 'allmountain', 'race') then return 0;
            else return 1;
            end if;
        when 'helmet' then
            if eq_item.get_helmet_size BETWEEN 52 AND 62 then return 1;
            else return 0;
            end if;
        when 'boots' then
            if eq_item.get_boots_size BETWEEN 34 AND 48 then return 1;
            else return 0;
            end if;
    end case;
  END;
  
  FUNCTION CHECK_ID_EXIST(tocheck_id in number) return number AS
  id_exist number := 0;
  BEGIN
    select count(e.id) into id_exist from eq_tab e where e.id = (select id from eq_tab eq where eq.id = tocheck_id);
    return id_exist;
  END;
  
  FUNCTION DEL_AVAIL(del_id in number) return number AS
  cant_del char(1);
  BEGIN
    select e.rent into cant_del from eq_tab e where e.id = (select id from eq_tab eq where eq.id = del_id);
    if cant_del = 'Y' then return 0;
    else return 1;
    end if;
  END;

END OWNER_COMMANDS;