<?php
use App\Controllers\AboutController;
use App\Controllers\HomeController;
use App\Controllers\MapController;
use App\Controllers\SpeciesController;
$router->get('/', [HomeController::class, 'index']);
$router->get('/herbdex', [SpeciesController::class, 'index']);
$router->get('/explore', [MapController::class, 'index']);
$router->get('/about', [AboutController::class, 'index']);
