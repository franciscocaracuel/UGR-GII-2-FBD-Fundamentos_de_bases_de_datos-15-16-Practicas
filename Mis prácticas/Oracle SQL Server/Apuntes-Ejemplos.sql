/*ALTER USER x6440940 IDENTIFIED BY xxxx*/

CREATE TABLE proveedor(
	codPro char(3) constraint codPro_primary_key primary key,
	nomPro varchar2(30) constraint nomPro_not_null not null,
	status number(2) constraint status_enre_1_10 check(status>=1 AND status<=10),
	ciudad varchar2(15)
	);
  
/* Ver la estructura de la tabla*/
describe proveedor;

/* Borrar tabla proveedor */
drop table proveedor;

/* Creación del resto de tablas */
create table pieza(
	codPie char(3) constraint codPie_primary_key primary key,
	nomPie varchar2(10) constraint nomPie_not_null not null,
	color varchar2(10),
	peso number(5,2) constraint peso_entre_0_100 check(peso>0 AND peso<=100),
	ciudad varchar2(15)
);

create table proyecto(
	codPj char(3) constraint codPj_primary_key primary key,
	nomPj varchar2(20) constraint nomPj_not_null not null,
	ciudad varchar2(15)
	/* Si se quiere restringir entre posibles valores:
	ciudad varchar2(15) check(color IN (`Rojo`, `Verde`, `Blanco`))*/
);

-- Tabla Relación "Ventas"
-- Se puede poner el tipo de dato en la foreign_key o no
-- Cuando hay atributos de la tabla que tienen que cumplir conjuntamente
-- una restricción se ponen al final de la tabla
create table ventas(
	codPro /*char(3)*/ constraint codPro_foreign_key references proveedor(codPro),
	codPie /*char(3)*/ constraint codPie_foreign_key references pieza(codPie),
	codPj /*char(3)*/ constraint codPj_foreign_key references proyecto(codPj),
	cantidad number(4),
	constraint primary_key_ventas primary key(codPro, codPie, codPj)
	/*Si quisiera tener una clave externa compuesta:
	foreign key(codPro, codPie) references proveedorPieza(codPro, codPie)*/
);

-- Modificar una tabla
alter table ventas ADD(
	fecha date default sysdate
);


-- Insertar datos a la tabla
insert into proveedor values
	('S1', 'JOSE FERNANDEZ', 2, 'MADRID');
	insert into proveedor values
	('S2', 'MANUEL VIDAL', 1, 'LONDRES');
	insert into proveedor values
	('S3', 'LUISA GOMEZ', 3, 'LISBOA');
	insert into proveedor values
	('S4', 'PEDRO SANCHEZ', 4, 'PARIS');
	insert into proveedor values
	('S5', 'MARIA REYES', 5, 'ROMA');
  
-- Consulta
select * from proveedor;

-- Guardar los cambios
COMMIT;

-- Deshacer cambios hasta el commit
--ROLLBACK;

-- Insertar un número con decimales, escribe con un punto "."
insert into pieza values
	('P1', 'TUERCA', 'GRIS', 2.5, 'MADRID');
insert into pieza values
	('P2', 'TORNILLO', 'ROJO', 1.25, 'PARIS');
insert into pieza values
	('P3', 'ARANDELA', 'BLANCO', 3, 'LONDRES');
insert into pieza values
	('P4', 'CLAVO', 'GRIS', 5.5, 'LISBOA');
insert into pieza values
	('P5', 'ALCAYATA', 'BLANCO', 10, 'ROMA');
  
SELECT * FROM PIEZA;
  
INSERT INTO PROYECTO VALUES
	('J1', 'PROYECTO 1', 'LONDRES');
INSERT INTO PROYECTO VALUES
	('J2', 'PROYECTO 2', 'LONDRES');
INSERT INTO PROYECTO VALUES
	('J3', 'PROYECTO 3', 'PARIS');
INSERT INTO PROYECTO VALUES
	('J4', 'PROYECTO 4', 'ROMA');

