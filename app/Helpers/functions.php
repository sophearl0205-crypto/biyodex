<?php
declare(strict_types=1);
function e(?string $value): string { return htmlspecialchars($value ?? '', ENT_QUOTES, 'UTF-8'); }
function url(string $path = ''): string { $script = str_replace('\\', '/', $_SERVER['SCRIPT_NAME'] ?? '/index.php'); $base = rtrim(dirname($script), '/'); if ($base === '/' || $base === '.') $base = ''; return $base . '/' . ltrim($path, '/'); }
function asset(string $path): string { return url('assets/' . ltrim($path, '/')); }
