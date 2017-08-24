select * from ventas;
select * from pieza;
select * from proveedor;

-- 3.3 Muestra las piezas de Madrid que son grises o rojas.
select nompie from pieza where ciudad='MADRID' AND (color='GRIS' OR color='ROJO');

-- 3.4 Encontrar todos los suministros cuya cantidad está entre 200 y 300, 
-- ambos inclusive
select distinct nompie from pieza p JOIN (select codpie from ventas
                                      where cantidad >=200 AND cantidad <= 300) v
  on p.codpie=v.codpie;
  
-- 3.13 Encontrar parejas de proveedores que no viven en la misma ciudad
select p1.nompro, p1.ciudad, p2.nompro, p2.ciudad from proveedor p1, proveedor p2
  where p1.ciudad!=p2.ciudad and p1.codpro>p2.codpro;
  
  
  
  
-- Ejercicios:
-- Encontrar c�digos(1)/nombres(2) de proyectos que usan piezas fabricadas
-- en Lisboa.
select codpj
  from ventas v, pieza p
      where v.codpie=p.codpie and p.ciudad = 'LISBOA';
      
select nompj
  from ventas v, pieza p, proyecto pj
      where v.codpie=p.codpie and v.codpj=pj.codpj and p.ciudad = 'LISBOA';

-- Nombres de piezas pedidas en cantidad minima.
select nompie
  from pieza p, ventas v
    where p.codpie=v.codpie and v.cantidad = (select min(cantidad) from ventas);
    
-- Parejas de proyectos que est�n en la misma ciudad.
select pj1.nompj, pj2.nompj, pj1.ciudad
  from proyecto pj1, proyecto pj2
    where pj1.codpj > pj2.codpj and pj1.ciudad=pj2.ciudad;

-- Ventas (todas sus columnas) en las que proveedor y proyecto son de la misma 
-- ciudad.
select *
  from ventas v, proveedor p, proyecto pj
    where v.codpro = p.codpro and v.codpj = pj.codpj and
    p.ciudad = pj.ciudad;

-- Parejas de proveedores que han vendido la misma pieza.
select v1.codpro, v2.codpro
  from ventas v1, ventas v2
    where v1.codpie = v2.codpie;

-- Nombres de parejas de proveedores que han vendido la misma pieza.
select p1.nompro, p2.nompro, v1.codpie
  from ventas v1, ventas v2, proveedor p1, proveedor p2
    where v1.codpie = v2.codpie and v1.codpro>v2.codpro and 
    v1.codpro=p1.codpro and v2.codpro = p2.codpro;

-- 3.3 Muestra las piezas de Madrid que son grises o rojas
select * 
  from pieza p
    where ciudad = 'MADRID' and (color = 'GRIS' or color = 'ROJO');

-- 3.4 Encontrar todos los suministros cuya cantidad está entre 200 y 300,
-- ambos inclusive
select *
  from ventas v
    where cantidad>=200 and cantidad <=300;

-- 3.31 Mostrar la media de las cantidades vendidas por cada c�digo de pieza 
-- junto con su nombre.
select p.nompie, pv.media
  from pieza p, (select codpie, avg(cantidad) media
                    from ventas
                      group by codpie) pv
    where p.codpie = pv.codpie;

-- 3.32 Encontrar la cantidad media de ventas de la pieza 'P1' realizada por
-- cada proveedor
select codpro, avg(cantidad)
  from ventas v
      where codpie = 'P1'
        group by codpro;

-- 3.33 Encontrar la cantidad total de cada pieza enviada a cada proyecto
select codpie, codpj, sum(cantidad)
  from ventas v
    group by codpie, codpj
      order by codpie, codpj;

-- 3.35 Mostrar los nombres de proveedores tales que el total de sus ventas
-- superen la cantidad de 1000 unidades
select *
  from proveedor p
    where codpro in (select codpro 
                      from ventas 
                        group by codpro 
                          having sum(cantidad) > 1000);

-- 3.36 Mostrar para cada pieza la máxima cantidad vendida
select codpie, max(cantidad)
  from ventas
    group by codpie;
    
-- 3.38 Encontrar la media de productos suministrados cada mes
select to_char(fecha, 'mm'), avg(cantidad)
  from ventas v
    group by to_char(fecha, 'mm')
      order by to_char(fecha, 'mm');

-- 3.42 Mostrar los códigos de aquellos proveedores que hayan superado las
-- ventas totales realizadas por el proveedor 'S1'
select v1.codpro, sum(cantidad)
  from ventas v1
    group by v1.codpro
      having sum(cantidad) > (select sum(cantidad) 
                                from ventas v2 
                                  where v2.codpro = 'S1');

-- 3.43 Mostrar los mejores proveedores, entendiéndose como los que tiene 
-- mayores cantidades totales
select codpro, sum(cantidad)
  from ventas
    group by codpro
      having sum(cantidad) = (select max(cant)
                                from (select codpro, sum(cantidad) as cant
                                        from ventas
                                          group by codpro))
      order by codpro;
      
-- 3.44 Mostrar los proveedores que venden piezas fabricadas en todas las 
-- ciudades de los proyectos a los que suministra S3, sin incluirlo
select codpro
  from proveedor p1
    where NOT EXISTS(
      (select ciudad 
        from proyecto
          where codpj in (select codpj
                            from ventas
                              where codpro = 'S3'))
      minus
      (select ciudad
        from pieza
          where codpie IN (select codpie
                            from ventas v2
                              where v2.codpro = p1.codpro)));
                      
-- 3.45 Encontrar aquellos proveedores que hayan hecho al menos diez pedidos.

-- 3.49 Encontrar la cantidad media de piezas suministrada a aquellos 
-- proveedores que venden la pieza P3

-- 3.52 Mostrar para cada proveedor la media de productos suministrados cada año

-- 3.53 Encontrar todos los proveedores que venden una pieza roja

-- 3.55 Encontrar todos los proveedores tales que todas las piezas que venden
-- son rojas

-- 3.56 Encontrar el nombre de aquellos proveedores que venden más de una pieza
-- roja

-- 3.58 Coloca el status igual a 1 a quellos proveedores que solo suministran
-- la pieza P1
















    
    
    
