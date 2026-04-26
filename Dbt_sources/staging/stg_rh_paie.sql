{{ config(
    materialized='table',
    schema='staging',
    tags=['staging']
) }}

WITH base AS (
    SELECT
        -- Identifiants employé
        TRY_CAST(EmployeID AS NUMBER(10,0)) AS employe_id,
        Matricule AS matricule,
        
        -- Informations personnelles
        Sexe AS sexe,
        
        -- UNIFORMISATION DES DATES AU FORMAT MM/DD/YYYY
        CASE 
            WHEN DateNaissance IS NULL OR DateNaissance = '' THEN NULL
            ELSE
                TRY_TO_DATE(
                    CASE 
                        WHEN TRY_CAST(SUBSTR(DateNaissance, 1, 2) AS INT) > 12 THEN
                            SUBSTR(DateNaissance, 4, 2) || '/' || 
                            SUBSTR(DateNaissance, 1, 2) || '/' || 
                            SUBSTR(DateNaissance, 7, 4)
                        ELSE
                            DateNaissance
                    END,
                    'MM/DD/YYYY'
                )
        END AS date_naissance,
        
        -- Même logique pour DateEmbauche
        CASE 
            WHEN DateEmbauche IS NULL OR DateEmbauche = '' THEN NULL
            ELSE
                TRY_TO_DATE(
                    CASE 
                        WHEN TRY_CAST(SUBSTR(DateEmbauche, 1, 2) AS INT) > 12 THEN
                            SUBSTR(DateEmbauche, 4, 2) || '/' || 
                            SUBSTR(DateEmbauche, 1, 2) || '/' || 
                            SUBSTR(DateEmbauche, 7, 4)
                        ELSE
                            DateEmbauche
                    END,
                    'MM/DD/YYYY'
                )
        END AS date_embauche,
        
        -- Même logique pour DatePresence
        CASE 
            WHEN DatePresence IS NULL OR DatePresence = '' THEN NULL
            ELSE
                TRY_TO_DATE(
                    CASE 
                        WHEN TRY_CAST(SUBSTR(DatePresence, 1, 2) AS INT) > 12 THEN
                            SUBSTR(DatePresence, 4, 2) || '/' || 
                            SUBSTR(DatePresence, 1, 2) || '/' || 
                            SUBSTR(DatePresence, 7, 4)
                        ELSE
                            DatePresence
                    END,
                    'MM/DD/YYYY'
                )
        END AS date_presence,
        
        -- CORRECTION POUR MOIS_PAIE
        CASE 
            WHEN MoisPaie IS NULL OR MoisPaie = '' THEN NULL
            ELSE
                DATE_TRUNC('MONTH', TRY_TO_DATE(
                    CASE 
                        WHEN TRY_CAST(SUBSTR(MoisPaie, 1, 2) AS INT) > 12 THEN
                            SUBSTR(MoisPaie, 4, 2) || '/' || 
                            SUBSTR(MoisPaie, 1, 2) || '/' || 
                            SUBSTR(MoisPaie, 7, 4)
                        ELSE
                            MoisPaie
                    END,
                    'MM/DD/YYYY'
                ))
        END AS mois_paie,
        
        Nationalite AS nationalite,
        NumeroIdentite AS numero_identite,
        SituationMaritale AS situation_maritale,
        
        -- Poste et carrière
        Poste AS poste,
        ABS(TRY_CAST(SalaireContractuel AS NUMBER(12,2))) AS salaire_contractuel,
        
        -- Département
        TRY_CAST(DepartementID AS NUMBER(10,0)) AS departement_id,
        DepartementCode AS departement_code,
        DepartementNom AS departement_nom,
        DepartementDescription AS departement_description,
        
        -- Usine
        TRY_CAST(UsineID AS NUMBER(10,0)) AS usine_id,
        UsineNom AS usine_nom,
        UsineVille AS usine_ville,
        UsineRegion AS usine_region,
        TypeSite AS type_site,
        
        -- Paie
        TRY_CAST(PaieID AS NUMBER(10,0)) AS paie_id,
        ABS(TRY_CAST(SalaireBrut AS NUMBER(12,2))) AS salaire_brut,
        ABS(TRY_CAST(Retenues AS NUMBER(12,2))) AS retenues,
        ABS(TRY_CAST(SalaireNet AS NUMBER(12,2))) AS salaire_net,
        
        -- Présence
        TRY_CAST(PresenceID AS NUMBER(10,0)) AS presence_id,
        ABS(TRY_CAST(HeuresTravaillees AS NUMBER(5,2))) AS heures_travaillees,
        ABS(TRY_CAST(HeuresSup AS NUMBER(5,2))) AS heures_sup,
        
        -- Métadonnées
        TRY_CAST(DateCreationEmploye AS TIMESTAMP) AS date_creation_employe,
        TRY_CAST(DateModificationEmploye AS TIMESTAMP) AS date_modification_employe,
        
        -- Date de chargement
        CURRENT_TIMESTAMP() AS loaded_at

    FROM {{ source('raw', 'RAW_RH_PAIE') }}
)

