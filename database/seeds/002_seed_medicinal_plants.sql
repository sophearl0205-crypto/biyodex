-- BiyoDex starter collection: ten historically recognized DOH medicinal plants.
-- Run once after importing 001_initial_schema.sql.
-- Profiles are published as an educational starter dataset; verify and expand references before final academic submission.

USE biyodex_db;

SET @plants_id = (SELECT id FROM categories WHERE slug = 'plants' LIMIT 1);

INSERT INTO sources (title, publisher, publication_year, source_type, url, accessed_at, citation_text, notes)
SELECT
  'Directory of Herbs',
  'Philippine Institute of Traditional and Alternative Health Care (PITAHC)',
  2026,
  'government',
  'https://pitahc.gov.ph/herbs-directory/',
  CURRENT_DATE,
  'PITAHC. Directory of Herbs. https://pitahc.gov.ph/herbs-directory/',
  'Current online directory. It currently lists nine herbs; use plant-specific entries for supported claims.'
WHERE NOT EXISTS (
  SELECT 1 FROM sources WHERE url = 'https://pitahc.gov.ph/herbs-directory/'
);

INSERT INTO sources (title, publisher, publication_year, source_type, url, accessed_at, citation_text, notes)
SELECT
  'Identification and Sectoral Policy Development for the Next Sampung Halamang Gamot: A Systematic Review of Selected Philippine Medicinal Plants',
  'Philippine Institute of Traditional and Alternative Health Care (PITAHC)',
  2024,
  'government',
  'https://pitahc.gov.ph/wp-content/uploads/2024/10/CB-015-2024-BIDDING-DOCUMENTS.pdf',
  CURRENT_DATE,
  'PITAHC. Terms of Reference: Identification and Sectoral Policy Development for the Next Sampung Halamang Gamot.',
  'Identifies the ten medicinal plants circulated by the DOH Traditional Medicine Unit in 1992.'
WHERE NOT EXISTS (
  SELECT 1 FROM sources
  WHERE url = 'https://pitahc.gov.ph/wp-content/uploads/2024/10/CB-015-2024-BIDDING-DOCUMENTS.pdf'
);

INSERT INTO species
(category_id, scientific_name, common_name, local_names, slug, description, is_featured, publication_status)
VALUES
(@plants_id, 'Senna alata', 'Akapulko', JSON_ARRAY('Bayabas-bayabasan'), 'akapulko', 'A shrub commonly known as ringworm bush. PITAHC lists antifungal and antiscabies uses in its herb directory.', 1, 'published'),
(@plants_id, 'Momordica charantia', 'Ampalaya', JSON_ARRAY('Bitter melon','Bitter gourd'), 'ampalaya', 'A climbing plant cultivated for its distinctive bitter fruits. It is included in the historical DOH ten medicinal plants list.', 1, 'published'),
(@plants_id, 'Allium sativum', 'Bawang', JSON_ARRAY('Garlic'), 'bawang', 'A bulb-forming plant widely used as food and included in the historical DOH ten medicinal plants list.', 1, 'published'),
(@plants_id, 'Psidium guajava', 'Bayabas', JSON_ARRAY('Guava'), 'bayabas', 'A fruit-bearing shrub or small tree widely cultivated in the Philippines. PITAHC documents traditional uses of its leaves.', 1, 'published'),
(@plants_id, 'Vitex negundo', 'Lagundi', JSON_ARRAY('Five-leaved chaste tree'), 'lagundi', 'A medicinal shrub included in the historical DOH ten medicinal plants list. PITAHC identifies an antitussive use in the Philippine setting.', 1, 'published'),
(@plants_id, 'Combretum indicum', 'Niyog-niyogan', JSON_ARRAY('Rangoon creeper','Quisqualis indica'), 'niyog-niyogan', 'A climbing ornamental plant also included in the historical DOH ten medicinal plants list. Older references may use the synonym Quisqualis indica.', 1, 'published'),
(@plants_id, 'Blumea balsamifera', 'Sambong', JSON_ARRAY('Blumea camphor'), 'sambong', 'An aromatic shrub distributed in the Philippines. PITAHC identifies diuretic and antiuricemic clinical uses in the Philippine setting.', 1, 'published'),
(@plants_id, 'Ehretia microphylla', 'Tsaang-gubat', JSON_ARRAY('Philippine tea tree','Carmona retusa'), 'tsaang-gubat', 'A shrub traditionally used in the Philippines. PITAHC identifies antispasmodic and caries-preventive clinical uses in the Philippine setting.', 1, 'published'),
(@plants_id, 'Peperomia pellucida', 'Ulasimang bato', JSON_ARRAY('Pansit-pansitan','Pepper elder'), 'ulasimang-bato', 'A small herb with succulent leaves, commonly found in moist and shaded places. It is included in the historical DOH ten medicinal plants list.', 1, 'published'),
(@plants_id, 'Mentha cordifolia', 'Yerba buena', JSON_ARRAY('Mint'), 'yerba-buena', 'An aromatic herb included in the historical DOH ten medicinal plants list. PITAHC identifies analgesic use in the Philippine setting.', 1, 'published')
ON DUPLICATE KEY UPDATE
  common_name = VALUES(common_name),
  description = VALUES(description),
  publication_status = VALUES(publication_status),
  is_featured = VALUES(is_featured);

-- Create a medicinal profile for each starter plant without overwriting existing research.
INSERT INTO medicinal_profiles (species_id, doh_recognition_label, traditional_uses)
SELECT s.id, 'Included in the historical DOH ten medicinal plants list',
       'See the cited government and academic references. Traditional use does not establish that every preparation is safe or effective.'
FROM species s
WHERE s.slug IN ('akapulko','ampalaya','bawang','bayabas','lagundi','niyog-niyogan','sambong','tsaang-gubat','ulasimang-bato','yerba-buena')
ON DUPLICATE KEY UPDATE
  doh_recognition_label = VALUES(doh_recognition_label);

-- Link the ten-plant historical list source to all ten species.
INSERT IGNORE INTO species_sources (species_id, source_id, relationship_type, notes)
SELECT s.id, src.id, 'identity',
       'PITAHC 2024 Terms of Reference names this plant among the ten medicinal plants circulated by the DOH Traditional Medicine Unit in 1992.'
FROM species s
JOIN sources src ON src.url = 'https://pitahc.gov.ph/wp-content/uploads/2024/10/CB-015-2024-BIDDING-DOCUMENTS.pdf'
WHERE s.slug IN ('akapulko','ampalaya','bawang','bayabas','lagundi','niyog-niyogan','sambong','tsaang-gubat','ulasimang-bato','yerba-buena');

-- Link PITAHC's current directory only to entries it currently contains.
INSERT IGNORE INTO species_sources (species_id, source_id, relationship_type, notes)
SELECT s.id, src.id, 'medicinal_use',
       'PITAHC online herb directory; consult the plant-specific entry for the exact claims and cautions.'
FROM species s
JOIN sources src ON src.url = 'https://pitahc.gov.ph/herbs-directory/'
WHERE s.slug IN ('akapulko','ampalaya','bawang','bayabas','lagundi','niyog-niyogan','sambong','tsaang-gubat','ulasimang-bato','yerba-buena');
