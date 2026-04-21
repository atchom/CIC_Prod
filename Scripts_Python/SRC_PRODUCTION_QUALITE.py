import pyodbc as pyo
import pandas as pd
conn_str = (
    "Driver={ODBC Driver 17 for SQL Server};"
    "Server=ATCHOM;"
    "Database=CIC_OP;"
    "Trusted_Connection=yes;"
)
conn = pyo.connect(conn_str)
cursor = conn.cursor()

# 1. Supprimer la vue si elle existe
try:
    cursor.execute("DROP VIEW IF EXISTS SRC_PRODUCTION_QUALITE;")
    # ou pour les anciennes versions :
    # cursor.execute("IF OBJECT_ID('SRC_PRODUCTION_QUALITE', 'V') IS NOT NULL DROP VIEW SRC_PRODUCTION_QUALITE;")
    conn.commit()
except pyo.Error as e:
    print(f"Erreur lors du DROP : {e}")

# 2. Créer la vue (seule dans son batch)
# Supprimer la vue si elle existe
cursor.execute("DROP VIEW IF EXISTS SRC_PRODUCTION_QUALITE;")
conn.commit()

# Créer la vue avec alias corrigé
create_sql = """
CREATE VIEW SRC_PRODUCTION_QUALITE AS
SELECT
    ofab.OF_ID,
    ofab.NumeroOF,
    ofab.UsineID,
    u.Nom AS UsineNom,
    ofab.ProduitFiniID,
    p.NomProduit AS ProduitFiniNom,
    ofab.DateLancement,
    ofab.DateFinPrevue,
    ofab.DateFinReelle,
    ofab.QuantitePrevue,
    ofab.QuantiteReelle,
    ofab.Statut,
    tl.LotID,
    tl.NumeroLot,
    tl.MatierePremiereLot,
    tl.ProduitFiniLot,
    tl.DateProduction,
    tl.QualiteControle,
    cq.ControleID,
    cq.DateControle,
    cq.Parametre,
    cq.ValeurMesure,
    cq.SeuilConformite,
    cq.Conforme,
    cq.DateCreation AS DateCreationControle
FROM OrdreFabrication ofab
LEFT JOIN Usine u ON ofab.UsineID = u.UsineID
LEFT JOIN Produit p ON ofab.ProduitFiniID = p.ProduitID
LEFT JOIN TraçabiliteLot tl ON ofab.OF_ID = tl.OrdreFabricationID
LEFT JOIN ControleQualite cq ON tl.LotID = cq.LotID;

"""

cursor.execute(create_sql)
conn.commit()
print("Vue créée avec succès.")
df = pd.read_sql("SELECT * FROM SRC_PRODUCTION_QUALITE;", conn)
print(df.head())          # Aperçu
#print(df.info())
cursor.close()
conn.close()
df.to_csv(r"C:\\CIC_Github\\SRC_PRODUCTION_QUALITE.csv", index=False, encoding='utf-8-sig')
