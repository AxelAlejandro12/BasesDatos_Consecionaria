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