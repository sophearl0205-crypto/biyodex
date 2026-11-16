<?php
declare(strict_types=1);
namespace App\Controllers;
use App\Core\Controller;
class AboutController extends Controller { public function index(): void { $this->view('about/index', ['title' => 'About BiyoDex']); } }
