{{ config(
    materialized='table',
    schema='staging',
    tags=['staging']
) }}

WITH base AS (
    SELECT
        -- Identifiants commande
        TRY_CAST(CommandeID AS NUMBER(10,0)) AS commande_id,
        NumeroCommande AS numero_commande,
        TRY_CAST(ClientID AS NUMBER(10,0)) AS client_id,
        ClientNom AS client_nom,
        TypeClient AS type_client,
        ClientPays AS client_pays,
        
        -- DATES COMMANDE - Uniformisation MM/DD/YYYY
        CASE 
            WHEN DateCommande IS NULL OR DateCommande = '' THEN NULL
            ELSE
                TRY_TO_DATE(
                    CASE 
                        WHEN TRY_CAST(SUBSTR(DateCommande, 1, 2) AS INT) > 12 THEN
                            SUBSTR(DateCommande, 4, 2) || '/' || 
                            SUBSTR(DateCommande, 1, 2) || '/' || 
                            SUBSTR(DateCommande, 7, 4)
                        ELSE
                            DateCommande
                    END,
                    'MM/DD/YYYY'
                )
        END AS date_commande,
        
        -- DATE LIVRAISON PREVUE - Uniformisation MM/DD/YYYY
        CASE 
            WHEN DateLivraisonPrevue IS NULL OR DateLivraisonPrevue = '' THEN NULL
            ELSE
                TRY_TO_DATE(
                    CASE 
                        WHEN TRY_CAST(SUBSTR(DateLivraisonPrevue, 1, 2) AS INT) > 12 THEN
                            SUBSTR(DateLivraisonPrevue, 4, 2) || '/' || 
                            SUBSTR(DateLivraisonPrevue, 1, 2) || '/' || 
                            SUBSTR(DateLivraisonPrevue, 7, 4)
                        ELSE
                            DateLivraisonPrevue
                    END,
                    'MM/DD/YYYY'
                )
        END AS date_livraison_prevue,
        
        -- DATE MOUVEMENT - Uniformisation MM/DD/YYYY
        CASE 
            WHEN DateMouvement IS NULL OR DateMouvement = '' THEN NULL
            ELSE
                TRY_TO_DATE(
                    CASE 
                        WHEN TRY_CAST(SUBSTR(DateMouvement, 1, 2) AS INT) > 12 THEN
                            SUBSTR(DateMouvement, 4, 2) || '/' || 
                            SUBSTR(DateMouvement, 1, 2) || '/' || 
                            SUBSTR(DateMouvement, 7, 4)
                        ELSE
                            DateMouvement
                    END,
                    'MM/DD/YYYY'
                )
        END AS date_mouvement,
        
        -- DATE CREATION MOUVEMENT - TIMESTAMP
        TRY_CAST(DateCreationMouvement AS TIMESTAMP) AS date_creation_mouvement,
        
        -- Montants
        ABS(TRY_CAST(MontantTotalHT AS NUMBER(18,2))) AS montant_total_ht,
        StatutCommande AS statut_commande,
        
        -- Lignes commande
        TRY_CAST(LigneID AS NUMBER(10,0)) AS ligne_id,
        TRY_CAST(ProduitID AS NUMBER(10,0)) AS produit_id,
        ProduitNom AS produit_nom,
        ProduitFamille AS produit_famille,
        ABS(TRY_CAST(QuantiteCommandee AS NUMBER(12,2))) AS quantite_commandee,
        ABS(TRY_CAST(PrixUnitaireVente AS NUMBER(12,2))) AS prix_unitaire_vente,
        ABS(TRY_CAST(MontantLigneHT AS NUMBER(18,2))) AS montant_ligne_ht,
        
        -- Mouvements stock
        TRY_CAST(MouvementID AS NUMBER(10,0)) AS mouvement_id,
        RefMouvement AS ref_mouvement,
        TRY_CAST(UsineID AS NUMBER(10,0)) AS usine_id,
        UsineNom AS usine_nom,
        TypeMouvement AS type_mouvement,
        ABS(TRY_CAST(QuantiteMouvement AS NUMBER(12,2))) AS quantite_mouvement,
        DocumentReference AS document_reference,
        
        -- Date de chargement
        CURRENT_TIMESTAMP() AS loaded_at

    FROM {{ source('raw', 'RAW_VENTES_STOCK') }}
)

SELECT 
    commande_id,
    numero_commande,
    client_id,
    client_nom,
    type_client,
    client_pays,
    date_commande,
    date_livraison_prevue,
    
    -- Délai de livraison prévu (en jours)
    DATEDIFF(DAY, date_commande, date_livraison_prevue) AS delai_livraison_jours,
    
    montant_total_ht,
    statut_commande,
    ligne_id,
    produit_id,
    produit_nom,
    produit_famille,
    quantite_commandee,
    prix_unitaire_vente,
    montant_ligne_ht,
    mouvement_id,
    ref_mouvement,
    usine_id,
    usine_nom,
    date_mouvement,
    type_mouvement,
    quantite_mouvement,
    document_reference,
    date_creation_mouvement,
    
    -- Indicateur si mouvement associé
    CASE 
        WHEN mouvement_id IS NOT NULL THEN TRUE
        ELSE FALSE
    END AS a_mouvement_associe,
    
    -- Prix total par ligne (vérification)
    ROUND(quantite_commandee * prix_unitaire_vente, 2) AS montant_ligne_calcule,
    
    -- Écart entre montant ligne déclaré et calculé
    ROUND(montant_ligne_ht - (quantite_commandee * prix_unitaire_vente), 2) AS ecart_montant_ligne,
    
    -- Classification du client
    CASE 
        WHEN type_client = 'exportateur' THEN 'Export'
        WHEN type_client = 'industriel' THEN 'Industrie'
        WHEN type_client = 'grossiste' THEN 'Grossiste'
        WHEN type_client = 'distributeur' THEN 'Distribution'
        ELSE 'Autre'
    END AS categorie_client,
    
    -- Classification du statut
    CASE 
        WHEN statut_commande IN ('Livrée', 'Expédiée') THEN 'Finalisée'
        WHEN statut_commande = 'Confirmée' THEN 'Confirmée'
        WHEN statut_commande = 'En attente' THEN 'En attente'
        ELSE 'Autre'
    END AS statut_categorie,
    
    loaded_at

FROM base
WHERE commande_id IS NOT NULL