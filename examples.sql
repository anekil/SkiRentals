-- Adding new customer to db by owner
begin
    OWNER_COMMANDS.ADD_CUSTOMER('Jan', 'Kowalski', 512400122, 'jan.kowalski@gmail.com', address_object('sloneczna 7', 2, '12-345', 'lodz'), 180);
    OWNER_COMMANDS.ADD_CUSTOMER('Anna', 'Kowalska', 512400122, 'anna.kowalska@gmail.com', address_object('sloneczna 7', 2, '12-345', 'lodz'), 170);
    OWNER_COMMANDS.ADD_CUSTOMER('Adam', 'Nowak', 665123098, 'Adam.Nowak@gmail.com', address_object('wesola 34', 12, '91-561', 'lodz'), 240);
    OWNER_COMMANDS.ADD_CUSTOMER('Adam', 'Nowak', 665123098, 'adam.com', address_object('wesola 34', 12, '91-561', 'lodz'), 165);                      -- wrong email
    OWNER_COMMANDS.ADD_CUSTOMER('Jan', 'Kowalski', 512400122, 'jan.kowalski@gmail.com', address_object('sloneczna 7', 2, '12-345', 'lodz'), -170);     -- wrong height
end;

select first_name, last_name, deref(address) from customers;

-- Adding equipment by owner
begin
    OWNER_COMMANDS.ADD_ITEM(ski_t(100, '4FRNT', 100, 'N', 230, 'allride'));
    OWNER_COMMANDS.ADD_ITEM(ski_t(101, 'Fischer', 120, 'N', 210, 'allmountain'));
    OWNER_COMMANDS.ADD_ITEM(ski_t(102, 'Salomon', 95, 'N', 235, 'race'));
    OWNER_COMMANDS.ADD_ITEM(ski_t(103, 'Lint', 90, 'N', 190, 'inny typ'));       -- unknown type
    
    OWNER_COMMANDS.ADD_ITEM(helmet_t(200, 'Shoei', 15, 'N', 53));
    OWNER_COMMANDS.ADD_ITEM(helmet_t(201, 'Gspeed', 25, 'N', 56));
    OWNER_COMMANDS.ADD_ITEM(helmet_t(202, 'Shark', 12, 'N', 60));
    OWNER_COMMANDS.ADD_ITEM(helmet_t(203, 'Arai', 20, 'N', 70));                -- size out of range

    OWNER_COMMANDS.ADD_ITEM(boots_t(300, 'HJC2', 35, 'N', 44));
    OWNER_COMMANDS.ADD_ITEM(boots_t(301, 'HJC', 30, 'N', 37));
    OWNER_COMMANDS.ADD_ITEM(boots_t(302, 'Nolan', 25, 'N', 42));
    OWNER_COMMANDS.ADD_ITEM(boots_t(303, 'Caberg', 10, 'N', 11));               -- size out of range
    
    OWNER_COMMANDS.VIEW_ITEM(100);
end;

select eq.show() from eq_tab eq;

-- Updating item
begin
    OWNER_COMMANDS.UPDATE_ITEM(101, ski_t(11, '4FRNT', 200, 'N', 230, 'allride'));
    OWNER_COMMANDS.UPDATE_ITEM(9999, ski_t(99, '4FRNT', 200, 'Y', 230, 'allride')); -- wrong id
    
    OWNER_COMMANDS.VIEW_ITEM(11);
    OWNER_COMMANDS.VIEW_ITEM(101);  -- updated id (not exist)
end;

select eq.show() from eq_tab eq;

-- Deleting item
begin
    OWNER_COMMANDS.DEL_ITEM(0);     -- wrong id
    OWNER_COMMANDS.DEL_ITEM(100);
    
    OWNER_COMMANDS.VIEW_ITEM(100);  -- id not exist
end;

select eq.show() from eq_tab eq;

-- Renting equipment
begin
    CUSTOMER_COMMANDS.RENT_SKI(
        customer_id => 1,
        ski_id => 100,
        boots_id => 101,
        helmet_id => 102,
        rental_start_date => sysdate,
        rental_end_date => sysdate);
        
        CUSTOMER_COMMANDS.RENT_SKI(
        customer_id => 2,
        ski_id => 200,
        boots_id => 201,
        helmet_id => 202,
        rental_start_date => (sysdate + interval '5' day),      -- DATE_TRIGGER called
        rental_end_date => sysdate);
        
        CUSTOMER_COMMANDS.RENT_SKI(
        customer_id => 1,
        ski_id => 300,
        boots_id => 301,
        helmet_id => 302,
        rental_start_date => sysdate,
        rental_end_date => (sysdate + interval '50' day));      -- DATE_TRIGGER called
end;

select * from customers;
select * from eq_tab;
select * from rentals;

-- Viewing rentals (view for clients)
begin
    CUSTOMER_COMMANDS.VIEW_RENTALS(cust_id => 1); 
    CUSTOMER_COMMANDS.VIEW_RENTALS(cust_id => 2); 
end;

-- Viewing rentals (view for owner)
begin
    OWNER_COMMANDS.VIEW_RENTALS;
end;

-- Returning equipment to owner
begin
    CUSTOMER_COMMANDS.RETURN_SKI(
        rent_id => 1,
        return_date => sysdate);

    CUSTOMER_COMMANDS.RETURN_SKI(
        rent_id => 2,
        return_date => sysdate);
        
    CUSTOMER_COMMANDS.RETURN_SKI(
        rent_id => 999,                 -- incorrect id
        return_date => sysdate);
end;

-- Searching for ideal ski
begin 
    CUSTOMER_COMMANDS.SEARCH_SKIS(
        height => 245,
        ski_type => 'allride',
        sex => 'M'
    );
end;

--can't find skis
begin 
    CUSTOMER_COMMANDS.SEARCH_SKIS(
        height => 240,
        ski_type => 'allmountain',
        sex => 'M'
    );
end;


