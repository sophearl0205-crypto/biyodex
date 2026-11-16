<?php
declare(strict_types=1);
namespace App\Core;

class Router
{
    private array $routes = [];
    public function get(string $path, array $action): void { $this->routes['GET'][$this->normalize($path)] = $action; }
    public function dispatch(string $requestUri, string $requestMethod): void
    {
        $requestPath = parse_url($requestUri, PHP_URL_PATH) ?: '/';
        $basePath = rtrim(str_replace('\\', '/', dirname($_SERVER['SCRIPT_NAME'] ?? '/index.php')), '/');
        if ($basePath !== '' && $basePath !== '/' && str_starts_with($requestPath, $basePath)) $requestPath = substr($requestPath, strlen($basePath));
        $path = $this->normalize($requestPath);
        $action = $this->routes[strtoupper($requestMethod)][$path] ?? null;
        if ($action === null) { http_response_code(404); $title = 'Page Not Found | BiyoDex'; require dirname(__DIR__) . '/Views/errors/404.php'; return; }
        [$controller, $method] = $action;
        (new $controller())->{$method}();
    }
    private function normalize(string $path): string { $path = '/' . trim($path, '/'); return $path === '//' ? '/' : $path; }
}
