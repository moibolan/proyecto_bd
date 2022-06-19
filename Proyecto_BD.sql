use db1
go

Print 'DROPEAMOS TABLAS'

DROP TABLE [dbo].[fechas_locacion]
GO
DROP TABLE [dbo].[empleado_solicitar]
GO
DROP TABLE [dbo].[empleado_aprobacion]
GO
DROP TABLE [dbo].[FEC_RESERVADAS]
GO
DROP TABLE [dbo].[REINTEGRO]
GO
DROP TABLE [dbo].[SOLICITUD]
GO
alter table departamento drop constraint departamento_jefatura_fk;
GO
DROP TABLE [dbo].[EMPLEADO]
GO
DROP TABLE [dbo].[DEPARTAMENTO]
GO
DROP TABLE [dbo].[PUESTO]
GO
DROP TABLE [dbo].[LOCACION]
GO

Print 'DROPEAMOS SECUENCIAS'
DROP SEQUENCE sec_solicitud;
DROP SEQUENCE sec_reintegro;
DROP SEQUENCE sequence_fec_reservadas;
GO

Print 'CREAMOS SECUENCIAS'
CREATE SEQUENCE sec_solicitud START WITH 300 INCREMENT BY 1;
CREATE SEQUENCE sec_reintegro START WITH 400 INCREMENT BY 1;
CREATE SEQUENCE sequence_fec_reservadas START WITH 81 INCREMENT BY 1;
GO

Print 'CREAMOS LAS TABLAS'

CREATE TABLE PUESTO
(
  ID_PUESTO INT NOT NULL,
  NOMBRE_PUESTO VARCHAR(50) NOT NULL,
  SALARIO_MIN INT NOT NULL,
  SALARIO_MAX INT NOT NULL,
  PRIMARY KEY (ID_PUESTO)
);
go

CREATE TABLE LOCACION
(
  ID_LOCACION INT NOT NULL,
  PROVINCIA VARCHAR(20) NOT NULL,
  CANTON VARCHAR(20) NOT NULL,
  DISTRITO VARCHAR(20) NOT NULL,
  PRIMARY KEY (ID_LOCACION)
);
go

CREATE TABLE DEPARTAMENTO
(
  ID_DEPARTAMENTO INT NOT NULL,
  NOMBRE_DEPARTAMENTO VARCHAR(50) NOT NULL,
  ID_JEFATURA INT NOT NULL,
  PRIMARY KEY (ID_DEPARTAMENTO)
 
);
go


CREATE TABLE EMPLEADO
(
  CEDULA INT NOT NULL,
  ID_EMPLEADO INT NOT NULL,
  NOMBRE VARCHAR(50) NOT NULL,
  APELLIDO1 VARCHAR(50) NOT NULL,
  APELLIDO2 VARCHAR(50) NOT NULL,
  CORREO VARCHAR(50) NOT NULL,
  TELEFONO INT NOT NULL,
  FEC_INGRESO DATE NOT NULL,
  FEC_SALIDA DATE,
  ID_PUESTO INT NOT NULL,
  ID_JEFATURA INT,
  ID_DEPARTAMENTO INT NOT NULL,
  DIAS_VACACIONES INT NOT NULL,
  TIPO_JORNADA VARCHAR(20) NOT NULL,
  TIPO_PERFIL VARCHAR(20) NOT NULL,
  ID_LOCACION INT NOT NULL,
  PRIMARY KEY (ID_EMPLEADO),
  FOREIGN KEY (ID_PUESTO) REFERENCES PUESTO(ID_PUESTO),
  FOREIGN KEY (ID_DEPARTAMENTO) REFERENCES DEPARTAMENTO(ID_DEPARTAMENTO),
  FOREIGN KEY (ID_LOCACION) REFERENCES LOCACION(ID_LOCACION),
  FOREIGN KEY (ID_JEFATURA) REFERENCES EMPLEADO(ID_EMPLEADO),
  UNIQUE (CEDULA)
);
go
--Fecha solicitud sysdate
CREATE TABLE SOLICITUD
(
	  ID_SOLICITUD INT NOT NULL,
	  FEC_SALIDA DATE NOT NULL,
	  FEC_REGRESO DATE NOT NULL,
	  FEC_SOLICITUD DATE NOT NULL,
	  CONCEPTO VARCHAR(20) NOT NULL,
	  ESTADO_SOL VARCHAR(20) NOT NULL,
	  ID_EMPLEADO INT NOT NULL,
	  PRIMARY KEY (ID_SOLICITUD),
	  FOREIGN KEY (ID_EMPLEADO) REFERENCES EMPLEADO(ID_EMPLEADO)
);
go