SELECT * FROM PROYECTO;

-- Insertar desde una consulta
describe ventas;
describe opc.ventas;

select * from opc.ventas;

insert into ventas 
	(select * from opc.ventas);

select * from ventas;

COMMIT;

-- Subir un punto a la categoria de todos los proveedores
UPDATE proveedor set status=status+1;

select * from proveedor;

--rollback;

commit;

-- SELECT
SELECT NOMPIE FROM PIEZA WHERE COLOR='BLANCO';

SELECT CODPRO, CODPIE, CANTIDAD FROM VENTAS
	WHERE  CANTIDAD>3 and CODPJ='J2';


-- PRODUCTO CARTESIANO
-- NOMBRES DE PIEZAS VENDIDAS POR EL PROVEEDOR S3
SELECT NOMPIE FROM PIEZA, VENTAS 
	WHERE PIEZA.CODPIE = VENTAS.CODPIE AND CODPRO='S3';

SELECT NOMPIE FROM PIEZA 
	JOIN VENTAS ON PIEZA.CODPIE=VENTAS.CODPIE
		WHERE CODPRO='S3';
    
-- Ejercicios:
-- codigos de piezas vendidas a proyectos de londres
select distinct codpie from ventas, proyecto
	where ventas.codpj=proyecto.codpj AND ciudad='LONDRES';

-- nombres de las piezas vendidas a proyectos de londres
select nompie from pieza p, (select distinct codpie from ventas, proyecto
	where ventas.codpj=proyecto.codpj AND ciudad='LONDRES') aux
	where p.codpie=aux.codpie;

-- nombres de proveedores que han hecho ventas durante el año 2015
-- dd\mm\yy
select distinct nompro from proveedor join ventas
	on proveedor.codpro=ventas.codpro
		where fecha>'31\12\2014' AND fecha<'01\01\2016';
    
-- Nombres de proveedores. Order by
select nompro, fecha from ventas v, proveedor p
	where v.codPro=p.codPro
		order by nompro, fecha desc;
    
-- Operadores de agregación. sum, max, min, count, avd, stdden
select sum(cantidad), count(cantidad)
	from ventas;
  
-- ¿En cuántos colores tienen las piezas?
select count(distinct color)
	from pieza;
  
-- Proveedores que tienen pedidos en cantidad superior a la media
select distinct codpro
	from ventas
		where cantidad>(select avg(cantidad) from ventas);
    
-- Ver la fecha de hoy
select sysdate
	from dual;
  
-- Proveedores que han vendido piezas blancas
-- Producto cartesiano
select distinct codpro from ventas v, pieza p
	where v.codpie=p.codpie and p.color='BLANCO';
-- Subconsulta
select distinct codpro from ventas
	where codpie IN (select codpie from pieza where color='BLANCO');
  
------------------------------------ FECHAS ------------------------------------
/* Para separar fechas se pueden poner los caracteres:
- / , ; : "

Para especificar el dia se puede poner:
d   -> 1..7   -> día de la semana
dd  -> 1..31  -> día del mes
ddd -> 1..365 -> díal del año

Para especificar el mes:
mm    -> 1..12 -> 
mon   -> JAN, FEB, MAR, ..., DEC -> (o en español). 3 primeras letras
month -> ENERO, FEBRERO, ..., DICIEMBRE -> nombre completo

Para especificar el año:
yyyy  -> año con 4 dígitos
y,yyy -> año con el primer dígito separado -> 2,016

--

Se escribe en el nombre de la columna del select.

*/

-- Ejemplos:
select codpro, to_char(fecha, 'day, dd "de" month "de" yyyy') as fecha
	from ventas;
  
select codpro, to_char(fecha, 'dd/mm/yyyy') as fecha
	from ventas;
   
-- Pedidos solo de abril del 2015
select * from ventas
	where to_char(fecha, 'mm/yyyy')='04/2015';
    
--------------------------------- TO_CHAR---------------------------------------
-- Convierte todo a cadena
    
--------------------------------- TO_DATE---------------------------------------    
-- Convierte una cadena a fecha

