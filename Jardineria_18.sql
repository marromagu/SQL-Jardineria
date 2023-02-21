ALTER SESSION
SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER jardineria18 identified by jardineria18 quota 5M ON USERS;
GRANT ALL PRIVILEGES TO jardineria18;
START C:\Users\mario\Documents\0A_DAM-II\BDD\BBDD_Jardineria\jardineria 

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
    WHERE YEAR(fechaPago) = 2009;--Error SQL: ORA-00904: "YEAR": identificador no válido

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
    GROUP BY proveedor
    HAVING proveedor NOT LIKE 'M%'
    AND AVG(precioProveedor) > 15;
/*AVG(PRECIOPROVEEDOR)
--------------------
          18,3986928
           16,942029
                29,9
          21,6153846*/