CREATE TABLE REINTEGRO
(
  ID_REINTEGRO INT NOT NULL,
  ID_SOLICITUD INT NOT NULL,
  DESCRIPCION VARCHAR(200) NOT NULL,
  ESTADO_REINTEGRO VARCHAR(20) NOT NULL,
  FEC_REINTEGRO DATE NOT NULL,
  PRIMARY KEY (ID_REINTEGRO),
  FOREIGN KEY (ID_SOLICITUD) REFERENCES SOLICITUD(ID_SOLICITUD),
   UNIQUE (ID_SOLICITUD)
);
GO

CREATE TABLE FEC_RESERVADAS
(
  ID_FECHA INT NOT NULL,
  FECHA DATE NOT NULL,
  CONCEPTO VARCHAR(20) NOT NULL,
  PRIMARY KEY (ID_FECHA)

);

CREATE TABLE empleado_aprobacion
(
	ID_EMP_APROBAR INT NOT NULL, 
	ID_EMP_PERMISO_APROBAR INT NOT NULL
);
GO

CREATE TABLE empleado_solicitar
(
	ID_EMP_SOLICITAR INT NOT NULL, 
	ID_EMP_PERMISO_SOLICITAR INT NOT NULL
);
GO

CREATE TABLE fechas_locacion
(
	ID_FECHA_RESERVADA INT NOT NULL, 
	ID_LOCACION_A_RESERVAR INT NOT NULL
);
GO

Print 'CREAMOS LAS FK Y CK'
alter table departamento add constraint departamento_jefatura_fk foreign key (ID_JEFATURA) references EMPLEADO;
GO
  
alter table empleado_aprobacion add constraint emp_a_aprob_fk foreign key (ID_EMP_APROBAR) references EMPLEADO;
alter table empleado_aprobacion add constraint emp_con_permisos_aprobar_fk foreign key (ID_EMP_PERMISO_APROBAR) references EMPLEADO;
GO

alter table empleado_solicitar add constraint emp_a_solicitar_fk foreign key (ID_EMP_SOLICITAR) references EMPLEADO;
alter table empleado_solicitar add constraint emp_con_permisos_solicitar_fk foreign key (ID_EMP_PERMISO_SOLICITAR) references EMPLEADO;
GO

alter table fechas_locacion add constraint fec_reservada_fk foreign key (ID_FECHA_RESERVADA) references FEC_RESERVADAS;
alter table fechas_locacion add constraint loc_reservada_fk foreign key (ID_LOCACION_A_RESERVAR) references LOCACION;

alter table empleado add constraint jornada_ck check (TIPO_JORNADA = 'NORMAL' or TIPO_JORNADA = 'EXTENDIDA');

alter table empleado add constraint perfil_ck check 
(TIPO_PERFIL = 'FUNCIONARIO' or TIPO_PERFIL = 'JEFATURA' or TIPO_PERFIL = 'ADMIN' or TIPO_PERFIL = 'VISTA');

alter table solicitud add constraint estado_solicitud_ck check 
(ESTADO_SOL = 'PENDIENTE' or ESTADO_SOL = 'RECHAZADA' or ESTADO_SOL = 'APROBADA' or ESTADO_SOL = 'DISCUSION');

alter table reintegro add constraint estado_reintegro_ck check 
(ESTADO_REINTEGRO = 'PENDIENTE' or ESTADO_REINTEGRO = 'RECHAZADA' or ESTADO_REINTEGRO = 'APROBADA' or ESTADO_REINTEGRO = 'DISCUSION');
GO

Print 'INSERTAMOS LOS VALORES'
INSERT INTO [dbo].[PUESTO] ([ID_PUESTO],[NOMBRE_PUESTO],[SALARIO_MIN],[SALARIO_MAX])
VALUES (11, 'Contador', 550000, 850000)

INSERT INTO [dbo].[PUESTO] ([ID_PUESTO],[NOMBRE_PUESTO],[SALARIO_MIN],[SALARIO_MAX])
VALUES (12, 'Ing Sistemas', 750000, 1250000)

INSERT INTO [dbo].[PUESTO] ([ID_PUESTO],[NOMBRE_PUESTO],[SALARIO_MIN],[SALARIO_MAX])
VALUES (13, 'Servicio al cliente Esp', 500000, 650000)

INSERT INTO [dbo].[PUESTO] ([ID_PUESTO],[NOMBRE_PUESTO],[SALARIO_MIN],[SALARIO_MAX])
VALUES (14, 'Servicio al cliente Ing', 700000, 850000)

