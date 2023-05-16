-- Año: 2023
-- Grupo: 11
-- Integrantes: Kameyha Facundo, Sebastian Contreras
-- Tema: Veterinaria
-- Nombre del Esquema: LBD2023G11Veterinaria
-- Plataforma (SO + Versión): Windows 10 Home 10.0.19044 compilación 19044
-- Motor y Versión: MySQL Server 8 (Community Edition)
-- GitHub Repositorio: LBD2023G11
-- GitHub Usuarios: KameyhaFacundo, sebastian-contreras


-- MySQL Script generated by MySQL Workbench
-- Fri Apr 21 19:20:23 2023
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema LBD2023G11Veterinaria
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LBD2023G11Veterinaria
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LBD2023G11Veterinaria` DEFAULT CHARACTER SET utf8 ;
USE `LBD2023G11Veterinaria` ;

-- -----------------------------------------------------
-- Table `LBD2023G11Veterinaria`.`Personas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2023G11Veterinaria`.`Personas` (
  `DNI` INT NOT NULL,
  `Nombre` VARCHAR(25) NOT NULL,
  `Apellido` VARCHAR(25) NOT NULL,
  `Telefono` VARCHAR(15) NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  `Rol` ENUM('Cliente', 'Veterinario', 'Administrador') NOT NULL DEFAULT 'Cliente',
  `Matricula` VARCHAR(45) NULL DEFAULT NULL,
  constraint privilegios CHECK(
    (Rol='Veterinario' AND Matricula IS NOT NULL) OR 
    (Rol='Cliente' AND Matricula IS NULL) OR 
    (Rol='Administrador' AND Matricula IS NULL)),
  `Direccion` TINYTEXT NULL,
  PRIMARY KEY (`DNI`),
  UNIQUE INDEX `Matricula_UNIQUE` (`Matricula` ASC),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LBD2023G11Veterinaria`.`Mascotas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2023G11Veterinaria`.`Mascotas` (
  `idMascotas` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(25) NOT NULL,
  `Edad` INT NOT NULL,
  `Tipo` ENUM('Perro', 'Gato', 'Pajaro','Pez','Hamster') NOT NULL ,
  `urlFoto` VARCHAR(2083) NOT NULL,
  `Personas_DNI` INT NOT NULL,
  `sexo` ENUM('Macho', 'Hembra') NOT NULL DEFAULT 'Macho',
  PRIMARY KEY (`idMascotas`, `Personas_DNI`),
  INDEX `fk_Mascotas_Personas1_idx` (`Personas_DNI` ASC),
  CONSTRAINT `fk_Mascotas_Personas1`
    FOREIGN KEY (`Personas_DNI`)
    REFERENCES `LBD2023G11Veterinaria`.`Personas` (`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LBD2023G11Veterinaria`.`Cita`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2023G11Veterinaria`.`Cita` (
  `idCita` INT NOT NULL AUTO_INCREMENT,
  `Fecha` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Consultorio` ENUM('A1', 'A2', 'A3', 'A4', 'A5') NOT NULL,
  `Monto` FLOAT NOT NULL CHECK (Monto > 0),  -- Agrego restriccion de monto >0
  `Veterinario_DNI` INT NOT NULL,
  `Mascotas_idMascotas` INT NOT NULL,
  `Mascotas_Cliente_DNI` INT NOT NULL,
  PRIMARY KEY (`idCita`, `Veterinario_DNI`, `Mascotas_idMascotas`, `Mascotas_Cliente_DNI`),
  INDEX `fk_Cita_Personas1_idx` (`Veterinario_DNI` ASC),
  INDEX `fk_Cita_Mascotas1_idx` (`Mascotas_idMascotas` ASC, `Mascotas_Cliente_DNI` ASC),
  CONSTRAINT `fk_Cita_Personas1`
    FOREIGN KEY (`Veterinario_DNI`)
    REFERENCES `LBD2023G11Veterinaria`.`Personas` (`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cita_Mascotas1`
    FOREIGN KEY (`Mascotas_idMascotas` , `Mascotas_Cliente_DNI`)
    REFERENCES `LBD2023G11Veterinaria`.`Mascotas` (`idMascotas` , `Personas_DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LBD2023G11Veterinaria`.`Historia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2023G11Veterinaria`.`Historia` (
  `idHistoria` INT NOT NULL AUTO_INCREMENT,
  `Titulo` VARCHAR(100) NOT NULL,
  `Descripcion` MEDIUMTEXT NOT NULL,
  `Imagenes` MEDIUMTEXT NULL,
  `Cita_idCita` INT NOT NULL,
  `Cita_Veterinario_DNI` INT NOT NULL,
  `Cita_Mascotas_idMascotas` INT NOT NULL,
  `Cita_Mascotas_Cliente_DNI` INT NOT NULL,
  PRIMARY KEY (`idHistoria`, `Cita_idCita`, `Cita_Veterinario_DNI`, `Cita_Mascotas_idMascotas`, `Cita_Mascotas_Cliente_DNI`),
  INDEX `fk_Historia_Cita1_idx` (`Cita_idCita` ASC, `Cita_Veterinario_DNI` ASC, `Cita_Mascotas_idMascotas` ASC, `Cita_Mascotas_Cliente_DNI` ASC),
  CONSTRAINT `fk_Historia_Cita1`
    FOREIGN KEY (`Cita_idCita` , `Cita_Veterinario_DNI` , `Cita_Mascotas_idMascotas` , `Cita_Mascotas_Cliente_DNI`)
    REFERENCES `LBD2023G11Veterinaria`.`Cita` (`idCita` , `Veterinario_DNI` , `Mascotas_idMascotas` , `Mascotas_Cliente_DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LBD2023G11Veterinaria`.`Provedores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2023G11Veterinaria`.`Provedores` (
  `CUIL` INT NOT NULL,
  `Direccion` TINYTEXT NOT NULL,
  `Telefono` VARCHAR(15) NOT NULL,
  `Estado` BIT(1) NOT NULL DEFAULT 1,
  `Email` VARCHAR(80) NOT NULL,
  `Nombre` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`CUIL`))
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `LBD2023G11Veterinaria`.`Compras`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2023G11Veterinaria`.`Compras` (
  `idCompras` INT NOT NULL AUTO_INCREMENT,
  `Fecha` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Provedores_CUIL` INT NOT NULL,
  PRIMARY KEY (`idCompras`, `Provedores_CUIL`),
  INDEX `fk_Compras_Provedores1_idx` (`Provedores_CUIL` ASC),
  CONSTRAINT `fk_Compras_Provedores1`
    FOREIGN KEY (`Provedores_CUIL`)
    REFERENCES `LBD2023G11Veterinaria`.`Provedores` (`CUIL`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LBD2023G11Veterinaria`.`Insumos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2023G11Veterinaria`.`Insumos` (
  `idInsumos` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(100) NOT NULL,
  `Cantidad` INT NOT NULL CHECK (Cantidad > 0) ,   -- Creacion de restriccion cantidad > 0
  `precioRefVenta` FLOAT NOT NULL CHECK (precioRefVenta > 0) ,   -- Creacion de restriccion precio de referencia > 0
  PRIMARY KEY (`idInsumos`))
ENGINE = InnoDB;

-- Agrego Indice Unique a tabla INSUMOS columna Nombre
ALTER TABLE `Insumos` ADD CONSTRAINT `U_InsumoNombre` UNIQUE (`Nombre`);

-- -----------------------------------------------------
-- Table `LBD2023G11Veterinaria`.`LineaDeCompras`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2023G11Veterinaria`.`LineaDeCompras` (
  `idLineaDeCompras` INT NOT NULL AUTO_INCREMENT,
  `idCompras` INT NOT NULL,
  `idInsumos` INT NOT NULL,
  `PrecioUnidad` FLOAT NOT NULL CHECK (PrecioUnidad > 0) ,   -- Creacion de restriccion precio unidad > 0
  `Cantidad` INT NOT NULL CHECK (Cantidad > 0), -- Creacion de restriccion cantidad > 0
  PRIMARY KEY (`idLineaDeCompras`, `idCompras`, `idInsumos`),
  INDEX `fk_LineaDeCompras_Insumos1_idx` (`idInsumos` ASC),
  CONSTRAINT `fk_LineaDeCompras_Compras1`
    FOREIGN KEY (`idCompras`)
    REFERENCES `LBD2023G11Veterinaria`.`Compras` (`idCompras`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LineaDeCompras_Insumos1`
    FOREIGN KEY (`idInsumos`)
    REFERENCES `LBD2023G11Veterinaria`.`Insumos` (`idInsumos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LBD2023G11Veterinaria`.`Ventas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2023G11Veterinaria`.`Ventas` (
  `idVentas` INT NOT NULL AUTO_INCREMENT,
  `Fecha` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Personas_DNI` INT NULL,
  PRIMARY KEY (`idVentas`),
  INDEX `fk_Ventas_Personas1_idx` (`Personas_DNI` ASC),
  CONSTRAINT `fk_Ventas_Personas1`
    FOREIGN KEY (`Personas_DNI`)
    REFERENCES `LBD2023G11Veterinaria`.`Personas` (`DNI`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LBD2023G11Veterinaria`.`LineaDeVentas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LBD2023G11Veterinaria`.`LineaDeVentas` (
  `idLineaDeVenta` INT NOT NULL AUTO_INCREMENT,
  `PrecioUnidad` FLOAT NOT NULL CHECK (PrecioUnidad > 0) ,   -- Creacion de restriccion precio unidad > 0
  `Cantidad` INT NOT NULL DEFAULT 1 CHECK (Cantidad > 0) ,   -- Creacion de restriccion cantidad > 0
  `idVentas` INT NOT NULL,
  `idInsumos` INT NOT NULL,
  PRIMARY KEY (`idLineaDeVenta`, `idVentas`, `idInsumos`),
  INDEX `fk_LineaDeVentas_Ventas1_idx` (`idVentas` ASC),
  INDEX `fk_LineaDeVentas_Insumos1_idx` (`idInsumos` ASC),
  CONSTRAINT `fk_LineaDeVentas_Ventas1`
    FOREIGN KEY (`idVentas`)
    REFERENCES `LBD2023G11Veterinaria`.`Ventas` (`idVentas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LineaDeVentas_Insumos1`
    FOREIGN KEY (`idInsumos`)
    REFERENCES `LBD2023G11Veterinaria`.`Insumos` (`idInsumos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- CONSULTAS
-- ----------------------------------------------------
-- inserccion de clientes
-- ----------------------------------------------------
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Rol,Matricula,Direccion) VALUES (13456672, 'Facundo', 'Kameyha','381345467','facKame@gmail.com','Cliente',NULL,'San Miguel de Tucumán');
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Direccion) VALUES (14456672, 'Sebastian', 'Contreras','381345467','sContreras@gmail.com','San Miguel de Tucumán');
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Direccion) VALUES (31567788, 'Maria', 'Gomez', '1145667889', 'mgomez@gmail.com', 'Av. Corrientes 1234');
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Direccion) VALUES (25567344, 'Lucas', 'Rodriguez', '2234567890', 'lrodriguez@yahoo.com', 'Av. Mitre 987');
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Direccion) VALUES (38768990, 'Carla', 'Lopez', '0114356899', 'clopez@hotmail.com', 'Calle 15 #456');
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Direccion) VALUES (29874216, 'Ana', 'González', '0112458796', 'ana.gonzalez@gmail.com', 'Av. Cabildo 1234, Buenos Aires');
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Direccion) VALUES (40899365, 'Javier', 'Martínez', '0345546789', 'jmartinez@hotmail.com', 'Calle San Martín 567, Córdoba');
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Direccion) VALUES (25781234, 'María', 'Gómez', '0221423658', 'mgomez@yahoo.com.ar', 'Calle Belgrano 789, La Plata');
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Direccion) VALUES (40523123, 'Juan', 'Pérez', '0299154678', 'jperez@hotmail.com', 'Av. San Martín 4321, Bariloche');
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Direccion) VALUES (18765432, 'Lucas', 'Ríos', '0261154789', 'lucasrios@gmail.com', 'Calle Sarmiento 123, Mendoza');
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Direccion) VALUES (31987654, 'Carla', 'López', '0223498576', 'clopez@gmail.com', 'Calle España 2345, Mar del Plata');
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Direccion) VALUES (43789123, 'Federico', 'Rodríguez', '0351156789', 'frodri@gmail.com', 'Av. 9 de Julio 567, Rosario');
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Direccion) VALUES (30657891, 'Sofía', 'Fernández', '0343154769', 'sfernandez@yahoo.com', 'Calle Mitre 876, Santa Fe');
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Direccion) VALUES (23981234, 'Tomás', 'Giménez', '0114748965', 'tgimenez@hotmail.com', 'Calle Rivadavia 2345, Buenos Aires');
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Direccion) VALUES (39456789, 'Valentina', 'García', '0223157890', 'vgarcia@yahoo.com', 'Av. Independencia 123, La Plata');
-- INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Rol,Matricula,Direccion) VALUES (15456672, 'Facundo', 'Kameyha','381345467','facKa@gmail.com','Cliente','2','San Miguel de Tucumán');
-- INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Rol,Matricula,Direccion) VALUES (15456672, 'Facundasdo', 'Kameyha','381345467','facKa@gmail.com','Administrador',NULL,'San Miguel de Tucumán');
-- ----------------------------------------------------
-- inserccion de Veterinarios
-- ----------------------------------------------------
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Rol,Matricula,Direccion) VALUES (45678234, 'Carla', 'Gomez', '3415567890', 'carla.gomez@gmail.com', 'Veterinario', '99876', 'Rosario');
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Rol,Matricula,Direccion) VALUES (24987654, 'Juan', 'Perez', '1145678901', 'juanperez@gmail.com', 'Veterinario', '76543', 'Ciudad de Buenos Aires');
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Rol,Matricula,Direccion) VALUES (67893456, 'Martina', 'Gonzalez', '2973456789', 'martina.gonzalez@gmail.com', 'Veterinario', '45678', 'Neuquén');
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Rol,Matricula,Direccion) VALUES (38976543, 'Lucas', 'Rodriguez', '2211234567', 'lucas.rodriguez@gmail.com', 'Veterinario', '65432', 'La Plata');
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Rol,Matricula,Direccion) VALUES (67891234, 'Camila', 'Lopez', '1149876543', 'camila.lopez@gmail.com', 'Veterinario', '11111', 'Ciudad de Buenos Aires');
-- ----------------------------------------------------
-- inserccion de Administrador
-- ----------------------------------------------------
INSERT INTO Personas (DNI,Nombre,Apellido,Telefono,Email,Rol,Direccion) VALUES (51523788, 'Administrador', 'Gomez', '12667889', 'admin@gmail.com','Administrador', 'Callera 123');
-- ----------------------------------------------------
-- inserccion de Mascostas
-- ----------------------------------------------------
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Toby', 3, 'Perro', 'https://example.com/toby.jpg', 13456672, 'Macho');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Luna', 2, 'Gato', 'https://example.com/luna.jpg', 14456672, 'Hembra');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Piolin', 1, 'Pajaro', 'https://example.com/piolin.jpg', 25567344, 'Macho');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Nemo', 1, 'Pez', 'https://example.com/nemo.jpg', 31567788, 'Macho');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Coco', 4, 'Hamster', 'https://example.com/coco.jpg', 38768990, 'Hembra');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Max', 2, 'Perro', 'https://example.com/max.jpg', 13456672, 'Macho');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Bella', 5, 'Gato', 'https://example.com/bella.jpg', 14456672, 'Hembra');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Tweety', 2, 'Pajaro', 'https://example.com/tweety.jpg', 25567344, 'Hembra');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Bubbles', 3, 'Pez', 'https://example.com/bubbles.jpg', 31567788, 'Hembra');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Whiskers', 1, 'Hamster', 'https://example.com/whiskers.jpg', 38768990, 'Macho');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Rocky', 4, 'Perro', 'https://example.com/rocky.jpg', 13456672, 'Macho');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Mimi', 3, 'Gato', 'https://example.com/mimi.jpg', 14456672, 'Hembra');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Paco', 2, 'Pajaro', 'https://example.com/paco.jpg', 25567344, 'Macho');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Chirpy', 1, 'Pajaro', 'https://example.com/chirpy.jpg', 31567788, 'Hembra');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Fluffy', 2, 'Hamster', 'https://example.com/fluffy.jpg', 38768990, 'Hembra');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Felix', 6, 'Gato', 'https://example.com/felix.jpg', 14456672, 'Macho');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Buddy', 3, 'Perro', 'https://example.com/buddy.jpg', 30657891, 'Macho');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Misty', 1, 'Gato', 'https://example.com/misty.jpg', 40899365, 'Hembra');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Tweety', 1, 'Pajaro', 'https://example.com/tweety.jpg', 31987654, 'Hembra');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Goldie', 2, 'Pez', 'https://example.com/goldie.jpg', 18765432, 'Hembra');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Dusty', 4, 'Hamster', 'https://example.com/dusty.jpg', 40523123, 'Macho');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Scooby', 6, 'Perro', 'https://example.com/scooby.jpg', 39456789, 'Macho');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Felix', 1, 'Gato', 'https://example.com/felix.jpg', 25781234, 'Macho');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Charlie', 5, 'Perro', 'https://example.com/charlie.jpg', 29874216, 'Macho');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Coco', 2, 'Hamster', 'https://example.com/coco.jpg', 23981234, 'Hembra');
INSERT INTO Mascotas (Nombre,Edad,Tipo,urlFoto,Personas_dni,sexo) VALUES ('Pippin', 1, 'Pajaro', 'https://example.com/pippin.jpg', 43789123, 'Macho');
-- ----------------------------------------------------
-- inserccion de Provedores
-- ----------------------------------------------------
INSERT INTO Provedores (CUIL,Direccion,Telefono,Estado,Email,Nombre) VALUES (201332201, 'San juan 139', '4943321',0, 'vacDog@gmail.com','VacDog');
INSERT INTO Provedores (CUIL,Direccion,Telefono,Email,Nombre) VALUES (201234567, 'Av. Italia 1234, Buenos Aires', '011-4798-1234', 'mascotaspremium@gmail.com', 'Mascotas Premium');
INSERT INTO Provedores (CUIL,Direccion,Telefono,Email,Nombre) VALUES (201987654, 'Calle San Martín 567, Córdoba', '0351-478-9123', 'veterinariaexpress@yahoo.com', 'Veterinaria Express');
INSERT INTO Provedores (CUIL,Direccion,Telefono,Email,Nombre) VALUES (202345678, 'Calle Belgrano 789, La Plata', '0221-498-4567', 'mascotasonline@gmail.com', 'Mascotas Online');
INSERT INTO Provedores (CUIL,Direccion,Telefono,Email,Nombre) VALUES (202432156, 'Av. San Martín 4321, Bariloche', '0294-456-7890', 'veterinariadelsur@hotmail.com', 'Veterinaria del Sur');
INSERT INTO Provedores (CUIL,Direccion,Telefono,Email,Nombre) VALUES (203456781, 'Calle España 2345, Mar del Plata', '0223-478-9156', 'veterinariamarina@yahoo.com', 'Veterinaria Marina');
INSERT INTO Provedores (CUIL,Direccion,Telefono,Email,Nombre) VALUES (203214567, 'Av. 9 de Julio 567, Rosario', '0341-498-4567', 'clinicaveterinariasanjose@hotmail.com', 'Clínica Veterinaria San José');
INSERT INTO Provedores (CUIL,Direccion,Telefono,Email,Nombre) VALUES (202345679, 'Calle Mitre 876, Santa Fe', '0342-456-7890', 'vetlife@hotmail.com', 'Vet Life');
INSERT INTO Provedores (CUIL,Direccion,Telefono,Email,Nombre) VALUES (202198765, 'Calle Rivadavia 2345, Buenos Aires', '011-4857-9012', 'mascotascity@yahoo.com', 'Mascotas City');
INSERT INTO Provedores (CUIL,Direccion,Telefono,Email,Nombre) VALUES (202345671, 'Av. Independencia 123, La Plata', '0221-478-9012', 'vetintegral@gmail.com', 'Vet Integral');
INSERT INTO Provedores (CUIL,Direccion,Telefono,Estado,Email,Nombre) VALUES (202345621, 'Calle San Luis 567, San Luis', '0266-478-9012', 1, 'clinicaveterinariasol@hotmail.com', 'Clínica Veterinaria Sol');
INSERT INTO Provedores (CUIL,Direccion,Telefono,Estado,Email,Nombre) VALUES (202134567, 'Av. Belgrano 789, Salta', '0387-498-1234', 0, 'mascotassalvajes@gmail.com', 'Mascotas Salvajes');
INSERT INTO Provedores (CUIL,Direccion,Telefono,Estado,Email,Nombre) VALUES (202345111, 'Calle San Juan 2345, San Juan', '0264-456-7890', 0, 'vetlibertad@yahoo.com', 'Vet Libertad');
INSERT INTO Provedores (CUIL,Direccion,Telefono,Estado,Email,Nombre) VALUES (201234571, 'Av. Pueyrredón 1234, Buenos Aires', '011-4789-3456', 0, 'consultaveterinaria@gmail.com', 'Consulta Veterinaria');
INSERT INTO Provedores (CUIL,Direccion,Telefono,Estado,Email,Nombre) VALUES (2030345621, 'Calle Catamarca 567, Catamarca', '0383-478-9012', 1, 'vetpura@hotmail.com', 'Vet Pura');
INSERT INTO Provedores (CUIL,Direccion,Telefono,Estado,Email,Nombre) VALUES (202198761, 'Av. Santa Fe 2345, Buenos Aires', '011-4876-9012', 0, 'mascotasvip@yahoo.com', 'Mascotas VIP');
INSERT INTO Provedores (CUIL,Direccion,Telefono,Estado,Email,Nombre) VALUES (202345681, 'Calle Mendoza 876, Mendoza', '0261-456-7890', 1, 'vetsaludable@gmail.com', 'Vet Saludable');
INSERT INTO Provedores (CUIL,Direccion,Telefono,Estado,Email,Nombre) VALUES (201234573, 'Av. Corrientes 1234, Buenos Aires', '011-4789-4567', 1, 'mascotasfelices@hotmail.com', 'Mascotas Felices');
INSERT INTO Provedores (CUIL,Direccion,Telefono,Estado,Email,Nombre) VALUES (202345691, 'Calle Tucumán 123, Tucumán', '0381-478-9012', 1, 'vetconfianza@yahoo.com', 'Vet Confianza');
INSERT INTO Provedores (CUIL,Direccion,Telefono,Estado,Email,Nombre) VALUES (202198763, 'Av. Córdoba 2345, Buenos Aires', '011-4856-9012', 1, 'mascotasmimosas@gmail.com', 'Mascotas Mimosas');
-- ----------------------------------------------------
-- inserccion de Insumos
-- ----------------------------------------------------
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Alimento para Perros', 500, 2500.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Alimento para Gatos', 250, 3000.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Collar Antipulgas', 100, 1500.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Shampoo para Perros', 300, 1200.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Shampoo para Gatos', 200, 1300.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Jaula para Hamster', 50, 2000.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Arena Sanitaria para Gatos', 150, 800.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Vitamina para Perros', 75, 3500.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Vitamina para Gatos', 60, 4000.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Cama para Perros', 25, 5000.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Cama para Gatos', 30, 4500.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Comedero para Perros', 200, 500.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Comedero para Gatos', 150, 450.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Juguete para Perros', 400, 700.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Juguete para Gatos', 300, 600.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Correa para Perros', 250, 1000.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Arena para Hamster', 100, 150.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Piedra Mineral para Pájaros', 50, 300.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Bebedero para Conejos', 50, 800.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Pienso para Aves', 300, 1000.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Antiparasitario para Perros', 100, 1800.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Acepromacina', 100, 1200.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Amoxicilina', 50, 800.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Atropina', 75, 900.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Buscapina', 80, 1000.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Carprofeno', 150, 1500.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Cefalexina', 60, 750.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Clindamicina', 40, 1300.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Dexametasona', 90, 1800.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Dipirona', 200, 1000.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Enrofloxacina', 50, 1200.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Fenilbutazona', 70, 1500.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Ivermectina', 120, 2000.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Ketoprofeno', 100, 1800.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Meloxicam', 80, 1500.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Metoclopramida', 60, 1000.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Pimobendan', 30, 3000.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Prednisolona', 40, 1200.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Ranitidina', 80, 900.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Sulfadimetoxina', 150, 1800.00);
INSERT INTO Insumos (Nombre, Cantidad, precioRefVenta) VALUES ('Tetraciclina', 100, 1200.00);

