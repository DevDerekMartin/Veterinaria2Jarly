CREATE DATABASE VETERINARIA;

USE VETERINARIA;
## tabla de cliente
######################################################################################
CREATE TABLE CLIENTE(
	ID INT AUTO_INCREMENT PRIMARY KEY,
    DNI CHAR(10) NOT NULL UNIQUE,
    NOMBRES VARCHAR(100) NOT NULL,
    EMAIL VARCHAR(100) UNIQUE NOT NULL,
    CONTACTO CHAR(10) NOT NULL,
    FECHA_NACIMIENTO DATE NOT NULL,
    GENERO ENUM('M', 'F', 'O') NOT NULL,
    DIRECCION VARCHAR(100) NOT NULL,
    CIUDAD VARCHAR(100) NOT NULL,
    REFERENCIA VARCHAR(100),
    -- Validaciones
    CONSTRAINT 
		CK_CONTACTO
    CHECK(
		CONTACTO REGEXP '^(0[2-7][0-9]{7})$' AND length(CONTACTO) = 9 
        OR 
        CONTACTO REGEXP '^(0[0-9]{9})$' AND length(CONTACTO) = 10
        )
);

## Tabla de veterinario
######################################################################################
CREATE TABLE VETERINARIO(
	ID INT AUTO_INCREMENT PRIMARY KEY,
    DNI CHAR(10) NOT NULL UNIQUE,
    NOMBRES VARCHAR(100) NOT NULL,
    EMAIL VARCHAR(100) UNIQUE,
    CONTACTO CHAR(10) NOT NULL,
    FECHA_NACIMIENTO DATE NOT NULL,
    GENERO ENUM('M', 'F', 'O') NOT NULL,
    ESPECIALIDAD VARCHAR(100) DEFAULT 'Medico Veterinario',
    DIRECCION VARCHAR(100) NOT NULL,
    CIUDAD VARCHAR(100) NOT NULL,
    REFERENCIA VARCHAR(100),
    -- Validaciones
    CONSTRAINT 
		CK_CONTACTO_VETERINARIO
    CHECK(
		CONTACTO REGEXP '^(0[2-7][0-9]{7})$' AND length(CONTACTO) = 9 
        OR 
        CONTACTO REGEXP '^(0[0-9]{9})$' AND length(CONTACTO) = 10
        )
);

## tabla de categoria
######################################################################################
CREATE TABLE CATEGORIA(
	ID INT PRIMARY KEY AUTO_INCREMENT,
    CODIGO VARCHAR(10) NOT NULL,
    NOMBRE VARCHAR(100) UNIQUE NOT NULL,
    FECHA_REGISTRO DATE NOT NULL,
    DESCRIPCION VARCHAR(255) NOT NULL,
    ESTADO ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO'
);

## Creación de trigger
DELIMITER //
CREATE TRIGGER T_BI_CATEGORIA BEFORE INSERT ON CATEGORIA
FOR EACH ROW
BEGIN
    DECLARE P_CODIGO VARCHAR(10);
    DECLARE P_ID INT;
    
    -- Esta consulta se utiliza para predecir el próximo valor auto-incremental
    SET P_ID = (SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'CATEGORIA');
    SET P_CODIGO = CONCAT('CTG-', P_ID);
    
    -- Antes de que sea insertado modifica este cmapo
    SET NEW.Codigo = P_CODIGO;
END //
DELIMITER ;

## tabla de proveedor
######################################################################################
CREATE TABLE PROVEEDOR(
	ID INT AUTO_INCREMENT PRIMARY KEY,
    RUC CHAR(13) NOT NULL UNIQUE,
    NOMBRE VARCHAR(100) NOT NULL,
    EMAIL VARCHAR(100) UNIQUE,
    CONTACTO CHAR(10) NOT NULL,
    FECHA_REGISTRO DATE NOT NULL,
    DESCRIPCION VARCHAR(100) NOT NULL,
    DIRECCION VARCHAR(100) DEFAULT 'Sin dirección física',
    PAIS VARCHAR(100) DEFAULT 'Ecuador',
    CIUDAD VARCHAR(100) DEFAULT 'No establecido',
    -- Validaciones
    CONSTRAINT 
		CK_CONTACTO_PROVEEDOR
    CHECK(
		CONTACTO REGEXP '^(0[2-7][0-9]{7})$' AND length(CONTACTO) = 9 
        OR 
        CONTACTO REGEXP '^(0[0-9]{9})$' AND length(CONTACTO) = 10
        )
);

