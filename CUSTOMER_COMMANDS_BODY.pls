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
  BEGIN
     
  END RENT_SKI;

  PROCEDURE RETURN_SKI(
    rental_id number,
    return_date date
) AS
  BEGIN
    -- TODO: Implementation required for PROCEDURE CUSTOMER_COMMANDS.RETURN_SKI
    NULL;
  END RETURN_SKI;

  FUNCTION VIEW_RENTALS(
    customer_id IN number
) AS
  BEGIN
    -- TODO: Implementation required for FUNCTION CUSTOMER_COMMANDS.VIEW_RENTALS
    NULL;
  END VIEW_RENTALS;

  FUNCTION SEARCH_SKIS(
    height IN number,
    type IN varchar2(12)
) AS
  BEGIN
    -- TODO: Implementation required for FUNCTION CUSTOMER_COMMANDS.SEARCH_SKIS
    NULL;
  END SEARCH_SKIS;

END CUSTOMER_COMMANDS;