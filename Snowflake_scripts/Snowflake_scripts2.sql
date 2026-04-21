# connexion a snowflake en remote via snowSQL:
snowsql -a XXXXXXX-XXXXX17 -u password

# pour connaitre les ROLES
show ROLES
#pour connaitre le role en cours
show current_role()
#pour connaitre les warehouse creer dans ce role
show warehouse
# creation du warehouse
Create Warehouse sandji_WH
warehouse_size = 'XSMALL'
auto_suspend = 120
auto_resume =TRUE
INITIALLY_SUSPENDED = TRUE;

use Warehouse sandji_WH

#pour changer de warehouse
use warehouse sandji_db_wh
use 

#Pour acceder au role
use role sysadmin
#Pour notre projet,l\access a notre warehouse:
use warehouse sandji_dbt_wh

# pour se loger dans la base de donnees au choix

use CIC_DBT_DB
#ensuite on entre dans le schema correspondant
 use schema raw
 
 # On creer les tables dans ce schema
 
## Creation de la table RAW_PRIX_MARCHE_LOGISTIQUE
CREATE OR REPLACE TABLE RAW_PRIX_MARCHE_LOGISTIQUE (
    Date VARCHAR,
    Variete VARCHAR,
    PrixUSD_Tonne VARCHAR,
    Source VARCHAR,
    DateExport VARCHAR,
    NumeroRapportSGS VARCHAR,
    Produit VARCHAR,
    QuantiteTonnes VARCHAR,
    ValeurFOB_USD VARCHAR,
    PaysDestination VARCHAR,
    DateOperation VARCHAR,
    Reference VARCHAR,
    Debit VARCHAR,
    Credit VARCHAR,
    Devise VARCHAR,
    Libelle VARCHAR
);
# une fois que la tab
# Création d’un stage interne (si inexistant)
CREATE OR REPLACE STAGE STAGE_INTERNAL;

# Mise en ligne du fichier
PUT 'file://C:\\CIC_Github\\CSV_PRIX_MARCHE_LOGISTIQUE.csv' @STAGE_INTERNAL;

# Mise en ligne du fichier
COPY INTO RAW_PRIX_MARCHE_LOGISTIQUE
FROM @STAGE_INTERNAL/CSV_PRIX_MARCHE_LOGISTIQUE.csv
FILE_FORMAT = (
    TYPE = 'CSV'
    FIELD_DELIMITER = ';'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF = ('NULL', '')
)
ON_ERROR = 'CONTINUE';
## creation de la table Raw_Rapport_mensuel
CREATE OR REPLACE TABLE RAW_RAPPORT_MENSUEL (
    Mois VARCHAR,
    ChiffreAffaires_XAF VARCHAR,
    ProductionTotaleTonnes VARCHAR,
    VentesTotalesTonnes VARCHAR,
    StockFinalTonnes VARCHAR,
    NbCommandes VARCHAR,
    NbEmployes VARCHAR,
    TauxRotationStock VARCHAR
);

# Mise en ligne du fichier
PUT 'file://C:\\CIC_Github\\CSV_RAPPORT_MENSUEL.csv' @STAGE_INTERNAL;

# Mise en ligne du fichier
COPY INTO RAW_RAPPORT_MENSUEL
FROM @STAGE_INTERNAL/CSV_RAPPORT_MENSUEL.csv
FILE_FORMAT = (
    TYPE = 'CSV'
    FIELD_DELIMITER = ';'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF = ('NULL', '')
)
ON_ERROR = 'CONTINUE';
## creation de la table RAW_ACHATS_FOURNISSEURS
CREATE OR REPLACE TABLE RAW_ACHATS_FOURNISSEURS (
    AchatID VARCHAR(20),
    NumeroBonAchat VARCHAR(20),
    FournisseurID VARCHAR(10),
    ProduitID VARCHAR(10),
    DateAchat VARCHAR(20),
    QuantiteTonnes VARCHAR(20),
    PrixTotalHT VARCHAR(20),
    PrixMoyenParTonne VARCHAR(20),
    NumeroLotFournisseur VARCHAR(30),
    StatutControleAchat VARCHAR(30),
    DateCreationAchat VARCHAR(50),
    FournisseurNom VARCHAR(100),
    FournisseurTypeProduit VARCHAR(50),
    FournisseurAdresse VARCHAR(200),
    FournisseurVille VARCHAR(100),
    FournisseurPays VARCHAR(100),
    CodeProduit VARCHAR(10),
    ProduitNom VARCHAR(100),
    ProduitFamille VARCHAR(50),
    Unite VARCHAR(20),
    PrixUnitaireStandard VARCHAR(20)
);

# Mise en ligne du fichier
PUT 'file://C:\\CIC_Github\\SRC_ACHATS_FOURNISSEURS.csv' @STAGE_INTERNAL;


# Mise en ligne du fichier
COPY INTO RAW_ACHATS_FOURNISSEURS
FROM @STAGE_INTERNAL/SRC_ACHATS_FOURNISSEURS.csv
FILE_FORMAT = (
    TYPE = 'CSV'
    FIELD_DELIMITER = ';'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF = ('NULL', '')
)
ON_ERROR = 'CONTINUE';