INSERT INTO [dbo].[PUESTO] ([ID_PUESTO],[NOMBRE_PUESTO],[SALARIO_MIN],[SALARIO_MAX])
VALUES (15, 'Asistente', 500000, 650000)

GO

INSERT INTO [dbo].[LOCACION]([ID_LOCACION],[PROVINCIA],[CANTON],[DISTRITO])
VALUES (21, 'Alajuela', 'Alajuela', 'San Antonio')

INSERT INTO [dbo].[LOCACION]([ID_LOCACION],[PROVINCIA],[CANTON],[DISTRITO])
VALUES (22, 'San Jose', 'San Jose', 'Carmen')

INSERT INTO [dbo].[LOCACION]([ID_LOCACION],[PROVINCIA],[CANTON],[DISTRITO])
VALUES (23, 'Cartago', 'Cartago', 'Occidental')

INSERT INTO [dbo].[LOCACION]([ID_LOCACION],[PROVINCIA],[CANTON],[DISTRITO])
VALUES (24, 'Limon', 'Limon', 'Rio Blanco')

INSERT INTO [dbo].[LOCACION]([ID_LOCACION],[PROVINCIA],[CANTON],[DISTRITO])
VALUES (25, 'Heredia', 'Heredia', 'San Francisco')

GO

ALTER TABLE departamento NOCHECK CONSTRAINT  departamento_jefatura_fk;
Go

INSERT INTO [dbo].[DEPARTAMENTO]([ID_DEPARTAMENTO],[NOMBRE_DEPARTAMENTO],[ID_JEFATURA])
VALUES (31, 'IT', 102)

INSERT INTO [dbo].[DEPARTAMENTO]([ID_DEPARTAMENTO],[NOMBRE_DEPARTAMENTO],[ID_JEFATURA])
VALUES (32, 'Contabilidad', 102)

INSERT INTO [dbo].[DEPARTAMENTO]([ID_DEPARTAMENTO],[NOMBRE_DEPARTAMENTO],[ID_JEFATURA])
VALUES (33, 'Recursos Humanos', 102)

INSERT INTO [dbo].[DEPARTAMENTO]([ID_DEPARTAMENTO],[NOMBRE_DEPARTAMENTO],[ID_JEFATURA])
VALUES (34, 'Servicioa Cliente', 102)

INSERT INTO [dbo].[DEPARTAMENTO]([ID_DEPARTAMENTO],[NOMBRE_DEPARTAMENTO],[ID_JEFATURA])
VALUES (35, 'Operario', 102)

GO

INSERT INTO [dbo].[EMPLEADO]([CEDULA],[ID_EMPLEADO],[NOMBRE],[APELLIDO1],[APELLIDO2],[CORREO],[TELEFONO],[FEC_INGRESO],[FEC_SALIDA]
           ,[ID_PUESTO],[ID_JEFATURA],[ID_DEPARTAMENTO],[DIAS_VACACIONES],[TIPO_JORNADA],[TIPO_PERFIL],[ID_LOCACION])
     VALUES
           (11111111, 100, 'Juan', 'Rojas', 'Villalobos', 'juan@gmail.com', 88888881,'2020-12-15', null, 
		   11, null, 31,18,'NORMAL', 'FUNCIONARIO', 21)

INSERT INTO [dbo].[EMPLEADO]([CEDULA],[ID_EMPLEADO],[NOMBRE],[APELLIDO1],[APELLIDO2],[CORREO],[TELEFONO],[FEC_INGRESO],[FEC_SALIDA]
           ,[ID_PUESTO],[ID_JEFATURA],[ID_DEPARTAMENTO],[DIAS_VACACIONES],[TIPO_JORNADA],[TIPO_PERFIL],[ID_LOCACION])
     VALUES
           (11111112, 101, 'Maria', 'Madriz', 'Calvo', 'maria@gmail.com', 88888882,'2020-10-13', null, 
		   12, 100, 32,11,'NORMAL', 'ADMIN', 22)

INSERT INTO [dbo].[EMPLEADO]([CEDULA],[ID_EMPLEADO],[NOMBRE],[APELLIDO1],[APELLIDO2],[CORREO],[TELEFONO],[FEC_INGRESO],[FEC_SALIDA]
           ,[ID_PUESTO],[ID_JEFATURA],[ID_DEPARTAMENTO],[DIAS_VACACIONES],[TIPO_JORNADA],[TIPO_PERFIL],[ID_LOCACION])
     VALUES
           (11111113, 102, 'Carlos', 'Guerrero', 'Garcia', 'carlos@gmail.com', 88888883,'2015-10-13', null, 
		   13, 100, 33,2,'EXTENDIDA', 'VISTA', 23)

