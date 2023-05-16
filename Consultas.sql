-- Año: 2023
-- Grupo: 11
-- Integrantes: Kameyha Facundo, Sebastian Contreras
-- Tema: Veterinaria
-- Nombre del Esquema: LBD2023G11Veterinaria
-- Plataforma (SO + Versión): Windows 10 Home 10.0.19044 compilación 19044
-- Motor y Versión: MySQL Server 8 (Community Edition)
-- GitHub Repositorio: LBD2023G11
-- GitHub Usuarios: KameyhaFacundo, sebastian-contreras

-- 1. Dado una persona , mostrar sus turnos (fecha y hora) entre un rango de fechas. Ordenar
-- según la fecha en orden cronológico inverso, y luego según la hora en orden cronológico.

	SELECT p.DNI,p.Nombre,p.Apellido,p.Telefono,p.Email,p.Direccion,c.Fecha,c.Consultorio,c.Veterinario_DNI,c.Mascota_idMascota
	FROM Personas p JOIN Citas c
	ON p.DNI = c.Mascota_Cliente_DNI WHERE p.DNI = '67891234' AND fecha BETWEEN '2023-03-01' AND '2023-05-30'  -- between verifica q este en ese rango.
	ORDER BY c.Fecha DESC;
    
    -- Orden Cronologico por hora
    
SELECT p.DNI,p.Nombre,p.Apellido,p.Telefono,p.Email,p.Direccion,c.Fecha,c.Consultorio,c.Veterinario_DNI,c.Mascota_idMascota
	FROM Personas p JOIN Citas c
	ON p.DNI = c.Mascota_Cliente_DNI WHERE p.DNI = '67891234' AND fecha BETWEEN '2023-03-01' AND '2023-05-30'  -- between verifica q este en ese rango.
	ORDER BY TIME(c.Fecha) ASC;

-- 2. Realizar un listado de todos los empleados. Mostrar apellido, nombre, dni, email, y rol.
-- Ordenar el listado alfabéticamente por apellido y nombre.

	SELECT p.Apellido,p.Nombre,p.Dni,p.Email,p.Rol
	FROM Personas AS p
	WHERE p.Rol='Empleado' or p.Rol='Veterinario' or p.Rol='Administrador'
	ORDER BY Apellido ASC, Nombre ASC;

-- 3. Dado un empleado, mostrar las ventas que hizo entre un rango de fechas. Mostrar el dni
-- del empleado, fecha de la venta, tipo de servicio, precio del mismo y total de la venta.
-- Ordenar cronológicamente
    SELECT p.DNI,v.Fecha,v.Servicio,SUM(lv.PrecioUnidad*lv.Cantidad) AS 'Total'
    FROM Personas as p JOIN Ventas as v ON p.DNI = v.Vendedor_DNI 
    JOIN LineaDeVentas as lv ON v.idVentas = lv.idVentas
    WHERE p.DNI='54321098' AND v.Fecha BETWEEN '2023-03-01' AND '2023-04-30'
    GROUP BY v.idVentas
    ORDER BY v.Fecha ASC;
    
-- FALTA PONER QUIEN HACE LA VENTA ????
-- TIPO DE SERVICIO?


-- 4. Dada una cita mostrar el historial
	SELECT c.idCita,h.idHistoria,h.Citas_Mascota_idMascota,h.Citas_Mascota_Cliente_DNI AS 'DNI Cliente',h.Citas_Veterinario_DNI AS 'DNI Veterinario',h.Titulo,h.Descripcion,h.Imagenes 
	FROM Historias h JOIN Citas c
	ON c.idCita=h.Citas_idCita WHERE c.idCita=3;