## tabla de servicio
######################################################################################
CREATE TABLE SERVICIO(
	ID INT PRIMARY KEY AUTO_INCREMENT,
    Codigo varchar(10) not null, 
    NOMBRE VARCHAR(100) UNIQUE NOT NULL,
    FECHA_REGISTRO DATE NOT NULL,
    DESCRIPCION VARCHAR(255) NOT NULL,
	ESTADO ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO',
    PRECIO DECIMAL(6,2) NOT NULL
);

## Creación de trigger
DELIMITER //
CREATE TRIGGER T_BI_SERVICIO BEFORE INSERT ON SERVICIO
FOR EACH ROW
BEGIN
    DECLARE P_CODIGO VARCHAR(10);
    DECLARE P_ID INT;
    
    -- Esta consulta se utiliza para predecir el próximo valor auto-incremental
    SET P_ID = (SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'SERVICIO');
    SET P_CODIGO = CONCAT('SRV-', P_ID);
    
    -- Antes de que sea insertado modifica este cmapo
    SET NEW.Codigo = P_CODIGO;
END //
DELIMITER ;

## tabla de mascotas
######################################################################################
CREATE TABLE MASCOTA(
	ID INT PRIMARY KEY AUTO_INCREMENT,
    CODIGO VARCHAR(10) NOT NULL,
    ID_CLIENTE INT NOT NULL,
    NOMBRE VARCHAR(100) NOT NULL,
    FECHA_REGISTRO TIMESTAMP NOT NULL,
    TIPO VARCHAR(100) NOT NULL,
    RAZA VARCHAR(100) DEFAULT 'sin raza',
    PESO DECIMAL(6,2) NOT NULL,
    ALTURA DECIMAL(6,2) NOT NULL,
    EDAD VARCHAR(100) DEFAULT 'Desconocida',
    SEXO ENUM('M', 'H') DEFAULT 'M',
    OBSERVACIONES VARCHAR(255) DEFAULT 'Sin observaciones',
    CONSTRAINT FK_MASCOTA_CLIENTE
    FOREIGN KEY(ID_CLIENTE)
    REFERENCES CLIENTE(ID)
);

## Creación de trigger
DELIMITER //
CREATE TRIGGER T_BI_MASCOTA BEFORE INSERT ON MASCOTA
FOR EACH ROW
BEGIN
    DECLARE P_CODIGO VARCHAR(10);
    DECLARE P_ID INT;
    
    -- Esta consulta se utiliza para predecir el próximo valor auto-incremental
    SET P_ID = (SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'MASCOTA');
    SET P_CODIGO = CONCAT('MSC-', P_ID);
    
    -- Antes de que sea insertado modifica este cmapo
    SET NEW.Codigo = P_CODIGO;
END //
DELIMITER ;


## MASCOTA_SERVICIO
######################################################################################
CREATE TABLE MASCOTA_SERVICIO(
	ID_MASCOTA INT,
    ID_SERVICIO INT,
    FECHA_REGISTRO TIMESTAMP,
    CONSTRAINT FK_MASCOTA_SERVICIOMASCOTA
    FOREIGN KEY(ID_MASCOTA)
    REFERENCES MASCOTA(ID),
    CONSTRAINT FK_SERVICIO_SERVICIOMASCOTA
    FOREIGN KEY(ID_SERVICIO)
    REFERENCES SERVICIO (ID)
);


## PROCEDIMIENTOS DE CLIENTES
#########################################################################################################################################
## Procedimeinto para seleccionar los clientes
DELIMITER //
	CREATE PROCEDURE OBTENER_CLIENTES()
		BEGIN
			SELECT 
				DNI,
                NOMBRES,
                EMAIL,
                CONTACTO,
                FECHA_NACIMIENTO,
                GENERO,
                DIRECCION,
                CIUDAD,
                REFERENCIA
			FROM
				CLIENTE
			ORDER BY 
				NOMBRES;
        END//
