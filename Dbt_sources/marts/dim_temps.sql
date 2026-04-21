{{ config(
    materialized='table',
    schema='marts',
    tags=['dimension']
) }}

WITH date_spine AS (
    SELECT 
        DATEADD(DAY, SEQ4(), '2020-01-01') AS date
    FROM TABLE(GENERATOR(ROWCOUNT => 3650))  -- 10 ans de données
)

SELECT 
    date,
    TO_VARCHAR(date, 'YYYYMMDD') AS date_key,
    EXTRACT(YEAR FROM date) AS annee,
    EXTRACT(MONTH FROM date) AS mois,
    EXTRACT(DAY FROM date) AS jour,
    EXTRACT(QUARTER FROM date) AS trimestre,
    TO_VARCHAR(date, 'MMMM') AS nom_mois,
    TO_VARCHAR(date, 'MM') AS numero_mois,
    TO_VARCHAR(date, 'WW') AS semaine,
    TO_VARCHAR(date, 'DAY') AS nom_jour,
    EXTRACT(DAYOFWEEK FROM date) AS numero_jour_semaine,
    CASE WHEN EXTRACT(MONTH FROM date) BETWEEN 1 AND 3 THEN 'T1'
         WHEN EXTRACT(MONTH FROM date) BETWEEN 4 AND 6 THEN 'T2'
         WHEN EXTRACT(MONTH FROM date) BETWEEN 7 AND 9 THEN 'T3'
         ELSE 'T4'
    END AS trimestre_nom,
    CASE WHEN EXTRACT(MONTH FROM date) BETWEEN 1 AND 6 THEN 'S1'
         ELSE 'S2'
    END AS semestre,
    EXTRACT(YEAR FROM date) || '-' || LPAD(EXTRACT(MONTH FROM date), 2, '0') AS annee_mois,
    DATE_TRUNC('MONTH', date) AS premier_jour_mois,
    DATE_TRUNC('YEAR', date) AS premier_jour_annee,
    LAST_DAY(date) AS dernier_jour_mois,
    DATEDIFF('DAY', DATE_TRUNC('MONTH', date), LAST_DAY(date)) + 1 AS jours_dans_mois,
    CASE WHEN EXTRACT(DAYOFWEEK FROM date) IN (6, 7) THEN TRUE ELSE FALSE END AS est_weekend,
    CASE WHEN EXTRACT(MONTH FROM date) IN (12, 1, 2) THEN 'Hiver'
         WHEN EXTRACT(MONTH FROM date) IN (3, 4, 5) THEN 'Printemps'
         WHEN EXTRACT(MONTH FROM date) IN (6, 7, 8) THEN 'Été'
         ELSE 'Automne'
    END AS saison

FROM date_spine
WHERE date <= CURRENT_DATE()