insert into ventas values('S1', 'P5', 'J3', 200, '01/05/2016'); --> Se puede
-- introducir así la fecha porque el sistema detecta este formato de fecha.
-- Si se pusiese el año 1956 ya daría error. Es mejor no usar el formato
-- estándar.
insert into ventas values('S1', 'P5', 'J3', 200, 
	to_date('17/12/1995', 'dd/mm/yyyy')); --> Con to_date se le pone la fecha
-- en el formato que queramos y especificamos a que corresponde cada cosa.

select to_char(fecha, 'dd "de" month "de" year')
	from ventas;
  
-- Pedidos de la última semana
select * from ventas
	where fecha >= sysdate-7;
    
    
-------------------------------- ALL - ANY -------------------------------------
/*>= all
<= all
= all ??
<> all

>= any
<= any
<> any
= any */

-- Devuelve todas las cantidades mayor o igual a cantidad. Si cantidad fuese 
-- igual al máximo solo devolvería el máximo
select codpro from ventas where cantidad >= all (
	select cantidad from ventas);
  
-- Esto solo tendría sentido si todos los elementos fuesen iguales, solo puede
-- haber un valor. Si hay más diferentes no funciona.
select codpro from ventas where cantidad = all (
	select cantidad from ventas);
  
-- Idéntico a NOT IN
select codpro from ventas where cantidad <> all (
	select cantidad from ventas);
    
-- Son inútiles
select codpro from ventas where cantidad >= any (
	select cantidad from ventas);
  
select codpro from ventas where cantidad >= all (
	select cantidad from ventas);
  
-- No tiene sentido
select codpro from ventas where cantidad <> all (
	select cantidad from ventas);
  
-- Equivale al ANY
select codpro from ventas where cantidad = all (
	select cantidad from ventas);
  
-- Pedidos que superen la cantidad media de unidades
select * from ventas where cantidad > (
	select avg(cantidad) from ventas);

-- Proyectos que usan piezas de más de 2 gramos
select ventas.codpj, peso from ventas 
	right join pieza 
		on ventas.codpie = pieza.codpie 
			where ventas.codpie in (
				select codpie from pieza where peso > 2);
        
        
--------------------------------- EXISTS - NOT EXISTS --------------------------

/* Si la consula que hay entre paréntesis devuelve algún valor, EXISTS devuelve
true. Si no devuelve nada, será false. Lo que devuelve la consulta da igual,
lo importante es que devuelva algo. 
*/

-- Devuelve si algún proveedor ha vendido algo
select * from proveedor p 
where EXISTS (
  select * from ventas v where v.codpro=p.codpro);
  
-- Devuelve si algún proveedor no ha vendido algo
select * from proveedor p 
where NOT EXISTS (
  select * from ventas v where v.codpro=p.codpro);

-- La misma consulta que la anterior pero haciéndolo como se hace en álgebra
select * from proveedor where codpro in (
(select codpro from proveedor)
MINUS
(select codpro from ventas));

-- MINUS -> -
-- UNION -> UNION -> es la única operación que elimina repetidas 
-- -> UNION ALL devuelve todos
-- INTERSECT -> intersección

select * from proveedor UNION select * from proveedor;
select * from proveedor UNION ALL select * from proveedor;

---------------------------------- GROUP BY ------------------------------------
-- Se pueden poner hasta 11 niveles de agrupamiento

-- No se pueden poner elementos que no se pueden agrupar, como codpie
select codpro, avg(cantidad), max(cantidad)
  from ventas
    group by codpro;
    
-- Media de las ventas anuales
select to_char(fecha, 'yyyy') as y, avg(cantidad), sum(cantidad), count (*)
  from ventas
    group by to_char(fecha, 'yyyy')
      order by to_char(fecha, 'yyyy');
      
-- Se cogen todas las piezas que son de color blanco en las ventas anuales
select to_char(fecha, 'yyyy') as y, avg(cantidad), sum(cantidad), count (*)
  from ventas
    where codpie in (select codpie from pieza where color='BLANCO')
      group by to_char(fecha, 'yyyy')
        order by to_char(fecha, 'yyyy');

