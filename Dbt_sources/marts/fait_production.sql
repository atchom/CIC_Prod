{{ config(
    materialized='table',
    schema='marts',
    tags=['fact']
) }}

SELECT 
    -- Clés étrangères
    p.of_id,
    p.usine_id,
    p.produit_fini_id AS produit_id,
    d.date_key AS date_lancement_key,
    d2.date_key AS date_fin_prevue_key,
    d3.date_key AS date_fin_reelle_key,
    
    -- Métriques
    p.quantite_prevue,
    p.quantite_reelle,
    p.rendement_pourcentage,
    p.controle_id,
    p.valeur_mesure,
    p.seuil_conformite,
    p.ecart_par_rapport_seuil,
    
    -- Dimensions supplémentaires
    p.statut,
    p.qualite_controle,
    p.parametre,
    p.est_conforme,
    p.usine_nom,
    p.produit_fini_nom,
    
    -- Date de chargement
    CURRENT_TIMESTAMP() AS loaded_at

FROM {{ ref('stg_production_qualite') }} p
LEFT JOIN {{ ref('dim_temps') }} d ON p.date_lancement = d.date
LEFT JOIN {{ ref('dim_temps') }} d2 ON p.date_fin_prevue = d2.date
LEFT JOIN {{ ref('dim_temps') }} d3 ON p.date_fin_reelle = d3.date
WHERE p.of_id IS NOT NULL