-- ----------------------------------------------------
-- inserccion de Ventas
-- ----------------------------------------------------
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-22 15:30:00', 45678234);
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-22 12:30:00', '67891234');
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-21 10:15:00', '38976543');
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-20 09:45:00', '67893456');
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-19 14:20:00', '24987654');
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-18 11:30:00', '45678234');
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-17 15:30:00', '67891234');
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-16 10:45:00', '38976543');
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-15 14:15:00', '67893456');
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-14 08:30:00', '24987654');
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-13 16:45:00', '45678234');
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-12 13:30:00', '67891234');
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-11 12:15:00', '38976543');
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-10 09:45:00', '67893456');
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-09 11:20:00', '24987654');
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-08 14:30:00', '45678234');
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-07 15:00:00', '67891234');
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-06 08:45:00', '38976543');
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-05 11:15:00', '67893456');
INSERT INTO Ventas (`Fecha`, `Personas_DNI`) VALUES ('2023-04-04 12:20:00', '24987654');

-- ----------------------------------------------------
-- inserccion de Lineas de Ventas
-- ----------------------------------------------------
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (5.5, 2, 4, 5);
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (3.25, 4, 5, 6);
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (8.0, 1, 6, 7);
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (10.75, 3, 7, 8);
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (4.5, 5, 8, 5);
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (7.25, 2, 9, 6);
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (9.5, 1, 4, 7);
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (12.0, 2, 4, 8);
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (6.25, 3, 5, 5);
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (3.75, 6, 5, 6);
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (8.5, 1, 6, 7);
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (11.25, 2, 6, 8);
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (7.0, 4, 7, 5);
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (4.25, 5, 7, 6);
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (10.0, 2, 8, 7);
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (14.5, 1, 8, 8);
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (5.75, 3, 9, 5);
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (2.5, 7, 9, 6);
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (7.75, 1, 10, 7);
INSERT INTO LineaDeVentas (`PrecioUnidad`, `Cantidad`, idVentas, idInsumos) VALUES (9.0, 2, 10, 8);