----------------------------- HAVING -------------------------------------------
-- No se puede escribir HAVING si no hay un GROUP BY

-- Poner condiciones a la tabla anterior que se ha conseguido
select to_char(fecha, 'yyyy') as y, avg(cantidad), sum(cantidad), count (*)
  from ventas
    where codpie in (select codpie from pieza where color='BLANCO')
      group by to_char(fecha, 'yyyy')
          having count(*) > 1
            order by to_char(fecha, 'yyyy');
            
-- Subconsulta con HAVING
-- La anterior con el año en el que se ha vendido más
select to_char(fecha, 'yyyy') as y, avg(cantidad), sum(cantidad), count (*)
  from ventas
    where codpie in (select codpie from pieza where color='BLANCO')
      group by to_char(fecha, 'yyyy')
          having sum(cantidad) >= ALL (select sum(cantidad) from ventas 
                                        where codpie in (
                                          select codpie from pieza 
                                            where color='BLANCO') 
                                          group by to_char(fecha, 'yyyy'))
            order by to_char(fecha, 'yyyy');
            
-- Dame las ventas totales de cada proveedor por año
-- Primero se agrupa por año y es el primero que se pone, después se agrupa por
-- codpro y es el siguiente que se pone.
select to_char(fecha, 'yyyy') as año, codpro, sum(cantidad)
  from ventas v
    group by to_char(fecha, 'yyyy'), codpro
      order by to_char(fecha, 'yyyy'), codpro;
      
-- Todos los datos de los proveedores que han vendido más de 200 unidades
select nompro, s
  from proveedor p, (select codpro, sum(cantidad) s
                      from ventas
                        group by codpro
                          having sum(cantidad) > 200) totales
    where p.codpro = totales.codpro;
    
    
----------------------------------- TODOS --------------------------------------

-- Proveedores que han vendido todas las piezas blancas
select codpro
  from proveedor pr
    where not exists ((select codpie from pieza where color='BLANCO') minus 
      (select codpie from ventas v where v.codpro=pr.codpro));

-- Proyectos de Londres que han usado todas las piezas vendidas por S3
select codpj
  from proyecto pj1
    where ciudad='LONDRES' and not exists ((select codpie
                                            from ventas v1
                                              where v1.codpro='S3') minus
                                          (select codpie
                                            from ventas v2
                                              where v2.codpj = pj1.codpj));
                                              
                                              
--------------------------------- CATÁLOGO -------------------------------------
/* El sistema tiene internamente muchas tablas para administrar todo.
xxx_tables da los datos de las tablas:
Cada tabla interna tiene 3 vistas: user_tables, all_tables, dba_tables.
-> user_tables: el usuario solo ve lo que es suyo
-> all_tables: el usuario ve todos los datos de los usuarios pero aún está muy
restringido.
-> dba_tables: solo lo ve el administrador de la plataforma. Dice quién es el
propietario de la tabla y aparece lo de todos los usuarios.

Aún faltan muchas cosas por ver, pero solo lo hace el software de Oracle

*/
describe user_tables;
select * from user_tables;
select table_name from user_tables;
select * from all_tables;
select table_name from all_tables;

-- Para ver los atributos de cada tabla
describe user_tab_columns;
select * from user_tab_columns;

-- Para ver los índices
select * from user_indexes;

-- Ver todas las condiciones de restricción
select * from user_constraints;

-- Ver todo lo que se tiene junto
select * from user_objects;

-------------------------------------- VISTAS ----------------------------------

CREATE VIEW ventas_buenas as
  (select codpro, codpie, cantidad
    from ventas
      where cantidad > 1000);
      
describe user_views;

select * from user_views;

describe all_views;

select * from all_views;

select * from ventas_buenas;

select * 
  from ventas_buenas vb, proveedor p
    where vb.codpro = p.codpro;
    