INSERT INTO [dbo].[EMPLEADO]([CEDULA],[ID_EMPLEADO],[NOMBRE],[APELLIDO1],[APELLIDO2],[CORREO],[TELEFONO],[FEC_INGRESO],[FEC_SALIDA]
           ,[ID_PUESTO],[ID_JEFATURA],[ID_DEPARTAMENTO],[DIAS_VACACIONES],[TIPO_JORNADA],[TIPO_PERFIL],[ID_LOCACION])
     VALUES
           (11111114, 103, 'Naty', 'Cordero', 'Cascante', 'naty@gmail.com', 88888884,'2011-10-13', null, 
		   14, 101, 34,9,'EXTENDIDA', 'JEFATURA', 24)
GO


INSERT INTO [dbo].[FEC_RESERVADAS]([ID_FECHA],[FECHA],[CONCEPTO])
     VALUES(NEXT VALUE FOR sequence_fec_reservadas,'2022-12-25', 'Navidad' )
INSERT INTO [dbo].[FEC_RESERVADAS]([ID_FECHA],[FECHA],[CONCEPTO])
     VALUES(NEXT VALUE FOR sequence_fec_reservadas,'2022-05-01', 'Dia Trabajador' )
INSERT INTO [dbo].[FEC_RESERVADAS]([ID_FECHA],[FECHA],[CONCEPTO])
     VALUES(NEXT VALUE FOR sequence_fec_reservadas,'2022-04-14', 'Jueves Santo' )
INSERT INTO [dbo].[FEC_RESERVADAS]([ID_FECHA],[FECHA],[CONCEPTO])
     VALUES(NEXT VALUE FOR sequence_fec_reservadas,'2022-04-15', 'Viernes Santo' )
INSERT INTO [dbo].[FEC_RESERVADAS]([ID_FECHA],[FECHA],[CONCEPTO])
     VALUES(NEXT VALUE FOR sequence_fec_reservadas,'2022-09-15', 'Dia Independencia' )
GO

INSERT INTO [dbo].[SOLICITUD]([ID_SOLICITUD],[FEC_SALIDA],[FEC_REGRESO],[FEC_SOLICITUD],[CONCEPTO],[ESTADO_SOL],[ID_EMPLEADO])
     VALUES 
		   (NEXT VALUE FOR sec_solicitud, '2022-6-9','2022-6-14','2022-6-9', 'Vacacion', 'PENDIENTE', 102)

INSERT INTO [dbo].[SOLICITUD]([ID_SOLICITUD],[FEC_SALIDA],[FEC_REGRESO],[FEC_SOLICITUD],[CONCEPTO],[ESTADO_SOL],[ID_EMPLEADO])
     VALUES 
		   (NEXT VALUE FOR sec_solicitud, '2022-6-9','2022-6-14','2022-6-9', 'Luto', 'APROBADA', 102)

INSERT INTO [dbo].[SOLICITUD]([ID_SOLICITUD],[FEC_SALIDA],[FEC_REGRESO],[FEC_SOLICITUD],[CONCEPTO],[ESTADO_SOL],[ID_EMPLEADO])
     VALUES 
		   (NEXT VALUE FOR sec_solicitud, '2022-6-9','2022-6-14','2022-6-9', 'Maternidad', 'PENDIENTE', 102)
INSERT INTO [dbo].[SOLICITUD]([ID_SOLICITUD],[FEC_SALIDA],[FEC_REGRESO],[FEC_SOLICITUD],[CONCEPTO],[ESTADO_SOL],[ID_EMPLEADO])
     VALUES 
		   (NEXT VALUE FOR sec_solicitud, '2022-6-9','2022-6-14','2022-6-9', 'Paternidad', 'PENDIENTE', 102)

INSERT INTO [dbo].[SOLICITUD]([ID_SOLICITUD],[FEC_SALIDA],[FEC_REGRESO],[FEC_SOLICITUD],[CONCEPTO],[ESTADO_SOL],[ID_EMPLEADO])
     VALUES 
		   (NEXT VALUE FOR sec_solicitud, '2022-6-9','2022-6-14','2022-6-9', 'Vacacion', 'PENDIENTE', 102)

INSERT INTO [dbo].[SOLICITUD]([ID_SOLICITUD],[FEC_SALIDA],[FEC_REGRESO],[FEC_SOLICITUD],[CONCEPTO],[ESTADO_SOL],[ID_EMPLEADO])
     VALUES 
		   (NEXT VALUE FOR sec_solicitud, '2022-6-9','2022-6-14','2022-6-9', 'Vacacion', 'PENDIENTE', 102)

