SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

CREATE DATABASE IF NOT EXISTS `chilero` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `chilero`;


-- USUARIO ---------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE `usuario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(99) NOT NULL,
  `correo` varchar(50) NOT NULL UNIQUE,
  `password` varchar(255) NOT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `tipo_usuario` enum('cliente','trabajador','admin') NOT NULL DEFAULT 'cliente',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



-- CATEGORIA -------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE `categoria` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- PRODUCTO ---------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE `producto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(99) NOT NULL,
  `marca` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL DEFAULT 0.00,
  `color` varchar(25) DEFAULT NULL,
  `genero` enum('hombre','mujer','ninos') DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_categoria` (`id_categoria`),
  CONSTRAINT `producto_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- VARIANTE_PRODUCTO -------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE `variante_producto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_producto` int(11) NOT NULL,
  `talla` varchar(10) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `codigo_unico` varchar(255) UNIQUE DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `variante_producto_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- PEDIDO ------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE `pedido` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `estado` enum('realizado','enviado','entregado') NOT NULL DEFAULT 'realizado',
  `metodo_pago` enum('tarjeta','pay pal','transferencia') NOT NULL DEFAULT 'tarjeta',
  PRIMARY KEY (`id`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `pedido_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- DETALLE_PEDIDDO ---------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE `detalle_pedido` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_pedido` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 1,
  `subTotal` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_pedido` (`id_pedido`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `detalle_pedido_ibfk_1` FOREIGN KEY (`id_pedido`) REFERENCES `pedido` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `detalle_pedido_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- REVIEWS -----------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `calificacion` tinyint(1) NOT NULL CHECK (`calificacion` BETWEEN 1 AND 5),
  `comentario` varchar(255) DEFAULT NULL,
  `fecha` date NOT NULL DEFAULT (CURRENT_DATE),
  PRIMARY KEY (`id`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- WHISHLIST ---------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE `wishlist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- -------------------------------------------------------------------------------------------------------------------------------
-- Inserción de Datos Iniciales (Usuarios de prueba)
-- Contraseña para todos: Password123!
-- -------------------------------------------------------------------------------------------------------------------------------
INSERT INTO `usuario` (`nombre`, `correo`, `password`, `telefono`, `direccion`, `tipo_usuario`) VALUES
('Kevin', 'admin@chilero.com', '$2y$10$w8fK2n3Fz5l5P8L0H9XJPeV5K9jA8L6q3X3Xz8p4p8X9v4k2A8L6q', '55512345', 'Sede Central', 'admin'),
('Martin', 'empleado@chilero.com', '$2y$10$w8fK2n3Fz5l5P8L0H9XJPeV5K9jA8L6q3X3Xz8p4p8X9v4k2A8L6q', '55598765', 'Antigua Guatemala', 'trabajador'),
('Ana', 'cliente@chilero.com', '$2y$10$w8fK2n3Fz5l5P8L0H9XJPeV5K9jA8L6q3X3Xz8p4p8X9v4k2A8L6q', '55567890', 'Zona 7, Ciudad', 'cliente');

INSERT INTO `categoria` (`nombre`, `descripcion`) VALUES
('Deportivos', 'Zapatillas para correr, entrenamiento y gimnasio'),
('Casuales', 'Zapatos cómodos para el uso diario'),
('Formales', 'Zapatos de vestir y cuero');

COMMIT;