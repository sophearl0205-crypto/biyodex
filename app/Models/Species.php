<?php
declare(strict_types=1);

namespace App\Models;

use App\Core\Database;
use PDO;

class Species
{
    public function published(int $limit = 100): array
    {
        $limit = max(1, min($limit, 500));
        $sql = 'SELECT s.id, s.scientific_name, s.common_name, s.slug, s.description,
                       c.name AS category_name
                FROM species s
                INNER JOIN categories c ON c.id = s.category_id
                WHERE s.publication_status = :status
                ORDER BY s.is_featured DESC, s.common_name ASC
                LIMIT ' . $limit;

        $statement = Database::connection()->prepare($sql);
        $statement->execute(['status' => 'published']);
        return $statement->fetchAll();
    }

    public function findPublishedBySlug(string $slug): ?array
    {
        $sql = 'SELECT s.*, c.name AS category_name,
                       mp.doh_recognition_label, mp.plant_parts_used,
                       mp.traditional_uses, mp.preparation_method,
                       mp.precautions, mp.evidence_summary,
                       mp.educational_disclaimer
                FROM species s
                INNER JOIN categories c ON c.id = s.category_id
                LEFT JOIN medicinal_profiles mp ON mp.species_id = s.id
                WHERE s.slug = :slug AND s.publication_status = :status
                LIMIT 1';

        $statement = Database::connection()->prepare($sql);
        $statement->execute(['slug' => $slug, 'status' => 'published']);
        $record = $statement->fetch(PDO::FETCH_ASSOC);
        return $record ?: null;
    }
}
