use ConsecionariaProyecto2
go

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

INSERT INTO catalogo.extras (id_extra, descripcion, costo_con_iva) VALUES
(1, 'Aire acondicionado', 500),
(2, 'Sistema de navegación', 700),
(3, 'Asientos de piel', 800),
(4, 'Cámara de reversa', 300),
(5, 'Control crucero', 400),
(6, 'Faros LED', 350),
(7, 'Techo panorámico', 1200),
(8, 'Sensores de estacionamiento', 250),
(9, 'Sistema de audio premium', 1000),
(10, 'Rines de aluminio', 600);

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
(2, NULL, 'XYZ2345678'),
(3, NULL, 'LMN3456789'),
(4, 4, 'PQR4567890'),
(5, NULL, 'JKL5678901'),
(6, 6, 'DEF6789012'),
(7, 7, 'MNO7890123'),
(8, 2, 'STU8901234'),
(9, 3, 'VWX9012345'),
(10, 7, 'YZA0123456'),
(1, 5, 'GHI6203726'),
(2, NULL, 'GHI7563648'),
(3, 3, 'XYZ2366775'),
(4, 5, 'JKL7592939'),
(5, NULL, 'XYZ1938686');

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
(2, 'Curso de Diagnóstico Automotriz'),
(4, 'Mantenimiento de Sistemas Eléctricos Automotrices'),
(5, 'Curso de Reparación de Transmisiones'),
(9, 'Capacitación en Diagnóstico de Motores'),
(15, 'Curso de Sistema de Frenos Avanzado'),
(16, 'Mantenimiento de Suspensión Automotriz'),
(17, 'Curso de Electricidad Automotriz'),
(18, 'Reparación de Aire Acondicionado'),
(2, 'Curso de Reparación de Direcciones'),
(17, 'Certificación en Reparación de Vehículos Diesel');

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
(1, '2024-01-01 08:00:00', '2024-01-03 17:00:00', 'Mantenimiento preventivo', 3, 1),--1
(2, '2024-06-02 09:00:00', '2024-06-03 18:00:00', 'Reparación de frenos', 2, 2),-->2
(1, '2024-12-03 10:00:00', '2024-12-08 16:00:00', 'Revisión de aceite', 3, 1),--3
(4, '2024-11-04 11:00:00', '2024-11-06 15:00:00', 'Reparación de motor', 2, 2),-->4
(1, '2024-02-05 12:00:00', '2024-02-06 17:00:00', 'Revisión de suspensión', 1, 2),-->5
(6, '2024-06-06 08:30:00', '2024-06-10 17:30:00', 'Reparación de sistema eléctrico', 3, 1),--6
(1, '2024-11-07 07:45:00', '2024-11-08 14:45:00', 'Revisión de transmisión', 2, 2),-->7
(8, '2024-03-08 10:30:00', '2024-03-14 16:30:00', 'Revisión de dirección', 3, 1),--8
(9, '2024-11-09 09:15:00', '2024-11-11 18:00:00', 'Reparación de aire acondicionado', 1, 1),--9
(10, '2024-11-10 08:00:00', '2024-11-17 17:00:00', 'Reparación de escape', 3, 2),-->10
(11, '2024-06-03 10:50:00', '2024-06-05 17:50:00', 'Reparación de motor', 1, 2),-->11
(12, '2024-11-05 10:39:00', '2024-11-06 16:39:00', 'Reparación de aire acondicionado', 3, 2),-->12
(13, '2024-11-03 10:40:00', '2024-11-04 17:40:00', 'Revisión de suspensión', 3, 2),-->13
(14, '2024-01-07 11:55:00', '2024-01-09 17:55:00', 'Revisión de dirección', 3, 2),-->14
(15, '2024-11-05 10:12:00', '2024-11-10 16:12:00', 'Revisión de suspensión', 1, 2),-->15
(1, '2024-05-07 11:03:00', '2024-05-09 17:03:00', 'Reparación de sistema eléctrico', 2, 1),--16
(2, '2024-07-08 11:35:00', '2024-07-09 19:35:00', 'Reparación de frenos', 2, 1),--17
(3, '2024-12-08 09:47:00', '2024-12-15 15:47:00', 'Reparación de sistema eléctrico', 2, 1),--18
(4, '2024-11-10 11:55:00', '2024-11-13 17:55:00', 'Mantenimiento preventivo', 1, 1),--19
(5, '2024-12-08 11:31:00', '2024-12-12 18:31:00', 'Reparación de escape', 3, 2);-->20