DELIMITER ;
## Procedimiento para insertar los clientes
DELIMITER //
	CREATE PROCEDURE INSERTAR_CLIENTE(
		IN P_DNI CHAR(10),
        IN P_NOMBRES VARCHAR(100),
        IN P_EMAIL VARCHAR(100),
        IN P_CONTACTO CHAR(10),
        IN P_FECHA_NACIMIENTO DATE,
        IN P_GENERO ENUM('M', 'F', 'O'),
        IN P_DIRECCION VARCHAR(100),
        IN P_CIUDAD VARCHAR(100),
        IN P_REFERENCIA VARCHAR(100)
    )
    BEGIN
		INSERT INTO CLIENTE(
			DNI,
            NOMBRES,
            EMAIL,
            CONTACTO,
            FECHA_NACIMIENTO,
            GENERO,
            DIRECCION,
            CIUDAD,
            REFERENCIA
        )
		VALUES(
			P_DNI,
			P_NOMBRES,
			P_EMAIL, 
			P_CONTACTO,
			P_FECHA_NACIMIENTO,
			P_GENERO,
			P_DIRECCION,
			P_CIUDAD,
			P_REFERENCIA
        );
	END //
DELIMITER ;
## Procedimiento para actualizar clientes
DELIMITER //
	CREATE PROCEDURE ACTUALIZAR_CLIENTE(
		IN P_DNI CHAR(10),
        IN P_NOMBRES VARCHAR(100),
        IN P_EMAIL VARCHAR(100),
        IN P_CONTACTO CHAR(10),
        IN P_FECHA_NACIMIENTO DATE,
        IN P_GENERO ENUM('M', 'F', 'O'),
        IN P_DIRECCION VARCHAR(100),
        IN P_CIUDAD VARCHAR(100),
        IN P_REFERENCIA VARCHAR(100)
    )
		BEGIN
			UPDATE CLIENTE
				SET
                    NOMBRES = P_NOMBRES,
                    EMAIL = P_EMAIL,
                    CONTACTO = P_CONTACTO,  
                    FECHA_NACIMIENTO = P_FECHA_NACIMIENTO,
                    GENERO = P_GENERO,
                    DIRECCION = P_DIRECCION,
                    CIUDAD = P_CIUDAD,
                    REFERENCIA = P_REFERENCIA
			WHERE
				DNI = P_DNI;
        END //
DELIMITER ;

## PROCEDIMIENTOS DE Veterinarios
#########################################################################################################################################
## Procedimeinto para seleccionar los clientes
DELIMITER //
	CREATE PROCEDURE OBTENER_VETERINARIOS()
		BEGIN
			SELECT 
				DNI,
                NOMBRES,
                EMAIL,
                CONTACTO,
                FECHA_NACIMIENTO,
                GENERO,
                ESPECIALIDAD,
                DIRECCION,
                CIUDAD,
                REFERENCIA
			FROM
				VETERINARIOS
			ORDER BY 
				NOMBRES;
        END//
DELIMITER ;
## Procedimiento para insertar veterinarios
DELIMITER //
	CREATE PROCEDURE INSERTAR_VETERINARIO(
		IN P_DNI CHAR(10),
        IN P_NOMBRES VARCHAR(100),
        IN P_EMAIL VARCHAR(100),
        IN P_CONTACTO CHAR(10),
        IN P_FECHA_NACIMIENTO DATE,
        IN P_GENERO ENUM('M', 'F', 'O'),
        IN P_ESPECIALIDAD VARCHAR(100),
        IN P_DIRECCION VARCHAR(100),
        IN P_CIUDAD VARCHAR(100),
        IN P_REFERENCIA VARCHAR(100)
    )
    BEGIN
		INSERT INTO VETERINARIOS(
			DNI,
            NOMBRES,
            EMAIL,
            CONTACTO,
            FECHA_NACIMIENTO,
            GENERO,
            ESPECIALIDAD,
            DIRECCION,
            CIUDAD,
            REFERENCIA
        )
		VALUES(
			P_DNI,
			P_NOMBRES,
			P_EMAIL, 
			P_CONTACTO,
			P_FECHA_NACIMIENTO,
			P_GENERO,
            P_ESPECIALIDAD,
			P_DIRECCION,
			P_CIUDAD,
			P_REFERENCIA
        );
	END //
DELIMITER ;
## Procedimiento para actualizar veterinarios
DELIMITER //
	CREATE PROCEDURE ACTUALIZAR_VETERINARIO(
		IN P_DNI CHAR(10),
        IN P_NOMBRES VARCHAR(100),
        IN P_EMAIL VARCHAR(100),
        IN P_CONTACTO CHAR(10),
        IN P_FECHA_NACIMIENTO DATE,
        IN P_GENERO ENUM('M', 'F', 'O'),
        IN P_ESPECIALIDAD VARCHAR(100),
        IN P_DIRECCION VARCHAR(100),
        IN P_CIUDAD VARCHAR(100),
        IN P_REFERENCIA VARCHAR(100)
    )
		BEGIN
			UPDATE VETERINARIOS
				SET
                    NOMBRES = P_NOMBRES,
                    EMAIL = P_EMAIL,
                    CONTACTO = P_CONTACTO,  
                    FECHA_NACIMIENTO = P_FECHA_NACIMIENTO,
                    GENERO = P_GENERO,
                    ESPECIALIDAD = P_ESPECIALIDAD,
                    DIRECCION = P_DIRECCION,
                    CIUDAD = P_CIUDAD,
                    REFERENCIA = P_REFERENCIA
			WHERE
				DNI = P_DNI;
        END //
