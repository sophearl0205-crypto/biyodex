# BiyoDex

An educational biodiversity index focused on Philippine species. The first release focuses on ten medicinal plants promoted by the Philippine Department of Health; the underlying data model is designed to expand to other flora and fauna.

## Stack
- PHP 8.1+
- MySQL 8.0+ or compatible MariaDB
- PDO prepared statements
- HTML, CSS and vanilla JavaScript
- Apache / XAMPP
- Lightweight MVC architecture

## Local setup
1. Clone this repository into `C:\\xampp\\htdocs\\biyodex`.
2. Start Apache and MySQL in XAMPP.
3. Open phpMyAdmin at `http://localhost/phpmyadmin`.
4. Import `database/migrations/001_initial_schema.sql`. It creates `biyodex_db`, tables, top-level categories, and the 18 Philippine regions.
5. Copy `config/database.example.php` to `config/database.php`.
6. Update the local database username and password in `config/database.php`.
7. Open `http://localhost/biyodex/public/`.

The `config/database.php` file is intentionally ignored by Git. Never commit real credentials.

## Database design
- `categories` and `species`: extensible biodiversity catalogue.
- `medicinal_profiles`: plant-specific educational/medicinal information.
- `regions`: Philippine administrative regions, identified by PSGC code.
- `species_distribution`: documented regional presence with evidence status.
- `sightings`: individual observations, separate from general distribution.
- `sources` and `species_sources`: traceable evidence and citations.

A region/species association must not be presented as a verified sighting. Only source-verified or expert-reviewed distribution records should be shown as confirmed on the public map. Sightings default to unverified.

## Data integrity
Medicinal information is educational and is not medical advice. Do not add therapeutic claims or regional distribution records without traceable references. The project should distinguish DOH recognition/promotional lists from regulatory approval of a particular product or treatment.

## Routes
- `/`
- `/herbdex`
- `/explore`
- `/about`

For XAMPP, use the `/public` path until an Apache virtual host is configured.
