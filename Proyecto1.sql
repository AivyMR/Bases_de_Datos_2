
-- Borrado de tablas 
/*
DROP TABLE marca;
DROP TABLE Talla;
DROP TABLE Categoria;
DROP TABLE Imagen;
DROP TABLE Coleccion;
DROP TABLE Producto;
DROP TABLE Producto_X_Coleccion; 
DROP TABLE Inventario;
DROP TABLE Usuario;
DROP TABLE Orden;
DROP TABLE Producto_X_Orden;
DROP TABLE Bitacora;
*/
-- creacion de tablas

CREATE TABLE Marca
(
    id INT PRIMARY KEY NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    logo_path VARCHAR(30) NOT NULL
);

CREATE TABLE Talla
(
    id INT PRIMARY KEY NOT NULL,
    nombre VARCHAR(20) NOT NULL
);

CREATE TABLE Categoria
(
    id INT PRIMARY KEY NOT NULL,
    nombre VARCHAR(20) NOT NULL
);

CREATE TABLE Imagen
(
    id_producto INT PRIMARY KEY NOT NULL,
    imagen_path VARCHAR(30) NOT NULL
);

CREATE TABLE Coleccion
(
    id INT PRIMARY KEY NOT NULL,
    nombre VARCHAR(20) NOT NULL
);

CREATE TABLE Producto
(
    id INT PRIMARY KEY NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    descripcion VARCHAR(30) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    id_marca INT NOT NULL,
    id_talla INT NOT NULL,
    id_categoria INT NOT NULL,
    id_imagen INT NOT NULL,
    id_coleccion INT NOT NULL,
    CONSTRAINT fk_id_marca FOREIGN KEY (id_marca) REFERENCES Marca(id),
    CONSTRAINT fk_id_talla FOREIGN KEY (id_talla) REFERENCES Talla(id),
    CONSTRAINT fk_id_categoria FOREIGN KEY (id_categoria) REFERENCES Categoria(id),
    CONSTRAINT fk_id_imagen FOREIGN KEY (id_imagen) REFERENCES Imagen(id_producto),
    CONSTRAINT fk_id_coleccion FOREIGN KEY (id_coleccion) REFERENCES Coleccion(id)
);

CREATE TABLE Producto_X_Coleccion
(
    id_producto INT NOT NULL,
    id_coleccion INT NOT NULL,
    PRIMARY KEY (id_producto, id_coleccion)
);

CREATE TABLE Inventario
(
    id INT PRIMARY KEY NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    id_producto INT NOT NULL,
    CONSTRAINT fk_id_producto FOREIGN KEY (id_producto) REFERENCES Producto(id)
);

CREATE TABLE Usuario
(
    cedula INT PRIMARY KEY NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    correo VARCHAR(20) NOT NULL,
    contrasena VARCHAR(20) NOT NULL,
    telefono INT NOT NULL,
    id_producto INT NOT NULL,
    is_admin NUMBER(1,0) NOT NULL
);

CREATE TABLE Orden
(
    id INT PRIMARY KEY NOT NULL,
    fecha DATE,
    id_usuario INT NOT NULL,
    CONSTRAINT fk_id_usuario FOREIGN KEY (id_usuario) REFERENCES Usuario(cedula)
);

CREATE TABLE Producto_X_Orden
(
    id_producto INT NOT NULL,
    id_orden INT NOT NULL,
    PRIMARY KEY (id_producto, id_orden)
);

CREATE TABLE Bitacora
(
    id INT PRIMARY KEY NOT NULL,
    fecha DATE,
    descripcion VARCHAR(30) NOT NULL,
    id_usuario INT NOT NULL,
    id_producto INT NOT NULL,
    CONSTRAINT fk_id_usuario_bitacora FOREIGN KEY (id_usuario) REFERENCES Usuario(cedula),
    CONSTRAINT fk_id_producto_bitacora FOREIGN KEY (id_producto) REFERENCES Producto(id)
);














