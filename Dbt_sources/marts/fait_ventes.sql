{{ config(
    materialized='table',
    schema='marts',
    tags=['fact']
) }}

SELECT 
    -- Clés étrangères
    v.commande_id,
    v.ligne_id,
    v.client_id,
    v.produit_id,
    v.usine_id,
    d.date_key AS date_commande_key,
    d2.date_key AS date_livraison_key,
    
    -- Métriques
    v.quantite_commandee,
    v.prix_unitaire_vente,
    v.montant_ligne_ht,
    v.montant_total_ht,
    v.delai_livraison_jours,
    v.ecart_montant_ligne,
    
    -- Dimensions supplémentaires
    v.statut_commande,
    v.type_client,
    v.client_pays,
    v.produit_famille,
    v.categorie_client,
    v.statut_categorie,
    v.a_mouvement_associe,
    
    -- Date de chargement
    CURRENT_TIMESTAMP() AS loaded_at

FROM {{ ref('stg_ventes_stock') }} v
LEFT JOIN {{ ref('dim_temps') }} d ON DATE(v.date_commande) = d.date
LEFT JOIN {{ ref('dim_temps') }} d2 ON DATE(v.date_livraison_prevue) = d2.date
WHERE v.commande_id IS NOT NULL