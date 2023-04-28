
/*
Prodecimiento almacenado para agregar clientes.
Recibe el id de la tienda, el nombre del nuevo cliente, el apellido del nuevo cliente, 
el email del cliente, la direccion del cliente ya registrada y si es un cliente activo.
Se agrega solo si la informacion de la direccion y tienda existe.
*/
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

/*
CALL insert_customer(3::SMALLINT, 'Noxian', 'Dive', 'ndive@gmail.com', 31::SMALLINT, 1);
*/

/*
Procedimiento que registra un alquiler.
Recibe el id del film en el inventario, el id del cliente y el id del staff.
Se registra solo si la informacion del film en el inventario, cliente y staff es correcto.
Lanza un error si no se logro registrar.
*****se debe activar un trigger para "borrar" del inventario el film que pasa a ser rentado.
*/
CREATE OR REPLACE PROCEDURE register_rent
(
	p_inventory_id INTEGER, 
	p_customer_id SMALLINT,
	p_staff_id SMALLINT
)
LANGUAGE plpgsql
AS $$
BEGIN 
	IF (SELECT EXISTS( SELECT 1 FROM inventory i WHERE i.inventory_id = p_inventory_id )) 
		AND (SELECT EXISTS (SELECT 1 FROM customer cu WHERE cu.customer_id = p_customer_id))
		AND (SELECT EXISTS (SELECT 1 FROM staff s WHERE s.staff_id = p_staff_id))
	THEN
		INSERT INTO rental(rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
		VALUES (NOW(), p_inventory_id, p_customer_id, NOW() + interval '1 week', p_staff_id, NOW());
		
		RAISE NOTICE 'Inserted';
	ELSE
		RAISE EXCEPTION 'Inventory, Customer or Staff not found';
	END IF;
END;$$

/*
CALL register_rent(1, 601::SMALLINT, 1::SMALLINT);
*/

/*
Procedimiento almacenado para registrar una devolucion de un film.
Recibe el id del cliente, id de un staff, id de un alquiler y el monto que debe pagar.
Lanza un error si la informacion del cliente, staff o del alquiler a pagar no se encuentra.
*****Se debe activar un trigger para agregar el film devuelto al inventario.
*/
CREATE OR REPLACE PROCEDURE register_payment
(
	p_customer_id SMALLINT,
	p_staff_id SMALLINT,
	p_rental_id INTEGER,
	p_amount NUMERIC(5,2)
)
LANGUAGE plpgsql
AS $$
BEGIN 
	IF (SELECT EXISTS( SELECT 1 FROM customer cu WHERE cu.customer_id = p_customer_id )) 
		AND (SELECT EXISTS (SELECT 1 FROM staff s WHERE s.staff_id = p_staff_id))
		AND (SELECT EXISTS (SELECT 1 FROM rental r WHERE r.rental_id = p_rental_id))
	THEN
		INSERT INTO payment(customer_id, staff_id, rental_id, amount, payment_date)
		VALUES (p_customer_id, p_staff_id, p_rental_id, p_amount, NOW());
		
		RAISE NOTICE 'Inserted';
	ELSE
		RAISE EXCEPTION 'Customer, Staff or rental not found';
	END IF;
END;$$

/*
CALL register_payment(601::SMALLINT, 1::SMALLINT, 16050, 4.99);
*/

/*
Funcion que encuentra el nombre de una pelicula con el nombre completo o una parte del nombre, o similares.
Recibe un string con el nombre o similar de una film.
Retorna una fabla con la infomacion basica de los films encontrados.
Basado en: https://www.postgresqltutorial.com/postgresql-plpgsql/plpgsql-function-returns-a-table/
*/
CREATE OR REPLACE FUNCTION find_film 
(
	p_title CHARACTER VARYING(255)
) 
RETURNS TABLE 
	(
		title CHARACTER VARYING(255), 
		release_year public.year, 
		language_of_film CHARACTER(20), 
		rental_rate NUMERIC(4,2), 
		special_features TEXT[]
	)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY 
		SELECT f.title, f.release_year, l.name AS language_of_film, f.rental_rate, f.special_features 
		FROM film f
		JOIN language l ON l.language_id = f.language_id
		WHERE f.title ILIKE p_title;
END;$$

/*
SELECT * FROM find_film('%Italian');
*/

