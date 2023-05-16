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
	ORDER BY HOUR(c.Fecha) ASC;

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
    
    SELECT * FROM ventasEmpleado

-- 9. Crear una copia de la tabla “Cita”, llamada “CitaJSON”, que tenga una columna del tipo
-- JSON para guardar el historial. Llenar esta tabla con los mismos datos del TP1 y resolver la
-- consulta del apartado 4 (ambas consultas deben presentar la misma salida).



-- 10. Realizar una vista que considere importante para su modelo. También dejar escrito el
-- enunciado de la misma.

-- Observaciones:
-- ● No incluir en el script sentencias que ejecuten procedimientos almacenados que no
-- cumplan con lo solicitado.
-- ● Si en el diseño de la BD hubiera cambios con respecto a lo presentado en el TP1,
-- incluirlos en el script. De igual forma en caso de necesitar más datos de los
-- generados en el TP1.
-- ● Respetar las mismas reglas del TP1 para los nombres de los archivos a subir al
-- repositorio, como así también los comentarios en el encabezado dentro del script.