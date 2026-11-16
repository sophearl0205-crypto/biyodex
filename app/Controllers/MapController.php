<?php
declare(strict_types=1);
namespace App\Controllers;
use App\Core\Controller;
class MapController extends Controller { public function index(): void { $this->view('map/index', ['title' => 'Explore the Philippines']); } }
