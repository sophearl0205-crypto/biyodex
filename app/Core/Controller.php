<?php
declare(strict_types=1);
namespace App\Core;

class Controller
{
    protected function view(string $view, array $data = []): void
    {
        $viewFile = dirname(__DIR__) . '/Views/' . $view . '.php';
        if (!is_file($viewFile)) throw new \RuntimeException("View not found: {$view}");
        extract($data, EXTR_SKIP);
        require dirname(__DIR__) . '/Views/layouts/header.php';
        require $viewFile;
        require dirname(__DIR__) . '/Views/layouts/footer.php';
    }
}