creation de la table raw_production_qualite
CREATE OR REPLACE TABLE RAW_PRODUCTION_QUALITE (
    OF_ID VARCHAR(20),
    NumeroOF VARCHAR(20),
    UsineID VARCHAR(10),
    UsineNom VARCHAR(100),
    ProduitFiniID VARCHAR(10),
    ProduitFiniNom VARCHAR(100),
    DateLancement VARCHAR(20),
    DateFinPrevue VARCHAR(20),
    DateFinReelle VARCHAR(20),
    QuantitePrevue VARCHAR(20),
    QuantiteReelle VARCHAR(20),
    Statut VARCHAR(30),
    LotID VARCHAR(20),
    NumeroLot VARCHAR(30),
    MatierePremiereLot VARCHAR(30),
    ProduitFiniLot VARCHAR(50),
    DateProduction VARCHAR(20),
    QualiteControle VARCHAR(30),
    ControleID VARCHAR(20),
    DateControle VARCHAR(20),
    Parametre VARCHAR(100),
    ValeurMesure VARCHAR(50),
    SeuilConformite VARCHAR(50),
    Conforme VARCHAR(10),
    DateCreationControle VARCHAR(50)
);

# Mise en ligne du fichier
PUT 'file://C:\\CIC_Github\\SRC_PRODUIT_QUALITE.csv' @STAGE_INTERNAL;

# Mise en ligne du fichier
COPY INTO RAW_PRODUCTION_QUALITE
FROM @STAGE_INTERNAL/SRC_PRODUIT_QUALITE.csv
FILE_FORMAT = (
    TYPE = 'CSV'
    FIELD_DELIMITER = ';'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF = ('NULL', '')
)
ON_ERROR = 'CONTINUE';

##creation de la table Raw RH_PAIE
CREATE OR REPLACE TABLE RAW_RH_PAIE (
    EmployeID VARCHAR(20),
    Matricule VARCHAR(20),
    Sexe VARCHAR(10),
    DateNaissance VARCHAR(20),
    Nationalite VARCHAR(50),
    NumeroIdentite VARCHAR(30),
    SituationMaritale VARCHAR(30),
    Poste VARCHAR(100),
    DateEmbauche VARCHAR(20),
    SalaireContractuel VARCHAR(20),
    DepartementID VARCHAR(10),
    DepartementCode VARCHAR(10),
    DepartementNom VARCHAR(100),
    DepartementDescription VARCHAR(200),
    UsineID VARCHAR(10),
    UsineNom VARCHAR(100),
    UsineVille VARCHAR(50),
    UsineRegion VARCHAR(50),
    TypeSite VARCHAR(20),
    PaieID VARCHAR(20),
    MoisPaie VARCHAR(20),
    SalaireBrut VARCHAR(20),
    Retenues VARCHAR(20),
    SalaireNet VARCHAR(20),
    PresenceID VARCHAR(20),
    DatePresence VARCHAR(20),
    HeuresTravaillees VARCHAR(20),
    HeuresSup VARCHAR(20),
    DateCreationEmploye VARCHAR(50),
    DateModificationEmploye VARCHAR(50)
);
PUT 'file://C:\\CIC_Github\\SRC_RH_PAIE.csv' @STAGE_INTERNAL;

# Mise en ligne du fichier
COPY INTO RAW_RH_PAIE
FROM @STAGE_INTERNAL/SRC_RH_PAIE.csv
FILE_FORMAT = (
    TYPE = 'CSV'
    FIELD_DELIMITER = ';'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF = ('NULL', '')
)
ON_ERROR = 'CONTINUE';

## Creation de la table Raw_ventes_stock

CREATE OR REPLACE TABLE RAW_VENTES_STOCK (
    CommandeID VARCHAR(20),
    NumeroCommande VARCHAR(20),
    ClientID VARCHAR(20),
    ClientNom VARCHAR(100),
    TypeClient VARCHAR(30),
    ClientPays VARCHAR(50),
    DateCommande VARCHAR(20),
    DateLivraisonPrevue VARCHAR(20),
    MontantTotalHT VARCHAR(20),
    StatutCommande VARCHAR(30),
    LigneID VARCHAR(20),
    ProduitID VARCHAR(20),
    ProduitNom VARCHAR(100),
    ProduitFamille VARCHAR(50),
    QuantiteCommandee VARCHAR(20),
    PrixUnitaireVente VARCHAR(20),
    MontantLigneHT VARCHAR(20),
    MouvementID VARCHAR(20),
    RefMouvement VARCHAR(30),
    UsineID VARCHAR(20),
    UsineNom VARCHAR(100),
    DateMouvement VARCHAR(20),
    TypeMouvement VARCHAR(20),
    QuantiteMouvement VARCHAR(20),
    DocumentReference VARCHAR(30),
    DateCreationMouvement VARCHAR(50)
);

PUT 'file://C:\\CIC_Github\\SRC_VENTES_STOCK.csv' @STAGE_INTERNAL;

COPY INTO RAW_VENTES_STOCK
FROM @STAGE_INTERNAL/SRC_VENTES_STOCK.csv
FILE_FORMAT = (
    TYPE = 'CSV'
    FIELD_DELIMITER = ';'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF = ('NULL', '')
)
ON_ERROR = 'CONTINUE';

# Mise en ligne du fichier autre methode
COPY INTO RAW.livraisons_cooperative (DateReception, NomCooperative, LotFournisseur, QuantiteKg, TauxFermentation, NoteQualite, DateChargement)
FROM (
    SELECT 
        $1::VARCHAR(20),
        $2::VARCHAR(200),
        $3::VARCHAR(50),
        $4::VARCHAR(50),
        $5::VARCHAR(20),
        $6::VARCHAR(100),
        CURRENT_TIMESTAMP()  -- ← DateChargement explicite
    FROM @RAW.stage_livraisons/livraisons_cooperative.csv
)
FILE_FORMAT = RAW.csv_livraisons_format
ON_ERROR = 'CONTINUE';

dbt run --select stg_prix_marche_logistique
