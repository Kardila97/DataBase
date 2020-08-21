-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema hospital_ent
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema hospital_ent
-- -----------------------------------------------------
drop SCHEMA IF EXISTS hospital_ent;
CREATE SCHEMA IF NOT EXISTS `hospital_ent` DEFAULT CHARACTER SET utf8 COLLATE utf8_spanish_ci ;
USE `hospital_ent` ;

-- -----------------------------------------------------
-- Table `hospital_ent`.`eps`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospital_ent`.`eps` (
  `Codigo_EPS` VARCHAR(4) NOT NULL COMMENT 'Codigo interno de la EPS',
  `Nombre_EPS` VARCHAR(45) NOT NULL COMMENT 'Nombre de la EPS',
  `Regimen_EPS` VARCHAR(1) NOT NULL COMMENT 'Aun por definir\n',
  PRIMARY KEY (`Codigo_EPS`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_spanish_ci
COMMENT = 'Almacena los datos basicos de las EPS';


-- -----------------------------------------------------
-- Table `hospital_ent`.`Departamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospital_ent`.`Departamento` (
  `Id_Departamento` INT NOT NULL COMMENT 'Identificador de la tabla Departamento',
  `Nombre_Departamento` VARCHAR(200) NOT NULL COMMENT 'Nombre del Departamento',
  `Cod_Departamento` VARCHAR(10) NOT NULL COMMENT 'Codigo del Departamento (dado por el estado)',
  PRIMARY KEY (`Id_Departamento`),
  UNIQUE INDEX `Cod_Departamento_UNIQUE` (`Cod_Departamento` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hospital_ent`.`Municipio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospital_ent`.`Municipio` (
  `Id_Municipio` INT NOT NULL COMMENT 'Identificador del Municipio',
  `Nombre_Municipio` VARCHAR(45) NOT NULL COMMENT 'Nombre del Municipio',
  `Cod_Municipio` VARCHAR(10) NOT NULL COMMENT 'Codigo del Municipio (dado por el estado)',
  `Departamento_Id_Departamento` INT NOT NULL COMMENT 'Llave Foranea Departamento',
  PRIMARY KEY (`Id_Municipio`, `Departamento_Id_Departamento`),
  INDEX `fk_Municipio_Departamento1_idx` (`Departamento_Id_Departamento` ASC) ,
  UNIQUE INDEX `Cod_Municipio_UNIQUE` (`Cod_Municipio` ASC) ,
  CONSTRAINT `fk_Municipio_Departamento1`
    FOREIGN KEY (`Departamento_Id_Departamento`)
    REFERENCES `hospital_ent`.`Departamento` (`Id_Departamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hospital_ent`.`residencia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospital_ent`.`residencia` (
  `Codigo_Resi` INT(11) NOT NULL COMMENT 'Identificador de residencia',
  `Direccion_Resi` VARCHAR(45) NOT NULL COMMENT 'Dirección de la casa, solo puede existir una vez esa dirección y se asigna a cada individuo que pertenezca a esa casa',
  `Zona_Residencia` VARCHAR(1) NULL COMMENT 'Zona de residencia\nU  => Urbano\nR  => Rural',
  `Municipio_Id_Municipio` INT NOT NULL COMMENT 'Llave Foranea del Municipio (propio de la tabla)',
  `Municipio_Departamento_Id_Departamento` INT NOT NULL COMMENT 'Llave Foranea del Municipio (propio de la tabla)',
  PRIMARY KEY (`Codigo_Resi`, `Municipio_Id_Municipio`, `Municipio_Departamento_Id_Departamento`),
  UNIQUE INDEX `Direccion_Resi_UNIQUE` (`Direccion_Resi` ASC) ,
  INDEX `fk_residencia_Municipio1_idx` (`Municipio_Id_Municipio` ASC, `Municipio_Departamento_Id_Departamento` ASC) ,
  CONSTRAINT `fk_residencia_Municipio1`
    FOREIGN KEY (`Municipio_Id_Municipio` , `Municipio_Departamento_Id_Departamento`)
    REFERENCES `hospital_ent`.`Municipio` (`Id_Municipio` , `Departamento_Id_Departamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_spanish_ci
COMMENT = 'Almacena los datos de residencia para asignarlo a uno o mas personas';


-- -----------------------------------------------------
-- Table `hospital_ent`.`persona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospital_ent`.`persona` (
  `Id_Persona` INT NOT NULL COMMENT 'Identificador de la tabla persona',
  `Documento_Pers` INT(10) NOT NULL COMMENT 'Documento de la persona dentro de la base de datos, es unico, puede ser la cedula o tarjeta de identidad',
  `Tipo_Doc_Pers` VARCHAR(2) NOT NULL COMMENT 'Tipo de documento de una persona\nTI => Tarjeta de indentidad\nCC => Cedula de ciudadania ',
  `Fecha_Nac_Pers` DATE NOT NULL COMMENT 'Fecha de nacimiento de la persona',
  `Nombre1_Pers` VARCHAR(45) NOT NULL COMMENT 'Primer nombre de una persona',
  `Nombre2_Pers` VARCHAR(45) NULL DEFAULT NULL COMMENT 'Segundo nombre de una persona',
  `Apellido1_Pers` VARCHAR(45) NOT NULL COMMENT 'Primer apellido de una persona',
  `Apellido2_Pers` VARCHAR(45) NULL DEFAULT NULL COMMENT 'Segundo apellido de una persona',
  `Celular_Pers` VARCHAR(10) NULL DEFAULT NULL COMMENT 'Numero telefonico o de contacto de una persona',
  `Genero_Pers` VARCHAR(1) NOT NULL COMMENT 'Genero de una persona, \nF => femenino\nM => masculino',
  `EPS_Codigo_EPS` VARCHAR(4) NOT NULL COMMENT 'Llave foranea EPS',
  `residencia_Codigo_Resi` INT(11) NOT NULL COMMENT 'Llave Foranea Departamento-Municipio',
  `residencia_Municipio_Id_Municipio` INT NOT NULL COMMENT 'Llave Foranea Departamento-Municipio',
  `residencia_Municipio_Departamento_Id_Departamento` INT NOT NULL COMMENT 'Llave Foranea Departamento-Municipio',
  PRIMARY KEY (`Id_Persona`),
  INDEX `fk_persona_EPS1_idx` (`EPS_Codigo_EPS` ASC) ,
  UNIQUE INDEX `Documento_Pers_UNIQUE` (`Documento_Pers` ASC) ,
  INDEX `fk_persona_residencia1_idx` (`residencia_Codigo_Resi` ASC, `residencia_Municipio_Id_Municipio` ASC, `residencia_Municipio_Departamento_Id_Departamento` ASC) ,
  CONSTRAINT `fk_persona_EPS1`
    FOREIGN KEY (`EPS_Codigo_EPS`)
    REFERENCES `hospital_ent`.`eps` (`Codigo_EPS`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_persona_residencia1`
    FOREIGN KEY (`residencia_Codigo_Resi` , `residencia_Municipio_Id_Municipio` , `residencia_Municipio_Departamento_Id_Departamento`)
    REFERENCES `hospital_ent`.`residencia` (`Codigo_Resi` , `Municipio_Id_Municipio` , `Municipio_Departamento_Id_Departamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_spanish_ci
COMMENT = 'Almacena los datos basicos de una persona';


-- -----------------------------------------------------
-- Table `hospital_ent`.`Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospital_ent`.`Usuario` (
  `Id_Usuario` INT NOT NULL COMMENT 'Id del usuario que se logea en el aplicativo',
  `Usuario` VARCHAR(45) NOT NULL COMMENT 'Nombre de usuario',
  `Password` VARCHAR(260) NOT NULL COMMENT 'Contraseña de usuario (se encripta con el algoritmo AES key=0x1ddce642ed4f4f26ec2e64eb0ec88a811e13b15fbc88800c) \n\nCodigo para crear la Key \"select UNHEX(SHA2(\'PyP San Gil\',512))\"\n\n\nEjemplo Encriptar Hola\nselect AES_ENCRYPT(\'hola\',0x1ddce642ed4f4f26ec2e64eb0ec88a811e13b15fbc88800c); \n\nEjemplo Desencriptar Hola\nselect AES_DECRYPT(0x3b3e67b6e015cd832aaf271326ac4a83,0x1ddce642ed4f4f26ec2e64eb0ec88a811e13b15fbc88800c);',
  `persona_Id_Persona` INT NOT NULL COMMENT 'Llave Foranea Persona',
  PRIMARY KEY (`Id_Usuario`),
  UNIQUE INDEX `Usuario_UNIQUE` (`Usuario` ASC) ,
  INDEX `fk_Usuario_persona1_idx` (`persona_Id_Persona` ASC) ,
  CONSTRAINT `fk_Usuario_persona1`
    FOREIGN KEY (`persona_Id_Persona`)
    REFERENCES `hospital_ent`.`persona` (`Id_Persona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hospital_ent`.`ROL`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospital_ent`.`ROL` (
  `Id_Rol` INT NOT NULL COMMENT 'Identificador de ROL',
  `Rol_Rol` VARCHAR(45) NOT NULL COMMENT 'Rol que desempeña:\nEnfermera/o\nJefe Enfermería\nDoctor',
  PRIMARY KEY (`Id_Rol`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hospital_ent`.`Usuario_ROL`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospital_ent`.`Usuario_ROL` (
  `Usuario_Id_Usuario` INT NOT NULL COMMENT 'Llave Foranea Usuario',
  `ROL_Id_Rol` INT NOT NULL COMMENT 'Llave Foranea ROL',
  PRIMARY KEY (`Usuario_Id_Usuario`, `ROL_Id_Rol`),
  INDEX `fk_Usuario_has_ROL_ROL1_idx` (`ROL_Id_Rol` ASC) ,
  INDEX `fk_Usuario_has_ROL_Usuario1_idx` (`Usuario_Id_Usuario` ASC) ,
  CONSTRAINT `fk_Usuario_has_ROL_Usuario1`
    FOREIGN KEY (`Usuario_Id_Usuario`)
    REFERENCES `hospital_ent`.`Usuario` (`Id_Usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Usuario_has_ROL_ROL1`
    FOREIGN KEY (`ROL_Id_Rol`)
    REFERENCES `hospital_ent`.`ROL` (`Id_Rol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hospital_ent`.`ent`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospital_ent`.`ent` (
  `Id_Enfermedad` VARCHAR(6) NOT NULL COMMENT 'Codigo asignado a la enfermedad',
  `Codigo_Enfermedad` VARCHAR(10) NOT NULL,
  `Nombre_Enfer` VARCHAR(100) NOT NULL COMMENT 'Nombre de la enfermedad',
  `Descripcion_Enfer` VARCHAR(400) NOT NULL COMMENT 'Descripcion corta o larga de la enfermedad',
  PRIMARY KEY (`Id_Enfermedad`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_spanish_ci
COMMENT = 'Enfermedad Cronica no transmisible';


-- -----------------------------------------------------
-- Table `hospital_ent`.`medicamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospital_ent`.`medicamento` (
  `Id_Medicamento` VARCHAR(10) NOT NULL COMMENT 'Codigo con el cual se guarda el medicamento',
  `Codigo_Medicamento` VARCHAR(10) NOT NULL COMMENT 'Codigo del medicamento (como lo registran en el sistema)',
  `Nombre_Med` VARCHAR(150) NOT NULL COMMENT 'Nombre del medicamento',
  `Precio_Med` DOUBLE NOT NULL COMMENT 'Precio de coste para el cliente, es el valor que debe pagar el cliente por el medicamento',
  `Descripción_Med` VARCHAR(400) NOT NULL COMMENT 'Descripción del medicamento, puede ser una explicación sencilla del porque se usa ese o en que casos se usa',
  `Concentración_Med` VARCHAR(4) NOT NULL COMMENT 'Concentración del medicamento ejemplo: 100mg o 40mg',
  PRIMARY KEY (`Id_Medicamento`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_spanish_ci
COMMENT = 'Almacena los medicamentos que se han suministrado a los pacientes.';


-- -----------------------------------------------------
-- Table `hospital_ent`.`ent_medicamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospital_ent`.`ent_medicamento` (
  `ent_Codigo_Enfer` VARCHAR(6) NOT NULL COMMENT 'LLave foranea Enfermedad',
  `medicamento_Codigo_Med` VARCHAR(6) NOT NULL COMMENT 'Llave foranea Medicamento',
  `Estado_medicamento` VARCHAR(1) NOT NULL COMMENT 'Estado del medicamento aplicado a esa enfermedad\n1. significa que el paciente se sigue tratando con ese medicamento\n0 significa que el paciente ya no se trata con ese medicamento',
  PRIMARY KEY (`ent_Codigo_Enfer`, `medicamento_Codigo_Med`),
  INDEX `fk_ent_has_medicamento_medicamento1_idx` (`medicamento_Codigo_Med` ASC) ,
  INDEX `fk_ent_has_medicamento_ent1_idx` (`ent_Codigo_Enfer` ASC) ,
  CONSTRAINT `fk_ent_has_medicamento_ent1`
    FOREIGN KEY (`ent_Codigo_Enfer`)
    REFERENCES `hospital_ent`.`ent` (`Id_Enfermedad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ent_has_medicamento_medicamento1`
    FOREIGN KEY (`medicamento_Codigo_Med`)
    REFERENCES `hospital_ent`.`medicamento` (`Id_Medicamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_spanish_ci
COMMENT = 'Almacena los datos medicamentos por enfermedad';


-- -----------------------------------------------------
-- Table `hospital_ent`.`ent_persona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospital_ent`.`ent_persona` (
  `ent_Codigo_Enfer` VARCHAR(6) NOT NULL COMMENT 'Llave Foranea Enfermedad',
  `persona_Id_Persona` INT NOT NULL COMMENT 'Llave Foranea PERSONA',
  `Fecha_Diagnostico` DATETIME NOT NULL COMMENT 'Fecha en la que se diagnostico la enfermedad del paciente',
  `HTA_CIE10(I10-I159)` VARCHAR(1) NULL COMMENT 'El paciente tiene diagnóstico confirmado de Hipertensión Arterial -HTA (CIE-10 con códigos entre I10-I159) (solo se llena para la Hipertensión Arterial)\nS => Si\nN => No',
  `ent_medicamento_ent_Codigo_Enfer` VARCHAR(6) NOT NULL,
  `ent_medicamento_medicamento_Codigo_Med` VARCHAR(6) NOT NULL,
  PRIMARY KEY (`ent_Codigo_Enfer`, `persona_Id_Persona`, `ent_medicamento_ent_Codigo_Enfer`, `ent_medicamento_medicamento_Codigo_Med`),
  INDEX `fk_ent_has_persona_persona1_idx` (`persona_Id_Persona` ASC) ,
  INDEX `fk_ent_has_persona_ent1_idx` (`ent_Codigo_Enfer` ASC) ,
  INDEX `fk_ent_persona_ent_medicamento1_idx` (`ent_medicamento_ent_Codigo_Enfer` ASC, `ent_medicamento_medicamento_Codigo_Med` ASC) ,
  CONSTRAINT `fk_ent_has_persona_ent1`
    FOREIGN KEY (`ent_Codigo_Enfer`)
    REFERENCES `hospital_ent`.`ent` (`Id_Enfermedad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ent_has_persona_persona1`
    FOREIGN KEY (`persona_Id_Persona`)
    REFERENCES `hospital_ent`.`persona` (`Id_Persona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ent_persona_ent_medicamento1`
    FOREIGN KEY (`ent_medicamento_ent_Codigo_Enfer` , `ent_medicamento_medicamento_Codigo_Med`)
    REFERENCES `hospital_ent`.`ent_medicamento` (`ent_Codigo_Enfer` , `medicamento_Codigo_Med`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_spanish_ci;


-- -----------------------------------------------------
-- Table `hospital_ent`.`control`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospital_ent`.`control` (
  `Codigo_Cont` VARCHAR(6) NOT NULL COMMENT 'Codigo del control',
  `Fecha_Cont` TIMESTAMP NULL DEFAULT NULL COMMENT 'Fecha en la que se realiza el control',
  `Fecha_Prox_Cont` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP() COMMENT 'Fecha Proximo control',
  `Edad_Paciente` FLOAT NOT NULL COMMENT 'Edad del paciente, calculado entre la fecha de nacimiento y la fecha del control, se debe mostrar al usuario antes de guardar los datos.',
  `Diagnostico_O` VARCHAR(45) NOT NULL COMMENT 'Diagnostico de Obesidad\nS => Si\nN => No',
  `Fecha_Ingreso_RCV` DATETIME NULL COMMENT 'Fecha de Ingreso al programa de Riegos CardioVascular (RCV)',
  `Usuario_ROL_Usuario_Id_Usuario` INT NOT NULL COMMENT 'Llave Foranea Id del usuario que se realizo el control',
  `Usuario_ROL_ROL_Id_Rol` INT NOT NULL COMMENT 'Llave Foranea Rol del usuario que realizo el control',
  `ent_persona_ent_Codigo_Enfer` VARCHAR(6) NOT NULL COMMENT 'Llave Foranea Codigo de la enfermadad tratada',
  `ent_persona_persona_Id_Persona` INT NOT NULL COMMENT 'Llave Foranea Identificador de la persona (es propio de la base de datos)',
  `Cla_estadio_HTA` VARCHAR(45) NULL COMMENT 'Clasificación estadio HTA',
  PRIMARY KEY (`Codigo_Cont`, `Usuario_ROL_Usuario_Id_Usuario`, `Usuario_ROL_ROL_Id_Rol`, `ent_persona_ent_Codigo_Enfer`, `ent_persona_persona_Id_Persona`),
  INDEX `fk_control_Usuario_ROL1_idx` (`Usuario_ROL_Usuario_Id_Usuario` ASC, `Usuario_ROL_ROL_Id_Rol` ASC) ,
  INDEX `fk_control_ent_persona1_idx` (`ent_persona_ent_Codigo_Enfer` ASC, `ent_persona_persona_Id_Persona` ASC) ,
  CONSTRAINT `fk_control_Usuario_ROL1`
    FOREIGN KEY (`Usuario_ROL_Usuario_Id_Usuario` , `Usuario_ROL_ROL_Id_Rol`)
    REFERENCES `hospital_ent`.`Usuario_ROL` (`Usuario_Id_Usuario` , `ROL_Id_Rol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_control_ent_persona1`
    FOREIGN KEY (`ent_persona_ent_Codigo_Enfer` , `ent_persona_persona_Id_Persona`)
    REFERENCES `hospital_ent`.`ent_persona` (`ent_Codigo_Enfer` , `persona_Id_Persona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_spanish_ci
COMMENT = 'Controles realizados al paciente';


-- -----------------------------------------------------
-- Table `hospital_ent`.`Sesion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hospital_ent`.`Sesion` (
  `Id_Sesion` INT NOT NULL COMMENT 'Identificador de la tabla Sesion',
  `Fecha_Entrada` DATETIME NOT NULL COMMENT 'Fecha en la que el usuario inicia sesion en la base de datos',
  `Fecha_Salida` DATETIME NULL COMMENT 'Fecha en la que el usuario cierra sesion en la base de datos',
  `Tiempo_Total` VARCHAR(45) NULL COMMENT 'Tiempo total de la sesion, se da en minutos',
  `Usuario_ROL_Usuario_Id_Usuario` INT NOT NULL COMMENT 'Llave foranea id usuario con el que se inicia sesion',
  `Usuario_ROL_ROL_Id_Rol` INT NOT NULL COMMENT 'Llave foranea id Rol con el que se inicia sesion',
  PRIMARY KEY (`Id_Sesion`, `Usuario_ROL_Usuario_Id_Usuario`, `Usuario_ROL_ROL_Id_Rol`),
  INDEX `fk_Sesion_Usuario_ROL1_idx` (`Usuario_ROL_Usuario_Id_Usuario` ASC, `Usuario_ROL_ROL_Id_Rol` ASC) ,
  CONSTRAINT `fk_Sesion_Usuario_ROL1`
    FOREIGN KEY (`Usuario_ROL_Usuario_Id_Usuario` , `Usuario_ROL_ROL_Id_Rol`)
    REFERENCES `hospital_ent`.`Usuario_ROL` (`Usuario_Id_Usuario` , `ROL_Id_Rol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;