{{ config(materialized='table') }}

WITH base AS (
    SELECT
        TO_DATE(Date, 'DD/MM/YYYY') AS date,
        Variete,
        TRY_CAST(PrixUSD_Tonne AS NUMBER(12,2)) AS prixusd_tonne,
        Source,
        TO_DATE(DateExport, 'DD/MM/YYYY') AS dateexport,
        NumeroRapportSGS,
        Produit,
        TRY_CAST(QuantiteTonnes AS NUMBER(12,2)) AS quantitetonnes,
        TRY_CAST(ValeurFOB_USD AS NUMBER(12,2)) AS valeurfob_usd,
        PaysDestination,
        TO_DATE(DateOperation, 'DD/MM/YYYY') AS dateoperation,
        Reference,
        TRY_CAST(Debit AS NUMBER(18,2)) AS debit,
        TRY_CAST(Credit AS NUMBER(18,2)) AS credit,
        Devise,
        Libelle
    FROM {{ source('raw', 'RAW_PRIX_MARCHE_LOGISTIQUE') }}
    WHERE Date IS NOT NULL
)

SELECT * FROM base
