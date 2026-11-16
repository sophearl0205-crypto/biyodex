-- BiyoDex initial schema
-- MySQL 8.0+ / MariaDB 10.5+; InnoDB and utf8mb4.
-- Import this file in phpMyAdmin after selecting/creating biyodex_db.

CREATE DATABASE IF NOT EXISTS biyodex_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE biyodex_db;

CREATE TABLE IF NOT EXISTS categories (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  parent_id BIGINT UNSIGNED NULL,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(120) NOT NULL UNIQUE,
  description TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_categories_parent FOREIGN KEY (parent_id) REFERENCES categories(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS species (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  category_id BIGINT UNSIGNED NOT NULL,
  scientific_name VARCHAR(190) NOT NULL,
  common_name VARCHAR(190) NOT NULL,
  local_names JSON NULL,
  slug VARCHAR(220) NOT NULL UNIQUE,
  description TEXT NULL,
  identification_features TEXT NULL,
  habitat TEXT NULL,
  conservation_status VARCHAR(100) NULL,
  is_featured TINYINT(1) NOT NULL DEFAULT 0,
  publication_status ENUM('draft','published','archived') NOT NULL DEFAULT 'draft',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_species_scientific_name (scientific_name),
  KEY idx_species_category_status (category_id, publication_status),
  CONSTRAINT fk_species_category FOREIGN KEY (category_id) REFERENCES categories(id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS medicinal_profiles (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  species_id BIGINT UNSIGNED NOT NULL UNIQUE,
  doh_recognition_label VARCHAR(190) NULL,
  plant_parts_used TEXT NULL,
  traditional_uses TEXT NULL,
  preparation_method TEXT NULL,
  precautions TEXT NULL,
  evidence_summary TEXT NULL,
  educational_disclaimer TEXT NOT NULL DEFAULT 'Educational information only. This profile is not medical advice and must not replace consultation with a qualified health professional.',
  reviewed_at DATE NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_medicinal_species FOREIGN KEY (species_id) REFERENCES species(id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS regions (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  psgc_code VARCHAR(20) NOT NULL UNIQUE,
  name VARCHAR(150) NOT NULL,
  short_name VARCHAR(40) NOT NULL,
  island_group ENUM('Luzon','Visayas','Mindanao') NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_regions_name (name)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS sources (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  publisher VARCHAR(190) NULL,
  author VARCHAR(190) NULL,
  publication_year SMALLINT UNSIGNED NULL,
  source_type ENUM('government','academic','book','database','field_observation','other') NOT NULL DEFAULT 'other',
  url VARCHAR(2048) NULL,
  accessed_at DATE NULL,
  citation_text TEXT NULL,
  notes TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_sources_publisher (publisher)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS species_sources (
  species_id BIGINT UNSIGNED NOT NULL,
  source_id BIGINT UNSIGNED NOT NULL,
  relationship_type ENUM('identity','medicinal_use','habitat','distribution','image','general') NOT NULL DEFAULT 'general',
  page_or_section VARCHAR(190) NULL,
  notes TEXT NULL,
  PRIMARY KEY (species_id, source_id, relationship_type),
  CONSTRAINT fk_species_sources_species FOREIGN KEY (species_id) REFERENCES species(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_species_sources_source FOREIGN KEY (source_id) REFERENCES sources(id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS species_distribution (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  species_id BIGINT UNSIGNED NOT NULL,
  region_id BIGINT UNSIGNED NOT NULL,
  presence_type ENUM('native','introduced','cultivated','naturalized','uncertain') NOT NULL DEFAULT 'uncertain',
  evidence_status ENUM('unverified','source_verified','expert_reviewed') NOT NULL DEFAULT 'unverified',
  source_id BIGINT UNSIGNED NULL,
  locality_notes TEXT NULL,
  last_verified_at DATE NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_species_region_presence (species_id, region_id, presence_type),
  KEY idx_distribution_region (region_id, evidence_status),
  CONSTRAINT fk_distribution_species FOREIGN KEY (species_id) REFERENCES species(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_distribution_region FOREIGN KEY (region_id) REFERENCES regions(id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_distribution_source FOREIGN KEY (source_id) REFERENCES sources(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS sightings (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  species_id BIGINT UNSIGNED NOT NULL,
  region_id BIGINT UNSIGNED NULL,
  source_id BIGINT UNSIGNED NULL,
  observed_on DATE NULL,
  locality VARCHAR(255) NULL,
  latitude DECIMAL(10,7) NULL,
  longitude DECIMAL(10,7) NULL,
  observation_notes TEXT NULL,
  verification_status ENUM('unverified','verified','rejected') NOT NULL DEFAULT 'unverified',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_sightings_species_date (species_id, observed_on),
  KEY idx_sightings_region (region_id),
  CONSTRAINT fk_sightings_species FOREIGN KEY (species_id) REFERENCES species(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_sightings_region FOREIGN KEY (region_id) REFERENCES regions(id)
    ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_sightings_source FOREIGN KEY (source_id) REFERENCES sources(id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- Top-level category records; additional categories can be added later.
INSERT INTO categories (name, slug, description)
VALUES
 ('Plants', 'plants', 'Plant species, including medicinal plants, trees, shrubs, herbs and other flora.'),
 ('Animals', 'animals', 'Animal species, including mammals, birds, reptiles, amphibians, fish and invertebrates.')
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- Philippine administrative regions based on the PSA PSGC structure (18 regions).
INSERT INTO regions (psgc_code, name, short_name, island_group) VALUES
 ('1300000000', 'National Capital Region (NCR)', 'NCR', 'Luzon'),
 ('1400000000', 'Cordillera Administrative Region (CAR)', 'CAR', 'Luzon'),
 ('0100000000', 'Ilocos Region', 'Region I', 'Luzon'),
 ('0200000000', 'Cagayan Valley', 'Region II', 'Luzon'),
 ('0300000000', 'Central Luzon', 'Region III', 'Luzon'),
 ('0400000000', 'CALABARZON', 'Region IV-A', 'Luzon'),
 ('1700000000', 'MIMAROPA Region', 'MIMAROPA', 'Luzon'),
 ('0500000000', 'Bicol Region', 'Region V', 'Luzon'),
 ('0600000000', 'Western Visayas', 'Region VI', 'Visayas'),
 ('1800000000', 'Negros Island Region', 'NIR', 'Visayas'),
 ('0700000000', 'Central Visayas', 'Region VII', 'Visayas'),
 ('0800000000', 'Eastern Visayas', 'Region VIII', 'Visayas'),
 ('0900000000', 'Zamboanga Peninsula', 'Region IX', 'Mindanao'),
 ('1000000000', 'Northern Mindanao', 'Region X', 'Mindanao'),
 ('1100000000', 'Davao Region', 'Region XI', 'Mindanao'),
 ('1200000000', 'SOCCSKSARGEN', 'Region XII', 'Mindanao'),
 ('1600000000', 'Caraga', 'Region XIII', 'Mindanao'),
 ('1500000000', 'Bangsamoro Autonomous Region in Muslim Mindanao (BARMM)', 'BARMM', 'Mindanao')
ON DUPLICATE KEY UPDATE name = VALUES(name), short_name = VALUES(short_name), island_group = VALUES(island_group);
