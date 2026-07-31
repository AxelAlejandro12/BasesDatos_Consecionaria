--a) Qué agente de ventas realiza más ventas en un periodo de tiempo
SELECT TOP 1 e.numEmpleado, e.nombre, e.apellidoPaterno, e.apellidoMaterno, COUNT(*) AS total_ventas
FROM personal.empleado e
JOIN venta.venta v ON e.numEmpleado = v.numEmpleado_agente
WHERE v.fecha_hora BETWEEN '2024-01-01' AND '2024-12-31'  -- ajusta las fechas según el periodo deseado
GROUP BY e.numEmpleado, e.nombre, e.apellidoPaterno, e.apellidoMaterno
ORDER BY total_ventas DESC;

--b) En qué época del año se realizan más ventas
SELECT DATENAME(MONTH, v.fecha_hora) AS mes, COUNT(*) AS total_ventas
FROM venta.venta v
WHERE v.fecha_hora BETWEEN '2024-01-01' AND '2024-12-31'  -- ajusta las fechas según el periodo deseado
GROUP BY DATENAME(MONTH, v.fecha_hora)
ORDER BY total_ventas DESC;

--c) Qué mecánicos realizan el mayor número de revisiones y reparaciones 
SELECT TOP 1 e.numEmpleado, e.nombre, e.apellidoPaterno, COUNT(*) AS total_revisiones_reparaciones
FROM personal.empleado e
JOIN servicio.revision s ON e.numEmpleado = s.numEmpleado
WHERE e.tipoEmpleado = 2
GROUP BY e.numEmpleado, e.nombre, e.apellidoPaterno
ORDER BY total_revisiones_reparaciones DESC;

SELECT TOP 1 e.numEmpleado, e.nombre, e.apellidoPaterno, COUNT(*) AS total_revisiones_reparaciones
FROM personal.empleado e
JOIN servicio.reparacion r ON e.numEmpleado = r.numEmpleado
WHERE e.tipoEmpleado = 2
GROUP BY e.numEmpleado, e.nombre, e.apellidoPaterno
ORDER BY total_revisiones_reparaciones DESC;

--d) Los servicios más solicitados
SELECT sv.tipoServicio, s.descripcion, COUNT(*) AS total_servicios
FROM servicio.servicio sv
JOIN catalogo.tipo_servicios s ON sv.tipoServicio = s.id_tipo_servicio
GROUP BY sv.tipoServicio, s.descripcion
ORDER BY total_servicios DESC;

--e) Los 5 vehículos más vendidos
SELECT TOP 5 c.id_modelo, COUNT(*) AS total_ventas
FROM venta.venta v
JOIN coche.coche c ON v.id_coche = c.id_coche
GROUP BY c.id_modelo
ORDER BY total_ventas DESC;

--f) Total de reparaciones y revisiones (por tipo) en un periodo de tiempo
SELECT s.tipoServicio AS tipoServicio, COUNT(*) AS total_reparaciones
FROM servicio.servicio s
JOIN catalogo.tipo_servicios r ON s.tipoServicio = r.id_tipo_servicio
WHERE s.fecha_ingreso BETWEEN '2024-01-01' AND '2024-12-31'  -- ajusta las fechas según el periodo deseado
GROUP BY s.tipoServicio
ORDER BY total_reparaciones DESC;

--g) Agente de ventas del mes
SELECT TOP 1 e.nombre + ' ' + e.apellidoPaterno + ' ' + e.apellidoMaterno AS nombre_completo, 
            COUNT(*) AS total_autos_vendidos, 
            SUM(v.costo_con_iva) AS total_monto, 
            c.correo
FROM venta.venta v
JOIN personal.empleado e ON v.numEmpleado_agente = e.numEmpleado
JOIN cliente.correo c ON v.id_cliente = c.id_cliente
WHERE v.fecha_hora BETWEEN '2024-11-01' AND '2024-11-30'  -- ajusta el mes según el periodo deseado
GROUP BY e.nombre, e.apellidoPaterno, e.apellidoMaterno, c.correo
ORDER BY total_autos_vendidos DESC;