-- ----------------------------------------------------
-- inserccion de Compras
-- ----------------------------------------------------

INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-22 12:00:00', '201332201');
INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-21 14:30:00', '202432156');
INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-20 10:15:00', '203214567');
INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-19 16:45:00', '202198765');
INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-18 09:30:00', '2030345621');
INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-17 11:00:00', '201332201');
INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-16 13:30:00', '202432156');
INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-15 15:45:00', '203214567');
INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-14 12:15:00', '202198765');
INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-13 08:30:00', '2030345621');
INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-12 10:00:00', '201332201');
INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-11 12:30:00', '202432156');
INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-10 14:45:00', '203214567');
INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-09 09:15:00', '202198765');
INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-08 15:30:00', '2030345621');
INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-07 11:00:00', '201332201');
INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-06 13:30:00', '202432156');
INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-05 15:45:00', '203214567');
INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-04 12:15:00', '202198765');
INSERT INTO Compras (`Fecha`, `Provedores_CUIL`) VALUES ('2023-04-03 08:30:00', '2030345621');

-- ----------------------------------------------------
-- inserccion de Lineas de Compras
-- ----------------------------------------------------
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (1, 1, 5.0, 10);
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (1, 2, 7.5, 5);
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (1, 3, 3.0, 20);
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (2, 1, 5.0, 15);
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (2, 4, 12.0, 3);
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (2, 6, 2.5, 30);
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (3, 3, 3.0, 25);
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (3, 5, 6.5, 8);
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (4, 2, 7.5, 7);
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (4, 4, 12.0, 4);
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (4, 6, 2.5, 40);
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (5, 1, 5.0, 20);
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (5, 3, 3.0, 30);
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (6, 2, 7.5, 4);
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (6, 4, 12.0, 2);
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (6, 5, 6.5, 10);
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (7, 3, 3.0, 10);
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (7, 6, 2.5, 20);
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (7,5,8.0,1);
INSERT INTO LineaDeCompras (idCompras,idInsumos,`PrecioUnidad`, `Cantidad`) VALUES (8,5,2.0,1);
-- ----------------------------------------------------
-- inserccion de Citas
-- ----------------------------------------------------
INSERT INTO Cita (Fecha, Consultorio, Monto, Veterinario_DNI, Mascotas_idMascotas, Mascotas_Cliente_DNI)
VALUES ('2023-04-22 15:30:00', 'A3', 150.0, 31567788, 1, 13456672);

