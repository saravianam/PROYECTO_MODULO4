--1.Crea el esquema de la BBDD
--hecho en la pestaña public

--2.Muestra los nombres de todas las películas con una clasificación por edades de 'R'
select 
	"title",
	"rating"
from "film" 
where "rating"='R';

--3.Encuentra los nombres de los actores que tengan un "actor_id" entre 30 y 40
select 
	"first_name",
	"last_name",
	"actor_id"
from "actor" 
where "actor_id">=30 AND "actor_id"<= 40;

--4.Obten las películas cuyo idioma coincide con el idioma original
SELECT DISTINCT (original_language_id)
FROM film AS f ;
--Salen todos los valores nulos por lo que no se puede determinar el idioma original

--5.Ordena las películas por duración de forma ascendente
select 
	"title",
	"length"
from "film" 
ORDER BY film.length ASC;

--6.Encuentra el nombre y apellido de los actores que tengan 'Allen' en su apellido
SELECT a.first_name , 
		a.last_name 
FROM actor AS a 
WHERE a.last_name ILIKE '%Allen%';
--No he concatenado el nombre y apellido porque no lo indicaba el enunciado

--7.Encuentra la totalidad de las películas en cada clasificacion de la tabla "film" y muestra la clasificación junto con el recuento.
select 
	"rating",
	count("film_id")
from "film"
GROUP BY rating ;

--8.Encuentra el título de todas las películas que son 'PG-13' o tienen una duracion mayor a 3 horas en la tabla film
SELECT f.title
FROM film AS f 
WHERE f.rating = 'PG-13' OR f.length > 180;

--9. Encuentra la variabilidad de lo que costaría reemplazar las películas
SELECT round (variance(replacement_cost),2)
FROM film ;
--entiendo variabilidad como varianza. He puesto dos decimales para mantener el formato del campo replacement_cost

--10.Encuentra la mayor y menor duracion de una pelicula
SELECT 
	MIN(f.length ) AS menor_duracion,
	MAX(f.length ) AS mayor_duracion
FROM film AS f ;

--11.Encuentra lo que costó el antepenúltimo alquiler ordenado por dia
SELECT 
    p.payment_id,
    p.amount AS costo,
    r.rental_date
FROM rental AS r
JOIN payment AS p ON r.rental_id = p.rental_id
ORDER BY r.rental_date DESC
LIMIT 1 OFFSET 2;

--12.Encuentra el título de las películas en la tabla film que no sean ni 'NC-17' ni 'G' en su clasificación
SELECT f.title 
FROM film AS f
WHERE f.rating NOT IN ('NC-17','G');

--13.Encuentra el promedio de duracion de las peliculas para cada clasificacion de la tabla film y muestra la clasificacion junto con el promedio de duracion
SELECT 
	f.rating  , 
	round(AVG(f.length ),2)
FROM film AS f
GROUP BY f.rating ;
--He redondeado a 2 decimales para que visualmente quede más limpio

--14.Encuentra el titulo de todas las películas que tengan una duración mayor a 180 minutos
SELECT f.title
FROM film AS f
WHERE f.length >180;
--no he indicado el campo de duracion al indicar el enunciado solo el titulo

--15.¿Cuánto dinero ha generado en total la empresa?
SELECT SUM(amount) AS total_recaudado
FROM payment;

--16.Muestra los 10 clientes con mayor valor de id
SELECT concat(c.first_name ,' ',c.last_name )
FROM customer AS c 
ORDER BY c.customer_id DESC 
LIMIT 10;
--he concatenado nombre y apellido para que se vea más claro

--17.Encuentra el nombre y apellido de los actores que aparecen en la pelicula cuyo titulo es 'Egg Igby'
SELECT a.first_name, a.last_name
FROM actor AS a
JOIN film_actor AS fa ON a.actor_id = fa.actor_id
JOIN film AS f ON fa.film_id = f.film_id
WHERE f.title = 'Egg Igby';
--Al no salir ningún resultado se entiende que no hay datos que den esta información por lo que no sabemos que actores participaron en esa película.