INSERT INTO servicio.revision (id_revision, numEmpleado, tipoRevision, fecha_planificada, fecha_realizacion) VALUES
(1, 7, 1, '2024-01-01', '2024-01-02'),
(3, 3, 2, '2024-12-03', '2024-12-05'),
(6, 7, 3, '2024-06-06', '2024-06-08'),
(8, 3, 4, '2024-03-08', '2024-03-10'),
(9, 15, 5, '2024-11-09', '2024-11-10'),
(16, 7, 6, '2024-05-07', '2024-05-08'),
(17, 17, 7, '2024-07-08', '2024-07-08'),
(18, 3, 8, '2024-12-08', '2024-12-13'),
(19, 7, 9, '2024-11-10', '2024-11-11');


INSERT INTO servicio.reparacion (id_reparacion, numEmpleado, tipoReparacion) VALUES
(2, 2, 1),
(4, 4, 2),
(5, 5, 3),
(7, 9, 4),
(10, 15, 5),
(11, 16, 6),
(12, 17, 7),
(13, 18, 8),
(14, 2, 9),
(15, 5, 10),
(20, 16, 10);


INSERT INTO catalogo.plazos (id_plazo, plazo_meses, tasa_mensual) VALUES
(1, 0, 0),
(2, 12, 0.016),
(3, 24, 0.020),
(4, 36, 0.025),
(5, 48, 0.029);


INSERT INTO venta.venta (id_cliente, id_coche, id_plazo, numEmpleado_agente, fecha_hora, costo_sin_iva) VALUES----------
(1, 1, 1, 1, '2024-11-01 10:00:00', 200000),
(2, 2, 2, 2, '2024-11-02 14:30:00', 350000),
(3, 3, 1, 3, '2024-11-03 09:15:00', 150000),
(4, 4, 4, 4, '2024-11-04 11:45:00', 400000),
(5, 5, 1, 1, '2024-11-05 13:00:00', 250000),
(6, 6, 2, 2, '2024-11-06 15:30:00', 180000),
(7, 7, 3, 3, '2024-11-07 17:00:00', 300000),
(8, 8, 1, 4, '2024-11-08 10:00:00', 450000),
(9, 9, 5, 1, '2024-11-09 12:00:00', 500000),
(10, 10, 3, 2, '2024-11-10 16:30:00', 550000);

/*INSERT INTO venta.venta (id_cliente, id_coche, id_plazo, numEmpleado_agente, fecha_hora, costo_sin_iva) VALUES
(1, 1, 1, 5, '2024-11-01 10:00:00', 200000),
(2, 2, 2, 10, '2024-11-02 14:30:00', 350000),
(3, 3, 2, 16, '2024-11-03 09:15:00', 150000),
(4, 4, 4, 17, '2024-11-04 11:45:00', 400000),
(5, 5, 8, 15, '2024-11-05 13:00:00', 250000),
(6, 6, 6, 12, '2024-11-06 15:30:00', 180000),
(7, 7, 8, 5, '2024-11-07 17:00:00', 300000),
(8, 8, 6, 14, '2024-11-08 10:00:00', 450000),
(9, 9, 7, 18, '2024-11-09 12:00:00', 500000),
(10, 10, 8, 5, '2024-11-10 16:30:00', 550000);*/

INSERT INTO venta.pagos (id_venta, banco, fecha, no_tarjeta, monto) VALUES------------------
(1, 'Banorte', '2024-11-01 10:05:00', 1234567812345678, 200000),--
(2, 'BBVA', '2024-11-02 14:35:00', 2345678923456789, 30000),--12
(3, 'Santander', '2024-11-03 09:20:00', 3456789034567890, 150000),--
(4, 'HSBC', '2024-11-04 11:50:00', 4567890145678901, 11500),--36
(5, 'Citibanamex', '2024-11-05 13:05:00', 5678901256789012, 250000),--
(6, 'Scotiabank', '2024-11-06 15:35:00', 6789012367890123, 15000),--12
(7, 'Banorte', '2024-11-07 17:05:00', 7890123478901234, 12500),--24
(8, 'BBVA', '2024-11-08 10:05:00', 8901234589012345, 450000),--
(9, 'Santander', '2024-11-09 12:05:00', 9012345690123456, 10500),--48
(10, 'HSBC', '2024-11-10 16:35:00', 1234567812345678, 21000);--24

INSERT INTO venta.extras (id_venta, id_extra) VALUES-------------------
(1, 1),
(2, 3),
(1, 2),
(3, 4),
(4, 1),
(5, 5),
(6, 2),
(6, 6),
(7, 3),
(9, 7);

select * from servicio.servicio

--select numEmpleado from personal.empleado where tipoEmpleado = 1

--CREATE OR ALTER VIEW cliente.visCliente as
--SELECT c.id_cliente, c.RFC_Cliente, (c.nombre+' '+c.apellidoPaterno+' '+ISNULL(e.apellidoMaterno, ' - ')) nombreCliente, 