-- 5. Hacer un ranking con los clientes que más turnos reservaron entre un rango de fechas.
-- Mostrar cliente y la cantidad de turnos.

	SELECT 
		Personas.Apellido,
		Personas.Nombre,
		Personas.Telefono,
		Personas.Email,
		Personas.Direccion,
		Personas.DNI,
		COUNT(*) AS TOTAL_TURNOS
	FROM Personas join Citas on Personas.DNI = Citas.Mascota_Cliente_DNI
	WHERE Citas.Fecha between'2023-02-01' AND '2023-06-30'
	GROUP BY Personas.DNI
	ORDER BY TOTAL_TURNOS DESC;
    


-- 6. Hacer un ranking con todos los insumos que más ventas tuvieron. Mostrar el nombre del
-- insumo y la cantidad de ventas. Mostrar en 0 los que nunca se vendieron.

    SELECT i.Insumo, IFNULL(SUM(lv.Cantidad),0) as 'Total de Ventas'
    FROM LineaDeVentas as lv RIGHT JOIN Insumos as i ON lv.idInsumos = i.idInsumos
    GROUP BY i.IdInsumos
    ORDER BY SUM(lv.Cantidad) DESC;
    
-- 7. Hacer un ranking con los horarios más usados para los turnos.
-- CORREGIR
	SELECT Time(Fecha), COUNT(Time(Fecha)) as 'Total de citas' 
    FROM Citas
    GROUP BY Time(Fecha) ORDER BY COUNT(Time(Fecha)) DESC;
	
-- 8. Crear una vista con la funcionalidad del apartado 3.
	DROP VIEW IF EXISTS ventasEmpleado;

	CREATE VIEW ventasEmpleado AS
     SELECT p.DNI,v.Fecha,v.Servicio,SUM(lv.PrecioUnidad*lv.Cantidad) AS 'Total'
    FROM Personas as p JOIN Ventas as v ON p.DNI = v.Vendedor_DNI 
    JOIN LineaDeVentas as lv ON v.idVentas = lv.idVentas
    WHERE p.DNI=54321098 AND v.Fecha BETWEEN '2023-03-01' AND '2023-04-30'
    GROUP BY v.idVentas
    ORDER BY v.Fecha ASC;
    
    SELECT * FROM ventasEmpleado;

-- 9. Crear una copia de la tabla “Cita”, llamada “CitaJSON”, que tenga una columna del tipo
-- JSON para guardar el historial. Llenar esta tabla con los mismos datos del TP1 y resolver la
-- consulta del apartado 4 (ambas consultas deben presentar la misma salida).

-- Creacion de tabla CitasJson

