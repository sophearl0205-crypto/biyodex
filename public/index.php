<?php
declare(strict_types=1);

use App\Core\Router;

session_start();
spl_autoload_register(static function (string $class): void {
    $prefix = 'App\\';
    if (!str_starts_with($class, $prefix)) return;
    $file = dirname(__DIR__) . '/app/' . str_replace('\\', '/', substr($class, strlen($prefix))) . '.php';
    if (is_file($file)) require $file;
});
require dirname(__DIR__) . '/app/Helpers/functions.php';
$router = new Router();
require dirname(__DIR__) . '/routes/web.php';
$router->dispatch($_SERVER['REQUEST_URI'] ?? '/', $_SERVER['REQUEST_METHOD'] ?? 'GET');