INSERT INTO Cita (Fecha, Consultorio, Monto, Veterinario_DNI, Mascotas_idMascotas, Mascotas_Cliente_DNI)
VALUES ('2023-04-22 10:00:00', 'A2', 35.0, 38976543, 2, 14456672);

INSERT INTO Cita (Fecha, Consultorio, Monto, Veterinario_DNI, Mascotas_idMascotas, Mascotas_Cliente_DNI)
VALUES ('2023-04-22 12:00:00', 'A4', 25.0, 38976543, 1, 13456672);

INSERT INTO Cita (Fecha, Consultorio, Monto, Veterinario_DNI, Mascotas_idMascotas, Mascotas_Cliente_DNI)
VALUES ('2023-04-23 09:00:00', 'A5', 60.0, 24987654, 2, 14456672);

INSERT INTO Cita (Fecha, Consultorio, Monto, Veterinario_DNI, Mascotas_idMascotas, Mascotas_Cliente_DNI)
VALUES ('2023-04-23 10:00:00', 'A1', 45.0, 38976543, 3, 25567344);

INSERT INTO Cita (Fecha, Consultorio, Monto, Veterinario_DNI, Mascotas_idMascotas, Mascotas_Cliente_DNI)
VALUES ('2023-04-23 11:00:00', 'A2', 80.0, 24987654, 4, 31567788);

