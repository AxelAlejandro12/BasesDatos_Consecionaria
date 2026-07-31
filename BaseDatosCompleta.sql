/*

Autores:
Beltrán Garcáa Fernando Iván
Quintos Delgadillo Axel Alejandro
Jiménez Enriquez Rubén Pedro
Vela Santos Emmanuel

Fecha de entrega: 

Semestre: 2025-1

Materia: Bases de Datos

*/
------------------------------------
----------Proyecto Final------------
------------------------------------
----------Concesionaria-------------
------------------------------------

USE [master]
go
--CREACIÓN DE LA BASE DE DATOS
CREATE DATABASE ConsecionariaProyecto
go

use ConsecionariaProyecto
go

-- Procedimiento para crear usuarios y asignar roles
CREATE PROCEDURE CrearUsuariosBaseDatos
    @UsuarioConsulta NVARCHAR(50) = 'usuarioConsulta',
    @UsuarioAdmin NVARCHAR(50) = 'usuarioConcesionario',
    @UsuarioUpdate NVARCHAR(50) = 'usuarioUpdate',
    @Password NVARCHAR(50) = '1234zaq*'
AS
BEGIN
    SET NOCOUNT ON;

    -- Variable para ejecutar comandos dinámicos
    DECLARE @ConsultaSQL NVARCHAR(MAX);

    -- Crear el usuario de solo consulta
    PRINT 'Creando usuario de consulta...';
    IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = @UsuarioConsulta)
    BEGIN
        SET @ConsultaSQL =
            'CREATE LOGIN [' + @UsuarioConsulta + '] WITH PASSWORD = ''' + @Password + ''', CHECK_POLICY = ON; ' +
            'CREATE USER [' + @UsuarioConsulta + '] FOR LOGIN [' + @UsuarioConsulta + ']; ' +
            'EXEC sp_addrolemember ''db_datareader'', [' + @UsuarioConsulta + '];';
        EXEC sp_executesql @ConsultaSQL;
    END
    ELSE
        PRINT 'El usuario de consulta ya existe.';

    -- Crear el usuario administrador
    PRINT 'Creando usuario administrador...';
    IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = @UsuarioAdmin)
    BEGIN
        SET @ConsultaSQL =
            'CREATE LOGIN [' + @UsuarioAdmin + '] WITH PASSWORD = ''' + @Password + ''', CHECK_POLICY = ON; ' +
            'CREATE USER [' + @UsuarioAdmin + '] FOR LOGIN [' + @UsuarioAdmin + ']; ' +
            'EXEC sp_addrolemember ''db_owner'', [' + @UsuarioAdmin + '];';
        EXEC sp_executesql @ConsultaSQL;
    END
    ELSE
        PRINT 'El usuario administrador ya existe.';

    -- Crear el usuario para agregar y actualizar información
    PRINT 'Creando usuario para agregar y actualizar información...';
    IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = @UsuarioUpdate)
    BEGIN
        SET @ConsultaSQL =
            'CREATE LOGIN [' + @UsuarioUpdate + '] WITH PASSWORD = ''' + @Password + ''', CHECK_POLICY = ON; ' +
            'CREATE USER [' + @UsuarioUpdate + '] FOR LOGIN [' + @UsuarioUpdate + ']; ' +
            'EXEC sp_addrolemember ''db_datawriter'', [' + @UsuarioUpdate + '];';
        EXEC sp_executesql @ConsultaSQL;
    END
    ELSE
        PRINT 'El usuario para agregar y actualizar información ya existe.';

    PRINT 'Usuarios creados correctamente con los roles asignados.';
END;
GO

EXEC CrearUsuariosBaseDatos;

EXEC CrearUsuariosBaseDatos 
    @UsuarioConsulta = 'usuarioConsulta2',
    @UsuarioAdmin = 'usuarioConcesionario2',
    @UsuarioUpdate = 'usuarioUpdate2',
    @Password = '1234zaq*';

--CREACION DE ESQUEMAS
CREATE SCHEMA Catalogos;
go

CREATE SCHEMA Operaciones;
go

CREATE SCHEMA Relaciones;
go


-- CREACIÓN DE TABLAS
CREATE TABLE Operaciones.Cliente (
    RFC_Cliente CHAR(8) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidoPaterno VARCHAR(50) NOT NULL,
    apellidoMaterno VARCHAR(50),
    direccion TEXT NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    email VARCHAR(50) NOT NULL
);
--EXEC sp_rename 'Operaciones.Cliente.RFC', 'RFC_Cliente', 'COLUMN';

-- Tabla ClienteCorreo
CREATE TABLE Catalogos.ClienteCorreo (
    id_correo CHAR(8) PRIMARY KEY,
    RFC_Cliente CHAR(8) NOT NULL,
    correo VARCHAR(50) NOT NULL,
    CONSTRAINT FK_ClienteCorreo_Cliente FOREIGN KEY (RFC_Cliente) REFERENCES Operaciones.Cliente(RFC_Cliente)
);

-- Tabla ClienteTelefono
CREATE TABLE Catalogos.ClienteTelefono (
    id_telefono CHAR(8) PRIMARY KEY,
    RFC_Cliente CHAR(8) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    CONSTRAINT FK_ClienteTelefono_Cliente FOREIGN KEY (RFC_Cliente) REFERENCES Operaciones.Cliente(RFC_Cliente)
);
--Tabla propietario
CREATE TABLE Operaciones.Propietario (
    RFC_propietario CHAR(8) PRIMARY KEY,
    nombrePilaPropietario VARCHAR(50) NOT NULL,
    apellidoPaternoPropietario VARCHAR(50) NOT NULL,
    apellidoMaternoPropietario VARCHAR(50),
    estado VARCHAR (50) NOT NULL,
	numero CHAR (3) NOT NULL,
	calle VARCHAR (100) NOT NULL,
	colonia VARCHAR (100) NOT NULL,
	municipio VARCHAR (100) NOT NULL
);
--Tabla coche
CREATE TABLE Operaciones.Coche (
    id_coche CHAR(8) PRIMARY KEY,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    matricula CHAR(10) NOT NULL,
    --CONSTRAINT PROPIETARIO_COCHE FOREIGN KEY(id_coche) REFERENCES Operaciones.Propietario
);
ALTER TABLE Operaciones.Coche
add RFC_PROPIETARIO CHAR (8) NOT NULL

ALTER TABLE Operaciones.Coche
ADD CONSTRAINT PROPIETARIO_COCHE FOREIGN KEY(RFC_PROPIETARIO) REFERENCES Operaciones.Propietario(RFC_propietario)

--agregamos las columnas de servicio y numEmpleado a la tabla Operaciones.Coche
ALTER TABLE Operaciones.Coche
add id_servicio_realiza CHAR(8) NOT NULL,
    num_empleado_realiza CHAR(18) NOT NULL,
    id_servicio_tiene CHAR(8) NOT NULL,
    num_empleado_tiene CHAR(18) NOT NULL;


--Se agregan los constraints para que la tabla Operaciones.Coche reciba sus PK y FK


-- Relación con Realiza
ALTER TABLE Operaciones.Coche
ADD CONSTRAINT FK_Coche_Realiza FOREIGN KEY (id_servicio_realiza, num_empleado_realiza)
REFERENCES Relaciones.Realiza (id_Servicio, numEmpleado);

-- Relación con Tiene
ALTER TABLE Operaciones.Coche
ADD CONSTRAINT FK_Coche_Tiene FOREIGN KEY (id_servicio_tiene, num_empleado_tiene)
REFERENCES Relaciones.Tiene (id_Servicio, numEmpleado);

--Tabla Aval
CREATE TABLE Operaciones.Aval (
    id_Aval CHAR(8) PRIMARY KEY,
    nombreAvalPila VARCHAR(50) NOT NULL,
    apellidoPaternoAval VARCHAR(50) NOT NULL,
    apellidoMaternoAval VARCHAR(50),
	estado VARCHAR (60) NOT NULL,
	numero CHAR (2) NOT NULL,
    calle CHAR(2) NOT NULL,
	municipio VARCHAR(30) NOT NULL,
	colonia VARCHAR(80) NOT NULL,
	CURP CHAR(18) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    email VARCHAR(50) NOT NULL,
	CONSTRAINT FK_RFC_Cliente FOREIGN KEY (id_Aval) REFERENCES Operaciones.Cliente(RFC_Cliente)
);

--tabla ventas
CREATE TABLE Operaciones.Ventas (
    id_Venta CHAR(8) PRIMARY KEY,
    id_coche CHAR(8) NOT NULL,
	RFC_Cliente CHAR(8) NOT NULL,
    id_agenteVentas CHAR(18) NOT NULL,
    fecha DATE NOT NULL,
    montoTotal DECIMAL(10, 2) NOT NULL,
    tipoPago VARCHAR(50) NOT NULL,
    estadoVenta VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Venta_Coche FOREIGN KEY (id_coche) REFERENCES Operaciones.Coche(id_coche),
	CONSTRAINT FK_Venta_Propietario FOREIGN KEY (RFC_CLiente) REFERENCES Operaciones.Cliente(RFC_Cliente),
    CONSTRAINT FK_Venta_Agente FOREIGN KEY (id_agenteVentas) REFERENCES Operaciones.AgenteVentas(id_agenteVentas)
);

--tabla personal
CREATE TABLE Operaciones.Personal (
    numEmpleado CHAR(18) PRIMARY KEY,
    nombrePilaPersonal VARCHAR(50) NOT NULL,
    apellidoPaternoPersonal VARCHAR(50) NOT NULL,
    apellidoMaternoPersonal VARCHAR(50),
	domicilio VARCHAR (100) NOT NULL,
	fechaIngreso DATE NOT NULL,
	fechaNacimiento DATE NOT NULL,
	sueldoBase MONEY NOT NULL,
	tipoCK CHAR(20) NOT NULL,
	tipoEmpleado VARCHAR (24) NOT NULL
);
--tabla PersonalCorreo
CREATE TABLE Catalogos.PersonalCorreo (
    id_correo CHAR(8) PRIMARY KEY,
    numEmpleado CHAR(18) NOT NULL,
    correo VARCHAR(50) NOT NULL,
    CONSTRAINT FK_PersonalCorreo_Personal FOREIGN KEY (numEmpleado) REFERENCES Operaciones.Personal(numEmpleado)
);

-- Tabla PersonalTelefono
CREATE TABLE Catalogos.PersonalTelefono (
    id_telefono CHAR(8) PRIMARY KEY,
    numEmpleado CHAR(18) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    CONSTRAINT FK_PersonalTelefono_Personal FOREIGN KEY (numEmpleado) REFERENCES Operaciones.Personal(numEmpleado)
);
--tabla AgenteVentas
CREATE TABLE Operaciones.AgenteVentas (
    id_agenteVentas CHAR (18) PRIMARY KEY,
	numEmpleado CHAR(18) NOT NULL,
    comision DECIMAL(10, 2) NOT NULL,
    --CONSTRAINT FK_numEmpleado FOREIGN KEY (id_agenteVentas) REFERENCES Operaciones.Personal(numEmpleado)
);

ALTER TABLE Operaciones.AgenteVentas
ADD CONSTRAINT FK_numEmpleado FOREIGN KEY (numEmpleado) REFERENCES Operaciones.Personal(numEmpleado)
/*
ALTER TABLE Operaciones.AgenteVentas
DROP CONSTRAINT FK_numEmpleado;

drop table Operaciones.AgenteVentas

ALTER TABLE Operaciones.AgenteVentas
ADD numEmpleado CHAR(18) NOT NULL;
ALTER TABLE Operaciones.AgenteVentas
ADD CONSTRAINT PK_agenteVentas PRIMARY KEY (id_agenteVentas);
*/
--ALTER TABLE Operaciones.AgenteVentas
--DROP CONSTRAINT id_agenteVentas;

--tabla mecanico
CREATE TABLE Operaciones.Mecanico (
    id_Mecanico CHAR (18) PRIMARY KEY,
	numEmpleado CHAR(18) NOT NULL,
    escolaridad VARCHAR(20) NOT NULL,
	cursosTomados INT NOT NULL, 
    --CONSTRAINT FK_num_Empleado FOREIGN KEY (id_Mecanico) REFERENCES Operaciones.Personal(numEmpleado)
);

--modificando el constraint
ALTER TABLE Operaciones.Mecanico
DROP CONSTRAINT FK_num_Empleado

ALTER TABLE Operaciones.Mecanico
ADD CONSTRAINT FK_num_Empleado FOREIGN KEY (numEmpleado) REFERENCES Operaciones.Personal(numEmpleado)
/*
ALTER TABLE Operaciones.Mecanico
DROP CONSTRAINT FK_num_Empleado;

drop table Operaciones.Mecanico
*/

--Tabla tecnico
CREATE TABLE Operaciones.Tecnico(
id_tecnico CHAR(18) PRIMARY KEY, 
numEmpleado CHAR(18) NOT NULL, 
--CONSTRAINT FK_PERSONAL FOREIGN KEY (id_tecnico) REFERENCES  Operaciones.Personal(numEmpleado)
);
--modificando el constraint
ALTER TABLE Operaciones.Tecnico
DROP CONSTRAINT FK_PERSONAL

ALTER TABLE Operaciones.Tecnico
ADD CONSTRAINT FK_PERSONAL FOREIGN KEY (numEmpleado) REFERENCES Operaciones.Personal(numEmpleado)

--tabla servicio
CREATE TABLE Catalogos.Servicio (
    id_Servicio CHAR (8) PRIMARY KEY,
	id_coche CHAR (8) NOT NULL,
	estatus CHAR (18) NOT NULL,
	motivo CHAR (40) NOT NULL,
	tipo CHAR (30) NOT NULL,
	costo DECIMAL(2,0) NOT NULL,
	tipoCK CHAR (4) NOT NULL, 
	CONSTRAINT FK_COCHE FOREIGN KEY (id_Servicio) REFERENCES Operaciones.Coche(id_coche)  
);
--tabla revision
CREATE TABLE Operaciones.Revision (
    id_Revision CHAR(8) PRIMARY KEY,
	id_Servicio CHAR(8) NOT NULL,
    descripcion VARCHAR(90) NOT NULL,
    costo DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_Revision_Servicio FOREIGN KEY (id_Servicio) REFERENCES Catalogos.Servicio(id_Servicio)
);
--tabla reparacion
CREATE TABLE Operaciones.Reparacion (
    id_Reparacion CHAR(8) PRIMARY KEY,
	id_Servicio CHAR (8) NOT NULL,
    descripcion VARCHAR (90) NOT NULL,
    costo DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_Reparacion_Servicio FOREIGN KEY (id_Servicio) REFERENCES Catalogos.Servicio(id_Servicio)
);
--tabla realiza
CREATE TABLE Relaciones.Realiza (
    id_Servicio CHAR(8) NOT NULL,
    numEmpleado CHAR(18) NOT NULL,
    fecha DATE NOT NULL,
	costo DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_Servicio, numEmpleado),
    CONSTRAINT FK_Realiza_Reparacion FOREIGN KEY (id_Servicio) REFERENCES Operaciones.Reparacion(id_Reparacion),
    CONSTRAINT FK_Realiza_Mecanico FOREIGN KEY (numEmpleado) REFERENCES Operaciones.Mecanico(id_Mecanico)
);

--tabla tiene
CREATE TABLE Relaciones.Tiene (
    id_Servicio CHAR(8) NOT NULL,
    numEmpleado CHAR(18) NOT NULL,
    fecha DATE NOT NULL,
	costo DECIMAL (10,2) NOT NULL,
    PRIMARY KEY (id_Servicio, numEmpleado),
    CONSTRAINT FK_Tiene_Revision FOREIGN KEY (id_Servicio) REFERENCES Operaciones.Revision(id_Revision),
    CONSTRAINT FK_Tiene_Tecnico FOREIGN KEY (numEmpleado) REFERENCES Operaciones.Tecnico(id_tecnico)
);

---CREACION DE CATALOGOS

CREATE TABLE Catalogos.Extra (
    id_Extra CHAR(8) PRIMARY KEY,
    id_Venta CHAR(8) NOT NULL,
    descripcion VARCHAR(35) NOT NULL,
    CONSTRAINT FK_Extra_Venta FOREIGN KEY (id_Venta) REFERENCES Operaciones.Ventas(id_Venta)
);

-- Tabla TipoCredito
CREATE TABLE Catalogos.TipoCredito (
    id_Credito CHAR(8) PRIMARY KEY,
    plazo INT NOT NULL,
    tasaInteres DECIMAL(5, 2) NOT NULL,
    descripcion VARCHAR(25) NOT NULL,
);

-- Tabla Pago
CREATE TABLE Operaciones.Pago (
    id_Pago CHAR(8) PRIMARY KEY,
    id_Credito CHAR(8) NOT NULL,
    id_Venta CHAR(8) NOT NULL,
    montoPagado DECIMAL(10, 2) NOT NULL,
    fechaPago DATE NOT NULL,
	numTarjeta CHAR(11) NOT NULL,
	banco CHAR(39)NOT NULL,
	precioVenta MONEY NOT NULL,
	interesMnesual DECIMAL(1,0) NOT NULL,
	montoTotal DECIMAL(1,0) NOT NULL,
    CONSTRAINT FK_Pago_TipoCredito FOREIGN KEY (id_Credito) REFERENCES Catalogos.TipoCredito(id_Credito),
    CONSTRAINT FK_Pago_Venta FOREIGN KEY (id_Venta) REFERENCES Operaciones.Ventas(id_Venta)
);


-- Tabla Municipio
CREATE TABLE Catalogos.Municipio (
    id_municipio CHAR(8) PRIMARY KEY,
	id_Aval CHAR (8) NOT NULL,
	RFC_Cliente CHAR (8) NOT NULL,
    nombreMunicipio VARCHAR(50) NOT NULL,
    estado VARCHAR(50) NOT NULL
);

--añadiendo el constraint a aval, cliente y propietario
ALTER TABLE Operaciones.Aval
ADD id_municipio CHAR(8) NOT NULL

ALTER TABLE Operaciones.Aval
ADD CONSTRAINT FK_MUNICIPIO_AVAL FOREIGN KEY (id_municipio) REFERENCES Catalogos.Municipio (id_municipio)

ALTER TABLE Operaciones.Cliente
ADD id_municipio CHAR(8) NOT NULL

ALTER TABLE Operaciones.Cliente
ADD CONSTRAINT FK_MUNICIPIO_CLIENTE FOREIGN KEY (id_municipio) REFERENCES Catalogos.Municipio (id_municipio)

ALTER TABLE Operaciones.Propietario
ADD id_municipio CHAR(8) NOT NULL

ALTER TABLE Operaciones.Propietario
ADD CONSTRAINT FK_MUNICIPIO_PROPIETARIO FOREIGN KEY (id_municipio) REFERENCES Catalogos.Municipio (id_municipio)

-- Tabla ModeloAuto
CREATE TABLE Catalogos.ModeloCoche (
    id_modelo CHAR(8) PRIMARY KEY,
	id_coche CHAR (8) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    anio INT NOT NULL
	CONSTRAINT FK_MODELO FOREIGN KEY (id_coche) REFERENCES Operaciones.Coche(id_coche)
);

-- Tabla CaracteristicasAuto
CREATE TABLE Catalogos.CaracteristicasCoche (
    id_caracteristica CHAR(8) PRIMARY KEY,
	id_coche CHAR (8) NOT NULL,
    descripcion VARCHAR(50) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
	CONSTRAINT FK_CARAC FOREIGN KEY (id_coche) REFERENCES Operaciones.Coche(id_coche)
);

-- Tabla ExtrasVentas
CREATE TABLE Catalogos.ExtrasVentas (
    id_extra CHAR(8) PRIMARY KEY,
	id_Venta CHAR (8) NOT NULL, 
    descripcion VARCHAR(100) NOT NULL,
	CONSTRAINT FK_EXTRAS_VENTAS FOREIGN KEY (id_Venta) REFERENCES Operaciones.Ventas(id_Venta)
);

--Tabla Estado

CREATE TABLE Catalogos.Estado(
id_Estado CHAR (8) PRIMARY KEY,
id_Aval CHAR (8) NOT NULL,
RFC_Cliente CHAR(8) NOT NULL,
RFC_propietario CHAR(8) NOT NULL,
nombreEstado VARCHAR(25) NOT NULL, 
);

--AGREGAGANDO LOS CONSTRAINT A LAS TABLAS CLIENTE, PROPIETARIO Y AVAL

ALTER TABLE Operaciones.Cliente
ADD id_Estado CHAR(8) NOT NULL
ALTER TABLE Operaciones.Propietario
ADD id_Estado CHAR(8) NOT NULL
ALTER TABLE Operaciones.Aval
ADD id_Estado CHAR(8) NOT NULL

ALTER TABLE Operaciones.Aval
ADD CONSTRAINT FK_ESTADO_AVAL FOREIGN KEY (id_Estado) REFERENCES Catalogos.Estado (id_Estado)

ALTER TABLE Operaciones.Cliente
ADD CONSTRAINT FK_ESTADO_CLIENTE FOREIGN KEY (id_Estado) REFERENCES Catalogos.Estado (id_Estado)

ALTER TABLE Operaciones.Propietario
ADD CONSTRAINT FK_ESTADO_PROPIETARIO FOREIGN KEY (id_Estado) REFERENCES Catalogos.Estado (id_Estado)

--RELACION ENTRE ESTADO Y MUNICIPIO
ALTER TABLE Catalogos.Estado
add id_municipio CHAR (8) NOT NULL

ALTER TABLE Catalogos.Estado
ADD CONSTRAINT FK_ESTADO_MUNICIPIO FOREIGN KEY (id_municipio) REFERENCES Catalogos.Municipio (id_municipio)


---------
---DCL---
---------

-- Crear usuario para solo consulta
CREATE LOGIN usuarioConsulta WITH PASSWORD = '1234zaq*';
CREATE USER usuarioConsulta FOR LOGIN usuarioConsulta;
ALTER ROLE db_datareader ADD MEMBER usuarioConsulta;

-- Crear usuario administrador
CREATE LOGIN usuarioConcesionario WITH PASSWORD = '1234zaq*';
CREATE USER usuarioConcesionario FOR LOGIN usuarioConcesionario;
ALTER ROLE db_owner ADD MEMBER usuarioConcesionario;
GO

--  Procedimiento almacenado para insertar una venta
CREATE PROCEDURE sp_InsertarVenta
    @id_Venta CHAR(8),
    @id_coche CHAR(8),
    @RFC_Cliente CHAR(8),
    @id_agenteVentas CHAR(18),
    @fecha DATE,
    @montoTotal DECIMAL(10, 2),
    @tipoPago VARCHAR(50),
    @estadoVenta VARCHAR(20)
AS
BEGIN
    INSERT INTO Operaciones.Ventas (id_Venta, id_coche, RFC_Cliente, id_agenteVentas, fecha, montoTotal, tipoPago, estadoVenta)
    VALUES (@id_Venta, @id_coche, @RFC_Cliente, @id_agenteVentas, @fecha, @montoTotal, @tipoPago, @estadoVenta);
END;
GO

-- Registrar, modificar o borrar una reparación
-- Registrar reparación:
CREATE PROCEDURE sp_RegistrarReparacion
    @id_Reparacion CHAR(8),
    @id_Servicio CHAR(8),
    @descripcion VARCHAR(90),
    @costo DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO Operaciones.Reparacion (id_Reparacion, id_Servicio, descripcion, costo)
    VALUES (@id_Reparacion, @id_Servicio, @descripcion, @costo);
END;
GO

-- Modificar reparación:
CREATE PROCEDURE sp_ModificarReparacion
    @id_Reparacion CHAR(8),
    @descripcion VARCHAR(90),
    @costo DECIMAL(10, 2)
AS
BEGIN
    UPDATE Operaciones.Reparacion
    SET descripcion = @descripcion, costo = @costo
    WHERE id_Reparacion = @id_Reparacion;
END;
GO

-- Borrar reparación:
CREATE PROCEDURE sp_BorrarReparacion
    @id_Reparacion CHAR(8)
AS
BEGIN
    DELETE FROM Operaciones.Reparacion
    WHERE id_Reparacion = @id_Reparacion;
END;
GO

-- Registrar, modificar o borrar una revisión
-- Registrar revisión:
CREATE PROCEDURE sp_RegistrarRevision
    @id_Revision CHAR(8),
    @id_Servicio CHAR(8),
    @descripcion VARCHAR(90),
    @costo DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO Operaciones.Revision (id_Revision, id_Servicio, descripcion, costo)
    VALUES (@id_Revision, @id_Servicio, @descripcion, @costo);
END;
GO

-- Modificar revisión:
CREATE PROCEDURE sp_ModificarRevision
    @id_Revision CHAR(8),
    @descripcion VARCHAR(90),
    @costo DECIMAL(10, 2)
AS
BEGIN
    UPDATE Operaciones.Revision
    SET descripcion = @descripcion, costo = @costo
    WHERE id_Revision = @id_Revision;
END;
GO

-- Borrar revisión:
CREATE PROCEDURE sp_BorrarRevision
    @id_Revision CHAR(8)
AS
BEGIN
    DELETE FROM Operaciones.Revision
    WHERE id_Revision = @id_Revision;
END;
GO

-- Registrar una cancelación de venta
CREATE PROCEDURE sp_CancelarVenta
    @id_Venta CHAR(8)
AS
BEGIN
    UPDATE Operaciones.Ventas
    SET estadoVenta = 'Cancelada'
    WHERE id_Venta = @id_Venta;
END;
GO

--Buscar un cliente
CREATE PROCEDURE sp_BuscarCliente
    @RFC_Cliente CHAR(8)
AS
BEGIN
    SELECT *
    FROM Operaciones.Cliente
    WHERE RFC_Cliente = @RFC_Cliente;
END;
GO

-- Obtener el adeudo de un determinado cliente
CREATE PROCEDURE sp_ObtenerAdeudoCliente
    @RFC_Cliente CHAR(8)
AS
BEGIN
    SELECT SUM(precioVenta + interesMnesual - montoPagado) AS Adeudo
    FROM Operaciones.Pago
    INNER JOIN Operaciones.Ventas ON Operaciones.Pago.id_Venta = Operaciones.Ventas.id_Venta
    WHERE RFC_Cliente = @RFC_Cliente;
END;
GO

-- Eliminar un cliente
CREATE PROCEDURE sp_EliminarCliente
    @RFC_Cliente CHAR(8)
AS
BEGIN
    DELETE FROM Operaciones.Cliente
    WHERE RFC_Cliente = @RFC_Cliente;
END;
GO

------------------------
---- CARGA INICIAL -----
------------------------
use [ConsecionariaProyecto] 
go

INSERT INTO Operaciones.Personal (numEmpleado, nombrePilaPersonal, apellidoPaternoPersonal, apellidoMaternoPersonal, domicilio, fechaIngreso, fechaNacimiento, sueldoBase, tipoCK, tipoEmpleado)
VALUES 
-- Insertar 8 Mecánicos
('EMP001', 'Luis', 'Fernández', 'Ruiz', 'Av. Reforma 100', '2022-01-10', '1990-05-15', 15000.00, '1234', 'Mecánico'),
('EMP002', 'Andrea', 'Martínez', 'Gómez', 'Calle Hidalgo 20', '2021-02-12', '1988-11-23', 16000.00, '5678', 'Mecánico'),
('EMP016', 'Francisco', 'Santos', 'Martínez', 'Calle Primavera 101', '2023-04-01', '1991-02-15', 15500.00, '2011', 'Mecánico'),
('EMP017', 'Laura', 'Gómez', 'Ramírez', 'Av. Victoria 250', '2021-10-15', '1993-11-07', 15800.00, '3145', 'Mecánico'),
('EMP018', 'Raúl', 'Castillo', 'Hernández', 'Blvd. Azteca 300', '2022-03-12', '1990-01-22', 16200.00, '4152', 'Mecánico'),
('EMP019', 'Jose', 'Delgado', 'Luna', 'Calle Los Álamos 45', '2020-06-25', '1988-05-10', 16000.00, '5236', 'Mecánico'),
('EMP020', 'Roboute', 'Reyes', 'Ortiz', 'Av. Revolución 140', '2022-08-05', '1995-03-18', 16500.00, '6328', 'Mecánico'),
('EMP021', 'Roberto', 'Lozano', 'Villalobos', 'Calle Hidalgo 77', '2023-11-01', '1987-09-09', 17000.00, '7419', 'Mecánico'),

-- Técnicos
('EMP003', 'Carlos', 'Hernández', 'Pérez', 'Blvd. Benito Juárez 300', '2023-03-01', '1995-07-10', 17000.00, '9101', 'Técnico'),
('EMP004', 'María', 'López', 'Núñez', 'Av. Insurgentes 450', '2020-09-15', '1989-06-18', 18000.00, '1122', 'Técnico'),
('EMP026', 'Esteban', 'Rodríguez', 'García', 'Calle Reforma 99', '2022-05-10', '1994-01-01', 17500.00, '3015', 'Técnico'),
('EMP027', 'Gabriela', 'Sánchez', 'Medina', 'Av. Siempre Viva 120', '2023-02-15', '1993-06-25', 17200.00, '4071', 'Técnico'),
('EMP028', 'Diego', 'Pérez', 'Quintana', 'Blvd. Juárez 215', '2021-11-01', '1988-12-09', 18000.00, '5139', 'Técnico'),
('EMP029', 'Patricia', 'Nava', 'Soto', 'Calle Álamo 12', '2020-07-20', '1992-07-15', 17000.00, '6203', 'Técnico'),
('EMP030', 'Héctor', 'Villalobos', 'Ortiz', 'Av. Central 450', '2023-04-01', '1990-09-22', 17700.00, '7315', 'Técnico'),
('EMP031', 'Laura', 'Figueroa', 'Ramos', 'Blvd. Reforma 200', '2021-06-10', '1991-04-18', 17400.00, '8492', 'Técnico'),

-- Insertar 7 Agentes de Ventas
('EMP005', 'Pedro', 'Jiménez', 'Castro', 'Av. Revolución 500', '2024-04-10', '1993-02-12', 19000.00, '3344', 'AgenteVentas'),
('EMP006', 'Lucía', 'Ramos', 'Ortega', 'Calle Palma 60', '2021-05-20', '1987-03-05', 19500.00, '5566', 'AgenteVentas'),
('EMP011', 'Valeria', 'Montes', 'Rojas', 'Calle Del Sol 300', '2022-02-01', '1994-05-12', 18500.00, '6667', 'AgenteVentas'),
('EMP012', 'Daniel', 'Esquivel', 'Moreno', 'Av. Río Bravo 120', '2021-06-15', '1990-03-22', 19200.00, '7689', 'AgenteVentas'),
('EMP013', 'Fernanda', 'García', 'López', 'Calle Laurel 88', '2020-08-25', '1995-10-08', 20000.00, '8901', 'AgenteVentas'),
('EMP014', 'Javier', 'Navarro', 'Torres', 'Blvd. Nuevo León 450', '2023-01-30', '1992-07-19', 19800.00, '9087', 'AgenteVentas'),
('EMP015', 'Elena', 'Morales', 'Ramírez', 'Av. Juárez 125', '2019-05-12', '1988-11-01', 20500.00, '1023', 'AgenteVentas'),

-- Administrativos
('EMP007', 'Jorge', 'Sánchez', 'Cortés', 'Calle Principal 10', '2019-01-15', '1990-10-30', 20000.00, '7788', 'Administrativo'),
('EMP022', 'Julieta', 'Cabrera', 'Muñoz', 'Av. Insurgentes 320', '2019-04-10', '1989-12-14', 22000.00, '8520', 'Administrativo'),
('EMP023', 'Emilio', 'Sandoval', 'Ramos', 'Calle Victoria 75', '2018-07-01', '1990-08-20', 23000.00, '9631', 'Administrativo'),
('EMP024', 'Claudia', 'Moreno', 'Hernández', 'Blvd. Central 100', '2020-01-12', '1987-03-11', 21500.00, '1078', 'Administrativo'),
('EMP025', 'Fernando', 'Martínez', 'Vázquez', 'Av. Hidalgo 430', '2021-10-03', '1985-11-27', 24000.00, '2154', 'Administrativo'),
('EMP008', 'Sofía', 'Pérez', 'Quintero', 'Av. Universidad 80', '2018-06-01', '1992-12-15', 21000.00, '9900', 'Administrativo'),

-- Supervisores
('EMP009', 'Alberto', 'Vargas', 'Reyes', 'Calle 5 de Mayo 100', '2020-07-20', '1985-09-09', 22000.00, '1212', 'Supervisor'),
('EMP010', 'Gabriela', 'Torres', 'González', 'Av. Central 200', '2017-11-05', '1980-08-25', 25000.00, '3434', 'Supervisor'),
('EMP032', 'Rafael', 'Jiménez', 'Montoya', 'Calle Principal 25', '2020-03-15', '1984-02-10', 26000.00, '1111', 'Supervisor'),
('EMP033', 'Daniela', 'Torres', 'Cervantes', 'Av. López Mateos 90', '2019-08-10', '1983-05-18', 25500.00, '2222', 'Supervisor'),
('EMP034', 'Enrique', 'Gutiérrez', 'Salinas', 'Calle 16 de Septiembre 50', '2021-11-05', '1985-10-30', 27000.00, '3333', 'Supervisor'),
('EMP035', 'Carolina', 'Vargas', 'Flores', 'Av. Hidalgo 123', '2018-05-20', '1986-01-25', 26500.00, '4444', 'Supervisor');
--comprobando que se hicieron los inserts
select * from Operaciones.Personal

INSERT INTO Catalogos.Municipio (id_municipio, id_Aval, RFC_Cliente, nombreMunicipio, estado, RFC_propietario)
VALUES 
('MUN001', 'AVA001', 'CLI001', 'Puebla', 'Puebla','PRO001'),
('MUN002', 'AVA002', 'CLI002', 'Coyoacán', 'Ciudad de México','PRO002'),
('MUN003', 'AVA003', 'CLI003', 'Zapopan', 'Jalisco','PRO003'),
('MUN004', 'AVA004', 'CLI004', 'Monterrey', 'Nuevo León','PRO004'),
('MUN005', 'AVA005', 'CLI005', 'Querétaro', 'Querétaro','PRO005'),
('MUN006', 'AVA006', 'CLI006', 'Oaxaca de Juárez', 'Oaxaca','PRO006'),
('MUN007', 'AVA007', 'CLI007', 'Tijuana', 'Baja California','PRO007'),
('MUN008','AVA008','CLI008','Ecatepec','Edomex','PRO008');

--ALTER TABLE Catalogos.Municipio
--add RFC_propietario CHAR(8) NOT NULL

--comprobando inserciones
select * from Catalogos.Municipio

INSERT INTO Catalogos.Estado (id_Estado, id_Aval, RFC_Cliente, RFC_propietario, nombreEstado, id_municipio)
VALUES 
('EST001', 'AVA001', 'CLI001', 'PRO001', 'Puebla','MUN001'),
('EST002', 'AVA002', 'CLI002', 'PRO002', 'Ciudad de México','MUN002'),
('EST003', 'AVA003', 'CLI003', 'PRO003', 'Jalisco','MUN003'),
('EST004', 'AVA004', 'CLI004', 'PRO004', 'Nuevo León','MUN004'),
('EST005', 'AVA005', 'CLI005', 'PRO005', 'Querétaro','MUN005'),
('EST006', 'AVA006', 'CLI006', 'PRO006', 'Oaxaca','MUN006'),
('EST007', 'AVA007', 'CLI007', 'PRO007', 'Baja California','MUN007'),
('EST008','AVA008','CLI008','PRO008','Edomex','MUN008');

--comprobando inserciones
select * from Catalogos.Estado

--Insertando propietarios

INSERT INTO Operaciones.Propietario (RFC_propietario, nombrePilaPropietario, apellidoPaternoPropietario, apellidoMaternoPropietario, estado, numero, calle, colonia, municipio, id_municipio,id_Estado)
VALUES 
('PRO001', 'Carlos', 'Hernández', 'Rodríguez', 'Puebla', '123', 'Angelopolis', 'Centro', 'Puebla', 'MUN001','EST001'),
('PRO002', 'Marta', 'Jiménez', 'López', 'Ciudad de Mexico', '456', 'Reforma', 'La Paz', 'Coyoacan', 'MUN002','EST002'),
('PRO003', 'Luis', 'Mendoza', 'Ortiz', 'Jalisco', '789', 'Juárez', 'Providencia', 'Zapopan', 'MUN003','EST003'),
('PRO004', 'Sofía', 'García', 'Núñez', 'Nuevo Leon', '321', 'Obispado', 'Independencia', 'Monterrey', 'MUN004','EST004'),
('PRO005', 'Daniel', 'Núñez', 'Guzmán', 'Queretaro', '987', 'Madero', 'Centro', 'Queretaro', 'MUN005','EST005'),
('PRO006', 'Carolina', 'Flores', 'Vargas', 'Oaxaca', '741', 'Allende', 'Las Rosas', 'Oaxaca de Juarez', 'MUN006','EST006'),
('PRO007', 'Javier', 'Ramos', 'Torres', 'Baja California', '654', 'Constituyentes', 'Centro Histórico', 'Tijuana', 'MUN007','EST007'),
('PRO008','Josue','Ramirez','Magon','Edomex','430','Rosales','Tal vez','Ecatepec', 'MUN008','EST008');

--corroborando los inserts
select * from Operaciones.Propietario

--llenando la tabla Operaciones.Cliente
INSERT INTO Operaciones.Cliente (RFC_Cliente, nombre, apellidoPaterno, apellidoMaterno, direccion, telefono, email, id_municipio, id_Estado, municipio)
VALUES 
('CLI001', 'Juan', 'Pérez', 'Gómez', 'Calle Falsa 123', '5551234567', 'juan.perez@example.com','MUN001','EST001','Puebla'),
('CLI002', 'Ana', 'López', 'Martínez', 'Av. Siempre Viva 456', '5557654321', 'ana.lopez@example.com','MUN002','EST002','Coyoacán'),
('CLI003', 'Pedro', 'García', 'Hernández', 'Bosques 987', '5556789123', 'pedro.garcia@example.com','MUN003','EST003','Zapopan'),
('CLI004', 'Laura', 'Santos', 'Ramírez', 'Calle Primavera 202', '5558765432', 'laura.santos@example.com','MUN004','EST004','Monterrey'),
('CLI005', 'Diego', 'Mendoza', 'Quintana', 'Av. Hidalgo 50', '5557891234', 'diego.mendoza@example.com','MUN005','EST005','Querétaro'),
('CLI006', 'Gabriela', 'González', 'Navarro', 'Av. Constitución 89', '5553214567', 'gabriela.gonzalez@example.com','MUN006','EST006','Oaxaca de Juárez'),
('CLI007', 'Miguel', 'Jiménez', 'Soto', 'Blvd. Reforma 145', '5556547890', 'miguel.jimenez@example.com','MUN007','EST007','Tijuana'),
('CLI008','Ricardo','Novoa','Jimenez','Imperium','55938320','richi@example.com','MUN008','EST008','Ecatepec');

--alter table Operaciones.Cliente
--add municipio CHAR(50) NOT NULL

--comprobando los inserts
select * from Operaciones.Cliente


--llenando la tabla Operaciones.Aval

INSERT INTO Operaciones.Aval (id_Aval, nombreAvalPila, apellidoPaternoAval, apellidoMaternoAval, estado, numero, calle, colonia, CURP, telefono, email, nombreMunicipio, id_municipio, id_Estado, RFC_Cliente)
VALUES 
('AVA001', 'María', 'López', 'Martínez', 'Puebla', '21', 'Benito Juárez', 'Centro', 'LOPM880123HPLMRR01', '5559876543', 'maria.lopez@example.com',  'Puebla', 'MUN001', 'EST001','CLI001'),
('AVA002', 'Pedro', 'Sánchez', 'Gómez', 'Ciudad de México', '32', 'Reforma', 'Del Valle', 'SNGP900511HPLRZN02', '5551234567', 'pedro.sanchez@example.com', 'Coyoacán','MUN002', 'EST002','CLI002'),
('AVA003', 'Lucía', 'Fernández', 'Pérez', 'Guadalajara', '45', 'Juárez', 'Providencia', 'FERL920710HPLQZR03', '5557654321', 'lucia.fernandez@example.com', 'Zapopan', 'MUN003', 'EST003','CLI003'),
('AVA004', 'Andrés', 'Martínez', 'Luna', 'Monterrey', '50', 'Obispado',  'Independencia', 'MRTL851224HPLMRN04', '5556789123', 'andres.martinez@example.com', 'Monterrey', 'MUN004', 'EST004','CLI004'),
('AVA005', 'Claudia', 'Ramírez', 'Hernández', 'Querétaro', '60', 'Constituyentes', 'Centro Histórico', 'RMHC890102HPLMRZ05', '5558765432', 'claudia.ramirez@example.com', 'Querétaro', 'MUN005', 'EST005','CLI005'),
('AVA006', 'Isabel', 'Hernández', 'Cruz', 'Oaxaca', '70', 'Margaritas', 'La Noria', 'HECI920523HPLMRZ06', '5556543210', 'isabel.hernandez@example.com', 'Oaxaca de Juárez', 'MUN006', 'EST006', 'CLI006'),
('AVA007', 'Roberto', 'Cortés', 'Mejía', 'Tijuana', '98', 'Tulum','Zona Río', 'CORM890607HPLMRT07', '5554321098', 'roberto.cortes@example.com',  'Tijuana', 'MUN007', 'EST007','CLI007'),
('AVA008', 'Ricardo', 'Novoa', 'Jiménez', 'Estado de México', '80', 'Ni idea', 'Jardines', 'NOVR940305HPLMRC08', '5593832020', 'ricardo.novoa@example.com', 'Ecatepec',  'MUN008', 'EST008','CLI008');

--corrigiendo errores en la creacion de la tabla Operaciones.Aval
--se olvido de agregar la columna RFC_Cliente que va a recibir la PK DE Operaciones.Cliente
alter table Operaciones.Aval
add RFC_Cliente CHAR(8) NOT NULL
--se agrega el constraint a la tabla Operaciones.Aval
ALTER TABLE Operaciones.Aval
add CONSTRAINT FK_RFC_CLIENTE FOREIGN KEY (RFC_Cliente) REFERENCES Operaciones.Cliente (RFC_Cliente)

--cambiando la extencion del char de la columna calle
alter table Operaciones.Aval
alter column calle CHAR(20) NOT NULL

--comprobando los inserts despues de las correcciones
select * from Operaciones.Aval

-- Insertar 10 Autos
INSERT INTO Operaciones.Coche (id_coche, marca, modelo, matricula, RFC_PROPIETARIO, id_servicio_realiza, num_empleado_realiza, id_servicio_tiene, num_empleado_tiene)
VALUES
('AUTO0001', 'Toyota', 'Corolla', 'ABC123DEF', 'PRO001', 'SERV0001', 'EMP001', 'SERV0006', 'EMP003'),
('AUTO0002', 'Honda', 'Civic', 'BCD234EFG', 'PRO002', 'SERV0002', 'EMP002', 'SERV0007', 'EMP004'),
('AUTO0003', 'Ford', 'Focus', 'CDE345FGH', 'PRO003', 'SERV0003', 'EMP0016', 'SERV0008', 'EMP0026'),
('AUTO0004', 'Mazda', 'Sedan', 'DEF456GHI', 'PRO004', 'SERV0004', 'EMP0020', 'SERV0009', 'EMP0028'),
('AUTO0005', 'Nissan', 'Altima', 'EFG567HIJ', 'PRO005', 'SERV0003', 'EMP0021', 'SERV0010', 'EMP030'),
('AUTO0006', 'Chevrolet', 'Malibu', 'FGH678IJK', 'PRO006', 'SERV0006', 'EMP001', 'SERV0001', 'EMP003'),
('AUTO0007', 'Volkswagen', 'Jetta', 'GHI789JKL', 'PRO007', 'SERV0001', 'EMP002', 'SERV0002', 'EMP0027'),
('AUTO0008', 'Hyundai', 'Elantra', 'HIJ890KLM', 'PRO008', 'SERV0008', 'EMP0018', 'SERV0003', 'EMP004'),
('AUTO0009', 'Kia', 'Optima', 'IJK901LMN', 'PRO001', 'SERV0009', 'EMP0017', 'SERV0009', 'EMP0028'),
('AUTO0010', 'Subaru', 'Impreza', 'JKL012MNO', 'PRO005', 'SERV0010', 'EMP0019', 'SERV0007', 'EMP031');

select * from Operaciones.Personal
where tipoEmpleado ='Mecánico'
-- 
INSERT INTO Operaciones.AgenteVentas (id_agenteVentas, numEmpleado, comision)
VALUES
('AGV0001', 'EMP005', 400.00),
('AGV0002', 'EMP006', 600.00),
('AGV0003', 'EMP011', 400.80),
('AGV0004', 'EMP012', 500.20),
('AGV0005', 'EMP013', 400.50),
('AGV0006', 'EMP014', 600.50),
('AGV0007', 'EMP015', 500.70);

--comprobamos los insert
select * from Operaciones.AgenteVentas

INSERT INTO Operaciones.Mecanico (id_Mecanico, numEmpleado, escolaridad, cursosTomados)
VALUES
('MEC0001', 'EMP001', 'Bachillerato', 5),
('MEC0002', 'EMP002', 'Superior', 3),
('MEC0003', 'EMP016', 'Pirmaria', 7),
('MEC0004', 'EMP017', 'Técnico', 4),
('MEC0005', 'EMP018', 'Superior', 6),
('MEC0006', 'EMP019', 'Técnico', 2),
('MEC0007', 'EMP020', 'Superior', 8),
('MEC0008', 'EMP021', 'Técnico', 5);
--comprobamos los inserts
select * from Operaciones.Mecanico

INSERT INTO Operaciones.Tecnico (id_tecnico, numEmpleado)
VALUES
('TEC0001', 'EMP003' ),
('TEC0002', 'EMP004' ),
('TEC0003', 'EMP026' ),
('TEC0004', 'EMP027' ),
('TEC0005', 'EMP028' ),
('TEC0006', 'EMP029'),
('TEC0007', 'EMP030'),
('TEC0008', 'EMP031');
--comprobamos
select * from Operaciones.Tecnico


-- Insertar 10 Servicios
INSERT INTO Catalogos.Servicio (id_Servicio, estatus, motivo, tipo, costo, tipoCK)
VALUES
('SERV0001','Activo', 'Mantenimiento', 'Preventivo', 1500.00, 'CK01'),
('SERV0002', 'Activo', 'Reparación', 'Correctivo', 2500.00, 'CK02'),
('SERV0003',  'Finalizado', 'Revisión', 'Diagnóstico', 1000.00, 'CK03'),
('SERV0004',  'Activo', 'Cambio de aceite', 'Preventivo', 1200.00, 'CK04'),
('SERV0005', 'Activo', 'Frenos', 'Correctivo', 2000.00, 'CK05'),
('SERV0006', 'Finalizado', 'Suspensión', 'Correctivo', 3000.00, 'CK06'),
('SERV0007', 'Activo', 'Alineación', 'Diagnóstico', 1000.00, 'CK07'),
('SERV0008', 'Finalizado', 'Llantas', 'Preventivo', 1800.00, 'CK08'),
('SERV0009',  'Activo', 'Electrónica', 'Correctivo', 4000.00, 'CK09'),
('SERV0010',  'Activo', 'Motor', 'Diagnóstico', 5000.00, 'CK10');

ALTER TABLE Catalogos.Servicio
drop column id_coche-- FOREIGN KEY (id_coche) REFERENCES Operaciones.Coche (id_coche)
ALTER TABLE Catalogos.Servicio
ALTER COLUMN costo DECIMAL(10,2)

--comporbamos los insert
select * from Catalogos.Servicio

INSERT INTO Relaciones.Realiza (id_Servicio, numEmpleado, fecha, costo)
VALUES 
('SERV0001', 'MEC9001', '2024-11-10', 2500.00),
('SERV0002', 'MEC0002', '2024-11-11', 2000.00),
('SERV0003', 'MEC0003', '2024-11-12', 3000.00),
('SERV0004', 'MEC0004', '2024-11-13', 1800.00),
('SERV0006', 'MEC0005', '2024-11-14', 3500.00),
('SERV0008', 'MEC006', '2024-11-15', 2200.00),
('SERV0009', 'MEC0007', '2024-11-16', 2700.00),
('SERV0010', 'MEC0008', '2024-11-17', 1800.00);

select * from Relaciones.Realiza

INSERT INTO Relaciones.Tiene(id_Servicio, numEmpleado, fecha, costo, id_Revision, id_tecnico)
VALUES 
('SERV0001','EMP003',  '2024-11-10', 2500.00,'REV0001','TEC0001'),
('SERV0004', 'EMP004','2024-11-11', 2000.00,'REV0004', 'TEC0002'),
('SERV0002', 'EMP026','2024-11-12', 3000.00,'REV0002', 'TEC0003'),
('SERV0003', 'EMP027','2024-11-13', 1800.00,'REV0003', 'TEC0004'),
('SERV0006', 'EMP028','2024-11-14', 3500.00,'REV0006', 'TEC0005'),
('SERV0009', 'EMP029','2024-11-15', 2200.00,'REV0009', 'TEC0006'),
('SERV0006', 'EMP030','2024-11-16', 2700.00,'REV0006', 'TEC0007'),
('SERV0010', 'EMP031','2024-11-17', 1800.00,'REV0010', 'TEC0008');

alter table Relaciones.Tiene
add id_Revision CHAR (8) NOT NULL
alter table Relaciones.Tiene
add CONSTRAINT FK_Tiene_Revision FOREIGN KEY (id_Revision) REFERENCES Operaciones.Revision (id_Revision)

alter table Relaciones.Tiene
add id_tecnico CHAR (18) NOT NULL
alter table Relaciones.Tiene
add CONSTRAINT FK_Tiene_Tecnico FOREIGN KEY (id_tecnico) REFERENCES Operaciones.Tecnico (id_tecnico)
--comprobando los inserts 
select *from Relaciones.Tiene

-- Insertar 10 Tipos de Revisiones
INSERT INTO Operaciones.Revision (id_Revision, id_Servicio, descripcion, costo)
VALUES
('REV0001', 'SERV0001', 'Revisión general', 1000),
('REV0002', 'SERV0002', 'Cambio de pastillas', 800),
('REV0003', 'SERV0003', 'Chequeo de frenos', 900),
('REV0004', 'SERV0004', 'Ajuste de motor', 1500),
('REV0005', 'SERV0005', 'Inspección de suspensión', 1200),
('REV0006', 'SERV0006', 'Prueba de emisiones', 700),
('REV0007', 'SERV0007', 'Cambio de filtros', 500),
('REV0008', 'SERV0008', 'Balanceo', 600),
('REV0009', 'SERV0009', 'Diagnóstico de batería', 400),
('REV0010', 'SERV0010', 'Alineación', 450);
--comprobamos los inserts
select * from Operaciones.Revision

INSERT INTO Operaciones.Coche (id_coche, marca, modelo, matricula, RFC_PROPIETARIO, id_servicio_realiza, num_empleado_realiza, id_servicio_tiene, num_empleado_tiene)
VALUES
('AUTO0001', 'Toyota', 'Corolla', 'ABC123DEF', 'PRO001','SERV0001','EMP001','SERV0001','EMP003'),
('AUTO0002', 'Honda', 'Civic', 'BCD234EFG', 'PRO002', 'SERV0002','EMP016','SERV0002','EMP026'),
('AUTO0003', 'Ford', 'Focus', 'CDE345FGH', 'PRO003', 'SERV0003','EMP017','SERV0003','EMP027'),
('AUTO0004', 'Mazda', 'Sedan', 'DEF456GHI', 'PRO004', 'SERV0004','EMP002' ,'SERV0010','EMP031'),
('AUTO0005', 'Nissan', 'Altima', 'EFG567HIJ', 'PRO005', 'SERV0006','EMP001','SERV0003','EMP027'),
('AUTO0006', 'Chevrolet', 'Malibu', 'FGH678IJK', 'PRO006','SERV0006','EMP017','SERV0010','EMP031' ),
('AUTO0007', 'Volkswagen', 'Jetta', 'GHI789JKL', 'PRO007','SERV0009','EMP021' ,'SERV0009','EMP029'),
('AUTO0008', 'Hyundai', 'Elantra', 'HIJ890KLM', 'PRO008','SERV00010','EMP019','SERV0001','EMP003' ),
('AUTO0009', 'Kia', 'Optima', 'IJK901LMN', 'PRO001', 'SERV0001','EMP016','SERV0004','EMP004'),
('AUTO0010', 'Subaru', 'Impreza', 'JKL012MNO', 'PRO005','SERV0003','EMP002','SERV0002','EMP026' );

-- Insertar 10 Reparaciones
INSERT INTO Operaciones.Reparacion (id_Reparacion, id_Servicio, descripcion, costo)
VALUES
('REP0001', 'SERV0001', 'Reparación de motor', 2500),
('REP0002', 'SERV0002', 'Cambio de transmisión', 3000),
('REP0003', 'SERV0003', 'Arreglo de suspensión', 2000),
('REP0004', 'SERV0004', 'Reparación de frenos', 1500),
('REP0005', 'SERV0005', 'Diagnóstico de fallos', 1200),
('REP0006', 'SERV0006', 'Reparación de luces', 800),
('REP0007', 'SERV0007', 'Revisión de cables', 1000),
('REP0008', 'SERV0008', 'Cambio de inyectores', 2200),
('REP0009', 'SERV0009', 'Reparación de batería', 1100),
('REP0010', 'SERV0010', 'Reparación de alternador', 2700);

--COMPROBAMOS

select * from Operaciones.Reparacion



--falta llenar las tablas ventas, caracteristicas del coche, pago, tipo credito y extras ventas


----------------------------------------------------------------Nuevo DDL---------------------------------------------------------

/*

Autores:
Beltrán Garcáa Fernando Iván
Quintos Delgadillo Axel Alejandro
Jiménez Enriquez Rubén Pedro
Vela Santos Emmanuel

Fecha de entrega: 

Semestre: 2025-1

Materia: Bases de Datos

*/
------------------------------------
----------Proyecto Final------------
------------------------------------
----------Concesionaria-------------
------------------------------------

USE [master]
go
--CREACIÓN DE LA BASE DE DATOS
CREATE DATABASE ConsecionariaProyecto2
go

use ConsecionariaProyecto2
go
--CREACION DE ESQUEMAS
CREATE SCHEMA catalogo;
go

CREATE SCHEMA personal;
go

CREATE SCHEMA cliente;
go

CREATE SCHEMA coche;
go

CREATE SCHEMA servicio;
go

CREATE SCHEMA venta;
go

-- CREACIÓN DE TABLAS
CREATE TABLE cliente.cliente (
	id_cliente SMALLINT IDENTITY (1,1),
    RFC_Cliente CHAR(8) NOT NULL CONSTRAINT ak_rfc_cliente UNIQUE,
    nombre VARCHAR(50) NOT NULL,
    apellidoPaterno VARCHAR(50) NOT NULL,
    apellidoMaterno VARCHAR(50),
	curp VARCHAR(18) NOT NULL CONSTRAINT ak_curp_cliente UNIQUE,
	genero CHAR(1) NOT NULL CONSTRAINT ck_genero CHECK (genero in ('F', 'M', 'X')),
	fecha_nacimiento DATE,
	calle VARCHAR(20)  NOT NULL,
	numero SMALLINT  NOT NULL,
	colonia VARCHAR(20)  NOT NULL,
	municipio VARCHAR(20)  NOT NULL,
	estado VARCHAR(20)  NOT NULL,
	CONSTRAINT pk_cliente PRIMARY KEY CLUSTERED (id_cliente)
);

/*CREATE TABLE cliente.domicilio (
	id_domicilio SMALLINT IDENTITY (1,1),
	id_cliente SMALLINT  NOT NULL,
	calle VARCHAR(20)  NOT NULL,
	numero SMALLINT  NOT NULL,
	colonia VARCHAR(20)  NOT NULL,
	municipio VARCHAR(20)  NOT NULL,
	estado VARCHAR(20)  NOT NULL,
	CONSTRAINT pk_cliente_domicilio PRIMARY KEY CLUSTERED (id_domicilio),
	CONSTRAINT FK_cliente_domicilio FOREIGN KEY (id_cliente) REFERENCES cliente.cliente(id_cliente)
);*/

-- Tabla ClienteCorreo
CREATE TABLE cliente.correo (
    id_correo SMALLINT IDENTITY (1,1),
    id_cliente SMALLINT NOT NULL,
    correo VARCHAR(50) NOT NULL,
	CONSTRAINT ak_cliente_correo UNIQUE (id_cliente,correo),
	CONSTRAINT pk_cliente_correo PRIMARY KEY CLUSTERED (id_correo),
    CONSTRAINT FK_ClienteCorreo FOREIGN KEY (id_cliente) REFERENCES cliente.cliente(id_cliente)
);

-- Tabla ClienteTelefono
CREATE TABLE cliente.telefono (
    id_telefono SMALLINT IDENTITY (1,1),
	id_cliente SMALLINT NOT NULL,
    telefono CHAR(10) NOT NULL CONSTRAINT ck_telefono_cliente CHECK (telefono LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' ),
	CONSTRAINT ak_cliente_telefono UNIQUE (id_cliente,telefono),
	CONSTRAINT pk_cliente_telefono PRIMARY KEY CLUSTERED (id_telefono),
    CONSTRAINT FK_ClienteTelefono FOREIGN KEY (id_cliente) REFERENCES cliente.cliente(id_cliente)
);

/*CREATE TABLE catalogo.tipo_cliente (
	id_tipo_cliente SMALLINT,
	descripcion VARCHAR(50) NOT NULL,
	CONSTRAINT pk_catalogo_cliente PRIMARY KEY CLUSTERED (id_tipo_cliente)
);

CREATE TABLE tipo.cliente (
	id_tipo SMALLINT,
	id_cliente SMALLINT,
	CONSTRAINT pk_tipo_cliente PRIMARY KEY (id_tipo, id_cliente),
	CONSTRAINT FK_tipo_tipo_cliente FOREIGN KEY (id_tipo) REFERENCES catalogo.tipo_cliente(id_tipo),
	CONSTRAINT FK_cliente_tipo_cliente FOREIGN KEY (id_cliente) REFERENCES cliente.cliente(id_cliente)
);

CREATE TABLE cliente.comprador (
	id_cliente SMALLINT,
	CONSTRAINT FK_cliente_comprador FOREIGN KEY (id_cliente) REFERENCES cliente.cliente(id_cliente)
);*/

--Tabla Aval
CREATE TABLE cliente.aval (
    id_aval SMALLINT IDENTITY (1,1),
	id_cliente SMALLINT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellidoPaterno VARCHAR(50) NOT NULL,
    apellidoMaterno VARCHAR(50),
	calle VARCHAR(20)  NOT NULL,
	numero SMALLINT  NOT NULL,
	colonia VARCHAR(20)  NOT NULL,
	municipio VARCHAR(20)  NOT NULL,
	estado VARCHAR(20)  NOT NULL,
	CURP CHAR(18) NOT NULL CONSTRAINT ak_curp_aval UNIQUE,
    telefono CHAR(10) NOT NULL CONSTRAINT ck_telefono_aval CHECK (telefono LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' ),
	CONSTRAINT pk_aval PRIMARY KEY CLUSTERED (id_aval),
	CONSTRAINT FK_id_cliente FOREIGN KEY (id_cliente) REFERENCES cliente.cliente(id_cliente)
);

CREATE TABLE catalogo.modelos (
	id_modelo SMALLINT,
	tipo VARCHAR(50) NOT NULL,
	marca VARCHAR(50) NOT NULL,
	modelo VARCHAR(50) NOT NULL,
	anio VARCHAR(50) NOT NULL,
	CONSTRAINT pk_modelo PRIMARY KEY CLUSTERED (id_modelo)
);

CREATE TABLE catalogo.extras (
	id_extra SMALLINT,
	descripcion VARCHAR(50) NOT NULL,
	CONSTRAINT pk_extra PRIMARY KEY CLUSTERED (id_extra)
);

CREATE TABLE catalogo.caracteristicas (
	id_caracteristica SMALLINT,
	descripcion VARCHAR(50) NOT NULL,
	CONSTRAINT pk_caracteristica PRIMARY KEY CLUSTERED (id_caracteristica)
);

CREATE TABLE coche.propietario (
    id_propietario SMALLINT IDENTITY (1,1),
    nombre VARCHAR(50) NOT NULL,
    apellidoPaterno VARCHAR(50) NOT NULL,
    apellidoMaterno VARCHAR(50),
	calle VARCHAR(20)  NOT NULL,
	numero SMALLINT  NOT NULL,
	colonia VARCHAR(20)  NOT NULL,
	municipio VARCHAR(20)  NOT NULL,
	estado VARCHAR(20)  NOT NULL,
	CURP CHAR(18) NOT NULL CONSTRAINT ak_curp_aval UNIQUE,
    telefono CHAR(10) NOT NULL CONSTRAINT ck_telefono_propietario CHECK (telefono LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' ),
	CONSTRAINT pk_propietario PRIMARY KEY CLUSTERED (id_propietario)
);

--Tabla coche
CREATE TABLE coche.coche (
    id_coche SMALLINT IDENTITY (1,1),
    id_modelo SMALLINT NOT NULL,
	  id_propietario SMALLINT,
    matricula CHAR(10) NOT NULL,
	CONSTRAINT pk_coche PRIMARY KEY CLUSTERED (id_coche),
	CONSTRAINT FK_coche_modelo FOREIGN KEY (id_modelo) REFERENCES catalogo.modelos(id_modelo),
	CONSTRAINT FK_coche_propietario FOREIGN KEY (id_propietario) REFERENCES coche.propietario(id_propietario)
);

CREATE TABLE coche.caracteristicas (
	id_coche SMALLINT NOT NULL,
	id_caracteristica SMALLINT NOT NULL,
	CONSTRAINT pk_coche_caracteristica PRIMARY KEY (id_coche, id_caracteristica),
	CONSTRAINT FK_coche_caract FOREIGN KEY (id_coche) REFERENCES coche.coche(id_coche),
	CONSTRAINT FK_caracteristica_caract FOREIGN KEY (id_caracteristica) REFERENCES catalogo.caracteristicas(id_caracteristica)
);

CREATE TABLE catalogo.tipo_empleado (
	id_tipo_empleado SMALLINT,
	descripcion VARCHAR(50) NOT NULL,
	CONSTRAINT pk_catalogo_empleado PRIMARY KEY CLUSTERED (id_tipo_empleado)
);

--tabla personal
CREATE TABLE personal.empleado (
    numEmpleado SMALLINT IDENTITY (1,1),
    nombre VARCHAR(50) NOT NULL,
    apellidoPaterno VARCHAR(50) NOT NULL,
    apellidoMaterno VARCHAR(50),
	calle VARCHAR(20)  NOT NULL,
	numero SMALLINT  NOT NULL,
	colonia VARCHAR(20)  NOT NULL,
	municipio VARCHAR(20)  NOT NULL,
	estado VARCHAR(20)  NOT NULL,
	fechaIngreso DATE NOT NULL,
	fechaNacimiento DATE NOT NULL,
	--sueldoBase MONEY NOT NULL CONSTRAINT df_sueldo default 8000,
	--tipoCK CHAR(20) NOT NULL,
	tipoEmpleado SMALLINT NOT NULL,
	CONSTRAINT pk_empleado PRIMARY KEY CLUSTERED (numEmpleado),
	CONSTRAINT FK_tipo_empleado FOREIGN KEY (tipoEmpleado) REFERENCES catalogo.tipo_empleado(id_tipo_empleado)
);

CREATE TABLE personal.correo (
    id_correo SMALLINT IDENTITY (1,1),
    id_empleado SMALLINT NOT NULL,
    correo VARCHAR(50) NOT NULL,
	CONSTRAINT ak_empleado_correo UNIQUE (id_empleado,correo),
	CONSTRAINT pk_empleado_correo PRIMARY KEY CLUSTERED (id_correo),
    CONSTRAINT FK_PersonalCorreo FOREIGN KEY (id_empleado) REFERENCES personal.empleado(numEmpleado)
);

CREATE TABLE personal.telefono (
    id_telefono SMALLINT IDENTITY (1,1),
	id_empleado SMALLINT NOT NULL,
    telefono CHAR(10) NOT NULL CONSTRAINT ck_telefono_personal CHECK (telefono LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' ),
	CONSTRAINT ak_empleado_telefono UNIQUE (id_empleado,telefono),
	CONSTRAINT pk_empleado_telefono PRIMARY KEY CLUSTERED (id_telefono),
    CONSTRAINT FK_ClienteTelefono FOREIGN KEY (id_empleado) REFERENCES personal.empleado(numEmpleado)
);

/*
--tabla AgenteVentas
CREATE TABLE personal.agenteVentas (
	numEmpleado SMALLINT NOT NULL,
    --comision DECIMAL(10, 2) NOT NULL,
	CONSTRAINT pk_agenteVentas PRIMARY KEY CLUSTERED (numEmpleado),
    CONSTRAINT FK_numEmpleado_agenteVentas FOREIGN KEY (numEmpleado) REFERENCES personal.empleado(numEmpleado)
);

CREATE TABLE personal.mecanico (
	numEmpleado SMALLINT NOT NULL,
	escolaridad VARCHAR(50) NOT NULL,
	sueldoBase MONEY NOT NULL CONSTRAINT df_sueldo_mecanico default 8000,
	CONSTRAINT pk_mecanico PRIMARY KEY CLUSTERED (numEmpleado),
    CONSTRAINT FK_numEmpleado_mecanico FOREIGN KEY (numEmpleado) REFERENCES personal.empleado(numEmpleado)
);

CREATE TABLE personal.tecnico (
	numEmpleado SMALLINT NOT NULL,
	sueldoBase MONEY NOT NULL CONSTRAINT df_sueldo_tecnico default 8000,
	CONSTRAINT pk_agenteVentas PRIMARY KEY CLUSTERED (numEmpleado),
    CONSTRAINT FK_numEmpleado_tecnico FOREIGN KEY (numEmpleado) REFERENCES personal.empleado(numEmpleado)
);
*/

CREATE TABLE personal.mecanico_cursos (
	id_curso SMALLINT IDENTITY (1,1),
	numEmpleado SMALLINT NOT NULL,
	descripcion VARCHAR(50) NOT NULL,
	CONSTRAINT ak_mecanico_cursos UNIQUE (numEmpleado,descripcion),
	CONSTRAINT pk_mecanico_cursos PRIMARY KEY CLUSTERED (id_curso),
	CONSTRAINT FK_numMecanico_curso FOREIGN KEY (numEmpleado) REFERENCES personal.empleado(numEmpleado)
);

CREATE TABLE catalogo.tipo_servicios(
	id_tipo_servicio SMALLINT NOT NULL,
	descripcion VARCHAR(50) NOT NULL,
	CONSTRAINT pk_catalogo_servicios PRIMARY KEY CLUSTERED (id_tipo_servicio)
);

CREATE TABLE catalogo.revisiones (
	id_tipo_revision SMALLINT NOT NULL,
	descripcion VARCHAR(50) NOT NULL,
	costo_sin_iva MONEY NOT NULL,
	iva AS (costo_sin_iva*0.16),
	costo_con_iva AS (costo_sin_iva+(costo_sin_iva*0.16)),
	CONSTRAINT pk_catalogo_revisiones PRIMARY KEY CLUSTERED (id_tipo_revision)
);
--10 tipos de rep
CREATE TABLE catalogo.reparaciones (
	id_tipo_reparacion SMALLINT NOT NULL,
	descripcion VARCHAR(50) NOT NULL,
	costo_sin_iva MONEY NOT NULL,
	iva AS (costo_sin_iva*0.16),
	costo_con_iva AS (costo_sin_iva+(costo_sin_iva*0.16)),
	CONSTRAINT pk_catalogo_reparaciones PRIMARY KEY CLUSTERED (id_tipo_reparacion)
);

CREATE TABLE catalogo.estatus_servicio (
	id_estatus SMALLINT NOT NULL,
	descripcion VARCHAR(50) NOT NULL,
	CONSTRAINT pk_catalogo_estatus PRIMARY KEY CLUSTERED (id_estatus)
);
--10 servicios
CREATE TABLE servicio.servicio (
	id_servicio SMALLINT IDENTITY (1,1),
	id_coche SMALLINT NOT NULL,
	fecha_ingreso DATETIME2 NOT NULL,
	fecha_salida DATETIME2, --guarda fecha y hora
	tiempo_estancia AS DATEDIFF(DAY, fecha_ingreso, fecha_salida),
	motivo VARCHAR(50) NOT NULL,
	id_estatus SMALLINT NOT NULL,
	tipoServicio SMALLINT NOT NULL,
	CONSTRAINT pk_servicio PRIMARY KEY CLUSTERED (id_servicio),
	CONSTRAINT FK_servicio_coche FOREIGN KEY (id_coche) REFERENCES coche.coche(id_coche),
	CONSTRAINT FK_servicio_estatus FOREIGN KEY (id_estatus) REFERENCES catalogo.estatus_servicio(id_estatus),
	CONSTRAINT FK_tipo_servicio FOREIGN KEY (tipoServicio) REFERENCES catalogo.tipo_servicios(id_tipo_servicio)
);

CREATE TABLE servicio.revision (
	id_revision SMALLINT NOT NULL,
	numEmpleado SMALLINT NOT NULL,
	tipoRevision SMALLINT NOT NULL,
	fecha_planificada DATE NOT NULL,
	fecha_realizacion DATE,
	CONSTRAINT pk_revision PRIMARY KEY CLUSTERED (id_revision),
	CONSTRAINT FK_servicio_revision FOREIGN KEY (id_revision) REFERENCES servicio.servicio(id_servicio),
	CONSTRAINT FK_empleado_revision FOREIGN KEY (numEmpleado) REFERENCES personal.empleado(numEmpleado),
	CONSTRAINT FK_tipo_revision FOREIGN KEY (tipoRevision) REFERENCES catalogo.revisiones(id_tipo_revision)
);

CREATE TABLE servicio.reparacion (
	id_reparacion SMALLINT NOT NULL,
	numEmpleado SMALLINT NOT NULL,
	tipoReparacion SMALLINT NOT NULL,
	CONSTRAINT pk_reparacion PRIMARY KEY CLUSTERED (id_reparacion),
	CONSTRAINT FK_servicio_reparacion FOREIGN KEY (id_reparacion) REFERENCES servicio.servicio(id_servicio),
	CONSTRAINT FK_empleado_reparacion FOREIGN KEY (numEmpleado) REFERENCES personal.empleado(numEmpleado),
	CONSTRAINT FK_tipo_reparacion FOREIGN KEY (tipoReparacion) REFERENCES catalogo.reparaciones(id_tipo_reparacion)
);

CREATE TABLE catalogo.plazos (
	id_plazo SMALLINT NOT NULL,
	plazo_meses SMALLINT NOT NULL,
	tasa_mensual NUMERIC(4,3) NOT NULL,
	CONSTRAINT pk_catalogo_plazos PRIMARY KEY CLUSTERED (id_plazo)
);

CREATE TABLE venta.venta (
	id_venta SMALLINT IDENTITY (1,1),
	id_cliente SMALLINT NOT NULL,
	id_coche SMALLINT NOT NULL,
	id_plazo SMALLINT NOT NULL,
	numEmpleado_agente SMALLINT NOT NULL,
	fecha_hora DATETIME2 NOT NULL,
	costo_sin_iva MONEY NOT NULL,
	iva AS (costo_sin_iva*0.16),
	costo_con_iva AS (costo_sin_iva+(costo_sin_iva*0.16)),
	comision_agente	AS (costo_sin_iva*0.03),
	CONSTRAINT pk_venta PRIMARY KEY CLUSTERED (id_venta),
	CONSTRAINT FK_cliente_venta FOREIGN KEY (id_cliente) REFERENCES cliente.cliente(id_cliente),
	CONSTRAINT FK_coche_venta FOREIGN KEY (id_coche) REFERENCES coche.coche(id_coche),
	CONSTRAINT FK_plazo_venta FOREIGN KEY (id_plazo) REFERENCES catalogo.plazos(id_plazo),
	CONSTRAINT FK_agente_venta FOREIGN KEY (numEmpleado_agente) REFERENCES personal.empleado(numEmpleado)
);

CREATE TABLE venta.pagos (
	id_pago SMALLINT IDENTITY (1,1),
	id_venta SMALLINT NOT NULL,
	banco VARCHAR(50) NOT NULL,
	fecha DATETIME2 NOT NULL,
	no_tarjeta NUMERIC(16,0) NOT NULL,
	monto MONEY NOT NULL,
	CONSTRAINT pk_pago PRIMARY KEY CLUSTERED (id_pago),
	CONSTRAINT FK_venta_pago FOREIGN KEY (id_venta) REFERENCES venta.venta(id_venta)
);

CREATE TABLE venta.extras (
	id_venta SMALLINT NOT NULL,
	id_extra SMALLINT NOT NULL,
	CONSTRAINT pk_venta_extras PRIMARY KEY CLUSTERED (id_venta,id_extra),
	CONSTRAINT FK_venta_extra FOREIGN KEY (id_venta) REFERENCES venta.venta(id_venta),
	CONSTRAINT FK_extra_extra FOREIGN KEY (id_extra) REFERENCES catalogo.extras(id_extra)
);

-----------------------------------------------------------------------------------------------------------------------

---EXEC sp_help [servicio.servicio] 


------------------
---insertando datos

INSERT INTO cliente.cliente ( RFC_Cliente, nombre, apellidoPaterno, apellidoMaterno,  curp, genero, fecha_nacimiento, calle, numero, colonia, 
    municipio, estado) VALUES
('ABC12345', 'Juan', 'Pérez', 'López', 'PELO900101HDFRNN09', 'M', '1990-01-01', 'Reforma', 123, 'Centro', 'Monterrey', 'Nuevo León'),
('DEF67890', 'María', 'Gómez', 'Martínez', 'GOMA920202MDFRMS03', 'F', '1992-02-02', 'Insurgentes', 456, 'Roma', 'Ciudad de México', 'Ciudad de México'),
('GHI12345', 'Alex', 'Hernández', NULL, 'HEPA010303XDFPMS05', 'X', '2001-03-03', 'Chapultepec', 789, 'Polanco', 'Guadalajara', 'Jalisco'),
('JKL45678', 'Carlos', 'Sánchez', 'Mendoza', 'SACM850505HDFRMS08', 'M', '1985-05-05', 'Morelos', 123, 'La Condesa',  'Puebla', 'Puebla'),
('MNO78901', 'Fernanda', 'Ruiz', 'Torres', 'RUTO910606MDFRTS09', 'F', '1991-06-06', 'Independencia', 234, 'Santa Fe', 'Toluca', 'Estado de México'),
('PQR23456', 'Roberto', 'Martínez', NULL, 'MART890707HDFRNT10', 'M', '1989-07-07', 'Juárez', 345, 'El Centro', 'Monterrey', 'Nuevo León'),
('STU34567', 'Ana', 'López', 'Cruz', 'LOCA930808MDFLCR11', 'F', '1993-08-08', 'Constitución', 456, 'Zona Rosa', 'Querétaro', 'Querétaro'),
('VWX56789', 'Elena', 'García', NULL, 'GARE950909MDFEGR12', 'F', '1995-09-09', 'Benito Juárez', 567, 'Del Valle', 'León', 'Guanajuato'),
('YZA89012', 'Luis', 'Pérez', 'Hernández', 'PEHE970101HDFLHN13', 'M', '1997-01-01', 'Revolución', 678, 'Guadalupe', 'Chihuahua', 'Chihuahua'),
('BCD34567', 'Sofía', 'Ramírez', 'Flores', 'RAFL990202MDFSRF14', 'F', '1999-02-02', 'Miguel Hidalgo', 789, 'Chapultepec', 'Veracruz', 'Veracruz');

INSERT INTO cliente.correo (id_cliente, correo) VALUES
(1, 'juan.perez@gmail.com'),
(2, 'maria.gomez@hotmail.com'),
(3, 'alex.hernandez@yahoo.com'),
(4, 'carlos.sanchez@outlook.com'),
(5, 'fernanda.ruiz@protonmail.com'),
(6, 'roberto.martinez@gmail.com'),
(7, 'ana.lopez@hotmail.com'),
(8, 'elena.garcia@yahoo.com'),
(9, 'luis.perez@outlook.com'),
(10, 'sofia.ramirez@protonmail.com');



INSERT INTO cliente.telefono (id_cliente, telefono) VALUES
(1, '5551234567'),
(2, '5552345678'),
(3, '5553456789'),
(4, '5554567890'),
(5, '5555678901'),
(6, '5556789012'),
(7, '5557890123'),
(8, '5558901234'),
(9, '5559012345'),
(10, '5550123456');



INSERT INTO cliente.aval (id_cliente, nombre, apellidoPaterno, apellidoMaterno, 
calle, numero, colonia, municipio, estado, CURP, telefono) VALUES
(1, 'Ricardo', 'González', 'Hernández', 'Morelos', 101, 'Centro', 'Puebla', 'Puebla', 'GONR850505HDFLHN01', '5512345678'),
(2, 'Mónica', 'Ramírez', 'Torres', 'Independencia', 102, 'Santa Fe', 'Toluca', 'Estado de México', 'RAMM910606MDFRTS02', '5523456789'),
(3, 'Jorge', 'Martínez', NULL, 'Juárez', 103, 'Roma', 'Monterrey', 'Nuevo León', 'MART890707HDFRNL03', '5534567890'),
(4, 'Carla', 'López', 'Cruz', 'Constitución', 104, 'Zona Rosa', 'Querétaro', 'Querétaro', 'LOCA930808MDFLCR04', '5545678901'),
(5, 'Elena', 'García', NULL, 'Benito Juárez', 105, 'Del Valle', 'León', 'Guanajuato', 'GARE950909MDFEGR05', '5556789012'),
(6, 'Luis', 'Pérez', 'Hernández', 'Revolución', 106, 'Guadalupe', 'Chihuahua', 'Chihuahua', 'PEHE970101HDFLHN06', '5567890123'),
(7, 'Sofía', 'Ramírez', 'Flores', 'Miguel Hidalgo', 107, 'Chapultepec', 'Veracruz', 'Veracruz', 'RAFL990202MDFSRF07', '5578901234'),
(8, 'Alejandro', 'Hernández', 'Núñez', 'Reforma', 108, 'Centro', 'Ciudad de México', 'Ciudad de México', 'HEAN010303XDFPMS08', '5589012345'),
(9, 'María', 'Gómez', 'Martínez', 'Insurgentes', 109, 'Roma', 'Guadalajara', 'Jalisco', 'GOMA920202MDFRMS09', '5590123456'),
(10, 'Carlos', 'Sánchez', 'Mendoza', 'Chapultepec', 110, 'Polanco', 'Puebla', 'Puebla', 'SACM850505HDFRMS10', '5501234567');


INSERT INTO catalogo.modelos (id_modelo, tipo, marca, modelo, anio) VALUES
(1, 'Sedán', 'Toyota', 'Corolla', '2023'),
(2, 'SUV', 'Honda', 'CR-V', '2022'),
(3, 'Pickup', 'Ford', 'F-150', '2021'),
(4, 'Sedán', 'Mazda', 'Mazda3', '2023'),
(5, 'Hatchback', 'Volkswagen', 'Golf', '2020'),
(6, 'SUV', 'Hyundai', 'Tucson', '2023'),
(7, 'Coupe', 'Chevrolet', 'Camaro', '2021'),
(8, 'Eléctrico', 'Tesla', 'Model 3', '2022'),
(9, 'Minivan', 'Chrysler', 'Pacifica', '2020'),
(10, 'Convertible', 'BMW', 'Z4', '2023');


INSERT INTO catalogo.extras (id_extra, descripcion) VALUES
(1, 'Aire acondicionado'),
(2, 'Sistema de navegación'),
(3, 'Asientos de piel'),
(4, 'Cámara de reversa'),
(5, 'Control crucero'),
(6, 'Faros LED'),
(7, 'Techo panorámico'),
(8, 'Sensores de estacionamiento'),
(9, 'Sistema de audio premium'),
(10, 'Rines de aluminio');

INSERT INTO catalogo.caracteristicas (id_caracteristica, descripcion) VALUES
(1, 'Aire acondicionado'),
(2, 'Asientos de cuero'),
(3, 'Faros LED'),
(4, 'Rines de aleación'),
(5, 'Sistema de navegación'),
(6, 'Cámara de reversa'),
(7, 'Control de crucero'),
(8, 'Techo solar'),
(9, 'Bluetooth integrado'),
(10, 'Sensor de estacionamiento');

INSERT INTO coche.propietario (nombre, apellidoPaterno, apellidoMaterno, calle, numero, colonia, 
    municipio, estado, CURP, telefono) VALUES
('Juan', 'Gómez', 'Sánchez', 'Avenida México', 123, 'Centro', 'Monterrey', 'Nuevo León', 'GOSJ800101HNLNJN05', '5512345678'),
('María', 'Pérez', 'López', 'Calle 5', 456, 'La Loma', 'Ciudad de México', 'CDMX', 'PELM900512MDFRMR08', '5523456789'),
('Carlos', 'Martínez', 'Torres', 'Paseo de la Reforma', 789, 'Polanco', 'Guadalajara', 'Jalisco', 'MTCJ750303HGRMRR09', '5534567890'),
('Lucía', 'Ramírez', 'Hernández', 'Boulevard Hidalgo', 101, 'Roma', 'León', 'Guanajuato', 'RMLL850714MGRMLD10', '5545678901'),
('José', 'González', 'Mendoza', 'Callejón del Sol', 202, 'Zona Rosa', 'Puebla', 'Puebla', 'GNZJ820315HDFGNS11', '5556789012'),
('Ana', 'Torres', 'Figueroa', 'Avenida Central', 303, 'Santa Fe', 'Querétaro', 'Querétaro', 'TFGA830625MDFNZN12', '5567890123'),
('Pedro', 'Hernández', 'García', 'Calle de la Paz', 404, 'Juárez', 'Tijuana', 'Baja California', 'HNGP710120HBCRPD13', '5578901234');

INSERT INTO coche.coche (id_modelo, id_propietario, matricula) VALUES
(1, 1, 'ABC1234567'),
(2, 2, 'XYZ2345678'),
(3, 3, 'LMN3456789'),
(4, 4, 'PQR4567890'),
(5, 5, 'JKL5678901'),
(6, 6, 'DEF6789012'),
(7, 7, 'MNO7890123'),
(8, 1, 'STU8901234'),
(9, 3, 'VWX9012345'),
(10, 7, 'YZA0123456');

INSERT INTO coche.caracteristicas (id_coche, id_caracteristica) VALUES
(1, 1),  -- Cambio de aceite
(1, 2),  -- Asientos de cuero
(2, 3),  -- Faros LED
(2, 4),  -- Rines de aleación
(3, 5),  -- Sistema de navegación
(3, 6),  -- Cámara de reversa
(4, 7),  -- Control de crucero
(4, 8),  -- Techo solar
(5, 9),  -- Bluetooth integrado
(5, 10), -- Sensor de estacionamiento
(6, 1),  -- Cambio de aceite
(6, 3),  -- Faros LED
(7, 2),  -- Asientos de cuero
(7, 4),  -- Rines de aleación
(8, 5),  -- Sistema de navegación
(8, 6),  -- Cámara de reversa
(9, 7),  -- Control de crucero
(9, 8),  -- Techo solar
(10, 9), -- Bluetooth integrado
(10, 10); -- Sensor de estacionamiento


INSERT INTO catalogo.tipo_empleado (id_tipo_empleado, descripcion) VALUES
(1, 'Agente de Ventas'),
(2, 'Mecánico'),
(3, 'Técnico');


INSERT INTO personal.empleado ( nombre, apellidoPaterno, apellidoMaterno, calle, numero, colonia, 
    municipio, estado, fechaIngreso, fechaNacimiento, tipoEmpleado) VALUES
('Carlos', 'Ramírez', 'Hernández', 'Reforma', 123, 'Centro', 'Puebla', 'Puebla', '2020-01-15', '1990-03-05', 1),
('Ana', 'Gómez', 'Martínez', 'Insurgentes', 234, 'Roma', 'Ciudad de México', 'Ciudad de México', '2019-06-20', '1988-07-14', 2),
('Luis', 'Pérez', 'López', 'Chapultepec', 345, 'Polanco', 'Monterrey', 'Nuevo León', '2021-08-10', '1992-11-25', 3),
('Mónica', 'Sánchez', NULL, 'Morelos', 456, 'La Condesa', 'Guadalajara', 'Jalisco', '2018-02-28', '1995-01-19', 2),
('Ricardo', 'Fernández', 'Cruz', 'Independencia', 567, 'Santa Fe', 'Toluca', 'Estado de México', '2020-11-12', '1985-09-23', 2),
('Elena', 'Torres', 'Núñez', 'Juárez', 678, 'Zona Rosa', 'Querétaro', 'Querétaro', '2022-03-01', '1993-04-12', 1),
('Jorge', 'Martínez', 'García', 'Constitución', 789, 'Del Valle', 'León', 'Guanajuato', '2023-01-05', '1991-08-30', 3),
('Carla', 'López', NULL, 'Revolución', 890, 'Guadalupe', 'Chihuahua', 'Chihuahua', '2017-07-25', '1987-10-15', 1),
('Alejandro', 'Hernández', 'Mendoza', 'Miguel Hidalgo', 901, 'Chapultepec', 'Veracruz', 'Veracruz', '2020-05-17', '1994-06-09', 2),
('Sofía', 'González', 'Flores', 'Benito Juárez', 1002, 'El Centro', 'Puebla', 'Puebla', '2021-09-09', '1996-12-22', 1),
('Juan', 'Perez', 'Lopez', 'Av. Reforma', 101, 'Centro', 'Ciudad de Mexico', 'CDMX', '2024-01-01', '1990-05-10', 1),
('Maria', 'Garcia', 'Martinez', 'Calle 5', 102, 'Santa Fe', 'Ciudad de Mexico', 'CDMX', '2024-02-01', '1985-07-15', 1),
('Carlos', 'Rodriguez', 'Fernandez', 'Calle 10', 103, 'Polanco', 'Ciudad de Mexico', 'CDMX', '2024-03-01', '1992-03-20', 1),
('Ana', 'Lopez', 'Gonzalez', 'Calle 15', 104, 'Roma Norte', 'Ciudad de Mexico', 'CDMX', '2024-04-01', '1993-11-25', 1),
('Pedro', 'Martinez', 'Hernandez', 'Av. Las Americas', 105, 'Lomas', 'Ciudad de Mexico', 'CDMX', '2024-05-01', '1980-02-10', 2),
('Lucia', 'Sanchez', 'Diaz', 'Calle 25', 106, 'Condesa', 'Ciudad de Mexico', 'CDMX', '2024-06-01', '1987-04-20', 2),
('Javier', 'Vazquez', 'Moreno', 'Calle 30', 107, 'Del Valle', 'Ciudad de Mexico', 'CDMX', '2024-07-01', '1983-09-30', 2),
('Sofia', 'Ramirez', 'Castillo', 'Calle 35', 108, 'Chapultepec', 'Ciudad de Mexico', 'CDMX', '2024-08-01', '1988-01-10', 2);


INSERT INTO personal.correo (id_empleado, correo) VALUES
(5, 'carlos.ramirez@empresa.com'),
(6, 'ana.gomez@empresa.com'),
(7, 'luis.perez@mecanico.com'),
(8, 'monica.sanchez@tecnico.com'),
(9, 'ricardo.fernandez@ventas.com'),
(10, 'elena.torres@empresa.com'),
(11, 'jorge.martinez@mecanico.com'),
(12, 'carla.lopez@tecnico.com'),
(13, 'alejandro.hernandez@ventas.com'),
(14, 'sofia.gonzalez@empresa.com');

INSERT INTO personal.telefono (id_empleado, telefono) VALUES
(5, '5512345678'),
(6, '5523456789'),
(7, '5534567890'),
(8, '5545678901'),
(9, '5556789012'),
(10, '5567890123'),
(11, '5578901234'),
(12, '5589012345'),
(13, '5590123456'),
(14, '5501234567');

INSERT INTO personal.mecanico_cursos (numEmpleado, descripcion) VALUES
(6, 'Curso de Diagnóstico Automotriz'),
(8, 'Mantenimiento de Sistemas Eléctricos Automotrices'),
(9, 'Curso de Reparación de Transmisiones'),
(13, 'Capacitación en Diagnóstico de Motores'),
(13, 'Curso de Sistema de Frenos Avanzado'),
(9, 'Mantenimiento de Suspensión Automotriz'),
(8, 'Curso de Electricidad Automotriz'),
(6, 'Reparación de Aire Acondicionado'),
(6, 'Curso de Reparación de Direcciones'),
(9, 'Certificación en Reparación de Vehículos Diesel');

INSERT INTO catalogo.tipo_servicios (id_tipo_servicio, descripcion) VALUES
(1, 'Revision'),
(2, 'Reparacion');

INSERT INTO catalogo.revisiones (id_tipo_revision, descripcion, costo_sin_iva) VALUES
(1, 'Revisión general', 1500.00),
(2, 'Revisión de frenos', 800.00),
(3, 'Revisión de aceite', 400.00),
(4, 'Revisión de transmisión', 1000.00),
(5, 'Revisión de suspensión', 600.00),
(6, 'Revisión de sistema eléctrico', 750.00),
(7, 'Revisión de frenos y suspensión', 1200.00),
(8, 'Revisión de alineación y balanceo', 500.00),
(9, 'Revisión de batería', 350.00),
(10, 'Revisión de aire acondicionado', 450.00);


INSERT INTO catalogo.reparaciones (id_tipo_reparacion, descripcion, costo_sin_iva) VALUES
(1, 'Reparación de motor', 5000.00),
(2, 'Reparación de frenos', 1200.00),
(3, 'Reparación de suspensión', 1500.00),
(4, 'Reparación de transmisión', 3500.00),
(5, 'Reparación de sistema eléctrico', 2500.00),
(6, 'Reparación de aire acondicionado', 2200.00),
(7, 'Reparación de escape', 1800.00),
(8, 'Reparación de dirección', 1300.00),
(9, 'Reparación de batería', 600.00),
(10, 'Reparación de sistema de combustible', 2700.00);

INSERT INTO catalogo.estatus_servicio (id_estatus, descripcion) VALUES
(1, 'En espera'),
(2, 'En proceso'),
(3, 'Finalizado');

INSERT INTO servicio.servicio (id_coche, fecha_ingreso, fecha_salida, motivo, id_estatus, tipoServicio) VALUES
(1, '2024-11-01 08:00:00', '2024-11-01 17:00:00', 'Mantenimiento preventivo', 3, 1),
(2, '2024-11-02 09:00:00', '2024-11-02 18:00:00', 'Reparación de frenos', 2, 2),
(3, '2024-11-03 10:00:00', '2024-11-03 16:00:00', 'Revisión de aceite', 3, 1),
(4, '2024-11-04 11:00:00', '2024-11-04 15:00:00', 'Reparación de motor', 2, 2),
(5, '2024-11-05 12:00:00', '2024-11-05 17:00:00', 'Revisión de suspensión', 1, 2),
(6, '2024-11-06 08:30:00', '2024-11-06 17:30:00', 'Reparación de sistema eléctrico', 3, 1),
(7, '2024-11-07 07:45:00', '2024-11-07 14:45:00', 'Revisión de transmisión', 2, 2),
(8, '2024-11-08 10:30:00', '2024-11-08 16:30:00', 'Revisión de dirección', 3, 1),
(9, '2024-11-09 09:15:00', '2024-11-09 18:00:00', 'Reparación de aire acondicionado', 1, 1),
(10, '2024-11-10 08:00:00', '2024-11-10 17:00:00', 'Reparación de escape', 3, 2);

INSERT INTO servicio.revision (id_revision, numEmpleado, tipoRevision, fecha_planificada, fecha_realizacion) VALUES
(1, 7, 1, '2024-11-05', '2024-11-06'),
(2,11, 2, '2024-11-06', '2024-11-07'),
(3, 11, 3, '2024-11-07', '2024-11-08'),
(4, 11, 4, '2024-11-08', '2024-11-09'),
(5, 7, 5, '2024-11-09', '2024-11-10'),
(6, 7, 6, '2024-11-10', '2024-11-11'),
(7, 7, 7, '2024-11-11', '2024-11-12'),
(8, 11, 8, '2024-11-12', '2024-11-13'),
(9, 7, 9, '2024-11-13', '2024-11-14'),
(10, 11, 10, '2024-11-14', '2024-11-15');


INSERT INTO servicio.reparacion (id_reparacion, numEmpleado, tipoReparacion) VALUES
(1, 6, 1),
(2, 8, 2),
(3, 9, 3),
(4, 13, 4),
(5, 19, 5),
(6, 21, 6),
(7, 9, 7),
(8, 21, 8),
(9, 22, 9),
(10, 19, 10);


INSERT INTO catalogo.plazos (id_plazo, plazo_meses, tasa_mensual) VALUES
(1, 6, 0.025),
(2, 12, 0.022),
(3, 18, 0.020),
(4, 24, 0.018),
(5, 30, 0.017),
(6, 36, 0.015),
(7, 48, 0.014),
(8, 60, 0.013),
(9, 72, 0.012),
(10, 84, 0.011);


INSERT INTO venta.venta (id_cliente, id_coche, id_plazo, numEmpleado_agente, fecha_hora, costo_sin_iva) VALUES
(1, 1, 3, 1, '2024-11-01 10:00:00', 200000),
(2, 2, 6, 2, '2024-11-02 14:30:00', 350000),
(3, 3, 12, 3, '2024-11-03 09:15:00', 150000),
(4, 4, 24, 4, '2024-11-04 11:45:00', 400000),
(5, 5, 18, 1, '2024-11-05 13:00:00', 250000),
(6, 6, 36, 2, '2024-11-06 15:30:00', 180000),
(7, 7, 48, 3, '2024-11-07 17:00:00', 300000),
(8, 8, 60, 4, '2024-11-08 10:00:00', 450000),
(9, 9, 72, 1, '2024-11-09 12:00:00', 500000),
(10, 10, 84, 2, '2024-11-10 16:30:00', 550000);



INSERT INTO venta.venta (id_cliente, id_coche, id_plazo, numEmpleado_agente, fecha_hora, costo_sin_iva) VALUES
(1, 1, 1, 5, '2024-11-01 10:00:00', 200000),
(2, 2, 2, 10, '2024-11-02 14:30:00', 350000),
(3, 3, 2, 16, '2024-11-03 09:15:00', 150000),
(4, 4, 4, 17, '2024-11-04 11:45:00', 400000),
(5, 5, 8, 15, '2024-11-05 13:00:00', 250000),
(6, 6, 6, 12, '2024-11-06 15:30:00', 180000),
(7, 7, 8, 5, '2024-11-07 17:00:00', 300000),
(8, 8, 6, 14, '2024-11-08 10:00:00', 450000),
(9, 9, 7, 18, '2024-11-09 12:00:00', 500000),
(10, 10, 8, 5, '2024-11-10 16:30:00', 550000);

INSERT INTO venta.pagos (id_venta, banco, fecha, no_tarjeta, monto) VALUES
(16, 'Banorte', '2024-11-01 10:05:00', 1234567812345678, 200000),
(22, 'BBVA', '2024-11-02 14:35:00', 2345678923456789, 350000),
(23, 'Santander', '2024-11-03 09:20:00', 3456789034567890, 150000),
(24, 'HSBC', '2024-11-04 11:50:00', 4567890145678901, 400000),
(25, 'Citibanamex', '2024-11-05 13:05:00', 5678901256789012, 250000),
(16, 'Scotiabank', '2024-11-06 15:35:00', 6789012367890123, 180000),
(17, 'Banorte', '2024-11-07 17:05:00', 7890123478901234, 300000),
(18, 'BBVA', '2024-11-08 10:05:00', 8901234589012345, 450000),
(19, 'Santander', '2024-11-09 12:05:00', 9012345690123456, 500000),
(20, 'HSBC', '2024-11-10 16:35:00', 1234567812345678, 550000);

INSERT INTO venta.extras (id_venta, id_extra) VALUES
(16, 1),
(17, 3),
(25, 2),
(23, 4),
(23, 1),
(20, 5),
(16, 2),
(24, 6),
(25, 3),
(22, 7);

------------------------------
----------CONSULTAS-----------
------------------------------

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