--18.Selecciona todos los nombres de las peliculas unicos
SELECT DISTINCT (f.title )
FROM film AS f ;

--19.Encuentra el titulo de las peliculas que son comedias y tienen una duracion mayor a 180 min en la tabla "film"
SELECT f.title, f.length
FROM film AS f
JOIN film_category AS fc ON f.film_id = fc.film_id
JOIN category AS c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy'
  AND f.length > 180;

--20.Encuentra las categorias de peliculas con duracion superior a 110 min y muestra el nombre de la categoria junto con el promedio de la duracion
SELECT 
    c.name AS categoria,
    round(AVG(f.length),2) AS promedio_duracion
FROM film AS f
JOIN film_category AS fc ON f.film_id = fc.film_id
JOIN category AS c ON fc.category_id = c.category_id
WHERE f.length > 110
GROUP BY c.name
ORDER BY promedio_duracion DESC;
--he redondeado la media a 2 decimales para que se vea más limpio el resultado

--21.¿Cuál es la media de duracion del alquiler de las peliculas?
SELECT round(AVG(f.rental_duration ),0)
FROM film AS f ;
--redondeo a 0 decimales para que tenga el mismo formato que el campo original

--22.Crea una columna con el nombre y apellidos de todos los actores y actrices
SELECT concat(a.first_name ,' ',a.last_name )
FROM actor AS a ;

--23.Numero de alquiler por dia, ordenados por cantidad de alquiler de forma descendente.
SELECT 
    DATE(rental_date) AS fecha,
    COUNT(*) AS cantidad_alquileres
FROM rental
GROUP BY DATE(rental_date)
ORDER BY cantidad_alquileres DESC;

--24.Encuentra las peliculas con una duracion superior al promedio
SELECT 
	f.title ,
	f.length 
FROM film AS f 
WHERE f.length > (
	SELECT AVG(f2.length)
	FROM film AS f2
);

--25.Averigua el número de alquileres registrados por mes
SELECT 
   	EXTRACT(YEAR FROM rental_date) AS año,
   	EXTRACT(MONTH FROM rental_date) AS mes,
    COUNT(*) AS cantidad_alquileres
FROM rental
GROUP BY año, mes
ORDER BY año, mes;
--He encontrado la manera de sacar el mes y el año con extract


--26.Encuentra el promedio, la desviacion estandar y la varizanza del total pagado
SELECT
    round(AVG(amount),2) AS promedio,
    round(STDDEV(amount),2) AS desviacion_estandar,
    round(VARIANCE(amount),2) AS varianza
FROM payment;
--he redondeado todos los datos a 2 decimales para que quede más limpio

--27.¿Qué peliculas se alquilan por encima del precio medio?
SELECT 
	f.title ,
	f.rental_rate 
FROM film AS f 
WHERE f.rental_rate > (
	SELECT AVG(f2.rental_rate)
	FROM film AS f2
);

--28.Muestra el id de los actores que hayan participado en más de 40 peliculas
SELECT 
    fa.actor_id,
    COUNT(fa.film_id) AS cantidad_peliculas
FROM film_actor AS fa
GROUP BY fa.actor_id
HAVING COUNT(fa.film_id) > 40;

--29.Obtener todas las peliculas y, si están disponibles en el inventario, mostrar la cantidad disponible.
SELECT 
    f.film_id,
    f.title,
    COUNT(i.inventory_id) AS cantidad_disponible
FROM film AS f
LEFT JOIN inventory AS i ON f.film_id = i.film_id
GROUP BY f.film_id, f.title;

--30.Obtener los actores y el numero de peliculas en las que ha actuado
SELECT 
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS cantidad_peliculas
FROM actor AS a
JOIN film_actor AS fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name; 