DELIMITER ;

## PROCEDIMIENTOS DE PROVEEDOR
#########################################################################################################################################
## Procedimeinto para seleccionar los clientes
DELIMITER //
	CREATE PROCEDURE OBTENER_PROVEEDORES()
		BEGIN
			SELECT 
				RUC,
                NOMBRE,
                EMAIL,
                CONTACTO,
                FECHA_REGISTRO,
                DESCRIPCION,
                DIRECCION,
                PAIS,
                CIUDAD
			FROM
				PROVEEDOR
			ORDER BY 
				NOMBRE;
        END//
DELIMITER ;
DELIMITER //
	CREATE PROCEDURE INSERTAR_PROVEEDOR(
		IN P_RUC CHAR(13),
        IN P_NOMBRE VARCHAR(100),
        IN P_EMAIL VARCHAR(100),
        IN P_CONTACTO CHAR(10),
        IN P_FECHA_REGISTRO DATE,
        IN P_DESCRIPCION VARCHAR(100),
        IN P_DIRECCION VARCHAR(100),
        IN P_PAIS VARCHAR(100),
        IN P_CIUDAD VARCHAR(100)
    )
    BEGIN
		INSERT INTO PROVEEDOR(
			RUC,
            NOMBRE,
            EMAIL,
            CONTACTO,
            FECHA_REGISTRO,
            DESCRIPCION,
            DIRECCION,
            PAIS,
            CIUDAD
        )
		VALUES(
			P_RUC,
			P_NOMBRE,
			P_EMAIL, 
			P_CONTACTO,
            P_FECHA_REGISTRO,
            P_DESCRIPCION,
			P_DIRECCION,
            P_PAIS,
			P_CIUDAD
        );
	END //
DELIMITER ;
## Procedimiento para actualizar veterinarios
DELIMITER //
	CREATE PROCEDURE ACTUALIZAR_PROVEEDOR(
		IN P_RUC CHAR(13),
        IN P_NOMBRE VARCHAR(100),
        IN P_EMAIL VARCHAR(100),
        IN P_CONTACTO CHAR(10),
        IN P_DESCRIPCION VARCHAR(100),
        IN P_DIRECCION VARCHAR(100),
        IN P_PAIS VARCHAR(100),
        IN P_CIUDAD VARCHAR(100)
    )
		BEGIN
			UPDATE PROVEEDOR
				SET
                    NOMBRE = P_NOMBRE,
                    EMAIL = P_EMAIL,
                    CONTACTO = P_CONTACTO,
                    DESCRIPCION = P_DESCRIPCION,
                    DIRECCION = P_DIRECCION,
                    PAIS = P_PAIS,
                    CIUDAD = P_CIUDAD
			WHERE
				RUC = P_RUC;
        END //
DELIMITER ;

## PROCEDIMIENTOS DE CATEGORIA
#########################################################################################################################################
## Procedimeinto para seleccionar las categorias
DELIMITER //
	CREATE PROCEDURE OBTENER_CATEGORIAS()
		BEGIN
			SELECT 
				CODIGO,
                NOMBRE,
                FECHA_REGISTRO,
                DESCRIPCION,
                ESTADO
			FROM
				CATEGORIA
			ORDER BY 
				NOMBRE;
        END//
DELIMITER ;
## Procedimiento para insertar categorias
DELIMITER //
	CREATE PROCEDURE INSERTAR_CATEGORIA(
		IN P_CODIGO VARCHAR(10),
        IN P_NOMBRE VARCHAR(100),
        IN P_FECHA_REGISTRO DATE,
        IN P_DESCRIPCION VARCHAR(100),
        IN P_ESTADO ENUM('ACTIVO', 'INACTIVO')
    )
    BEGIN
		INSERT INTO CATEGORIA(
			CODIGO,
            NOMBRE,
            FECHA_REGISTRO,
            DESCRIPCION,
            ESTADO
        )
		VALUES(
			P_CODIGO,
			P_NOMBRE,
            P_FECHA_REGISTRO,
            P_DESCRIPCION,
			P_ESTADO
        );
	END //