INSERT INTO [dbo].[REINTEGRO]([ID_REINTEGRO],[ID_SOLICITUD],[DESCRIPCION],[ESTADO_REINTEGRO],[FEC_REINTEGRO])
     VALUES
           (NEXT VALUE FOR sec_reintegro, 301,'Evento ON CALL','PENDIENTE', GETDATE())

INSERT INTO [dbo].[REINTEGRO]([ID_REINTEGRO],[ID_SOLICITUD],[DESCRIPCION],[ESTADO_REINTEGRO],[FEC_REINTEGRO])
     VALUES
           (NEXT VALUE FOR sec_reintegro, 302,'Evento ON CALL','APROBADA', GETDATE())

INSERT INTO [dbo].[REINTEGRO]([ID_REINTEGRO],[ID_SOLICITUD],[DESCRIPCION],[ESTADO_REINTEGRO],[FEC_REINTEGRO])
     VALUES
           (NEXT VALUE FOR sec_reintegro, 303,'Evento ON CALL','RECHAZADA', GETDATE())

INSERT INTO [dbo].[REINTEGRO]([ID_REINTEGRO],[ID_SOLICITUD],[DESCRIPCION],[ESTADO_REINTEGRO],[FEC_REINTEGRO])
     VALUES
           (NEXT VALUE FOR sec_reintegro, 304,'Evento ON CALL','PENDIENTE', GETDATE())

GO

INSERT INTO [dbo].[empleado_aprobacion]([ID_EMP_APROBAR],[ID_EMP_PERMISO_APROBAR])
     VALUES(100,101)
INSERT INTO [dbo].[empleado_aprobacion]([ID_EMP_APROBAR],[ID_EMP_PERMISO_APROBAR])
     VALUES(100,101)
INSERT INTO [dbo].[empleado_aprobacion]([ID_EMP_APROBAR],[ID_EMP_PERMISO_APROBAR])
     VALUES(102,100)
INSERT INTO [dbo].[empleado_aprobacion]([ID_EMP_APROBAR],[ID_EMP_PERMISO_APROBAR])
     VALUES(103,102)
GO

INSERT INTO [dbo].[empleado_solicitar]([ID_EMP_SOLICITAR],[ID_EMP_PERMISO_SOLICITAR])
     VALUES(100,101)
INSERT INTO [dbo].[empleado_solicitar]([ID_EMP_SOLICITAR],[ID_EMP_PERMISO_SOLICITAR])
     VALUES(101,102)
INSERT INTO [dbo].[empleado_solicitar]([ID_EMP_SOLICITAR],[ID_EMP_PERMISO_SOLICITAR])
     VALUES(102,103)
GO

INSERT INTO [dbo].[fechas_locacion]([ID_FECHA_RESERVADA],[ID_LOCACION_A_RESERVAR])
     VALUES(81,21)
INSERT INTO [dbo].[fechas_locacion]([ID_FECHA_RESERVADA],[ID_LOCACION_A_RESERVAR])
     VALUES(82,22)
INSERT INTO [dbo].[fechas_locacion]([ID_FECHA_RESERVADA],[ID_LOCACION_A_RESERVAR])
     VALUES(83,23)
INSERT INTO [dbo].[fechas_locacion]([ID_FECHA_RESERVADA],[ID_LOCACION_A_RESERVAR])
     VALUES(84,24)
GO


ALTER TABLE departamento CHECK CONSTRAINT  departamento_jefatura_fk;
Go


--------------------- SELECTS DE PRUEBA DE CADA TABLA ---------------------

---- SELECT DE LOS DEPARTAMENTOS ----

--SELECT TOP (1000) [ID_DEPARTAMENTO]
--      ,[NOMBRE_DEPARTAMENTO]
--      ,[ID_JEFATURA]
--  FROM [db1].[dbo].[DEPARTAMENTO]

---- SELECT DE LOS EMPLEADOS ----

--SELECT TOP (1000) [CEDULA]
--      ,[ID_EMPLEADO]
--      ,[NOMBRE]
--      ,[APELLIDO1]
--      ,[APELLIDO2]
--      ,[CORREO]
--      ,[TELEFONO]
--      ,[FEC_INGRESO]
--      ,[FEC_SALIDA]
--      ,[ID_PUESTO]
--      ,[ID_JEFATURA]
--      ,[ID_DEPARTAMENTO]
--      ,[DIAS_VACACIONES]
--      ,[TIPO_JORNADA]
--      ,[TIPO_PERFIL]
--      ,[ID_LOCACION]
--  FROM [db1].[dbo].[EMPLEADO]

