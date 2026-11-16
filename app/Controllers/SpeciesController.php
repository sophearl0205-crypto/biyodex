<?php
declare(strict_types=1);
namespace App\Controllers;
use App\Core\Controller;
class SpeciesController extends Controller { public function index(): void { $this->view('species/index', ['title' => 'HerbDex']); } }