CREATE TABLE IF NOT EXISTS `LBD2023G11Veterinaria`.`CitasJson` (
  `idCitaJson` INT NOT NULL AUTO_INCREMENT,
  `Mascota_idMascota` INT NOT NULL,
  `Mascota_Cliente_DNI` INT NOT NULL,
  `Veterinario_DNI` INT NOT NULL,
  `Fecha` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Consultorio` ENUM('A1', 'A2', 'A3', 'A4', 'A5') NOT NULL,
  `Monto` FLOAT NOT NULL CHECK (Monto > 0),  -- Agrego restriccion de monto >0
  `Historia` JSON,
  PRIMARY KEY (`idCitaJson`, `Mascota_idMascota`, `Mascota_Cliente_DNI`, `Veterinario_DNI`),
  INDEX `fk_CitaJson_Personas1_idx` (`Veterinario_DNI` ASC),
  INDEX `fk_CitaJson_Mascotas1_idx` (`Mascota_idMascota` ASC, `Mascota_Cliente_DNI` ASC),
  CONSTRAINT `fk_CitaJson_Personas1`
    FOREIGN KEY (`Veterinario_DNI`)
    REFERENCES `LBD2023G11Veterinaria`.`Personas` (`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CitaJson_Mascotas1`
    FOREIGN KEY (`Mascota_idMascota` , `Mascota_Cliente_DNI`)
    REFERENCES `LBD2023G11Veterinaria`.`Mascotas` (`idMascotas` , `Personas_DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- Agrego datos CitasJson
-- -------------------------------------------------
-- Inserccion de citas
-- -----------------------------------------------

    INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (1, '14456672', '40899365', '2023-04-22 15:30:00', 'A3', 150.0
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo","Historia 1"),JSON_OBJECT("Descripcion","Esta es la descripción de la historia 1"),JSON_OBJECT("Imagenes","imagen1")
));
    INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (2, '31567788', '25781234', '2023-04-22 10:00:00', 'A2', 35.0
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo","Historia 2"),JSON_OBJECT("Descripcion","Esta es la descripción de la historia 2"),JSON_OBJECT("Imagenes",NULL)
));
    INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (3, '25567344', '40523123', '2023-04-22 12:00:00', 'A4', 25.0
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo","Historia 3"),JSON_OBJECT("Descripcion","Esta es la descripción de la historia 3"),JSON_OBJECT("Imagenes",NULL)
));
    INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (4, '38768990', '18765432', '2023-04-23 09:00:00', 'A5', 60.0
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo","Historia 4"),JSON_OBJECT("Descripcion","Esta es la descripción de la historia 4"),JSON_OBJECT("Imagenes",NULL)
));
    INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (5, '29874216', '31987654', '2023-04-23 10:00:00', 'A1', 45.0
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo","Historia 5"),JSON_OBJECT("Descripcion","Esta es la descripción de la historia 5"),JSON_OBJECT("Imagenes",NULL)
));
    INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (6, '40899365', '67891234', '2023-04-23 11:00:00', 'A2', 80.0
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo","Historia 6"),JSON_OBJECT("Descripcion","Esta es la descripción de la historia 6"),JSON_OBJECT("Imagenes","imagen2")
));
    INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (7, '25781234', '67893456', '2023-04-23 12:00:00', 'A3', 15.0
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo","Historia 7"),JSON_OBJECT("Descripcion","Esta es la descripción de la historia 7"),JSON_OBJECT("Imagenes",NULL)
));
    INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (8, '40523123', '14456672', '2023-04-24 09:00:00', 'A4', 50.0
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo","Historia 8"),JSON_OBJECT("Descripcion","Esta es la descripción de la historia 8"),JSON_OBJECT("Imagenes",NULL)
));
    INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (9, '18765432', '31567788', '2023-04-24 10:00:00', 'A5', 35.0
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo","Historia 9"),JSON_OBJECT("Descripcion","Esta es la descripción de la historia 9"),JSON_OBJECT("Imagenes",NULL)
));
    INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (10, 31987654, 45678234, '2023-05-15 10:30:00', 'A1', 50.00
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo","Historia 1"),JSON_OBJECT("Descripcion","Esta es la descripción de la historia 1"),JSON_OBJECT("Imagenes","imagen1")
));
	INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (11, 43789123, 67893456, '2023-05-15 11:15:00', 'A2', 60.00
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo","Historia 2"),JSON_OBJECT("Descripcion","Esta es la descripción de la historia 2"),JSON_OBJECT("Imagenes",NULL)
));
	INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (12, 30657891, 38976543, '2023-05-16 13:00:00', 'A3', 55.00
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo","Historia 3"),JSON_OBJECT("Descripcion","Esta es la descripción de la historia 3"),JSON_OBJECT("Imagenes",NULL)
));
	INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (13, 23981234, 24987654, '2023-05-16 14:30:00', 'A4', 65.00
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo","Historia 4"),JSON_OBJECT("Descripcion","Esta es la descripción de la historia 4"),JSON_OBJECT("Imagenes",NULL)
));
	INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (14, 39456789, 67893456, '2023-05-17 15:45:00', 'A1', 50.00
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo","Historia 5"),JSON_OBJECT("Descripcion","Esta es la descripción de la historia 5"),JSON_OBJECT("Imagenes",NULL)
));
	INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (15, 45678234, 45678234, '2023-05-17 16:30:00', 'A2', 60.00
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo","Historia 6"),JSON_OBJECT("Descripcion","Esta es la descripción de la historia 6"),JSON_OBJECT("Imagenes","imagen2")
));
	INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (16, 24987654, 67891234, '2023-05-18 10:00:00', 'A1', 55.00
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo","Historia 7"),JSON_OBJECT("Descripcion","Esta es la descripción de la historia 7"),JSON_OBJECT("Imagenes",NULL)
));
	INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (17, 67893456, 45678234, '2023-05-18 11:15:00', 'A3', 65.00
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo","Historia 8"),JSON_OBJECT("Descripcion","Esta es la descripción de la historia 8"),JSON_OBJECT("Imagenes",NULL)
));
	INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (18, 38976543, 67893456, '2023-05-19 14:00:00', 'A2', 50.00
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo","Historia 9"),JSON_OBJECT("Descripcion","Esta es la descripción de la historia 9"),JSON_OBJECT("Imagenes",NULL)
));
	INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (19, 67891234, 24987654, '2023-03-19 16:30:00', 'A4', 60.00
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo",NULL),JSON_OBJECT("Descripcion",NULL),JSON_OBJECT("Imagenes",NULL)
));
    INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (19, 67891234, 24987654, '2023-05-12 13:30:00', 'A4', 60.00
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo",NULL),JSON_OBJECT("Descripcion",NULL),JSON_OBJECT("Imagenes",NULL)
));
    INSERT INTO CitasJson (Mascota_idMascota, Mascota_Cliente_DNI, Veterinario_DNI, Fecha, Consultorio, Monto,Historia)
