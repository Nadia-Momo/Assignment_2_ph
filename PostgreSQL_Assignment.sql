-- Active: 1747913853853@@127.0.0.1@5432@ph
CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
region VARCHAR(50)  NOT NULL
);
SELECT * FROM rangers;
INSERT INTO rangers(name,region) VALUES 
('Alice Green','Northern Hills'),
('Bob White','River Delta'),
('Carol King','Mountain Range');
CREATE TABLE species(
    species_id serial PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(50) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) NOT NULL
);
select * from species;
INSERT INTO species(common_name,scientific_name,discovery_date,conservation_status) VALUES 
('Snow Leopard','Panthera uncia','1775-01-01','Endangered'),
('Bengal Tiger','Panthera tigris tigris','1758-01-01','Endangered'),
('Red Panda','Ailurus fulgens','1825-01-01','Vulnerable'),
('Asiatic Elephant',' Elephas maximus indicus','1758-01-01',' Endangered ');
select * from species;
ALTER TABLE species ALTER COLUMN discovery_date SET NOT NULL;

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT REFERENCES species(species_id),
    ranger_id INT REFERENCES rangers(ranger_id),
    sighting_time TIMESTAMP NOT NULL,
    location VARCHAR(150) NOT NULL,
    notes TEXT
);
INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00',NULL);
-- Problem 1
INSERT INTO rangers(name,region) values ('Derek Fox','Coastal Plains');
--problem 2
SELECT COUNT(DISTINCT species_id) as unique_species_count from sightings;
--problem 3
SELECT * from sightings WHERE location LIKE '%Pass%';
--problem 4
select rangers.name,count(sightings.ranger_id) AS  total_sightings  from rangers join "sightings" on rangers.ranger_id="sightings".ranger_id GROUP BY rangers.name ORDER BY rangers.name;
--problem 5 
SELECT common_name from species where species_id not in (select species_id from sightings);
--problem 6
select species.common_name,sightings.sighting_time,rangers.name from sightings 
join species on sightings.species_id =species.species_id
join rangers on sightings.ranger_id=rangers.ranger_id
ORDER BY  sightings.sighting_time desc limit 2;

--problem 7
Update species set conservation_status='Historic' where EXTRACT(YEAR FROM discovery_date)<1800;
--problem 8
Select
  sighting_id,
  Case 
    When EXTRACT(hour from sighting_time) < 12 THEN 'Morning'
    when EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS time_of_day
FROM sightings;
-- problem 9
DELETE FROM rangers
WHERE ranger_id NOT IN (
  SELECT ranger_id FROM sightings
);
