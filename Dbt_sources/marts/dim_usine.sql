{{ config(
    materialized='table',
    schema='marts',
    tags=['dimension']
) }}

WITH usines_ventes AS (
    SELECT DISTINCT
        usine_id,
        usine_nom,
        NULL AS usine_ville,
        NULL AS usine_region,
        NULL AS type_site
    FROM {{ ref('stg_ventes_stock') }}
    WHERE usine_id IS NOT NULL
),

usines_production AS (
    SELECT DISTINCT
        usine_id,
        usine_nom,
        NULL AS usine_ville,
        NULL AS usine_region,
        NULL AS type_site
    FROM {{ ref('stg_production_qualite') }}
    WHERE usine_id IS NOT NULL
),

usines_rh AS (
    SELECT DISTINCT
        usine_id,
        usine_nom,
        usine_ville,
        usine_region,
        type_site
    FROM {{ ref('stg_rh_paie') }}
    WHERE usine_id IS NOT NULL
)

SELECT 
    COALESCE(v.usine_id, p.usine_id, r.usine_id) AS usine_id,
    COALESCE(v.usine_nom, p.usine_nom, r.usine_nom) AS usine_nom,
    r.usine_ville,
    r.usine_region,
    r.type_site,
    CASE WHEN r.type_site = 'Siege' THEN 'Administratif' ELSE 'Production' END AS categorie_usine,
    CURRENT_TIMESTAMP() AS loaded_at

FROM usines_ventes v
FULL OUTER JOIN usines_production p ON v.usine_id = p.usine_id
FULL OUTER JOIN usines_rh r ON COALESCE(v.usine_id, p.usine_id) = r.usine_id