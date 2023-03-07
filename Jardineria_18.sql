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
/*
NOMBRECLIENTE                                      TOTAL_PEDIDOS
-------------------------------------------------- -------------
Flores Marivi                                                 10
Gardening Associates                                           9
Camunas Jardines S.L.                                          5
Sotogrande                                                     5
FLORES S.L.                                                    5
Beragua                                                        5
JardinerÃ­as MatÃ­as SL                                        5
Agrojardin                                                     5
Tutifruti S.A                                                  5
Jardineria Sara                                               10
DGPRODUCTIONS GARDEN                                          11
Tendo Garden                                                   5
Naturagua                                                      5
Dardena S.A.                                                   5
Golf S.A.                                                      5
El Jardin Viviente S.L                                         5
Gerudo Valley                                                  5
Jardines y Mansiones CACTUS SL                                 5
Jardin de Flores                                               5

19 filas seleccionadas. */

/* 16.	Sacar un litado con los clientes y el total pagado por cada uno de ellos */
SELECT c.NombreCliente, SUM(p.Cantidad) AS Total_Pagado
    FROM Clientes c INNER JOIN Pagos p
                            ON c.CodigoCliente = p.CodigoCliente
    GROUP BY c.NombreCliente;
/*NOMBRECLIENTE                                      TOTAL_PAGADO
-------------------------------------------------- ------------
Flores Marivi                                              4399
Gardening Associates                                      10926
Camunas Jardines S.L.                                      2246
Sotogrande                                                  272
Beragua                                                    2390
JardinerÃ­as MatÃ­as SL                                   10972
Agrojardin                                                 8489
Tutifruti S.A                                              3321
Jardineria Sara                                            7863
DGPRODUCTIONS GARDEN                                       4000
Tendo Garden                                              23794
Naturagua                                                   929
Dardena S.A.                                               4160
Golf S.A.                                                   232
El Jardin Viviente S.L                                     1171
Gerudo Valley                                             81849
Jardines y Mansiones CACTUS SL                            18846
Jardin de Flores                                          12081

18 filas seleccionadas.*/

/* 17.	Nombre de los clientes que hayan hecho pedidos en 2008 */
SELECT DISTINCT(c.NombreCliente)
    FROM Clientes c INNER JOIN Pedidos p
                            ON c.CodigoCliente = p.CodigoCliente
    WHERE EXTRACT(YEAR FROM p.FechaPedido) =  '2008';
/*NOMBRECLIENTE                                     
--------------------------------------------------
Flores Marivi
Camunas Jardines S.L.
FLORES S.L.
Tutifruti S.A
DGPRODUCTIONS GARDEN
Tendo Garden
Dardena S.A.
El Jardin Viviente S.L
Gerudo Valley
Jardines y Mansiones CACTUS SL
Jardin de Flores

11 filas seleccionadas.*/

/* 18.	Listar el nombre de cliente y nombre y apellido de sus representantes de aquellos clientes que no hayan realizado pagos */
SELECT c.NombreCliente, e.Nombre, e.Apellido1, e.Apellido2
    FROM Clientes c INNER JOIN Empleados e ON c.CodigoEmpleadoRepVentas = e.CodigoEmpleado
                    LEFT JOIN Pagos p ON c.CodigoCliente = p.CodigoCliente
    WHERE p.CodigoCliente IS NULL;
--Otra froma.
SELECT c.NombreCliente, e.Nombre, e.Apellido1, e.Apellido2
    FROM Clientes c INNER JOIN Empleados e ON c.CodigoEmpleadoRepVentas = e.CodigoEmpleado
                    
    WHERE c.CodigoCliente NOT IN(SELECT p.CodigoCliente
                                    FROM Pagos p);

/*CODIGOCLIENTE NOMBRECLIENTE                                      NOMBRE                                             APELLIDO1                                          APELLIDO2                                         
------------- -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- --------------------------------------------------
            6 Lasas S.A.                                         Mariano                                            LÃ³pez                                             Murcia                                            
            8 Club Golf Puerta del hierro                        Emmanuel                                           MagaÃ±a                                            Perez                                             
           10 DaraDistribuciones                                 Emmanuel                                           MagaÃ±a                                            Perez                                             
           11 MadrileÃ±a de riegos                               Emmanuel                                           MagaÃ±a                                            Perez                                             
           12 Lasas S.A.                                         Mariano                                            LÃ³pez                                             Murcia                                            
           17 Flowers, S.A                                       Felipe                                             Rosas                                              Marquez                                           
           18 Naturajardin                                       Julian                                             Bellinelli                                                                                           
           20 AYMERICH GOLF MANAGEMENT, SL                       JosÃ© Manuel                                       Martinez                                           De la Osa                                         
           21 Aloha                                              JosÃ© Manuel                                       Martinez                                           De la Osa                                         
           22 El Prat                                            JosÃ© Manuel                                       Martinez                                           De la Osa                                         
           24 Vivero Humanes                                     Julian                                             Bellinelli                                                                                           
           25 Fuenla City                                        Felipe                                             Rosas                                              Marquez                                           
           29 Top Campo                                          Felipe                                             Rosas                                              Marquez                                           
           31 Campohermoso                                       Julian                                             Bellinelli                                                                                           
           32 france telecom                                     Lionel                                             Narvaez                                                                                              
           33 MusÃ©e du Louvre                                   Lionel                                             Narvaez                                                                                              
           36 FLORES S.L.                                        Michael                                            Bolton                                                                                               
           37 THE MAGIC GARDEN                                   Michael                                            Bolton                                                                                               

18 filas seleccionadas. */