DELIMITER ;
## Procedimiento para actualizar veterinarios
DELIMITER //
	CREATE PROCEDURE ACTUALIZAR_CATEGORIA(
		IN P_CODIGO VARCHAR(10),
		IN P_NOMBRE VARCHAR(100),
        IN P_FECHA_REGISTRO DATE,
        IN P_DESCRIPCION VARCHAR(100),
        IN P_ESTADO ENUM('ACTIVO', 'INACTIVO')
    )
		BEGIN
			UPDATE CATEGORIA
				SET
                    NOMBRE = P_NOMBRE,
                    DESCRIPCION = P_DESCRIPCION,
                    ESTADO = P_ESTADO
			WHERE
				CODIGO= P_CODIGO;
        END //
DELIMITER ;
## PROCEDIMIENTOS DE SERVICIOS
#########################################################################################################################################
## Procedimeinto para seleccionar los servicios
DELIMITER //
	CREATE PROCEDURE OBTENER_SERVICIOS()
		BEGIN
			SELECT 
				CODIGO,
                NOMBRE,
                FECHA_REGISTRO,
                DESCRIPCION,
                ESTADO,
                PRECIO
			FROM
				SERVICIO
			ORDER BY 
				NOMBRE;
        END//
DELIMITER ;
## Procedimiento para insertar categorias
DELIMITER //
	CREATE PROCEDURE INSERTAR_SERVICIO(
		IN P_CODIGO VARCHAR(10),
        IN P_NOMBRE VARCHAR(100),
        IN P_FECHA_REGISTRO DATE,
        IN P_DESCRIPCION VARCHAR(100),
		IN P_ESTADO ENUM('ACTIVO', 'INACTIVO'),
        IN P_PRECIO DECIMAL(6,2)
    )
    BEGIN
		INSERT INTO SERVICIO(
			CODIGO,
            NOMBRE,
            FECHA_REGISTRO,
            DESCRIPCION,
            ESTADO,
            PRECIO
        )
		VALUES(
			P_CODIGO,
			P_NOMBRE,
            P_FECHA_REGISTRO,
            P_DESCRIPCION,
			P_ESTADO,
            P_PRECIO
        );
	END //
DELIMITER ;
## Procedimiento para actualizar veterinarios
DELIMITER //
	CREATE PROCEDURE ACTUALIZAR_SERVICIO(
		IN P_CODIGO VARCHAR(10),
		IN P_NOMBRE VARCHAR(100),
        IN P_FECHA_REGISTRO DATE,
        IN P_DESCRIPCION VARCHAR(100),
        IN P_ESTADO ENUM('ACTIVO', 'INACTIVO'),
        IN P_PRECIO DECIMAL(6,2)
    )
		BEGIN
			UPDATE SERVICIO
				SET
                    NOMBRE = P_NOMBRE,
                    DESCRIPCION = P_DESCRIPCION,
                    ESTADO = P_ESTADO,
                    PRECIO = P_PRECIO
			WHERE
				CODIGO= P_CODIGO;
        END //
DELIMITER ;

## PROCEDIMIENTOS DE MASCOTAS
#########################################################################################################################################
## Procedimeinto para seleccionar las mascotas
DELIMITER //
	CREATE PROCEDURE OBTENER_MASCOTAS()
		BEGIN
			SELECT 
				C.DNI,
                C.NOMBRES AS NOMBRERESPONSABLE,
                M.CODIGO,
                M.NOMBRE,
                M.FECHA_REGISTRO,
				M.TIPO, 
				M.RAZA,
				M.PESO,
				M.ALTURA, 
				M.EDAD,
				M.SEXO,
				M.OBSERVACIONES,
                S.NOMBRE AS SERVICIO
			FROM
				MASCOTA AS M
			INNER JOIN
				CLIENTE AS C
					ON M.ID = C.ID
			INNER JOIN
				MASCOTA_SERVICIO AS MS
					ON MS.ID_MASCOTA = M.ID
			INNER JOIN
				SERVICIO AS S
					ON S.ID = MS.ID_SERVICIO
			ORDER BY 
				M.NOMBRE;
        END//
DELIMITER ;