--31.Obtener las peliculas y mostrar los actores que han actuado en ellas, incluso si algunas peliculas no tienen actores asociados.
SELECT 
    f.film_id,
    f.title,
    CONCAT(a.first_name, ' ', a.last_name) AS actor
FROM film AS f
LEFT JOIN film_actor AS fa ON f.film_id = fa.film_id
LEFT JOIN actor AS a ON fa.actor_id = a.actor_id;

--32.Obtener todos los actores y mostrar las peliculas en las que han actuado, incluso si algunos actores no han actuado en ninguna pelicula
SELECT 
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS actor,
    f.title AS pelicula
FROM actor AS a
LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id
LEFT JOIN film AS f ON fa.film_id = f.film_id ;

--33.Obtener todas las peliculas que tenemos y todos los registros de alquiler.
SELECT 
    f.film_id,
    f.title,
    r.rental_id,
    r.rental_date,
    r.return_date
FROM film AS f
LEFT JOIN inventory AS i ON f.film_id = i.film_id
LEFT JOIN rental AS r ON i.inventory_id = r.inventory_id; 

--34.Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS cliente,
    SUM(p.amount) AS total_gastado
FROM customer AS c
JOIN payment AS p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
LIMIT 5;

--35.Seleccionar todos los actores cuyo primer nombre es 'Johnny'
SELECT 
	a.actor_id,
	a.first_name 
FROM actor AS a 
WHERE a.first_name ILIKE 'Johnny';

--36.Renombra la columna "first_name" como Nombre y "last_name" como Apellido
SELECT 
	a.first_name AS Nombre,
	a.last_name AS Apellido
FROM actor AS a ;

--37.Encuentra el ID del actor mas bajo y mas alto en la tabla actor.
SELECT 
	MIN(a.actor_id ),
	MAX(a.actor_id )
FROM actor;

--38.Cuenta cuantos actores hay en la tabla actor
SELECT count (a.actor_id )
FROM actor;

--39.Selecciona todos los actores y ordenalos por apellido en orden ascendente
SELECT *
FROM actor AS a 
ORDER BY a.last_name ;
--Selecciono todos los campos al no indicar cuales se quieren visualizar

--40.Selecciona las primeras 5 películas de la tabla "film"
SELECT *
FROM film 
LIMIT 5;
--he seleccionado todos los campos de esas peliculas porque no indicaba ninguno en concreto

--41.Agrupa los actores por su nombre y cuenta cuantos actores tienen el mismo nombre. ¿Cual es el nombre más repetido?
SELECT 
	a.first_name,
	count (a.actor_id ) AS "recuento"
FROM actor AS a 
GROUP BY a.first_name 
ORDER BY "recuento" DESC;
--Los nombres más repetidos son Kenneth, Penelope y Julia empatados con 4

--42.Encuentra todos los alquileres y los nombres de los clientes que los realizaron
SELECT 
    r.rental_id,
    r.rental_date,
    CONCAT(c.first_name, ' ', c.last_name) AS cliente,
    f.title AS pelicula
FROM rental AS r
JOIN customer AS c ON r.customer_id = c.customer_id
JOIN inventory AS i ON r.inventory_id = i.inventory_id
JOIN film AS f ON i.film_id = f.film_id; 

--43.Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS cliente,
    r.rental_id,
    r.rental_date,
    r.return_date
FROM customer AS c
LEFT JOIN rental AS r ON c.customer_id = r.customer_id;

--44.Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja despues de la consulta la contestacion
SELECT *
FROM film AS f 
CROSS JOIN category AS c ;
--Esta consulta genera todas las posibles combinaciones entre los campos de las tablas por loq ue se genera una tabla con muchas filas que tampoco genera mucho valor ya que en muchos casos no hay coincidencias entre ellas.

--45.Encuentra los actores que han participado en peliculas de la categoria 'Action'
SELECT 
    DISTINCT a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS actor
