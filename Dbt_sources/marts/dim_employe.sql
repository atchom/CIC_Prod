{{ config(
    materialized='table',
    schema='marts',
    tags=['dimension']
) }}

SELECT DISTINCT
    employe_id,
    matricule,
    sexe,
    nationalite,
    situation_maritale,
    poste,
    departement_id,
    departement_code,
    departement_nom,
    departement_description,
    usine_id,
    type_site,
    date_embauche,
    anciennete_annees,
    tranche_anciennete,
    niveau_salaire,
    CURRENT_TIMESTAMP() AS loaded_at

FROM {{ ref('stg_rh_paie') }}
WHERE employe_id IS NOT NULL