---- SELECT DE LAS FECHAS RESERVADAS ----

--SELECT TOP (1000) [ID_FECHA]
--      ,[FECHA]
--      ,[CONCEPTO]
--  FROM [db1].[dbo].[FEC_RESERVADAS]

---- SELECT DE LOS PUESTOS ----

--SELECT TOP (1000) [ID_PUESTO]
--      ,[NOMBRE_PUESTO]
--      ,[SALARIO_MIN]
--      ,[SALARIO_MAX]
--  FROM [db1].[dbo].[PUESTO]

---- SELECT DE LAS LOCACIONES ----

--SELECT TOP (1000) [ID_LOCACION]
--      ,[PROVINCIA]
--      ,[CANTON]
--      ,[DISTRITO]
--  FROM [db1].[dbo].[LOCACION]

---- SELECT DE LAS SOLICITUDES ----

--SELECT TOP (1000) [ID_SOLICITUD]
--      ,[FEC_SALIDA]
--      ,[FEC_REGRESO]
--      ,[FEC_SOLICITUD]
--      ,[CONCEPTO]
--      ,[ESTADO_SOL]
--      ,[ID_EMPLEADO]
--  FROM [db1].[dbo].[SOLICITUD]

---- SELECT DE LOS REINTEGROS ----

--SELECT TOP (1000) [ID_REINTEGRO]
--      ,[ID_SOLICITUD]
--      ,[DESCRIPCION]
--      ,[ESTADO_REINTEGRO]
--      ,[FEC_REINTEGRO]
--  FROM [db1].[dbo].[REINTEGRO]

---- TABLA INTERMEDIA (EMPLEADOS CON PERMISO DE APROBACION DE VACACIONES) ----

--SELECT TOP (1000) [ID_EMP_APROBAR]
--      ,[ID_EMP_PERMISO_APROBAR]
--  FROM [db1].[dbo].[empleado_aprobacion]

---- TABLA INTERMEDIA (EMPLEADOS CON PERMISO DE SOLICITAR VACACIONES A OTROS FUNCIONARIOS) ----

--SELECT TOP (1000) [ID_EMP_SOLICITAR]
--      ,[ID_EMP_PERMISO_SOLICITAR]
--  FROM [db1].[dbo].[empleado_solicitar]

---- TABLA INTERMEDIA (FECHAS RESERVADAS POR LOCACION) ----

--SELECT TOP (1000) [ID_FECHA_RESERVADA]
--      ,[ID_LOCACION_A_RESERVAR]
--  FROM [db1].[dbo].[fechas_locacion]


--- PROCEDIMIENTO INSERTAR EN SOLICITUD ---
DROP PROCEDURE [dbo].prc_ins_solicitud;
go

CREATE PROCEDURE [dbo].prc_ins_solicitud  

       @PFecha_salida                     DATE, 
       @PFecha_regreso                    DATE, 
	   @PConcepto                       VARCHAR(20),
	   @PEstado_sol                     VARCHAR(20),
	   @PId_empleado                        INT
AS 
BEGIN 
     SET NOCOUNT ON 
INSERT INTO [dbo].[SOLICITUD]([ID_SOLICITUD],[FEC_SALIDA],[FEC_REGRESO],[FEC_SOLICITUD],[CONCEPTO],[ESTADO_SOL],[ID_EMPLEADO])
     VALUES 
		   (NEXT VALUE FOR sec_solicitud, @PFecha_salida,@PFecha_regreso,GETDATE(), @PConcepto , @PEstado_sol , @PId_empleado)
END 
GO

EXEC dbo.prc_ins_solicitud '2022-6-9','2022-6-14', 'Vacacion', 'APROBADA', 102;
GO

--- PROCEDIMIENTO ACTUALIZAR  SOLICITUD ---
DROP PROCEDURE [dbo].prc_act_solicitud;
go

CREATE PROCEDURE [dbo].prc_act_solicitud
       @PId_solicitud                      INT, 
       @PFecha_salida                     DATE, 
       @PFecha_regreso                    DATE, 
	   @PConcepto                       VARCHAR(20),
	   @PEstado_sol                     VARCHAR(20),
	   @PId_empleado                        INT
