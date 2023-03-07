-- EJERCICIOS DE CONSULTAS BBDD JARDINERÍA 
-- 
-- Sobre la base da datos de jardinería:

-- 			Multitabla
-- 1.	Sacar un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.

SELECT c.NombreCliente, e.nombre NombreRepresentante, e.apellido1 Apellido1Representante
	FROM clientes c 
			INNER JOIN Empleados e ON c.CodigoEmpleadoRepVentas = e.CodigoEmpleado;

-- 2.	Sacar un listado con el nombre de cada cliente y el nombre de su representante y la oficina a la que pertenece dicho representante

SELECT c.NombreCliente, e.nombre NombreRepresentante, o.CodigoOficina, o.ciudad
	FROM Clientes c 
			INNER JOIN Empleados e ON c.CodigoEmpleadoRepVentas = e.CodigoEmpleado
			INNER JOIN Oficinas o ON e.CodigoOficina = o.CodigoOficina;

-- 3.	Listar las ventas totales de los productos que hayan facturado más de 3000 euros. Se mostrará el nombre, unidades vendidas y total facturado

SELECT p.nombre, COUNT(dp.*) unidadesVendidas, SUM(p.PrecioVenta) totalFacturado
	FROM Productos p 
			INNER JOIN DetallesPedidos dp ON p.CodigoProducto = dp.CodigoProducto
	GROUP BY p.nombre
	HAVING SUM(p.PrecioVenta) > 3000;
			

-- 4.	Listar la dirección de las oficinas que tengan clientes en Fuenlabrada.

SELECT DISTINCT o.lineaDireccion1, o.lineaDireccion2
	FROM Oficinas o
			INNER JOIN Empleados e  ON o.codigoOficina = e.codigoOficina
			INNER JOIN Clientes c 	ON e.codigoEmpleado = c.CodigoEmpleadoRepVentas
	WHERE UPPER(c.ciudad) = UPPER('Fuenlabrada');

-- 5.	Obtener un listado con los nombres de los empleados más los nombres de sus jefes

SELECT e.nombre Empleado, e.CodigoEmpleado CodigoEmpleado, j.nombre Jefe, j.CodigoEmpleado CodigoJefe
	FROM Empleados e
			INNER JOIN Empleados j  ON e.CodigoJefe = j.CodigoEmpleado;

-- 6.	Obtener el nombre de los clientes a los que no se les ha entregados a tiempo un pedido

SELECT c.NombreCliente
	FROM Clientes c 
			INNER JOIN Pedidos p 	ON c.CodigoCliente = p.CodigoCliente
	WHERE p.FechaEsperada < p.fechaEntrega;

-- 			Funciones agrupadas
-- 7.	Obtener el código de oficina y la ciudad donde hay oficinas.

SELECT o.codigoOficina, o.ciudad
	FROM Oficinas o
    GROUP BY o.codigoOficina, o.ciudad;
	
-- 8.	Sacar cuántos empleados hay en la compañía

SELECT COUNT(*) numeroEmpleados
	FROM Empleados;

-- 9.	Sacar cuántos clientes tiene cada país

SELECT c.pais, COUNT(*)
	FROM Clientes c
	GROUP BY c.pais;

-- 10.	Sacar cuál fue el pago medio en 2009 (PISTA: usar la función YEAR de MySql)

SELECT ROUND(AVG(p.cantidad))
	FROM Pagos p
	WHERE EXTRACT (YEAR FROM fechapago) = 2009;

-- 11.	Sacar cuántos pedidos están en cada estado ordenado descendentemente por el número de pedido

SELECT UPPER(p.estado), COUNT(*) Total
	FROM Pedidos p
	GROUP BY UPPER(p.estado)
	ORDER BY Total;

-- 12.	Sacar el precio más caro y el más barato de los productos

SELECT MAX(p.precioVenta) Maximo, MIN(p.precioVenta) Minimo
	FROM Productos p;
	
-- 13.	Obtener las gamas de productos que tengan más de 100 productos  (en la tabla productos)