SELECT 
    employe_id,
    matricule,
    sexe,
    date_naissance,
    date_embauche,
    date_presence,
    mois_paie,
    
    -- COLONNES CALCULÉES
    
    -- Âge calculé
    DATEDIFF(YEAR, date_naissance, CURRENT_DATE()) AS age,
    
    -- Ancienneté (en années)
    DATEDIFF(YEAR, date_embauche, CURRENT_DATE()) AS anciennete_annees,
    
    -- Taux de prélèvement en pourcentage
    CASE 
        WHEN salaire_brut > 0 
        THEN ROUND((retenues / salaire_brut) * 100, 2)
        ELSE 0
    END AS taux_prelevement_pourcentage,
    
    -- Total heures (normales + sup)
    COALESCE(heures_travaillees, 0) + COALESCE(heures_sup, 0) AS total_heures,
    
    -- Salaire horaire (si heures travaillées > 0)
    CASE 
        WHEN COALESCE(heures_travaillees, 0) > 0 
        THEN ROUND(salaire_brut / heures_travaillees, 2)
        ELSE 0
    END AS salaire_horaire_brut,
    
    -- Classification par âge
    CASE 
        WHEN DATEDIFF(YEAR, date_naissance, CURRENT_DATE()) < 25 THEN 'Jeune (moins de 25 ans)'
        WHEN DATEDIFF(YEAR, date_naissance, CURRENT_DATE()) BETWEEN 25 AND 35 THEN '25-35 ans'
        WHEN DATEDIFF(YEAR, date_naissance, CURRENT_DATE()) BETWEEN 36 AND 45 THEN '36-45 ans'
        WHEN DATEDIFF(YEAR, date_naissance, CURRENT_DATE()) BETWEEN 46 AND 55 THEN '46-55 ans'
        ELSE 'Senior (plus de 55 ans)'
    END AS tranche_age,
    
    -- Classification par ancienneté
    CASE 
        WHEN DATEDIFF(YEAR, date_embauche, CURRENT_DATE()) < 1 THEN 'Moins d\'1 an'
        WHEN DATEDIFF(YEAR, date_embauche, CURRENT_DATE()) BETWEEN 1 AND 3 THEN '1-3 ans'
        WHEN DATEDIFF(YEAR, date_embauche, CURRENT_DATE()) BETWEEN 4 AND 7 THEN '4-7 ans'
        WHEN DATEDIFF(YEAR, date_embauche, CURRENT_DATE()) BETWEEN 8 AND 12 THEN '8-12 ans'
        ELSE 'Plus de 12 ans'
    END AS tranche_anciennete,
    
    -- Niveau de salaire
    CASE 
        WHEN salaire_brut < 500000 THEN 'Bas'
        WHEN salaire_brut BETWEEN 500000 AND 1000000 THEN 'Moyen'
        WHEN salaire_brut BETWEEN 1000001 AND 2000000 THEN 'Élevé'
        ELSE 'Très élevé'
    END AS niveau_salaire,
    
    -- Heures supplémentaires (oui/non)
    CASE 
        WHEN COALESCE(heures_sup, 0) > 0 THEN 'Oui'
        ELSE 'Non'
    END AS a_fait_heures_sup,
    
    nationalite,
    numero_identite,
    situation_maritale,
    poste,
    salaire_contractuel,
    departement_id,
    departement_code,
    departement_nom,
    departement_description,
    usine_id,
    usine_nom,
    usine_ville,
    usine_region,
    type_site,
    paie_id,
    salaire_brut,
    retenues,
    salaire_net,
    presence_id,
    heures_travaillees,
    heures_sup,
    date_creation_employe,
    date_modification_employe,
    loaded_at

FROM base
WHERE employe_id IS NOT NULL