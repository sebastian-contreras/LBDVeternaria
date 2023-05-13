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

	SELECT p.DNI,p.Nombre,p.Apellido,p.Telefono,p.Email,p.Direccion,p.Rol,p.Matricula,c.Fecha
	FROM Personas p JOIN Citas c
	WHERE p.DNI = c.Mascota_Cliente_DNI AND fecha BETWEEN '2023-04-22' AND '2023-05-22'  -- between verifica q este en ese rango.
	ORDER BY c.Fecha ASC;

-- Inverso
	SELECT p.DNI,p.Nombre,p.Apellido,p.Telefono,p.Email,p.Direccion,p.Rol,p.Matricula,c.Fecha
	FROM Personas p JOIN Citas c
	WHERE p.DNI = c.Mascota_Cliente_DNI AND fecha BETWEEN '2023-04-22' AND '2023-05-22'  -- between verifica q este en ese rango.
	ORDER BY c.Fecha DESC;

-- 2. Realizar un listado de todos los empleados. Mostrar apellido, nombre, dni, email, y rol.
-- Ordenar el listado alfabéticamente por apellido y nombre.

	SELECT *
	FROM Personas
	ORDER BY Apellido ASC, Nombre ASC;

-- 3. Dado un empleado, mostrar las ventas que hizo entre un rango de fechas. Mostrar el dni
-- del empleado, fecha de la venta, tipo de servicio, precio del mismo y total de la venta.
-- Ordenar cronológicamente.

-- FALTA PONER QUIEN HACE LA VENTA ????
-- TIPO DE SERVICIO?

SELECT Ventas.idVentas, Ventas.Personas_DNI, Ventas.Fecha,Insumos.Insumo,Insumos.precioRefVenta, 
SUM(Insumos.precioRefVenta) AS TOTAL
FROM (((Personas INNER JOIN Ventas ON Personas.DNI = Ventas.Personas_DNI) 
INNER JOIN LineaDeVentas ON LineaDeVentas.idVentas=Ventas.idVentas)  
INNER JOIN Insumos ON Insumos.idInsumos=LineaDeVentas.idInsumos) WHERE Personas.DNI='45678234' AND Ventas.Fecha BETWEEN '2023-04-14' AND '2023-04-18'  -- between verifica q este en ese rango.
GROUP BY Ventas.idVentas, Ventas.Personas_DNI, Ventas.Fecha, Insumos.Insumo, Insumos.precioRefVenta
ORDER BY Ventas.Fecha ASC;


-- 4. Dada una cita mostrar el historial
	SELECT c.idCita,h.idHistoria,h.Citas_Mascota_idMascota,h.Citas_Mascota_Cliente_DNI,h.Citas_Veterinario_DNI,h.Titulo,h.Descripcion,h.Imagenes 
	FROM Historias h JOIN Citas c
	ON c.idCita=h.Citas_idCita AND c.idCita=3;

-- 5. Hacer un ranking con los clientes que más turnos reservaron entre un rango de fechas.
-- Mostrar cliente y la cantidad de turnos.

	SELECT 
		Personas.Apellido,
		Personas.Nombre,
		Personas.Telefono,
		Personas.Email,
		Personas.Rol,
		Personas.Matricula,
		Personas.Direccion,
		Personas.DNI, 
		COUNT(*) AS TOTAL_TURNOS
	FROM Personas join Citas on Personas.DNI = Citas.Mascota_Cliente_DNI
	WHERE Citas.Fecha between'2023-04-22' AND '2023-05-18'
	GROUP BY Personas.DNI
	ORDER BY TOTAL_TURNOS DESC;

-- 6. Hacer un ranking con todos los insumos que más ventas tuvieron. Mostrar el nombre del
-- insumo y la cantidad de ventas. Mostrar en 0 los que nunca se vendieron.

    SELECT Insumos.Insumo, COUNT(Ventas.idVentas) AS TotalVentas
	FROM Insumos LEFT JOIN LineaDeVentas ON Insumos.idInsumos = LineaDeVentas.idInsumos
	LEFT JOIN Ventas ON LineaDeVentas.idVentas = Ventas.idVentas
	GROUP BY Insumos.Insumo
	ORDER BY TotalVentas DESC;
    
-- 7. Hacer un ranking con los horarios más usados para los turnos.
-- CORREGIR
	SELECT 
		Citas.idCita,
        Citas.Fecha,
        Citas.Consultorio,
        Citas.Monto,
        COUNT(Citas.Fecha) AS Horarios_Total
        FROM Citas
        GROUP BY Citas.Fecha
		ORDER BY Horarios_Total DESC

-- 8. Crear una vista con la funcionalidad del apartado 3.


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