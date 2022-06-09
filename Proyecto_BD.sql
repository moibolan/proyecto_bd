use db1
go

DROP TABLE [dbo].[REINTEGRO]
GO
DROP TABLE [dbo].[SOLICITUD]
GO
DROP TABLE [dbo].[EMPLEADO]
GO
DROP TABLE [dbo].[PUESTO]
GO
DROP TABLE [dbo].[LOCACION]
GO
DROP TABLE [dbo].[DEPARTAMENTO]
GO


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
  FEC_SALIDA DATE NOT NULL,
  ID_PUESTO INT NOT NULL,
  ID_JEFATURA INT NOT NULL,
  ID_DEPARTAMENTO INT NOT NULL,
  DIAS_VACACIONES INT NOT NULL,
  ID_LOCATION INT NOT NULL,
  TIPO_JORNADA INT NOT NULL,
  TIPO_PERFIL VARCHAR(20) NOT NULL,
  ID_LOCACION INT NOT NULL,
  PRIMARY KEY (ID_EMPLEADO),
  FOREIGN KEY (ID_PUESTO) REFERENCES PUESTO(ID_PUESTO),
  FOREIGN KEY (ID_DEPARTAMENTO) REFERENCES DEPARTAMENTO(ID_DEPARTAMENTO),
  FOREIGN KEY (ID_LOCACION) REFERENCES LOCACION(ID_LOCACION),
  UNIQUE (CEDULA)
);
go

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
  ESTADO_SOLICITUD VARCHAR(20) NOT NULL,
  FEC_REINTEGRO DATE NOT NULL,
  PRIMARY KEY (ID_REINTEGRO),
  FOREIGN KEY (ID_SOLICITUD) REFERENCES SOLICITUD(ID_SOLICITUD)
);

GO