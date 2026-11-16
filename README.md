# BiyoDex

An educational biodiversity index focused on Philippine species. Version 1 begins with ten researched Philippine medicinal plants and is designed to expand to other flora and fauna.

## Stack
- PHP 8+
- MySQL with PDO (database integration is the next milestone)
- HTML, CSS, vanilla JavaScript
- Apache / XAMPP
- Lightweight MVC architecture

## Local setup
1. Place this repository in `C:\\xampp\\htdocs\\biyodex`.
2. Start Apache in XAMPP.
3. Open `http://localhost/biyodex/public/`.
4. Visit `/herbdex`, `/explore`, and `/about` under the same base URL.

Enable Apache `mod_rewrite` and `AllowOverride All` for routed pages.

## Current status
The initial MVC skeleton is being established. Plant records and geographic sightings will be added only after source verification by the research team.
