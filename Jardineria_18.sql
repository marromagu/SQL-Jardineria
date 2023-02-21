ALTER SESSION
SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER jardineria18 identified by jardineria18 quota 5M ON USERS;
GRANT ALL PRIVILEGES TO jardineria18;
START C:\Users\mario\Documents\0A_DAM-II\BDD\BBDD_Jardineria\jardineria 

SET LINESIZE 500;
SET PAGESIZE 500;

--Multitabla
/*1.	Sacar un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.*/
SELECT cli.NombreCliente, rv.nombre, rv.apellido1, rv.apellido2
 FROM Clientes cli INNER JOIN Empleados rv
						 ON CodigoEmpleadoRepVentas = CodigoEmpleado;
/*SELECT cli.NombreCliente, rv.nombre, rv.apellido1, rv.apellido2
	FROM Empleados rv, Clientes cli
	WHERE CodigoEmpleadoRepVentas = CodigoEmpleado;*/

/*2.	Sacar un listado con el nombre de cada cliente y el nombre de su representante y la oficina a la que pertenece dicho representante*/

SELECT cli.NombreCliente, rv.nombre, ofi.ciudad, ofi.CodigoOficina
	FROM Empleados rv INNER JOIN Clientes cli
							ON CodigoEmpleadoRepVentas = CodigoEmpleado
					  INNER JOIN  Oficinas ofi 
							ON ofi.CodigoOficina = rv.CodigoOficina;

/*SELECT cli.NombreCliente, rv.nombre, ofi.ciudad, ofi.CodigoOficina
	FROM Empleados rv, Clientes cli, Oficinas ofi
	WHERE CodigoEmpleadoRepVentas = CodigoEmpleado
	AND ofi.CodigoOficina = rv.CodigoOficina;*/

/*3.	Listar las ventas totales de los productos que hayan facturado más de 3000 euros. Se mostrará el nombre, unidades vendidas y total facturado*/
SELECT pr.CodigoProducto, pr.nombre, SUM(d.Cantidad), SUM(d.Cantidad*d.PrecioUnidad)
	FROM Productos pr INNER JOIN DetallePedidos d
							ON  pr.CodigoProducto = d.CodigoProducto
	GROUP BY pr.CodigoProducto, pr.nombre
	HAVING SUM(d.Cantidad*d.PrecioUnidad)>3000;

/*4.	Listar la dirección de las oficinas que tengan clientes en Fuenlabrada.*/
SELECT ofi.LineaDireccion1, ofi.LineaDireccion2
    FROM Clientes cli INNER JOIN Empleados emp
                        ON cli.CodigoEmpleadoRepVentas = emp.CodigoEmpleado
                    INNER JOIN Oficinas ofi
                        ON ofi.CodigoOficina = emp.CodigoOficina
    WHERE UPPER(cli.Ciudad) = UPPER('Fuenlabrada');

/*5.	Obtener un listado con los nombres de los empleados más los nombres de sus jefes*/
SELECT E.Nombre, j.nombre 
FROM Empleados E INNER JOIN Empleados J
					ON J.CodigoJefe = E.CodigoEmpleado;

/*6.	Obtener el nombre de los clientes a los que no se les ha entregados a tiempo un pedido*/
SELECT cli.NombreCliente
	FROM Clientes cli INNER JOIN Pedidos p
							ON p.CodigoCliente = cli.CodigoCliente
	WHERE  p.Estado = 'Entregado'
	AND FechaEsperada < FechaEntrega;


------------------------------------------------------------------------------------------------------------------------------------
--Funciones agrupadas

/* 7.	Obtener el código de oficina y la ciudad donde hay oficinas. */
SELECT codigoOficina, ciudad
    FROM oficinas;

/*CODIGOOFIC CIUDAD                        
---------- ------------------------------
BCN-ES     Barcelona                     
BOS-USA    Boston                        
LON-UK     Londres                       
MAD-ES     Madrid                        
PAR-FR     Paris                         
SFC-USA    San Francisco                 
SYD-AU     Sydney                        
TAL-ES     Talavera de la Reina          
TOK-JP     Tokyo                         

9 filas seleccionadas. */

/* 8.	Sacar cuántos empleados hay en la compañía */
SELECT COUNT(codigoEmpleado) AS Numero_De_Empleados
    FROM empleados;

/*NUMERO_DE_EMPLEADOS
-------------------
                 31*/

/* 9.	Sacar cuántos clientes tiene cada país */
SELECT pais, COUNT(codigoCliente)
    FROM clientes
    GROUP BY pais;

/*PAIS                                               COUNT(CODIGOCLIENTE)
-------------------------------------------------- --------------------
Spain                                                                 4
France                                                                2
USA                                                                   4
EspaÃ±a                                                              23
Australia                                                             2
United Kingdom                                                        1

6 filas seleccionadas. */

/* 10.	Sacar cuál fue el pago medio en 2009 (PISTA: usar la función YEAR de MySql) */
SELECT AVG(cantidad)
    FROM pagos
    WHERE EXTRACT(YEAR FROM FechaPago) =2009;

SELECT AVG(cantidad)
    FROM pagos
    WHERE fechaPago > '2009-01-01';

/*AVG(CANTIDAD)
-------------
   4504,07692*/


/* 11.	Sacar cuántos pedidos están en cada estado ordenado descendentemente por el número de pedido */
SELECT  COUNT(codigoPedido) AS Pedidos, estado
    FROM pedidos
    GROUP BY estado
    ORDER BY COUNT(codigoPedido) DESC;

