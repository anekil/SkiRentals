CREATE OR REPLACE 
PACKAGE CUSTOMER_COMMANDS AS 

  PROCEDURE RENT_SKI(
    customer_id number,
    ski_id number,
    boots_id number,
    helmet_id number,
    rental_start_date date,
    rental_end_date date
);

PROCEDURE RETURN_SKI(
    rental_id number,
    return_date date
);

FUNCTION VIEW_RENTALS(
    customer_id IN number
);

FUNCTION SEARCH_SKIS(
    height IN number,
    type IN varchar2(12)
);

END CUSTOMER_COMMANDS;