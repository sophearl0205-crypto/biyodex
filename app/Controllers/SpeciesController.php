<?php
declare(strict_types=1);

namespace App\\Controllers;

use App\\Core\\Controller;
use App\\Models\\Species;

class SpeciesController extends Controller
{
    public function index(): void
    {
        $speciesModel = new Species();
        $plants = $speciesModel->published();

        $this->view('species/index', [
            'title' => 'HerbDex',
            'plants' => $plants,
            'plantCount' => count($plants),
        ]);
    }
}
