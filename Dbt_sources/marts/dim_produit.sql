{{ config(
    materialized='table',
    schema='marts',
    tags=['dimension']
) }}

WITH produits_ventes AS (
    SELECT DISTINCT
        produit_id,
        produit_nom,
        produit_famille,
        NULL AS code_produit,
        NULL AS unite
    FROM {{ ref('stg_ventes_stock') }}
    WHERE produit_id IS NOT NULL
),

produits_achats AS (
    SELECT DISTINCT
        produit_id,
        produit_nom,
        produit_famille,
        code_produit,
        unite
    FROM {{ ref('stg_achats_fournisseurs') }}
    WHERE produit_id IS NOT NULL
),

produits_production AS (
    SELECT DISTINCT
        produit_fini_id AS produit_id,
        produit_fini_nom AS produit_nom,
        NULL AS produit_famille,
        NULL AS code_produit,
        NULL AS unite
    FROM {{ ref('stg_production_qualite') }}
    WHERE produit_fini_id IS NOT NULL
)

SELECT 
    COALESCE(v.produit_id, a.produit_id, p.produit_id) AS produit_id,
    COALESCE(v.produit_nom, a.produit_nom, p.produit_nom) AS produit_nom,
    COALESCE(v.produit_famille, a.produit_famille) AS produit_famille,
    a.code_produit,
    a.unite,
    CASE 
        WHEN v.produit_id IS NOT NULL THEN 'Vente'
        WHEN a.produit_id IS NOT NULL THEN 'Achat'
        WHEN p.produit_id IS NOT NULL THEN 'Production'
    END AS source_produit,
    CURRENT_TIMESTAMP() AS loaded_at

FROM produits_ventes v
FULL OUTER JOIN produits_achats a ON v.produit_id = a.produit_id
FULL OUTER JOIN produits_production p ON COALESCE(v.produit_id, a.produit_id) = p.produit_id