AS
BEGIN
       SET NOCOUNT ON;

       UPDATE [dbo].[SOLICITUD] SET 
	   [FEC_SALIDA] = @PFecha_salida, [FEC_REGRESO] = @PFecha_regreso,
	   [FEC_SOLICITUD] = GETDATE(), [CONCEPTO] = @PConcepto, [ESTADO_SOL] = @PEstado_sol,
	   [ID_EMPLEADO] = @PId_empleado
	   WHERE ID_SOLICITUD = @PId_solicitud
END
go


EXEC dbo.prc_act_solicitud 305, '2020-1-1','2020-1-1', 'Sabatico', 'APROBADA', 102;
go

--- PROCEDIMIENTO ELIMINAR SOLICITUD ---
DROP PROCEDURE [dbo].prc_bor_solicitud;
go
CREATE PROCEDURE [dbo].prc_bor_solicitud
       @PId_solicitud   INT
AS
BEGIN
       SET NOCOUNT ON;
       DELETE [dbo].[SOLICITUD] WHERE ID_SOLICITUD = @PId_solicitud
END
go

EXEC dbo.prc_bor_solicitud 300;
go

-- PROCEDIMIENTO INSERTAR EN REINTEGRO ---
DROP PROCEDURE [dbo].prc_ins_reintegro;
go

CREATE PROCEDURE [dbo].prc_ins_reintegro
       @PId_solicitud                     INT, 
       @PDescripcion                     VARCHAR(20), 
       @PEstado_reintegro                VARCHAR(20)
AS 
BEGIN 
     SET NOCOUNT ON 
INSERT INTO [dbo].[REINTEGRO]([ID_REINTEGRO],[ID_SOLICITUD],[DESCRIPCION],[ESTADO_REINTEGRO],[FEC_REINTEGRO])
     VALUES
           (NEXT VALUE FOR sec_reintegro, @PId_solicitud,@PDescripcion, @PEstado_reintegro, GETDATE())
END 
GO

EXEC dbo.prc_ins_reintegro 305,'Evento ON CALL','RECHAZADA';
GO

--- PROCEDIMIENTO ACTUALIZAR  REINTEGRO ---
DROP PROCEDURE [dbo].prc_act_reintegro;
go


CREATE PROCEDURE [dbo].prc_act_reintegro
	   @PId_reintegro                     INT,
       @PId_solicitud                     INT, 
       @PDescripcion                      VARCHAR(20), 
       @PEstado_reintegro                 VARCHAR(20)
AS
BEGIN
      SET NOCOUNT ON
	  UPDATE [dbo].[REINTEGRO] SET 
      [ID_SOLICITUD] = @PId_solicitud, [DESCRIPCION] = @PDescripcion,
	  [ESTADO_REINTEGRO] = @PEstado_reintegro, [FEC_REINTEGRO] = GETDATE()
	  WHERE [ID_REINTEGRO] = @PId_reintegro

END
go

EXEC dbo.prc_act_reintegro 401,306, 'Emergencia', 'Pendiente';
GO

--- PROCEDIMIENTO ELIMINAR REINTEGRO ---
DROP PROCEDURE [dbo].prc_bor_reintegro;
go
CREATE PROCEDURE [dbo].prc_bor_reintegro
       @PId_reintegro   INT
AS
BEGIN
       SET NOCOUNT ON;
       DELETE [dbo].[REINTEGRO] WHERE ID_REINTEGRO = @PId_reintegro
END
go

EXEC dbo.prc_bor_reintegro 400;
go

--PROCEDIMIENTO INSERTAR FECHAS_LOCACION
DROP PROCEDURE [dbo].prc_ins_fec_locacion;
GO

CREATE PROCEDURE [dbo].prc_ins_fec_locacion
		@PIdFecha					int,
		@PIdLocacion				int
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO [dbo].fechas_locacion([ID_FECHA_RESERVADA],[ID_LOCACION_A_RESERVAR])
	VALUES (@PIdFecha, @PIdLocacion);
END
GO

--PROCEDIMIENTO INSERTAR FECHAS RESERVADAS
DROP PROCEDURE [dbo].prc_ins_fec_reservadas;
GO

CREATE PROCEDURE [dbo].prc_ins_fec_reservadas
		@PFecha							DATE,
		@PConcepto						VARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON
	INSERT INTO [dbo].FEC_RESERVADAS([ID_FECHA],[FECHA],[CONCEPTO])
	VALUES	(NEXT VALUE FOR sequence_fec_reservadas, @PFecha, @PConcepto);
END
GO

EXEC dbo.prc_ins_fec_reservadas '2022-08-15', 'Dia de las Madres';

--PROCEDIMIENTO UPDATE FECHAS RESERVADAS
DROP PROCEDURE [dbo].prc_upd_fec_reservadas;
GO