## Insertar mascota
DELIMITER //
	CREATE PROCEDURE INSERTAR_MASCOTA(
     IN P_CODIGO VARCHAR(10),
	 IN P_DNI CHAR(10),
	 IN P_NOMBRE VARCHAR(100),
	 IN P_FECHA_REGISTRO TIMESTAMP,
	 IN P_TIPO VARCHAR(100),
	 IN P_RAZA VARCHAR(100),
     IN P_PESO DECIMAL(6,2),
     IN P_ALTURA DECIMAL(6,2),
     IN P_EDAD VARCHAR(100),
     IN P_SEXO ENUM('M','H'),
     IN P_OBSERVACIONES VARCHAR(255),
     IN P_SERVICIO VARCHAR(100)
    )
		BEGIN
			DECLARE DECISION BOOLEAN DEFAULT FALSE;
            DECLARE ID_MASCOTA INT DEFAULT -1;
            DECLARE ID_SERVICIO INT DEFAULT -1;
            DECLARE ID_CLIENTE INT DEFAULT -1;
		
		##condición para verificar si la mascota ya ha sido registrada		
			SELECT
				M.ID
			FROM
				MASCOTA AS M
			INNER JOIN
				CLIENTE AS C
					ON
						M.ID_CLIENTE = C.ID
			WHERE
				C.DNI = P_DNI AND M.NOMBRE = P_NOMBRE
			INTO
				ID_MASCOTA;
                
            IF ID_MASCOTA = -1 
				THEN
					SELECT C.ID FROM CLIENTE AS C WHERE C.DNI = P_DNI INTO ID_CLIENTE;
					INSERT INTO MASCOTA
                    (CODIGO, ID_CLIENTE, NOMBRE, FECHA_REGISTRO, TIPO, RAZA, PESO, ALTURA, EDAD, SEXO, OBSERVACIONES)
                    VALUES(P_CODIGO, ID_CLIENTE, P_NOMBRE, P_FECHA_REGISTRO, P_TIPO, P_RAZA, P_PESO, P_ALTURA, P_EDAD, P_SEXO, P_OBSERVACIONES);
                    SET ID_MASCOTA = -1;
			END IF;
            
            SELECT
				M.ID
			FROM
				MASCOTA AS M
			WHERE
				M.NOMBRE = P_NOMBRE
			INTO
				ID_MASCOTA;
            
            SELECT 
				S.ID
			FROM
				SERVICIO AS S
			WHERE
				S.NOMBRE = P_SERVICIO
			INTO
				ID_SERVICIO;
            
            INSERT INTO MASCOTA_SERVICIO
            VALUES(ID_MASCOTA, ID_SERVICIO, P_FECHA_REGISTRO);
		END //
DELIMITER ;

## Insertar mascota
DELIMITER //
	CREATE PROCEDURE ACTUALIZAR_MASCOTA(
     IN P_CODIGO VARCHAR(10),
	 IN P_DNI CHAR(10),
	 IN P_NOMBRE VARCHAR(100),
	 IN P_FECHA_REGISTRO TIMESTAMP,
	 IN P_TIPO VARCHAR(100),
	 IN P_RAZA VARCHAR(100),
     IN P_PESO DECIMAL(6,2),
     IN P_ALTURA DECIMAL(6,2),
     IN P_EDAD VARCHAR(100),
     IN P_SEXO ENUM('M','H'),
     IN P_OBSERVACIONES VARCHAR(255),
     IN P_SERVICIO VARCHAR(100)
    )
		BEGIN
        
			DECLARE ID_CLIENTE INT DEFAULT -1;
			DECLARE ID_SERVICIO INT DEFAULT -1;
            
			SELECT 
				C.ID
			FROM
				CLIENTE AS C
			WHERE
				C.DNI = P_DNI                
			INTO ID_CLIENTE;
            
            SELECT
				S.ID
			FROM
				SERVICIO AS S
			WHERE
				S.NOMBRE = P_SERVICIO
			INTO 
				ID_SERVICIO;
			
			UPDATE MASCOTA AS M, MASCOTA_SERVICIO AS MS 
			SET 
				M.NOMBRE = P_NOMBRE,
				M.TIPO = P_TIPO,
                M.RAZA = P_RAZA,
                M.PESO = P_PESO,
                M.ALTURA = P_ALTURA,
                M.EDAD = P_EDAD,
                M.SEXO = P_SEXO,
                M.OBSERVACIONES = P_OBSERVACIONES,
                MS.ID_SERVICIO = ID_SERVICIO
			WHERE
				M.CODIGO = P_CODIGO AND M.FECHA_REGISTRO = P_FECHA_REGISTRO;
		END//
DELIMITER ;


