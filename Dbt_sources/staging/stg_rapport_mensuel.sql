{{ config(
    materialized='table',
    schema='staging',
    tags=['staging']
) }}

SELECT
    -- Traitement des dates : 'Date invalide' si la date est incorrecte
    CASE 
        WHEN TRY_CAST(Mois AS DATE) IS NOT NULL THEN Mois
        WHEN Mois LIKE '____-__' AND TRY_CAST(Mois || '-01' AS DATE) IS NOT NULL THEN Mois
        ELSE 'Date invalide'
    END AS mois,
    
    -- Chiffre d'affaires (valeur absolue)
    ABS(TRY_CAST(REPLACE(REPLACE(ChiffreAffaires_XAF, ' ', ''), ',', '') AS NUMBER(18,2))) AS chiffre_affaires_xaf,
    
    -- Production totale (valeur absolue)
    ABS(TRY_CAST(REPLACE(REPLACE(ProductionTotaleTonnes, ' ', ''), ',', '') AS NUMBER(12,2))) AS production_totale_tonnes,
    
    -- Ventes totales (valeur absolue, 0 si NULL)
    COALESCE(ABS(TRY_CAST(REPLACE(REPLACE(VentesTotalesTonnes, ' ', ''), ',', '') AS NUMBER(12,2))), 0) AS ventes_totales_tonnes,
    
    -- Stock final (valeur absolue, 0 si NULL)
    COALESCE(ABS(TRY_CAST(REPLACE(REPLACE(StockFinalTonnes, ' ', ''), ',', '') AS NUMBER(12,2))), 0) AS stock_final_tonnes,
    
    -- Nombre de commandes (valeur absolue, 0 si NULL)
    COALESCE(ABS(TRY_CAST(REPLACE(REPLACE(NbCommandes, ' ', ''), ',', '') AS NUMBER(10,0))), 0) AS nb_commandes,
    
    -- Nombre d'employés (valeur absolue, 0 si NULL)
    COALESCE(ABS(TRY_CAST(REPLACE(REPLACE(NbEmployes, ' ', ''), ',', '') AS NUMBER(10,0))), 0) AS nb_employes,
    
    -- Taux de rotation du stock (valeur absolue, 0 si NULL)
    COALESCE(ABS(TRY_CAST(REPLACE(TauxRotationStock, ',', '.') AS NUMBER(10,2))), 0) AS taux_rotation_stock

FROM {{ source('raw', 'RAW_RAPPORT_MENSUEL') }}