FROM actor AS a
JOIN film_actor AS fa ON a.actor_id = fa.actor_id
JOIN film AS f ON fa.film_id = f.film_id
JOIN film_category AS fc ON f.film_id = fc.film_id
JOIN category AS c ON fc.category_id = c.category_id
WHERE c.name = 'Action';

--46.Encuentra todos los actores que no han participado en peliculas
SELECT 
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS actor
FROM actor AS a
LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;
--No salen resultados por lo que se entiende que no hay ningun actor que no haya participado en películas

--47.Selecciona el nombre de los actores y la cantidad de peliculas en las que han participado
SELECT 
    a.actor_id,
    CONCAT(a.first_name, ' ', a.last_name) AS actor,
    COUNT(fa.film_id) AS cantidad_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name;

--48.Crea una vista llamada "actor_num_peliculas" que muestre los nombres de los actores y el numero de peliculas en las que han participado
CREATE VIEW actor_num_peliculas AS
SELECT 
    CONCAT(a.first_name, ' ', a.last_name) AS actor,
    COUNT(fa.film_id) AS cantidad_peliculas
FROM actor AS a
LEFT JOIN film_actor AS fa 
	ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name;

--49.Calcula el numero total de alquileres realizados por cada cliente
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS cliente,
    COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
LEFT JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, cliente;

--50.Calcula la duracion total de las peliculas en la categoria 'Action'
SELECT 
    c.name AS categoria,
    SUM(f.length) AS duracion_total
FROM film AS f
JOIN film_category AS fc ON f.film_id = fc.film_id
JOIN category AS c ON fc.category_id = c.category_id
WHERE c.name = 'Action'
GROUP BY c.name;

--51.Crea una tabla temporal llamada "clientes_rentas_temporal" para almacenar el total de alquileres por cliente
CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS cliente,
    COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
LEFT JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, cliente;

--52.Crea una tabla temporal llamada "peliculas_alquiladas" que almacene las peliculas que han sido alquiladas al menos 10 veces.
CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT 
    f.film_id,
    f.title,
    COUNT(r.rental_id) AS total_alquileres
FROM film AS f
JOIN inventory AS i ON f.film_id = i.film_id
JOIN rental AS r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;

--53.Encuentra el titulo de las peliculas que han sido alquiladas por el cliente con el nombre 'Tammy Sanders' y que aun no se han devuelto. Ordena los resultados alfabeticamente por titulo de pelicula.
SELECT 
    f.title AS pelicula
FROM customer AS c
JOIN rental AS r ON c.customer_id = r.customer_id
JOIN inventory AS i ON r.inventory_id = i.inventory_id
JOIN film AS f ON i.film_id = f.film_id
WHERE c.first_name = 'Tammy'
  AND c.last_name = 'Sanders'
  AND r.return_date IS NULL
ORDER BY f.title;
--No se han encontrado resultados por lo que se entiende que ninguna pelicula cumple con esas caracteristicas

--54.Encuentra los nombres de los actores que han actuado en al menos una pelicula que pertene a la categoria 'Sci-Fi'. Ordena los resultados alfabeticamente por apellido.
SELECT 
    DISTINCT a.first_name,
    a.last_name
FROM actor AS a
JOIN film_actor AS fa ON a.actor_id = fa.actor_id
JOIN film AS f ON fa.film_id = f.film_id
JOIN film_category AS fc ON f.film_id = fc.film_id
JOIN category AS c ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name, a.first_name;

--55.Encuentra el nombre y apellido de los actores que han actuado en peliculas que se alquilar después de que la pelicula 'Spartacus Cheaper' se alquilara por primera vez. Ordena los resultados alfabeticamente por apellido.
SELECT DISTINCT 
    a.first_name,
    a.last_name
