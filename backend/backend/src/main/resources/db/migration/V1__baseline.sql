-- Data-free initial schema. Do not add demo users, credentials, catalog rows, or
-- production data. Existing schemas require backup and compatibility review.
-- Order and audit references restrict deletion to preserve purchase history.

CREATE TABLE usuarios (
    id_usuario BIGINT AUTO_INCREMENT PRIMARY KEY,
    correo VARCHAR(255) NOT NULL UNIQUE,
    nombre VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    rol ENUM('ADMIN','CLIENTE') DEFAULT 'CLIENTE'
) ENGINE=InnoDB;

CREATE TABLE categorias (
    id_categoria BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE productos (
    id_producto BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion VARCHAR(500),
    precio DECIMAL(10,2) NOT NULL,
    color VARCHAR(255),
    genero ENUM('HOMBRE','MUJER','UNISEX') DEFAULT 'UNISEX',
    imagenes TEXT,
    id_categoria BIGINT NOT NULL,
    CONSTRAINT FK_producto_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categorias(id_categoria)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_productos_genero ON productos(genero);
CREATE INDEX idx_productos_nombre ON productos(nombre);
CREATE INDEX idx_productos_categoria ON productos(id_categoria);

CREATE TABLE producto_tallas (
    id_talla BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_producto BIGINT NOT NULL,
    talla VARCHAR(50) NOT NULL,
    stock INT NOT NULL,
    CONSTRAINT FK_producto_talla
        FOREIGN KEY (id_producto)
        REFERENCES productos(id_producto)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_producto_tallas_producto ON producto_tallas(id_producto);
CREATE UNIQUE INDEX idx_producto_talla_unica ON producto_tallas(id_producto, talla);

CREATE TABLE carritos (
    id_carrito BIGINT AUTO_INCREMENT PRIMARY KEY,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_usuario BIGINT NOT NULL,
    CONSTRAINT FK_carrito_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE UNIQUE INDEX idx_carrito_usuario ON carritos(id_usuario);

CREATE TABLE detalle_carrito (
    id_detalle_carrito BIGINT AUTO_INCREMENT PRIMARY KEY,
    cantidad INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    talla VARCHAR(50),
    id_carrito BIGINT NOT NULL,
    id_producto BIGINT NOT NULL,
    CONSTRAINT FK_detalle_carrito
        FOREIGN KEY (id_carrito)
        REFERENCES carritos(id_carrito)
        ON DELETE CASCADE,
    CONSTRAINT FK_detalle_producto
        FOREIGN KEY (id_producto)
        REFERENCES productos(id_producto)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE UNIQUE INDEX idx_detalle_carrito_producto ON detalle_carrito(id_carrito, id_producto, talla);

CREATE TABLE pedidos (
    id_pedido BIGINT AUTO_INCREMENT PRIMARY KEY,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM(
        'PENDIENTE',
        'EN_PROCESO',
        'ENVIADO',
        'ENTREGADO',
        'CANCELADO'
    ) DEFAULT 'PENDIENTE',
    total DECIMAL(10,2) NOT NULL,
    id_usuario BIGINT NOT NULL,
    CONSTRAINT FK_pedido_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario)
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE INDEX idx_pedidos_usuario ON pedidos(id_usuario);
CREATE INDEX idx_pedidos_estado ON pedidos(estado);

CREATE TABLE detalle_pedido (
    id_detalle_pedido BIGINT AUTO_INCREMENT PRIMARY KEY,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    talla VARCHAR(50),
    id_pedido BIGINT NOT NULL,
    id_producto BIGINT NOT NULL,
    CONSTRAINT FK_detallepedido_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedidos(id_pedido)
        ON DELETE RESTRICT,
    CONSTRAINT FK_detallepedido_producto
        FOREIGN KEY (id_producto)
        REFERENCES productos(id_producto)
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE historial_estado_pedido (
    id_historial BIGINT AUTO_INCREMENT PRIMARY KEY,
    estado_anterior ENUM(
        'PENDIENTE',
        'EN_PROCESO',
        'ENVIADO',
        'ENTREGADO',
        'CANCELADO'
    ) NOT NULL,
    estado_nuevo ENUM(
        'PENDIENTE',
        'EN_PROCESO',
        'ENVIADO',
        'ENTREGADO',
        'CANCELADO'
    ) NOT NULL,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_pedido BIGINT NOT NULL,
    id_usuario BIGINT NOT NULL,
    CONSTRAINT FK_historial_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedidos(id_pedido)
        ON DELETE RESTRICT,
    CONSTRAINT FK_historial_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario)
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE INDEX idx_historial_pedido ON historial_estado_pedido(id_pedido);
