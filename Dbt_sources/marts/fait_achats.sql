{{ config(
    materialized='table',
    schema='marts',
    tags=['fact']
) }}

SELECT 
    -- Clés étrangères
    a.achat_id,
    a.fournisseur_id,
    a.produit_id,
    d.date_key AS date_achat_key,
    
    -- Métriques
    a.quantite_tonnes,
    a.prix_total_ht,
    a.prix_moyen_par_tonne,
    a.prix_unitaire_standard,
    
    -- Dimensions supplémentaires
    a.fournisseur_nom,
    a.fournisseur_type_produit,
    a.fournisseur_pays,
    a.produit_nom,
    a.produit_famille,
    a.statut_controle_achat,
    a.numero_lot_fournisseur,
    
    -- Date de chargement
    CURRENT_TIMESTAMP() AS loaded_at

FROM {{ ref('stg_achats_fournisseurs') }} a
LEFT JOIN {{ ref('dim_temps') }} d ON DATE(a.date_achat) = d.date
WHERE a.achat_id IS NOT NULL