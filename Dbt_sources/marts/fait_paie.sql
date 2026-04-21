{{ config(
    materialized='table',
    schema='marts',
    tags=['fact']
) }}

SELECT 
    -- Clés étrangères
    p.paie_id,
    p.employe_id,
    p.usine_id,
    p.departement_id,
    d.date_key AS mois_paie_key,
    d2.date_key AS date_presence_key,
    
    -- Métriques
    p.salaire_brut,
    p.retenues,
    p.salaire_net,
    p.heures_travaillees,
    p.heures_sup,
    p.total_heures,
    p.taux_prelevement_pourcentage,
    p.salaire_horaire_brut,
    
    -- Dimensions supplémentaires
    p.poste,
    p.type_site,
    p.tranche_age,
    p.tranche_anciennete,
    p.niveau_salaire,
    p.a_fait_heures_sup,
    
    -- Date de chargement
    CURRENT_TIMESTAMP() AS loaded_at

FROM {{ ref('stg_rh_paie') }} p
LEFT JOIN {{ ref('dim_temps') }} d ON DATE(p.mois_paie) = d.date
LEFT JOIN {{ ref('dim_temps') }} d2 ON DATE(p.date_presence) = d2.date
WHERE p.paie_id IS NOT NULL