FROM actor AS a
JOIN film_actor AS fa ON a.actor_id = fa.actor_id
JOIN film AS f ON fa.film_id = f.film_id
JOIN inventory AS i ON f.film_id = i.film_id
JOIN rental AS r ON i.inventory_id = r.inventory_id
WHERE r.rental_date > (
    SELECT MIN(r2.rental_date)
    FROM rental AS r2
    JOIN inventory AS i2 ON r2.inventory_id = i2.inventory_id
    JOIN film AS f2 ON i2.film_id = f2.film_id
    WHERE f2.title = 'Spartacus Cheaper'
)
ORDER BY a.last_name, a.first_name;
--Ningun resultado aplica a esos criterios

--56.Encuentre el nombre y apellido de lso actores que no han actuado en ninguna pelicula de la categoria 'Music'
SELECT 
    a.first_name,
    a.last_name
FROM actor AS a
WHERE a.actor_id NOT IN (
    SELECT DISTINCT fa.actor_id
    FROM film_actor AS fa
    JOIN film_category AS fc ON fa.film_id = fc.film_id
    JOIN category AS c ON fc.category_id = c.category_id
    WHERE c.name = 'Music'
);

--57.Encuentra el titulo de las peliculas que fueron alquiladas por mas de 8 dias
SELECT 
    f.title
FROM rental AS r
JOIN inventory AS i ON r.inventory_id = i.inventory_id
JOIN film AS f ON i.film_id = f.film_id
WHERE (r.return_date - r.rental_date) > INTERVAL '8 days';

--58.Encuentra el titulo de las peliculas que son de la misma categoria que 'Animation'
SELECT 
    f.title
FROM film AS f
JOIN film_category AS fc ON f.film_id = fc.film_id
JOIN category AS c ON fc.category_id = c.category_id
WHERE c.name = 'Animation';

--59.Encuentra los nombres de las peliculas que tienen la misma duracion que la pelicula con el titulo 'Dancing Fever'. Ordena los resultados alfabeticamente por titulo de pelicula.
SELECT 
	f.title 
FROM film
WHERE f.length = ( 
	SELECT f2.length 
	FROM film AS f2
	WHERE f2.title ILIKE 'Dancing Fever'
)
ORDER BY f.title ;

--60.Encuentra los nombres de los clientes que han alquilado al menos 7 peliculas distintas. Ordena los resultados alfabeticamente por apellido
SELECT 
    c.first_name,
    c.last_name,
    COUNT(DISTINCT f.film_id) AS peliculas_distintas
FROM customer AS c
JOIN rental AS r ON c.customer_id = r.customer_id
JOIN inventory AS i ON r.inventory_id = i.inventory_id
JOIN film AS f ON i.film_id = f.film_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT f.film_id) >= 7
ORDER BY c.last_name;

--61.Encuentra la cantidad total de peliculas alquiladas por categoria y muestra el nombre de la categoria junto con el recuento de alquileres
SELECT 
    c.name AS categoria,
    COUNT(r.rental_id) AS total_alquileres
FROM category AS c
JOIN film_category AS fc ON c.category_id = fc.category_id
JOIN film AS f ON fc.film_id = f.film_id
JOIN inventory AS i ON f.film_id = i.film_id
JOIN rental AS r ON i.inventory_id = r.inventory_id
GROUP BY c.name;

--62.Encuentra el numero de peliculas por categoria estrenadas en 2006
SELECT 
    c.name AS categoria,
    COUNT(f.film_id) AS total_peliculas
FROM category AS c
JOIN film_category AS fc ON c.category_id = fc.category_id
JOIN film AS f ON fc.film_id = f.film_id
WHERE f.release_year = 2006
GROUP BY c.name;

--63.Obtén todas las combinaciones posibles de trabajores con las tiendas que tenemos.
SELECT *
FROM staff AS s 
CROSS JOIN store AS s2 ;
--selecciono todas las columnas al no tener ninguna especificación

--64.Encuentra la cantidad total de peliculas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de peliculas alquiladas
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_peliculas_alquiladas
FROM customer AS c
LEFT JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name; 











