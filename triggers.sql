--creating trigger to insert country_id each time a country is added
CREATE OR REPLACE TRIGGER a1phra.countries_seq
BEFORE INSERT ON a1phra.countries
FOR EACH ROW
BEGIN
    IF :NEW.id_row IS NULL THEN
        SELECT a1phra.countries_seq.NEXTVAL INTO :NEW.id_row FROM DUAL;
    END IF;
END;
/