/*   PEDIDOS ESTADO         
---------- ---------------
        55 Entregado      
        27 Pendiente      
        22 Rechazado      
         6 entregado      
         2 pendiente      
         2 rechazado      
         1 Pediente       

7 filas seleccionadas.*/

/* 12.	Sacar el precio más caro y el más barato de los productos */
SELECT MAX(precioVenta), MIN(precioVenta)
    FROM productos;

/*MAX(PRECIOVENTA) MIN(PRECIOVENTA)
---------------- ----------------
             462                1*/

/* 13.	Obtener las gamas de productos que tengan más de 100 productos  (en la tabla productos) */
SELECT gama
     FROM productos
     GROUP BY gama
     HAVING COUNT(codigoProducto) > 100;

/*GAMA                                               COUNT(CODIGOPRODUCTO)
-------------------------------------------------- ---------------------
Frutales                                                             108
Ornamentales                                                         154*/

/* 14.	Obtener el precio medio de proveedor de PRODUCTOS agrupando por proveedor de los proveedores que no empiecen por M y visualizando sólo los que la media es mayor de 15. */
SELECT AVG(precioProveedor)
    FROM productos
    WHERE proveedor NOT LIKE 'M%'
    GROUP BY proveedor
    HAVING AVG(precioProveedor) > 15;

/*AVG(PRECIOPROVEEDOR)
--------------------
          18,3986928
           16,942029
                29,9
          21,6153846*/

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Consultas variadas

/* 15.	Listado de los clientes indicando el nombre y cuántos pedidos han realizado */
SELECT c.NombreCliente, COUNT(p.CodigoPedido) AS Total_Pedidos
    FROM Pedidos p INNER JOIN Clientes c
                            ON c.CodigoCliente = p.CodigoCliente
    GROUP BY c.NombreCliente;

/* 16.	Sacar un litado con los clientes y el total pagado por cada uno de ellos */
SELECT c.NombreCliente, SUM(p.Cantidad) AS Total_Pagado
    FROM Clientes c INNER JOIN Pagos p
                            ON c.CodigoCliente = p.CodigoCliente
    GROUP BY c.NombreCliente;

/* 17.	Nombre de los clientes que hayan hecho pedidos en 2008 */
SELECT DISTINCT(c.NombreCliente)
    FROM Clientes c INNER JOIN Pedidos p
                            ON c.CodigoCliente = p.CodigoCliente
    WHERE EXTRACT(YEAR FROM p.FechaPedido) =  '2008';
/*SELECT c.NombreCliente
    FROM Clientes c INNER JOIN Pedidos p
                            ON c.CodigoCliente = p.CodigoCliente
    WHERE p.FechaPedido LIKE '%08'
    GROUP BY c.NombreCliente;
                                        MAL */

/* 18.	Listar el nombre de cliente y nombre y apellido de sus representantes de aquellos clientes que no hayan realizado pagos */
SELECT DISTINCT(c.NombreCliente), c.NombreContacto,  c.ApellidoContacto
    FROM Clientes c INNER JOIN Pagos p
                            ON c.CodigoCliente NOT IN p.CodigoCliente;--Poner una subconsulta

/* 19.	Sacar un listado de los clientes donde aparezca el nombre de su comercial y la ciudad donde está su oficina */
SELECT cli.NombreCliente, c.nombre, ofi.ciudad, ofi.CodigoOficina
	FROM Empleados c INNER JOIN Clientes cli
							ON CodigoEmpleadoRepVentas = CodigoEmpleado
					  INNER JOIN  Oficinas ofi 
							ON ofi.CodigoOficina = c.CodigoOficina;
                            -- Igual q el ejercicio 1 ?¿

/* 20.	Sacar el nombre, apellidos, oficina y cargo de aquellos empleados que no sean representantes de ventas */
SELECT e.Nombre, e.Apellido1, e.Apellido2, o.CodigoOficina, e.Puesto
    FROM Empleados e INNER JOIN Oficinas o
                            ON o.CodigoOficina = e.CodigoOficina
                    INNER JOIN Clientes c
                            ON c.CodigoEmpleadoRepVentas NOT IN e.CodigoEmpleado
    GROUP BY e.Nombre, e.Apellido1, e.Apellido2; 
    --  Error

/* 21.	Sacar cuántos empleados tiene cada oficina, mostrando el nombre de la ciudad donde está la oficina */
SELECT o.codigoOficina, o.Ciudad, COUNT(e.CodigoEmpleado)
    FROM Empleados e INNER JOIN Oficinas o
                            ON o.CodigoOficina = e.CodigoOficina
    GROUP BY  o.codigoOficina;
    

/* 22.	Sacar el nombre, apellido, oficina(ciudad) y cargo del empleado que no represente a ningún cliente */


/* 23.	Sacar la media de unidades en stock de los productos agrupados por gamas */


/* 24.	Sacar un listado de los clientes que residen en la misma ciudad donde hay oficina, indicando dónde está la oficina */


/* 25.	Sacar los clientes que residan en ciudades donde no hay oficinas ordenado por la ciudad donde residen*/

/* 26.	Sacar el número de clientes que tiene asignado cada representante de ventas */
/* 27.	Sacar el cliente que hizo el pago con mayor cuantía y el que hizo el pago con menor cuantía */
/* 28.	Sacar un listado con el precio total de cada pedido */
/* 29.	Sacar los clientes que hayan hecho pedidos en el 2008 por una cuantía superior a 2000 euros */
/* 30.	Sacar cuantos pedidos tiene cada cliente en cada estado */
/* 31.	Sacar los clientes que han pedido más de 200 unidades de cualquier producto */
