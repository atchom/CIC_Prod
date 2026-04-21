{{ config(
    materialized='table',
    schema='marts',
    tags=['dimension']
) }}

SELECT DISTINCT
    client_id,
    client_nom,
    type_client,
    client_pays,
    CASE 
        WHEN type_client = 'exportateur' THEN 'Export'
        WHEN type_client = 'industriel' THEN 'Industrie'
        WHEN type_client = 'grossiste' THEN 'Grossiste'
        WHEN type_client = 'distributeur' THEN 'Distribution'
        ELSE 'Autre'
    END AS categorie_client,
    CASE 
        WHEN client_pays = 'Cameroun' THEN 'Local'
        ELSE 'International'
    END AS type_zone,
    CURRENT_TIMESTAMP() AS loaded_at

FROM {{ ref('stg_ventes_stock') }}
WHERE client_id IS NOT NULL