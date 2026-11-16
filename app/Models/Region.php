<?php
declare(strict_types=1);

namespace App\Models;

use App\Core\Database;

class Region
{
    public function all(): array
    {
        $statement = Database::connection()->query(
            'SELECT id, psgc_code, name, short_name, island_group FROM regions ORDER BY psgc_code'
        );
        return $statement->fetchAll();
    }

    public function publishedSpecies(int $regionId): array
    {
        $sql = 'SELECT s.id, s.common_name, s.scientific_name, s.slug,
                       sd.presence_type, sd.evidence_status
                FROM species_distribution sd
                INNER JOIN species s ON s.id = sd.species_id
                WHERE sd.region_id = :region_id
                  AND sd.evidence_status IN (\'source_verified\', \'expert_reviewed\')
                  AND s.publication_status = \'published\'
                ORDER BY s.common_name';

        $statement = Database::connection()->prepare($sql);
        $statement->execute(['region_id' => $regionId]);
        return $statement->fetchAll();
    }
}