-- Crear una vista con los ventas del 2015
create view ventas_2015 (proveedor, suma, media) as (
  select codpro, sum(cantidad), avg(cantidad)
    from ventas
      where to_char(fecha, 'yyyy') = '2015'
      group by codpro);
      
select * from ventas_2015;


-- Las vistas tienen problemas para hacer INSERT, UPDATE, DELETE porque esas 
-- tablas no existen .
-- Las condiciones para que se actualicen las vistas son (mejor no hacer nada 
-- de actualización con las vistas):
  -- La vista no puede tener group by, ni max, count, avg, etc.
  -- No puede tener la cláusula distintc.
  -- No puede tener más de una tabla en el from.
  -- Las filas de la vista tienen que tener coincidencias con la fila real.
  -- Los valores de las columnas que quedan sin explicitar no pueden ser pk
  -- ni null, porque no puede dejar la restricción de integrad.
  
-- Borrar la vista

drop view ventas_2015;



-------------------------------- ÍNDICES ---------------------------------------

-- Indexar por un atributo
create index ind_prove ON proveedor(nompro);

-- ¿ Por qué no me interesa hacer el create index después del create table?
-- Cuando hace una inserción va a hacer su insert en la tabla y en el index,
-- hace esfuerzo doble.

-- Indexar por dos atributos
create index ind_prove2 ON proveedor(nompro, status);

-- La necesidad de crear un índice viene dada por:
  -- El número de veces que se consulta una tabla por un atributo. Debe tener 
  -- una buena frecuencia de consultas.
  -- Todos los atributos que tienen "unique". Cuando se hace una inserción o 
  -- modificación se consulta este atributo. Si tiene un índice se hace muy 
  -- rápido.
  -- La tabla tiene que tener muchas filas.
  
-- Borrar el índice
drop index ind_prove2;

select * from user_indexes;


-------------------------------- Clusters --------------------------------------

-- Altera la forma de almacenamiento por defecto que tiene el sistema.

-- Si más del 90% de las consultas de una tabla se hace reuniendo con otra
-- tabla, la forma de almacenamiento por defecto es mala.

-- Si una consulta tiene esa consulta conjunta, el sistema lee del mismo bloque
-- todo y es más rápido.

-- Si se cambia el clúster y se quiere hacer una consulta solo de una de esas
-- tablas se tendrá que traer tantos clústeres como tuplas de la tabla hay.

-- El clúster hay que crearlo antes que la tabla.

-- Crear un clúster:
-- El atributo que se pone debe ser un atributo comúin de las dos tablas y muy,
-- importante, el tipo de atributo de las dos tablas debe ser igual en las dos
-- y en la creación del clúster
create cluster venta_pro(codpro char(3));

-- Cuando ya está creado el cluster se crea la tabla. Se debe poner
CREATE TABLE proveedor2(
	codPro char(3) constraint codPro2_primary_key primary key,
	nomPro varchar2(30) constraint nomPro2_not_null not null,
	status number(2) constraint status2_enre_1_10 check(status>=1 AND status<=10),
	ciudad varchar2(15)
	) CLUSTER venta_pro(codpro);
  
-- Es obligatorio indexar el cluster antes de insertar nada en la tabla.
create index cluster_indx ON cluster venta_pro;

-- Borrar el cluster. Hay que tener cuidado porque se pierden las tablas
-- que están dentro.
-- Manualmente: borrar el contenido del cluster primero y luego el cluster
drop cluster venta_pro; --> daría error si hay tablas dentro.

-- Automático: borrar todo completamente
drop cluster venta_pro including tables;

-- Si nos arrepentimos del cluster y se quiere poner normal, se pueden
-- volcar los datos directamente a tablas nuevas con todas sus restricciones.
create table proveedor2 as opc.proveedor;

alter table proveedor2 rename proveedor3;



-- Dame una razón por la que montar un clúster sin saber a ciencia cierta
-- como es la frecuencia de las consultas.
-- ¿Qué tipo de entidades son propensas a montar un clúster?

-- Las entidades débiles.