/* 19.	Sacar un listado de los clientes donde aparezca el nombre de su comercial y la ciudad donde está su oficina */
SELECT c.CodigoCliente, e.Nombre, o.Ciudad
    FROM Clientes c INNER JOIN Empleados e ON c.CodigoEmpleadoRepVentas = e.CodigoEmpleado
                    INNER JOIN  Oficinas o ON o.CodigoOficina = e.CodigoOficina;
/*CODIGOCLIENTE NOMBRE                                             CIUDAD                        
------------- -------------------------------------------------- ------------------------------
            1 Walter Santiago                                    San Francisco                 
            3 Walter Santiago                                    San Francisco                 
            4 Lorena                                             Boston                        
            5 Lorena                                             Boston                        
            6 Mariano                                            Madrid                        
            7 Emmanuel                                           Barcelona                     
            8 Emmanuel                                           Barcelona                     
            9 Emmanuel                                           Barcelona                     
           10 Emmanuel                                           Barcelona                     
           11 Emmanuel                                           Barcelona                     
           12 Mariano                                            Madrid                        
           13 Mariano                                            Madrid                        
           14 Mariano                                            Madrid                        
           15 Julian                                             Sydney                        
           16 Felipe                                             Talavera de la Reina          
           17 Felipe                                             Talavera de la Reina          
           18 Julian                                             Sydney                        
           19 JosÃ© Manuel                                       Barcelona                     
           20 JosÃ© Manuel                                       Barcelona                     
           21 JosÃ© Manuel                                       Barcelona                     
           22 JosÃ© Manuel                                       Barcelona                     
           23 JosÃ© Manuel                                       Barcelona                     
           24 Julian                                             Sydney                        
           25 Felipe                                             Talavera de la Reina          
           26 Lucio                                              Madrid                        
           27 Lucio                                              Madrid                        
           28 Julian                                             Sydney                        
           29 Felipe                                             Talavera de la Reina          
           30 Felipe                                             Talavera de la Reina          
           31 Julian                                             Sydney                        
           32 Lionel                                             Paris                         
           33 Lionel                                             Paris                         
           35 Mariko                                             Sydney                        
           36 Michael                                            San Francisco                 
           37 Michael                                            San Francisco                 
           38 Mariko                                             Sydney                        

36 filas seleccionadas. */

/* 20.	Sacar el nombre, apellidos, oficina y cargo de aquellos empleados que no sean representantes de ventas */
SELECT e.Nombre, e.Apellido1, e.Apellido2, e.CodigoOficina, e.Puesto
    FROM Empleados e
    WHERE e.Puesto != 'Representante Ventas';
/*NOMBRE                                             APELLIDO1                                          APELLIDO2                                          CODIGOOFIC PUESTO                                            
-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ---------- --------------------------------------------------
Marcos                                             MagaÃ±a                                            Perez                                              TAL-ES     Director General                                  
Ruben                                              LÃ³pez                                             Martinez                                           TAL-ES     Subdirector Marketing                             
Alberto                                            Soria                                              Carrasco                                           TAL-ES     Subdirector Ventas                                
Maria                                              SolÃ­s                                             Jerez                                              TAL-ES     Secretaria                                        
Carlos                                             Soria                                              Jimenez                                            MAD-ES     Director Oficina                                  
Emmanuel                                           MagaÃ±a                                            Perez                                              BCN-ES     Director Oficina                                  
Francois                                           Fignon                                                                                                PAR-FR     Director Oficina                                  
Michael                                            Bolton                                                                                                SFC-USA    Director Oficina                                  
Hilary                                             Washington                                                                                            BOS-USA    Director Oficina                                  
Nei                                                Nishikori                                                                                             TOK-JP     Director Oficina                                  
Amy                                                Johnson                                                                                               LON-UK     Director Oficina                                  
Kevin                                              Fallmer                                                                                               SYD-AU     Director Oficina                                  

12 filas seleccionadas. */

/* 21.	Sacar cuántos empleados tiene cada oficina, mostrando el nombre de la ciudad donde está la oficina */
 SELECT o.Ciudad, COUNT(e.CodigoEmpleado)
    FROM Oficinas o INNER JOIN Empleados e ON o.CodigoOficina = e.CodigoOficina
    GROUP BY o.Ciudad;
/*CIUDAD                         COUNT(E.CODIGOEMPLEADO)
------------------------------ -----------------------
Madrid                                               4
Sydney                                               3
Paris                                                3
Londres                                              3
Talavera de la Reina                                 6
Tokyo                                                3
Barcelona                                            4
Boston                                               3
San Francisco                                        2

9 filas seleccionadas. */

