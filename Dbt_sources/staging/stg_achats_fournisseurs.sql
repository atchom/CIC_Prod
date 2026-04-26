{{ config(
    materialized='table',
    schema='staging',
    tags=['staging']
) }}

SELECT
    -- Identifiants
    TRY_CAST(AchatID AS NUMBER(10,0)) AS achat_id,
    NumeroBonAchat AS numero_bon_achat,
    TRY_CAST(FournisseurID AS NUMBER(10,0)) AS fournisseur_id,
    TRY_CAST(ProduitID AS NUMBER(10,0)) AS produit_id,
    
    -- Dates
    TRY_CAST(DateAchat AS DATE) AS date_achat,
    TRY_CAST(DateCreationAchat AS TIMESTAMP) AS date_creation_achat,
    
    -- Quantités et prix (valeur absolue pour corriger les négatifs éventuels)
    ABS(TRY_CAST(QuantiteTonnes AS NUMBER(12,2))) AS quantite_tonnes,
    ABS(TRY_CAST(PrixTotalHT AS NUMBER(18,2))) AS prix_total_ht,
    ABS(TRY_CAST(PrixMoyenParTonne AS NUMBER(12,2))) AS prix_moyen_par_tonne,
    ABS(TRY_CAST(PrixUnitaireStandard AS NUMBER(12,2))) AS prix_unitaire_standard,
    
    -- Informations fournisseur
    FournisseurNom AS fournisseur_nom,
    FournisseurTypeProduit AS fournisseur_type_produit,
    FournisseurAdresse AS fournisseur_adresse,
    FournisseurVille AS fournisseur_ville,
    FournisseurPays AS fournisseur_pays,
    
    -- Informations produit
    CodeProduit AS code_produit,
    ProduitNom AS produit_nom,
    ProduitFamille AS produit_famille,
    Unite AS unite,
    
    -- Lot et statut
    NumeroLotFournisseur AS numero_lot_fournisseur,
    StatutControleAchat AS statut_controle_achat,
    
    -- Date de chargement
    CURRENT_TIMESTAMP() AS loaded_at

FROM {{ source('raw', 'RAW_ACHATS_FOURNISSEURS') }}
WHERE AchatID IS NOT NULL  -- Exclure les lignes sans ID