SELECT * FROM customer


CREATE OR REPLACE PROCEDURE insert_customer
(
	p_store_id SMALLINT, 
	p_first_name CHARACTER VARYING(45), 
	p_last_name CHARACTER VARYING(45),
	p_email CHARACTER VARYING(50),
	p_address_id SMALLINT,
	p_active INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN 
	IF (SELECT EXISTS( SELECT 1 FROM store s WHERE s.store_id = p_store_id )) AND (SELECT EXISTS (SELECT 1 FROM address ad WHERE ad.address_id = p_address_id))
	THEN
		INSERT INTO customer(store_id, first_name, last_name, email, address_id, active)
		VALUES (p_store_id, p_first_name, p_last_name, p_email, p_address_id, p_active);
		
		RAISE NOTICE 'Inserted';
	ELSE
		RAISE EXCEPTION 'Address or Store not found';
	END IF;
END;$$

CALL insert_customer(3::SMALLINT, 'Noxian', 'Dive', 'ndive@gmail.com', 31::SMALLINT, 1);