/* 22.	Sacar el nombre, apellido, oficina(ciudad) y cargo del empleado que no represente a ningún cliente */
SELECT e.Nombre, e.Apellido1, e.Apellido2, e.CodigoOficina, e.Puesto
    FROM Empleados e
    WHERE e.CodigoCliente NOT IN (SELECT c.CodigoEmpleadoRepVentas
                                    FROM Clientes c);
/*NOMBRE                                             APELLIDO1                                          APELLIDO2                                          CODIGOOFIC PUESTO                                            
-------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ---------- --------------------------------------------------
Marcos                                             MagaÃ±a                                            Perez                                              TAL-ES     Director General                                  
Ruben                                              LÃ³pez                                             Martinez                                           TAL-ES     Subdirector Marketing                             
Alberto                                            Soria                                              Carrasco                                           TAL-ES     Subdirector Ventas                                
Maria                                              SolÃ­s                                             Jerez                                              TAL-ES     Secretaria                                        
Juan Carlos                                        Ortiz                                              Serrano                                            TAL-ES     Representante Ventas                              
Carlos                                             Soria                                              Jimenez                                            MAD-ES     Director Oficina                                  
Hilario                                            Rodriguez                                          Huertas                                            MAD-ES     Representante Ventas                              
David                                              Palma                                              Aceituno                                           BCN-ES     Representante Ventas                              
Oscar                                              Palma                                              Aceituno                                           BCN-ES     Representante Ventas                              
Francois                                           Fignon                                                                                                PAR-FR     Director Oficina                                  
Laurent                                            Serra                                                                                                 PAR-FR     Representante Ventas                              
Hilary                                             Washington                                                                                            BOS-USA    Director Oficina                                  
Marcus                                             Paxton                                                                                                BOS-USA    Representante Ventas                              
Nei                                                Nishikori                                                                                             TOK-JP     Director Oficina                                  
Narumi                                             Riko                                                                                                  TOK-JP     Representante Ventas                              
Takuma                                             Nomura                                                                                                TOK-JP     Representante Ventas                              
Amy                                                Johnson                                                                                               LON-UK     Director Oficina                                  
Larry                                              Westfalls                                                                                             LON-UK     Representante Ventas                              
John                                               Walton                                                                                                LON-UK     Representante Ventas                              
Kevin                                              Fallmer                                                                                               SYD-AU     Director Oficina                                  

20 filas seleccionadas.*/

/* 23.	Sacar la media de unidades en stock de los productos agrupados por gamas */
SELECT AVG(p.CantidadEnStock), p.Gama
    FROM Productos
    GROUP BY p.Gama;
/*AVG(P.CANTIDADENSTOCK) GAMA                                              
---------------------- --------------------------------------------------
                   140 AromÃ¡ticas                                       
             182,12963 Frutales                                          
                    15 Herramientas                                      
            81,9285714 Ornamentales         
*/

/* 24.	Sacar un listado de los clientes que residen en la misma ciudad donde hay oficina, indicando dónde está la oficina */
SELECT c.NombreCliente, o.Ciudad
    FROM CLIENTES c INNER JOIN Empleados e ON c.CodigoEmpleadoRepVentas = e.CodigoEmpleado
                    INNER JOIN Oficinas o ON o.CodigoOficina = e.CodigoOficina
    WHERE o.Ciudad = c.ciudad;
/*NOMBRECLIENTE                                      CIUDAD                        
-------------------------------------------------- ------------------------------
DGPRODUCTIONS GARDEN                               San Francisco                 
Dardena S.A.                                       Madrid                        
AYMERICH GOLF MANAGEMENT, SL                       Barcelona                     
Jardines y Mansiones CACTUS SL                     Madrid                        
JardinerÃ­as MatÃ­as SL                            Madrid                        
france telecom                                     Paris                         
MusÃ©e du Louvre                                   Paris                         
Tutifruti S.A                                      Sydney                        
El Jardin Viviente S.L                             Sydney                        

9 filas seleccionadas.*/

/* 25.	Sacar los clientes que residan en ciudades donde no hay oficinas ordenado por la ciudad donde residen*/
SELECT c.NombreCliente, o.Ciudad
    FROM CLIENTES c INNER JOIN Empleados e ON c.CodigoEmpleadoRepVentas = e.CodigoEmpleado
                    INNER JOIN Oficinas o ON o.CodigoOficina = e.CodigoOficina
    WHERE o.Ciudad not in (SELECT ciudad
                                from clientes );
/* 26.	Sacar el número de clientes que tiene asignado cada representante de ventas */
/* 27.	Sacar el cliente que hizo el pago con mayor cuantía y el que hizo el pago con menor cuantía */
/* 28.	Sacar un listado con el precio total de cada pedido */
/* 29.	Sacar los clientes que hayan hecho pedidos en el 2008 por una cuantía superior a 2000 euros */
/* 30.	Sacar cuantos pedidos tiene cada cliente en cada estado */
/* 31.	Sacar los clientes que han pedido más de 200 unidades de cualquier producto */
