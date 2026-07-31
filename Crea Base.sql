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

CREATE INDEX idx_rfc_cliente
ON cliente.cliente (RFC_Cliente);

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
	ON DELETE CASCADE
);

-- Tabla ClienteTelefono
CREATE TABLE cliente.telefono (
    id_telefono SMALLINT IDENTITY (1,1),
	id_cliente SMALLINT NOT NULL,
    telefono CHAR(10) NOT NULL CONSTRAINT ck_telefono_cliente CHECK (telefono LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' ),
	CONSTRAINT ak_cliente_telefono UNIQUE (id_cliente,telefono),
	CONSTRAINT pk_cliente_telefono PRIMARY KEY CLUSTERED (id_telefono),
    CONSTRAINT FK_ClienteTelefono FOREIGN KEY (id_cliente) REFERENCES cliente.cliente(id_cliente)
	ON DELETE CASCADE
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
	ON DELETE CASCADE
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
	costo_con_iva MONEY NOT NULL,
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
    matricula CHAR(10) NOT NULL CONSTRAINT ak_matricula_coche UNIQUE,
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