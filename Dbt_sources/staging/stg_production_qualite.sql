{{ config(
    materialized='table',
    schema='staging',
    tags=['staging']
) }}

WITH base AS (
    SELECT
        -- Identifiants
        TRY_CAST(OF_ID AS NUMBER(10,0)) AS of_id,
        NumeroOF AS numero_of,
        TRY_CAST(UsineID AS NUMBER(10,0)) AS usine_id,
        UsineNom AS usine_nom,
        TRY_CAST(ProduitFiniID AS NUMBER(10,0)) AS produit_fini_id,
        ProduitFiniNom AS produit_fini_nom,
        
        -- DATES - Uniformisation MM/DD/YYYY
        CASE 
            WHEN DateLancement IS NULL OR DateLancement = '' THEN NULL
            ELSE
                TRY_TO_DATE(
                    CASE 
                        WHEN TRY_CAST(SUBSTR(DateLancement, 1, 2) AS INT) > 12 THEN
                            SUBSTR(DateLancement, 4, 2) || '/' || 
                            SUBSTR(DateLancement, 1, 2) || '/' || 
                            SUBSTR(DateLancement, 7, 4)
                        ELSE
                            DateLancement
                    END,
                    'MM/DD/YYYY'
                )
        END AS date_lancement,
        
        CASE 
            WHEN DateFinPrevue IS NULL OR DateFinPrevue = '' THEN NULL
            ELSE
                TRY_TO_DATE(
                    CASE 
                        WHEN TRY_CAST(SUBSTR(DateFinPrevue, 1, 2) AS INT) > 12 THEN
                            SUBSTR(DateFinPrevue, 4, 2) || '/' || 
                            SUBSTR(DateFinPrevue, 1, 2) || '/' || 
                            SUBSTR(DateFinPrevue, 7, 4)
                        ELSE
                            DateFinPrevue
                    END,
                    'MM/DD/YYYY'
                )
        END AS date_fin_prevue,
        
        CASE 
            WHEN DateFinReelle IS NULL OR DateFinReelle = '' THEN NULL
            ELSE
                TRY_TO_DATE(
                    CASE 
                        WHEN TRY_CAST(SUBSTR(DateFinReelle, 1, 2) AS INT) > 12 THEN
                            SUBSTR(DateFinReelle, 4, 2) || '/' || 
                            SUBSTR(DateFinReelle, 1, 2) || '/' || 
                            SUBSTR(DateFinReelle, 7, 4)
                        ELSE
                            DateFinReelle
                    END,
                    'MM/DD/YYYY'
                )
        END AS date_fin_reelle,
        
        CASE 
            WHEN DateProduction IS NULL OR DateProduction = '' THEN NULL
            ELSE
                TRY_TO_DATE(
                    CASE 
                        WHEN TRY_CAST(SUBSTR(DateProduction, 1, 2) AS INT) > 12 THEN
                            SUBSTR(DateProduction, 4, 2) || '/' || 
                            SUBSTR(DateProduction, 1, 2) || '/' || 
                            SUBSTR(DateProduction, 7, 4)
                        ELSE
                            DateProduction
                    END,
                    'MM/DD/YYYY'
                )
        END AS date_production,
        
        CASE 
            WHEN DateControle IS NULL OR DateControle = '' THEN NULL
            ELSE
                TRY_TO_DATE(
                    CASE 
                        WHEN TRY_CAST(SUBSTR(DateControle, 1, 2) AS INT) > 12 THEN
                            SUBSTR(DateControle, 4, 2) || '/' || 
                            SUBSTR(DateControle, 1, 2) || '/' || 
                            SUBSTR(DateControle, 7, 4)
                        ELSE
                            DateControle
                    END,
                    'MM/DD/YYYY'
                )
        END AS date_controle,
        
        TRY_CAST(DateCreationControle AS TIMESTAMP) AS date_creation_controle,
        
        -- Quantités (valeur absolue)
        ABS(TRY_CAST(QuantitePrevue AS NUMBER(12,2))) AS quantite_prevue,
        ABS(TRY_CAST(QuantiteReelle AS NUMBER(12,2))) AS quantite_reelle,
        
        -- RENDEMENT POURCENTAGE (calculé)
        CASE 
            WHEN ABS(TRY_CAST(QuantitePrevue AS NUMBER(12,2))) > 0 
            THEN ROUND(
                ABS(TRY_CAST(QuantiteReelle AS NUMBER(12,2))) / 
                ABS(TRY_CAST(QuantitePrevue AS NUMBER(12,2))) * 100, 
                2
            )
            ELSE NULL
        END AS rendement_pourcentage,
        
        -- Statut
        Statut AS statut,
        
        -- Lot
        TRY_CAST(LotID AS NUMBER(10,0)) AS lot_id,
        NumeroLot AS numero_lot,
        MatierePremiereLot AS matiere_premiere_lot,
        ProduitFiniLot AS produit_fini_lot,
        
        -- Contrôle qualité
        QualiteControle AS qualite_controle,
        TRY_CAST(ControleID AS NUMBER(10,0)) AS controle_id,
        Parametre AS parametre,
        TRY_CAST(REPLACE(ValeurMesure, ',', '.') AS NUMBER(12,2)) AS valeur_mesure,
        TRY_CAST(REPLACE(SeuilConformite, ',', '.') AS NUMBER(12,2)) AS seuil_conformite,
        
        -- Écart par rapport au seuil (calculé)
        CASE 
            WHEN TRY_CAST(REPLACE(ValeurMesure, ',', '.') AS NUMBER(12,2)) IS NOT NULL 
             AND TRY_CAST(REPLACE(SeuilConformite, ',', '.') AS NUMBER(12,2)) IS NOT NULL
            THEN ROUND(
                TRY_CAST(REPLACE(ValeurMesure, ',', '.') AS NUMBER(12,2)) - 
                TRY_CAST(REPLACE(SeuilConformite, ',', '.') AS NUMBER(12,2)),
                2
            )
            ELSE NULL
        END AS ecart_par_rapport_seuil,
        
        -- Conformité (boolean)
        CASE 
            WHEN UPPER(Conforme) = 'TRUE' THEN TRUE
            WHEN UPPER(Conforme) = 'FALSE' THEN FALSE
            ELSE NULL
        END AS est_conforme,
        
        -- Date de chargement
        CURRENT_TIMESTAMP() AS loaded_at

    FROM {{ source('raw', 'RAW_PRODUCTION_QUALITE') }}
)

SELECT * FROM base
WHERE of_id IS NOT NULL