INSERT INTO Cita (Fecha, Consultorio, Monto, Veterinario_DNI, Mascotas_idMascotas, Mascotas_Cliente_DNI)
VALUES ('2023-04-23 12:00:00', 'A3', 15.0, 38976543, 5, 38768990);

INSERT INTO Cita (Fecha, Consultorio, Monto, Veterinario_DNI, Mascotas_idMascotas, Mascotas_Cliente_DNI)
VALUES ('2023-04-24 09:00:00', 'A4', 50.0, 24987654, 6, 13456672);

INSERT INTO Cita (Fecha, Consultorio, Monto, Veterinario_DNI, Mascotas_idMascotas, Mascotas_Cliente_DNI)
VALUES ('2023-04-24 10:00:00', 'A5', 35.0,24987654, 7, 14456672);

-- ----------------------------------------------------
-- inserccion de Historias
-- ----------------------------------------------------
INSERT INTO Historia (Titulo, Descripcion, Imagenes, Cita_idCita, Cita_Veterinario_DNI, Cita_Mascotas_idMascotas, Cita_Mascotas_Cliente_DNI) 
VALUES ('Título de la historia', 'Descripción de la historia', 'ruta/de/la/imagen.jpg', 1, 31567788, 1, 13456672);
INSERT INTO Historia (Titulo, Descripcion, Imagenes, Cita_idCita, Cita_Veterinario_DNI, Cita_Mascotas_idMascotas, Cita_Mascotas_Cliente_DNI)
VALUES ('titulo1', 'descripcion1', 'imagen1,imagen2', 2, 38976543, 2, 14456672);
INSERT INTO Historia (Titulo, Descripcion, Imagenes, Cita_idCita, Cita_Veterinario_DNI, Cita_Mascotas_idMascotas, Cita_Mascotas_Cliente_DNI)
VALUES ('titulo2', 'descripcion2', 'imagen2', 3, 38976543, 1, 13456672);
INSERT INTO Historia (Titulo, Descripcion, Imagenes, Cita_idCita, Cita_Veterinario_DNI, Cita_Mascotas_idMascotas, Cita_Mascotas_Cliente_DNI)
VALUES ('titulo3', 'descripcion3', 'imagen3', 4, 24987654, 2, 14456672);
INSERT INTO Historia (Titulo, Descripcion, Imagenes, Cita_idCita, Cita_Veterinario_DNI, Cita_Mascotas_idMascotas, Cita_Mascotas_Cliente_DNI)
VALUES ('titulo4', 'descripcion4', 'imagen4', 5, 38976543, 3, 25567344);
INSERT INTO Historia (Titulo, Descripcion, Imagenes, Cita_idCita, Cita_Veterinario_DNI, Cita_Mascotas_idMascotas, Cita_Mascotas_Cliente_DNI)
VALUES ('titulo5', 'descripcion5', 'imagen5', 6, 24987654, 4, 31567788);
INSERT INTO Historia (Titulo, Descripcion, Imagenes, Cita_idCita, Cita_Veterinario_DNI, Cita_Mascotas_idMascotas, Cita_Mascotas_Cliente_DNI)
VALUES ('titulo6', 'descripcion6', 'imagen6', 7, 38976543, 5, 38768990);
INSERT INTO Historia (Titulo, Descripcion, Imagenes, Cita_idCita, Cita_Veterinario_DNI, Cita_Mascotas_idMascotas, Cita_Mascotas_Cliente_DNI)
VALUES ('titulo7', 'descripcion7', 'imagen7', 8, 24987654, 6, 13456672);
INSERT INTO Historia (Titulo, Descripcion, Imagenes, Cita_idCita, Cita_Veterinario_DNI, Cita_Mascotas_idMascotas, Cita_Mascotas_Cliente_DNI)
VALUES ('titulo8', 'descripcion8', 'imagen8', 9, 24987654, 7, 14456672);
INSERT INTO Historia (Titulo, Descripcion, Imagenes, Cita_idCita, Cita_Veterinario_DNI, Cita_Mascotas_idMascotas, Cita_Mascotas_Cliente_DNI)
VALUES ('titulo9', 'descripcion9', 'imagen9', 1, 31567788, 1, 13456672);
INSERT INTO Historia (Titulo, Descripcion, Imagenes, Cita_idCita, Cita_Veterinario_DNI, Cita_Mascotas_idMascotas, Cita_Mascotas_Cliente_DNI)
VALUES ('titulo10', 'descripcion10', 'imagen10', 2, 38976543, 2, 14456672);




