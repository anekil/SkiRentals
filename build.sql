-- It builds all db
set serveroutput on;

-- Creating object to eq_tab
CREATE OR REPLACE TYPE eq_t AS OBJECT (
 id      number,
 name    varchar2(20),
 price   number,
 rent    char(1),
 MAP MEMBER FUNCTION get_id RETURN NUMBER,
 MEMBER FUNCTION show RETURN VARCHAR2,
 MEMBER FUNCTION get_type RETURN VARCHAR2,
 MEMBER FUNCTION get_name RETURN VARCHAR2,
 MEMBER FUNCTION get_price RETURN NUMBER,
 MEMBER FUNCTION get_rent RETURN CHAR,
 MEMBER FUNCTION get_ski_type RETURN VARCHAR2,
 MEMBER FUNCTION get_ski_length RETURN NUMBER,
 MEMBER FUNCTION get_helmet_size RETURN NUMBER,
 MEMBER FUNCTION get_boots_size RETURN NUMBER)
 NOT FINAL;
 /
CREATE OR REPLACE TYPE BODY eq_t AS
 MAP MEMBER FUNCTION get_id RETURN NUMBER IS BEGIN RETURN id; END;
-- function that can be overriden by subtypes
 MEMBER FUNCTION show RETURN VARCHAR2 IS
 BEGIN
   RETURN 'Id: ' || TO_CHAR(id) || ', Name: ' || name;
 END;
 MEMBER FUNCTION get_type RETURN VARCHAR2 IS BEGIN RETURN 'equipment'; END;
 MEMBER FUNCTION get_name RETURN VARCHAR2 IS BEGIN RETURN name; END;
 MEMBER FUNCTION get_price RETURN NUMBER IS BEGIN RETURN price; END;
 MEMBER FUNCTION get_rent RETURN CHAR IS BEGIN RETURN rent; END;
 MEMBER FUNCTION get_ski_type RETURN VARCHAR2 IS BEGIN RETURN 'None'; END;
 MEMBER FUNCTION get_ski_length RETURN NUMBER IS BEGIN RETURN 0; END;
 MEMBER FUNCTION get_helmet_size RETURN NUMBER IS BEGIN RETURN 0; END;
 MEMBER FUNCTION get_boots_size RETURN NUMBER IS BEGIN RETURN 0; END;
END;

/

CREATE TYPE ski_t UNDER eq_t (
   length number,
   ski_type varchar2(12),
   OVERRIDING MEMBER FUNCTION show RETURN VARCHAR2,
   OVERRIDING MEMBER FUNCTION get_type RETURN VARCHAR2,
   OVERRIDING MEMBER FUNCTION get_ski_type RETURN VARCHAR2,
   OVERRIDING MEMBER FUNCTION get_ski_length RETURN NUMBER)
   NOT FINAL;
/
CREATE TYPE BODY ski_t AS
 OVERRIDING MEMBER FUNCTION show RETURN VARCHAR2 IS
 BEGIN
    RETURN (self AS eq_t).show || ' Length: ' || length || ' Type: ' || ski_type ;
 END;
 OVERRIDING MEMBER FUNCTION get_type RETURN VARCHAR2 IS BEGIN RETURN 'ski'; END;
 OVERRIDING MEMBER FUNCTION get_ski_type RETURN VARCHAR2 IS BEGIN RETURN ski_type; END;
 OVERRIDING MEMBER FUNCTION get_ski_length RETURN NUMBER IS BEGIN RETURN length; END;
END;

/

CREATE TYPE helmet_t UNDER eq_t (
   helmet_size number,
   OVERRIDING MEMBER FUNCTION show RETURN VARCHAR2,
   OVERRIDING MEMBER FUNCTION get_type RETURN VARCHAR2,
   OVERRIDING MEMBER FUNCTION get_helmet_size RETURN NUMBER)
   NOT FINAL;
/
CREATE TYPE BODY helmet_t AS
 OVERRIDING MEMBER FUNCTION show RETURN VARCHAR2 IS
 BEGIN
    RETURN (self AS eq_t).show || ' Size: ' || helmet_size;
 END;
 OVERRIDING MEMBER FUNCTION get_type RETURN VARCHAR2 IS BEGIN RETURN 'helmet'; END;
 OVERRIDING MEMBER FUNCTION get_helmet_size RETURN NUMBER IS BEGIN RETURN helmet_size; END;