CREATE PROCEDURE [dbo].prc_upd_fec_reservadas
		@PIdFecha							INT,
		@PFecha							DATE,
		@PConcepto						VARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON
	UPDATE dbo.FEC_RESERVADAS 
	SET FECHA = @PFecha, CONCEPTO = @PConcepto
	WHERE dbo.FEC_RESERVADAS.ID_FECHA = @PIdFecha;
END
GO

EXEC dbo.prc_upd_fec_reservadas 86, '2022-06-19','Prueba';

--PROCEDIMIENTO ELIMINAR FECHAS RESERVADAS
DROP PROCEDURE [dbo].prc_del_fec_reservadas;
GO

CREATE PROCEDURE [dbo].prc_del_fec_reservadas
		@PIdFecha							INT
AS
BEGIN
	SET NOCOUNT ON
	DELETE FROM dbo.FEC_RESERVADAS 
	WHERE dbo.FEC_RESERVADAS.ID_FECHA = @PIdFecha;
END
GO

EXEC dbo.prc_del_fec_reservadas 86;


Print 'VISTA - 1'

--drop view  rep_saldo_dias_departamento;
--go

--create view rep_saldo_dias_departamento as
--select a.NOMBRE_DEPARTAMENTO NOM_DEP, b.DIAS_VACACIONES
--from   DEPARTAMENTO a, EMPLEADO b
--where  a.ID_DEPARTAMENTO = b.ID_DEPARTAMENTO;
--go

--select * from  rep_saldo_dias_departamento;


Print 'VISTA - 2'
Print 'VISTA - 3'
Print 'FUNCION - 1'
Print 'FUNCION - 2'
Print 'FUNCION - 3'
Print 'PROCEDIMIENTO - 1'

--PROCEDIMIENTO INSERTAR TABLA REINTEGRO SOLO SI EL ESTADO DE SOLICITUD ESTA APROBADO
DROP PROCEDURE [dbo].prc_ins_reintegro_aprob;
go

CREATE PROCEDURE [dbo].prc_ins_reintegro_aprob
		@PId_Solicitud					INT,
		@PDescripcion					VARCHAR(40),
		@PFechaReintegro				DATE
AS
DECLARE @VEstado_sol AS varchar(20);
BEGIN
		SELECT @VEstado_sol =  s.ESTADO_SOL
		FROM [dbo].SOLICITUD AS s
		WHERE s.ID_SOLICITUD = @PId_Solicitud;

		IF @VEstado_sol = 'APROBADA' 
			INSERT INTO [dbo].[REINTEGRO]([ID_REINTEGRO],[ID_SOLICITUD],[ESTADO_REINTEGRO],[DESCRIPCION],[FEC_REINTEGRO])
			VALUES (NEXT VALUE FOR sec_reintegro, @PId_Solicitud, 'PENDIENTE', @PDescripcion, @PFechaReintegro)
		ELSE 
			RAISERROR('No se puede crear un reintegro de una solicitud que no este aprobada',16,1);
END
GO

EXEC dbo.prc_ins_reintegro_aprob 304, 'Prueba', '2022-06-19';
EXEC dbo.prc_ins_reintegro_aprob 301, 'Prueba', '2022-06-19';

Print 'PROCEDIMIENTO - 2'

--PROCEDIMIENTO INSERTAR TABLA USUARIOS_SOLICITAR
--Verificar que Id_Empleado_A_Solicitar no sea el mismo que ID_Empleado_Permisos_Solicitar para poder realizar un insert 
DROP PROCEDURE [dbo].prc_ins_usuarios_solicitar;
go

CREATE PROCEDURE [dbo].prc_ins_usuarios_solicitar
		@PId_Emp_Permisos_Solicitar					INT,
		@PId_Emp_Solicitar							INT
AS
BEGIN
		IF @PId_Emp_Permisos_Solicitar <> @PId_Emp_Solicitar
			INSERT INTO [dbo].empleado_solicitar([ID_EMP_SOLICITAR],[ID_EMP_PERMISO_SOLICITAR])
			VALUES (@PId_Emp_Solicitar,@PId_Emp_Permisos_Solicitar);
		ELSE 
			RAISERROR('El id del empleado a solicitar no puede ser el mismo a empleado que se le solicita permiso',16,1);
END
GO

EXEC dbo.prc_ins_usuarios_solicitar 100,101;
EXEC dbo.prc_ins_usuarios_solicitar 101,101;


Print 'PROCEDIMIENTO - 3'
Print 'TRIGGER - 1'
Print 'TRIGGER - 2'
Print 'TRIGGER - 3'