VALUES (19, 67891234, 24987654, '2023-03-01 18:30:00', 'A4', 60.00
,JSON_MERGE_PRESERVE(
JSON_OBJECT("Titulo",NULL),JSON_OBJECT("Descripcion",NULL),JSON_OBJECT("Imagenes",NULL)
));

-- Consulta 4

-- 4. Dada una cita mostrar el historial

    SELECT idCitaJson,Mascota_idMascota,Mascota_Cliente_DNI,Veterinario_DNI,Fecha,Consultorio,Monto
    ,JSON_UNQUOTE(JSON_EXTRACT(`Historia` , '$.Titulo')) AS 'Titulo'
    ,JSON_UNQUOTE(JSON_EXTRACT(`Historia` , '$.Descripcion')) AS 'Descripcion'
    ,JSON_UNQUOTE(JSON_EXTRACT(`Historia` , '$.Imagenes')) AS 'Imagenes'
    FROM CitasJson WHERE idCitaJson=3 ;



-- Consulta CitasJson
-- 10. Realizar una vista que considere importante para su modelo. También dejar escrito el
-- enunciado de la misma.
-- Enunciado: Mostrar la Historia Clinica de una mascota por su ID
	DROP VIEW IF EXISTS HistoriaClinicaMascota;

CREATE VIEW HistoriaClinicaMascota AS
SELECT m.idMascotas,m.Tipo,m.sexo,m.Mascota,m.Personas_DNI as 'Dueno',c.Fecha,h.Titulo,h.Descripcion,h.Imagenes FROM
Mascotas AS m JOIN Citas as c ON m.idMascotas = c.Mascota_idMascota
JOIN Historias as h ON m.idMascotas = h.Citas_Mascota_idMascota WHERE m.idMascotas=3;

SELECT * FROM HistoriaClinicaMascota;
-- Observaciones:
-- ● No incluir en el script sentencias que ejecuten procedimientos almacenados que no
-- cumplan con lo solicitado.
-- ● Si en el diseño de la BD hubiera cambios con respecto a lo presentado en el TP1,
-- incluirlos en el script. De igual forma en caso de necesitar más datos de los
-- generados en el TP1.
-- ● Respetar las mismas reglas del TP1 para los nombres de los archivos a subir al
-- repositorio, como así también los comentarios en el encabezado dentro del script.