END;

/

CREATE TYPE boots_t UNDER eq_t (
   boots_size number,
   OVERRIDING MEMBER FUNCTION show RETURN VARCHAR2,
   OVERRIDING MEMBER FUNCTION get_type RETURN VARCHAR2,
   OVERRIDING MEMBER FUNCTION get_boots_size RETURN NUMBER)
   NOT FINAL;
/
CREATE TYPE BODY boots_t AS
 OVERRIDING MEMBER FUNCTION show RETURN VARCHAR2 IS
 BEGIN
    RETURN (self AS eq_t).show || ' Size: ' || boots_size;
 END;
 OVERRIDING MEMBER FUNCTION get_type RETURN VARCHAR2 IS BEGIN RETURN 'boots'; END;
 OVERRIDING MEMBER FUNCTION get_boots_size RETURN NUMBER IS BEGIN RETURN boots_size; END;
END;

/

-- Creating sqquences
CREATE SEQUENCE seq_customers INCREMENT BY 1 START WITH 1;
/
CREATE SEQUENCE seq_eq INCREMENT BY 1 START WITH 1;
/
CREATE SEQUENCE seq_rentals INCREMENT BY 1 START WITH 1;

/

-- Creating tables
create table eq_tab of eq_t(id primary key not null);
alter table eq_tab add constraint check_rent check (rent LIKE 'Y' OR rent LIKE 'N');

/

create or replace type address_object as object(
    street varchar2(40),
    street_no number,
    post_code varchar2(6),
    city varchar2(20)
);
/
create table customers(
    customer_id number primary key not null,
    first_name varchar2(20),
    last_name varchar2(20),
    phone_number number(9,0),
    email varchar(40)
    CONSTRAINT check_email CHECK (email LIKE '%@%.com' OR email LIKE '%@%.pl'),
    address address_object,
    height number(5, 2)
    CONSTRAINT check_height CHECK (height > 0)
);

/

create or replace type rented_id_type as varray(3) of number;
/
create table rentals(
    rental_id number primary key not null,
    customer_id number not null,
    CONSTRAINT check_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),
    rented_ids rented_id_type,
    rental_start_date date,
    rental_end_date date
);

/

-- Creating triggers
CREATE OR REPLACE TRIGGER DATE_TRIGGER 
BEFORE INSERT OR UPDATE ON RENTALS 
FOR EACH ROW 
DECLARE
    temp_date date;
BEGIN
  if :new.rental_start_date > :new.rental_end_date then
    temp_date := :new.rental_start_date;
    :new.rental_start_date := :new.rental_end_date;
    :new.rental_end_date := temp_date;
    dbms_output.put_line('start date was later than end date, so we swaped dates');
  elsif :new.rental_start_date = :new.rental_end_date then
    :new.rental_end_date := :new.rental_end_date + interval '1' day;
    dbms_output.put_line('The dates were the same and minimal period of rent is one day, so we changed end date');
  end if;
  
  if (:new.rental_end_date - :new.rental_start_date) > 14 then
    :new.rental_end_date := :new.rental_start_date + interval '14' day;
    dbms_output.put_line('Maximum period of rent is 14 days and difference between date is higher than 14 days, so we changed end date');
  end if;
END;

/

-- Creating packages
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
/
CREATE OR REPLACE
PACKAGE BODY OWNER_COMMANDS AS

  PROCEDURE ADD_CUSTOMER(fname in varchar2, lname in varchar2, phone in number, email in varchar2, address in address_object, height in number) AS
  BEGIN
    insert into customers values(seq_customers.nextval, fname, lname, phone, email, address, height);
  END ADD_CUSTOMER;

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

/

CREATE OR REPLACE 
PACKAGE CUSTOMER_COMMANDS AS 
Type cur_type is ref cursor;

PROCEDURE RENT_SKI(
    customer_id number,
    ski_id number,
    boots_id number,
    helmet_id number,
    rental_start_date date,
    rental_end_date date
);

