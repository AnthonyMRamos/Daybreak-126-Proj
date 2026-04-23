-- Fix separators (hyphens)
-- Replaces broken characters that have a space on either side with a hyphen
UPDATE "combined_2010_to_2023_hospital_data"
SET HOSPITAL = REPLACE(HOSPITAL, ' � ', ' - ')
WHERE HOSPITAL LIKE '% �%';

UPDATE "combined_2010_to_2023_hospital_data"
SET HOSPITAL = REPLACE(HOSPITAL, ' ? ', ' - ')
WHERE HOSPITAL LIKE '% ? %';

-- Fix the grammar (apostrophes)
-- Replace the remaining broken characters tucked inside words
UPDATE "combined_2010_to_2023_hospital_data"
SET HOSPITAL = REPLACE(HOSPITAL, '�', '''')
WHERE HOSPITAL LIKE '%�%';

UPDATE "combined_2010_to_2023_hospital_data"
SET HOSPITAL = REPLACE(HOSPITAL, '?', '''')
WHERE HOSPITAL LIKE '%?%';