SELECT p.gama, COUNT(*)
	FROM Productos p
	GROUP BY p.gama
	HAVING COUNT(*) > 100;

-- 14.	Obtener el precio medio de proveedor de PRODUCTOS agrupando por proveedor de los proveedores que no empiecen por M y visualizando sólo los que la media es mayor de 15. 

SELECT ROUND(AVG(p.PrecioProveedor), 2)
	FROM Productos p
	WHERE UPPER(p.proveedor) NOT LIKE 'M%'
	GROUP BY p.Proveedor
	HAVING AVG(p.PrecioProveedor) > 15;

-- 			Consultas variadas
-- 15.	Listado de los clientes indicando el nombre y cuántos pedidos han realizado

SELECT c.nombreCliente, COUNT(pe.codigoPedido) cantidad
	FROM Cliente c 
			INNER JOIN Pedidos pe 	ON c.CodigoCliente = pe.CodigoCliente
	GROUP BY c.nombreCliente;
	
-- 16.	Sacar un litado con los clientes y el total pagado por cada uno de ellos

SELECT c.nombreCliente, SUM(p.Cantidad) Total
	FROM Clientes c
			INNER JOIN Pagos p 		ON c.codigoCliente = p.codigoCliente
	GROUP BY c.nombreCliente;

-- 17.	Nombre de los clientes que hayan hecho pedidos en 2008

SELECT DISTINCT c.nombreCliente
	FROM Clientes c
			INNER JOIN Pedidos p 	ON c.codigoCliente = p.codigoCliente
	WHERE EXTRACT (YEAR FROM p.fechaPedido) = '2008';

-- 18.	Listar el nombre de cliente y nombre y apellido de sus representantes de aquellos clientes que no hayan realizado pagos

SELECT c.nombreCliente, e.nombre, e.apellido1
	FROM Clientes c
			INNER JOIN Empleados e 	ON c.CodigoEmpleadoRepVentas = e.CodigoEmpleado
			INNER JOIN Pagos p ON c.codigoCliente = p.CodigoCliente
	WHERE c.codigoCliente NOT IN (SELECT codigoCliente
										FROM pagos)

-- 19.	Sacar un listado de los clientes donde aparezca el nombre de su comercial y la ciudad donde está su oficina

SELECT c.nombreCliente, e.nombre, o.ciudad
	FROM Clientes c
			INNER JOIN Empleados e 	ON c.CodigoEmpleadoRepVentas = e.CodigoEmpleado
			INNER JOIN Oficinas o 	ON e.codigoOficina = o.CodigoOficina;

-- 20.	Sacar el nombre, apellidos, oficina y cargo de aquellos empleados que no sean representantes de ventas

SELECT e.nombre, e.apellido1, e.apellido2, e.codigoOficina, e.puesto
	FROM Empleados e 
	WHERE UPPER(e.puesto) != UPPER('Representante Ventas');

-- 21.	Sacar cuántos empleados tiene cada oficina, mostrando el nombre de la ciudad donde está la oficina

SELECT o.ciudad, COUNT(e.codigoEmpleado)
	FROM Oficinas o 
			INNER JOIN Empleados e	ON o.codigoOficina = e.codigoOficina
	GROUP BY (o.ciudad);

-- 22.	Sacar el nombre, apellido, oficina(ciudad) y cargo del empleado que no represente a ningún cliente

SELECT e.nombre, e.apellido1, o.ciudad, e.puesto
	FROM Empleados e
			INNER JOIN Oficinas o	ON e.codigoOficina = o.codigoOficina
	WHERE e.codigoEmpleado NOT IN (SELECT DISTINCT CodigoEmpleadoRepVentas
										FROM Clientes);

-- 23.	Sacar la media de unidades en stock de los productos agrupados por gamas

SELECT p.gama, ROUND(AVG(p.cantidadEnStock), 2)
	FROM Productos p
	GROUP BY p.gama;

-- 24.	Sacar un listado de los clientes que residen en la misma ciudad donde hay oficina, indicando dónde está la oficina