PROCEDURE RETURN_SKI(
    rent_id number,
    return_date date
);

PROCEDURE VIEW_RENTALS(
    cust_id number
);

PROCEDURE SEARCH_SKIS(
    height number,
    ski_type varchar2,
    sex char
);

END CUSTOMER_COMMANDS;
/
CREATE OR REPLACE
PACKAGE BODY CUSTOMER_COMMANDS AS

  PROCEDURE RENT_SKI(
    customer_id number,
    ski_id number,
    boots_id number,
    helmet_id number,
    rental_start_date date,
    rental_end_date date
) AS
    is_rented char := 'Y';
    rented_exception EXCEPTION;
  BEGIN
     select rent into is_rented from eq_tab where id=ski_id;
     if is_rented = 'Y' then
        RAISE rented_exception;
     end if;
     select rent into is_rented from eq_tab where id=boots_id;
     if is_rented = 'Y' then
        RAISE rented_exception;
     end if;
     select rent into is_rented from eq_tab where id=helmet_id;
     if is_rented = 'Y' then
        RAISE rented_exception;
     end if;
     
     update eq_tab set rent='Y' where id=ski_id;
     update eq_tab set rent='Y' where id=boots_id;
     update eq_tab set rent='Y' where id=helmet_id;
     
     insert into rentals values(seq_rentals.nextval, customer_id, rented_id_type(ski_id, boots_id, helmet_id), rental_start_date, rental_end_date);
     DBMS_OUTPUT.PUT_LINE('Equipment successfully rented');
  EXCEPTION  
    WHEN rented_exception THEN
        DBMS_OUTPUT.PUT_LINE('Equipment already rented');
        return;
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Equipment not found');
  END RENT_SKI;

  PROCEDURE RETURN_SKI(
    rent_id number,
    return_date date
) AS
    rented rented_id_type;
    single_price number;
    payment number := 0;
  BEGIN   
    select rented_ids into rented from rentals where rentals.rental_id = rent_id;
    for i in 1..rented.count loop
        update eq_tab set rent='N' where id=rented(i);
        select price into single_price from eq_tab where eq_tab.id=rented(i);
        payment := payment + single_price;
    end loop;
    
    update rentals set rental_end_date=return_date where rental_id=rentals.rental_id;
    dbms_output.put_line('Owing: ' || payment);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Rental details not found');
  END RETURN_SKI;

  PROCEDURE VIEW_RENTALS(
    cust_id number
) 
AS
  cursor cur is select rental_id, customer_id, rented_ids, rental_start_date, rental_end_date 
  from rentals r where r.customer_id = cust_id;
  BEGIN
    for c in cur
    loop
        dbms_output.put_line('rental id: ' || c.rental_id);
        dbms_output.put_line('customer id: ' || c.customer_id);
        dbms_output.put('list of rentals: ');
        for i in c.rented_ids.first..c.rented_ids.last loop
            dbms_output.put(c.rented_ids(i) || ' ');
        end loop;
        dbms_output.put_line('');
        dbms_output.put_line('start date: ' || c.rental_start_date);
        dbms_output.put_line('end date: ' || c.rental_end_date);
        dbms_output.put_line('');
    end loop;
  END VIEW_RENTALS;

  PROCEDURE SEARCH_SKIS(
    height IN number,
    ski_type IN varchar2,
    sex IN char
) AS
    searched_lenght number;
    result varchar2(256);
  BEGIN
    if ski_type = 'allride' then
        if sex = 'M' then
            searched_lenght := height - 15;
        else
            searched_lenght := height - 20;
        end if;
    elsif ski_type = 'allmountain' then
                if sex = 'M' then
            searched_lenght := height - 10;
        else
            searched_lenght := height - 15;
        end if;
    elsif ski_type = 'race' then
        searched_lenght := height;
    end if;
    
    select eq.show() into result from eq_tab eq where eq.id = (select e.id from eq_tab e where e.get_ski_length() = searched_lenght);
    dbms_output.put_line(result);
    
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Could not find skis');  
  END SEARCH_SKIS;

END CUSTOMER_COMMANDS;
