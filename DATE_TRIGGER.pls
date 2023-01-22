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