SELECT c.nombreCliente, c.ciudad
	FROM Clientes c
	WHERE c.ciudad IN(SELECT o.ciudad
							FROM Oficinas o);
							
-- Sacar los clientes que tienen su oficina que les atiende en donde residen 

SELECT c.nombreCliente, c.ciudad, o.ciudad
	FROM Clientes c
			INNER JOIN Empleados e	ON c.CodigoEmpleadoRepVentas = e.codigoEmpleado
			INNER JOIN Oficinas o 	ON e.codigoOficina = o.codigoOficina
	WHERE c.ciudad = o.ciudad;

-- 25.	Sacar los clientes que residan en ciudades donde no hay oficinas ordenado por la ciudad donde residen

SELECT c.nombreCliente, c.ciudad
	FROM Clientes c
	WHERE c.ciudad NOT IN (SELECT o.ciudad	
								FROM Oficinas o)
	ORDER BY c.ciudad;

-- 26.	Sacar el número de clientes que tiene asignado cada representante de ventas

SELECT e.codigoEmpleado, e.nombre, COUNT(c.codigoCliente)
	FROM Empleados e
			INNER JOIN Clientes c	ON e.codigoEmpleado = c.CodigoEmpleadoRepVentas
	GROUP BY e.codigoEmpleado, e.nombre;

-- 27.	Sacar el cliente que hizo el pago con mayor cuantía y el que hizo el pago con menor cuantía

SELECT c.nombreCliente, p.cantidad
	FROM Clientes c
			INNER JOIN Pagos p 	ON c.codigoCliente = p.codigoCliente
	WHERE p.cantidad = (SELECT MIN(cantidad)
							FROM pagos)
		OR p.cantidad = (SELECT MAX(cantidad)
							FROM pagos);

-- 28.	Sacar un listado con el precio total de cada pedido

SELECT p.codigoPedido, SUM(dp.cantidad*dp.precioUnidad)
	FROM Pedidos p
			INNER JOIN DetallePedidos dp	ON p.codigoPedido = dp.codigoPedido
	GROUP BY p.codigoPedido;

-- 29.	Sacar los clientes que hayan hecho pedidos en el 2008 por una cuantía superior a 2000 euros

SELECT c.codigoCliente, c.nombreCliente, SUM(dp.cantidad*dp.precioUnidad)
	FROM Clientes c
			INNER JOIN Pedidos p	ON c.codigoCliente = p.codigoCliente
			INNER JOIN DetallePedidos dp	ON p.codigoPedido = dp.codigoPedido
	WHERE EXTRACT (YEAR FROM p.fechaPedido) = 2008
	GROUP BY p.codigoPedido, c.codigoCliente, c.nombreCliente
	HAVING SUM(dp.cantidad*dp.precioUnidad) > 2000;

-- 30.	Sacar cuantos pedidos tiene cada cliente en cada estado

SELECT c.codigoCliente, c.nombreCliente, c.pais, COUNT(p.codigoPedido)
	FROM Clientes c
			INNER JOIN Pedidos p	ON c.codigoCliente = p.codigoCliente
	GROUP BY c.codigoCliente, c.nombreCliente, c.pais;

-- 31.	Sacar los clientes que han pedido más de 200 unidades de cualquier producto

SELECT c.codigoCliente, c.nombreCliente, SUM(dp.cantidad)
	FROM Clientes c
			INNER JOIN Pedidos p	ON c.codigoCliente = p.codigoCliente
			INNER JOIN DetallePedidos dp	ON p.codigoPedido = dp.codigoPedido
	GROUP BY c.codigoCliente, c.nombreCliente
	HAVING SUM(dp.cantidad) > 200
	ORDER BY c.codigoCliente;

-- 			Subconsultas
-- 32.	Obtener el nombre de cliente con mayor límite de crédito

SELECT c.codigoCliente, c.nombreCliente
	FROM Clientes c
	ORDER BY c.LimiteCredito DESC
	FETCH FIRST ROW ONLY;

