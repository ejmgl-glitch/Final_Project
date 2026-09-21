<?php
// Configuración de la base de datos
define('DB_HOST', 'localhost');
define('DB_NAME', 'chilero');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_CHARSET', 'utf8mb4');

// Configuración de la sesión
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}