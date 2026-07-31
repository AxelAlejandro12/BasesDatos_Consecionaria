use ConsecionariaProyecto2
go

------------------------------
-----------VISTAS-------------
------------------------------

--Vista para ver ventas con precio total, con extras
CREATE VIEW venta.viscostoTotalVenta AS
SELECT 
    vv.id_venta, 
    c.nombre+' '+c.apellidoPaterno+' '+ISNULL(c.apellidoMaterno, '') AS cliente, 
    vv.costo_con_iva + ISNULL(SUM(ce.costo_con_iva),0) AS costoTotal
FROM venta.venta vv
JOIN cliente.cliente c ON c.id_cliente = vv.id_cliente
LEFT JOIN venta.extras ve ON ve.id_venta = vv.id_venta
LEFT JOIN catalogo.extras ce ON ce.id_extra = ve.id_extra
GROUP BY vv.id_venta, c.nombre, c.apellidoPaterno, c.apellidoMaterno, vv.costo_con_iva;
GO

SELECT * FROM venta.viscostoTotalVenta
GO

CREATE VIEW coche.infoCoche AS
SELECT cc.id_coche,
	   p.nombre+' '+p.apellidoPaterno+' '+ISNULL(p.apellidoMaterno, '') AS propietario,
	   cm.tipo, cm.marca, cm.modelo, cm.anio
FROM coche.coche cc
LEFT JOIN coche.propietario p ON p.id_propietario = cc.id_propietario
JOIN catalogo.modelos cm ON cm.id_modelo = cc.id_modelo;
GO

SELECT * FROM coche.infoCoche
GO

--Vista para buscar un cliente
CREATE VIEW cliente.Contacto AS
SELECT RFC_Cliente,
	   c.nombre+' '+c.apellidoPaterno+' '+ISNULL(c.apellidoMaterno, '') AS cliente,
	   corr.correo, tel.telefono
FROM cliente.cliente c
JOIN cliente.correo corr ON corr.id_cliente = c.id_cliente
JOIN cliente.telefono tel ON tel.id_cliente = c.id_cliente;
GO

SELECT * FROM cliente.Contacto
GO

------------------------------
-------PROCEDIMIENTOS---------
------------------------------

--Procedimiento para insertar una venta
CREATE PROCEDURE InsertarVenta
    @id_cliente INT,
    @id_coche INT,
    @id_plazo INT,
    @numEmpleado_agente INT,
    @costo_sin_iva DECIMAL(10, 2),
    @fecha_hora DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Iniciar transacción
        BEGIN TRANSACTION;

        -- Insertar en la tabla venta
        INSERT INTO venta.venta (id_cliente, id_coche, id_plazo, numEmpleado_agente, 
                           fecha_hora, costo_sin_iva)
        VALUES (@id_cliente, @id_coche, @id_plazo, @numEmpleado_agente, 
                @fecha_hora, @costo_sin_iva);

        -- Confirmar transacción
        COMMIT TRANSACTION;

        PRINT 'Venta registrada correctamente.';
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, se deshace la transacción
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMsg NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT 'Error al insertar la venta: ' + @ErrorMsg;
    END CATCH;
END;
GO

--Ejecucion
EXEC InsertarVenta
    @id_cliente = 1,
    @id_coche = 3,
    @id_plazo = 2,
    @numEmpleado_agente = 5,
    @costo_sin_iva = 200000.00,
    @fecha_hora = '2024-11-26';
    
--Procedimiento reporte mensual de ventas
CREATE PROCEDURE reporte_mensual_ventas (@mes INT, @año INT)
AS
BEGIN
    SELECT 
        v.id_venta,
        p.marca,
        p.modelo,
        p.anio,
        c.nombre AS cliente,
        v.costo_sin_iva,
        v.costo_con_iva
    FROM venta.venta v
    JOIN coche.coche a ON v.id_coche = a.id_coche
	JOIN catalogo.modelos p ON a.id_modelo = p.id_modelo
    JOIN cliente.cliente c ON v.id_cliente = c.id_cliente
    WHERE MONTH(v.fecha_hora) = @mes AND YEAR(v.fecha_hora) = @año
    ORDER BY v.fecha_hora;
END;

EXEC reporte_mensual_ventas @mes = 11, @año = 2024;
    
------------------------------
----------TRIGGERS------------
------------------------------

CREATE TRIGGER tr_auditoria_reparaciones
ON servicio.reparacion
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Auditoría para INSERT
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        -- Se pueden consultar los registros insertados
        SELECT 
            'INSERT' AS tipo_evento,
            i.id_reparacion,
            i.numEmpleado,
            i.tipoReparacion
        FROM inserted i;
    END;

    -- Auditoría para UPDATE
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        -- Se pueden consultar los registros actualizados
        SELECT 
            'UPDATE' AS tipo_evento,
            i.id_reparacion,
            i.numEmpleado,
            i.tipoReparacion
        FROM inserted i
        JOIN deleted d ON i.id_reparacion = d.id_reparacion
        WHERE i.id_reparacion != d.id_reparacion;
    END;

    -- Auditoría para DELETE
    IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        -- Se pueden consultar los registros eliminados
        SELECT 
            'DELETE' AS tipo_evento,
            d.id_reparacion,
            d.numEmpleado,
            d.tipoReparacion
        FROM deleted d;
    END;
END;


--falta validar los triggers con scripts aparte
--Trigger para registrar, modificar o borrar una reparación
/*
CREATE TRIGGER trgReparacion
ON servicio.reparacion
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        -- Registro o modificación
        INSERT INTO LogReparacion (id_reparacion, numEmpleado, tipoReparacion, accion, fecha)
        SELECT id_reparacion, numEmpleado, tipoReparacion, 'INSERT/UPDATE', GETDATE()
        FROM inserted;
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
    BEGIN
        -- Borrado
        INSERT INTO LogReparacion (id_reparacion, numEmpleado, tipoReparacion, accion, fecha)
        SELECT id_reparacion, numEmpleado, tipoReparacion, 'DELETE', GETDATE()
        FROM deleted;
    END
END;

-- Trigger para registrar, modificar o borrar una revisión
CREATE TRIGGER trgRevision
ON servicio.revision
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        -- Registro o modificación
        INSERT INTO LogRevision (id_revision, numEmpleado, tipoRevision, fecha_planificada, fecha_realizacion, accion, fecha)
        SELECT id_revision, numEmpleado, tipoRevision, fecha_planificada, fecha_realizacion, 'INSERT/UPDATE', GETDATE()
        FROM inserted;
    END
    ELSE IF EXISTS (SELECT * FROM deleted)
    BEGIN
        -- Borrado
        INSERT INTO LogRevision (id_revision, numEmpleado, tipoRevision, fecha_planificada, fecha_realizacion, accion, fecha)
        SELECT id_revision, numEmpleado, tipoRevision, fecha_planificada, fecha_realizacion, 'DELETE', GETDATE()
        FROM deleted;
    END
END;
*/