-- 33.	Obtener el nombre, apellido1 y cargo de los empleados que no representen a ningún cliente

SELECT e.nombre, e.apellido1, e.puesto
	FROM Empleados e 
	WHERE e.codigoEmpleado NOT IN (SELECT CodigoEmpleadoRepVentas
										FROM Clientes);
		
-- 34.	Obtener el nombre del producto más caro

SELECT p.codigoProducto, p.nombre, p.precioVenta
	FROM Productos p
	ORDER BY p.precioVenta DESC
	FETCH FIRST ROW ONLY;
	
-- 35.	Obtener el nombre del producto del que más unidades se hayan vendido en un mismo pedido

SELECT pro.codigoProducto, pro.nombre, dp.cantidad
	FROM Productos pro
			INNER JOIN DetallePedidos dp	ON pro.codigoProducto = dp.codigoProducto
	WHERE dp.cantidad = (SELECT MAX(cantidad)
							FROM DetallePedidos);

	-- OTRA FORMA DE HACERLO

SELECT p.nombre,
	FROM Productos p 
	WHERE p.codigoProducto = (SELECT dp.codigoProducto
									FROM DetallePedidos dp
									WHERE dp.cantidad = (SELECT MAX(cantidad)
															FROM DetallePedidos));

-- 36.	Obtener los clientes cuya línea de crédito sea mayor que los pagos que haya realizado

SELECT c.codigoCliente, c.nombreCliente, c.limiteCredito
	FROM Clientes c
	WHERE c.limiteCredito > (SELECT SUM(cantidad)
									FROM Pagos
                                    WHERE codigoCliente = c.codigoCliente
									GROUP BY codigoCliente);

-- 37.	Sacar el producto que más unidades tiene en stock y el que menos unidades tiene en stock

SELECT MAX(p.cantidadEnStock) masUnidades, MIN(p.cantidadEnStock) minUnidades
	FROM Productos p;

-- 			Consultas Resumen
-- 38.	Obtener el código de oficina y la ciudad donde hay oficinas.

SELECT o.codigoOficina, o.ciudad
	FROM Oficinas o;

-- 39.	Sacar cuántos empleados hay en la compañía

SELECT COUNT(*)
	FROM Empleados;

-- 40.	Sacar cuántos clientes tiene cada país

SELECT c.pais, COUNT(c.codigoCliente) numeroClientes
	FROM Clientes c
	GROUP BY c.pais;

-- 41.	Sacar cuál fue el pago medio en 2009 (PISTA: usar la función YEAR de MySql)

SELECT ROUND(AVG(SUM(dp.cantidad*dp.precioUnidad)),2) PagoMedio
	FROM DetallePedidos dp
			INNER JOIN Pedidos p	ON dp.codigoPedido = p.codigoPedido
	WHERE EXTRACT (YEAR FROM p.fechaPedido) = 2009
    GROUP BY p.fechaPedido;
	
-- 42.	Sacar cuántos pedidos están en cada estado ordenado descendentemente por el número de pedido

SELECT p.Estado, COUNT(p.codigoPedido) numeroPedidos
	FROM Pedidos p
	GROUP BY UPPER(p.Estado)
	ORDER BY numeroPedidos DESC;

-- 43.	Sacar el precio más caro y el más barato de los productos

SELECT MAX(p.precioVenta) maximoPrecio, MIN(p.precioVenta) minimoPrecio
	FROM Productos p;

-- 44.	Obtener las gamas de productos que tengan más de 100 productos (en la tabla productos)

SELECT p.gama, COUNT(p.codigoProducto)
	FROM Productos p
	GROUP BY p.gama
	HAVING COUNT(p.codigoProducto) > 100;

-- 45.	Obtener el precio medio de proveedor de PRODUCTOS agrupando por proveedor de los proveedores que no empiecen por M y visualizando sólo los que la media es mayor de 15. 

SELECT ROUND(AVG(p.PrecioProveedor), 2)
	FROM Productos p
	GROUP BY p.proveedor;