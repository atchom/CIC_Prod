
CREATE TABLE Usine (
    UsineID INT IDENTITY(1001,1) PRIMARY KEY,
    CodeUsine AS CONCAT('US-', RIGHT('0000' + CAST(UsineID AS VARCHAR), 4)) PERSISTED,
    Nom NVARCHAR(50) NOT NULL,
    Ville NVARCHAR(50) NOT NULL,
    Region NVARCHAR(50) NOT NULL,
    CapaciteProdTonnes INT NOT NULL,
    TypeSite NVARCHAR(20) NOT NULL DEFAULT 'Usine',
    EstActif BIT NOT NULL DEFAULT 1,
    DateCreation DATETIME NOT NULL DEFAULT GETDATE(),
    DateModification DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT CK_Usine_Capacite_TypeSite CHECK (
        (TypeSite = 'Usine' AND CapaciteProdTonnes > 0)
        OR (TypeSite = 'Siege' AND CapaciteProdTonnes >= 0)
    ),
    CONSTRAINT CK_Usine_TypeSite CHECK (TypeSite IN ('Usine', 'Siege'))
);


-- Table Département (pour les employés)
CREATE TABLE Departement (
    DepartementID INT IDENTITY(201,1) PRIMARY KEY,
    Code NVARCHAR(10) NOT NULL UNIQUE,
    Nom NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200) NULL,
    EstActif BIT NOT NULL DEFAULT 1,
    DateCreation DATETIME NOT NULL DEFAULT GETDATE()
);


CREATE TABLE Employe (
    EmployeID INT IDENTITY(301,1) PRIMARY KEY,
    Matricule AS CONCAT('EMP-', RIGHT('0000' + CAST(EmployeID AS VARCHAR), 4)) PERSISTED,
    DepartementID INT NULL FOREIGN KEY REFERENCES Departement(DepartementID),
    Nom NVARCHAR(50) NOT NULL,
    Prenom NVARCHAR(50) NOT NULL,
    Sexe CHAR(1) NOT NULL CHECK (Sexe IN ('M', 'F')),
    DateNaissance DATE NOT NULL,
    Nationalite NVARCHAR(50) NOT NULL,
    NumeroIdentite NVARCHAR(50) NOT NULL UNIQUE, -- CNI, passeport, etc.
    Telephone NVARCHAR(20) NOT NULL,
    SituationMaritale NVARCHAR(20) NOT NULL CHECK (SituationMaritale IN ('Célibataire', 'Marié(e)', 'Divorcé(e)', 'Veuf/Veuve')),
    Poste NVARCHAR(50) NOT NULL,
    UsineID INT NOT NULL FOREIGN KEY REFERENCES Usine(UsineID),
    DateEmbauche DATE NOT NULL,
    SalaireMensuel DECIMAL(10,2) NOT NULL CHECK (SalaireMensuel >= 0),
    EstActif BIT NOT NULL DEFAULT 1,
    DateCreation DATETIME NOT NULL DEFAULT GETDATE(),
    DateModification DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Fournisseur (
    FournisseurID INT IDENTITY(401,1) PRIMARY KEY,
    CodeFournisseur AS CONCAT('FOU-', RIGHT('0000' + CAST(FournisseurID AS VARCHAR), 4)) PERSISTED,
    NomSociete NVARCHAR(100) NOT NULL,
    TypeProduit NVARCHAR(50) NOT NULL CHECK (TypeProduit IN ('fèves cacao', 'sucre', 'lait', 'café vert')),
    Adresse NVARCHAR(200) NOT NULL,
    Ville NVARCHAR(50) NOT NULL,
    Pays NVARCHAR(50) NOT NULL,
    EstActif BIT NOT NULL DEFAULT 1,
    DateCreation DATETIME NOT NULL DEFAULT GETDATE(),
    DateModification DATETIME NOT NULL DEFAULT GETDATE()
);

-- Table Client
CREATE TABLE Client (
    ClientID INT IDENTITY(501,1) PRIMARY KEY,
    CodeClient AS CONCAT('CLI-', RIGHT('0000' + CAST(ClientID AS VARCHAR), 4)) PERSISTED,
    NomSociete NVARCHAR(100) NOT NULL,
    TypeClient NVARCHAR(20) NOT NULL CHECK (TypeClient IN ('exportateur', 'grossiste', 'industriel', 'distributeur')),
    Adresse NVARCHAR(200) NOT NULL,
    Ville NVARCHAR(50) NOT NULL,
    Pays NVARCHAR(50) NOT NULL,
    EstActif BIT NOT NULL DEFAULT 1,
    DateCreation DATETIME NOT NULL DEFAULT GETDATE(),
    DateModification DATETIME NOT NULL DEFAULT GETDATE()
);

-- Table Produit
CREATE TABLE Produit (
    ProduitID INT IDENTITY(1,1) PRIMARY KEY,
    CodeArticle AS CONCAT('PRD-', RIGHT('0000' + CAST(ProduitID AS VARCHAR), 4)) PERSISTED,
    CodeProduit NVARCHAR(20) NOT NULL UNIQUE,
    NomProduit NVARCHAR(100) NOT NULL,
    Famille NVARCHAR(50) NOT NULL CHECK (Famille IN ('cacao semi-fini', 'chocolat', 'boisson', 'café')),
    Unite NVARCHAR(10) NOT NULL,
    PrixUnitaireHT DECIMAL(10,2) NOT NULL CHECK (PrixUnitaireHT >= 0),
    EstActif BIT NOT NULL DEFAULT 1,
    DateCreation DATETIME NOT NULL DEFAULT GETDATE(),
    DateModification DATETIME NOT NULL DEFAULT GETDATE()
);

-- ============================================
-- 2. Flux matières premières et production
-- ============================================

CREATE TABLE AchatMatierePremiere (
    AchatID INT IDENTITY(11,1) PRIMARY KEY,
    NumeroBonAchat AS CONCAT('ACH-', RIGHT('0000' + CAST(AchatID AS VARCHAR), 4)) PERSISTED,
    FournisseurID INT NOT NULL FOREIGN KEY REFERENCES Fournisseur(FournisseurID),
    ProduitID INT NOT NULL FOREIGN KEY REFERENCES Produit(ProduitID),
    DateAchat DATE NOT NULL,
    QuantiteTonnes DECIMAL(12,3) NOT NULL CHECK (QuantiteTonnes > 0),
    PrixTotalHT DECIMAL(12,2) NOT NULL CHECK (PrixTotalHT >= 0),
    NumeroLotFournisseur NVARCHAR(50),
    StatutControle NVARCHAR(20) NOT NULL DEFAULT 'En attente' CHECK (StatutControle IN ('Conforme', 'Non conforme', 'En attente')),
    DateCreation DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE OrdreFabrication (
    OF_ID INT IDENTITY(21,1) PRIMARY KEY,
    NumeroOF AS CONCAT('OF-', RIGHT('0000' + CAST(OF_ID AS VARCHAR), 4)) PERSISTED,
    UsineID INT NOT NULL FOREIGN KEY REFERENCES Usine(UsineID),
    ProduitFiniID INT NOT NULL FOREIGN KEY REFERENCES Produit(ProduitID),
    DateLancement DATE NOT NULL,
    DateFinPrevue DATE NOT NULL,
    DateFinReelle DATE NULL,
    QuantitePrevue DECIMAL(12,3) NOT NULL CHECK (QuantitePrevue > 0),
    QuantiteReelle DECIMAL(12,3) NULL CHECK (QuantiteReelle >= 0),
    Statut NVARCHAR(20) NOT NULL DEFAULT 'planifié' CHECK (Statut IN ('planifié', 'en cours', 'terminé', 'annulé')),
    DateCreation DATETIME NOT NULL DEFAULT GETDATE(),
    DateModification DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE TraçabiliteLot (
    LotID INT IDENTITY(31,1) PRIMARY KEY,
    NumeroLot AS CONCAT('LOT-', RIGHT('0000' + CAST(LotID AS VARCHAR), 4)) PERSISTED,
    OrdreFabricationID INT NOT NULL FOREIGN KEY REFERENCES OrdreFabrication(OF_ID),
    MatierePremiereLot NVARCHAR(50) NOT NULL,
    ProduitFiniLot NVARCHAR(50) NOT NULL,
    DateProduction DATE NOT NULL,
    QuantiteProduite DECIMAL(12,3) NOT NULL CHECK (QuantiteProduite > 0),
    QualiteControle NVARCHAR(20) NOT NULL DEFAULT 'En attente' CHECK (QualiteControle IN ('OK', 'non conforme', 'En attente')),
    DateCreation DATETIME NOT NULL DEFAULT GETDATE()
);


-- ============================================
-- 3. Stocks
-- ============================================

CREATE TABLE MouvementStock (
    MouvementID INT IDENTITY(001,1) PRIMARY KEY,
    RefMouvement AS CONCAT('MVT-', RIGHT('0000' + CAST(MouvementID AS VARCHAR), 4)) PERSISTED,
    ProduitID INT NOT NULL FOREIGN KEY REFERENCES Produit(ProduitID),
    UsineID INT NOT NULL FOREIGN KEY REFERENCES Usine(UsineID),
    DateMouvement DATE NOT NULL,
    TypeMouvement NVARCHAR(10) NOT NULL CHECK (TypeMouvement IN ('entrée', 'sortie')),
    Quantite DECIMAL(12,3) NOT NULL CHECK (Quantite > 0),
    DocumentReference NVARCHAR(50),
    DateCreation DATETIME NOT NULL DEFAULT GETDATE()
);

-- ============================================
-- 4. Ventes
-- ============================================

CREATE TABLE CommandeClient (
    CommandeID INT IDENTITY(1001,1) PRIMARY KEY,
    NumeroCommande AS CONCAT('CMD-', RIGHT('0000' + CAST(CommandeID AS VARCHAR), 4)) PERSISTED,
    ClientID INT NOT NULL FOREIGN KEY REFERENCES Client(ClientID),
    DateCommande DATE NOT NULL,
    DateLivraisonPrevue DATE NOT NULL,
    MontantTotalHT DECIMAL(12,2) NOT NULL CHECK (MontantTotalHT >= 0),
    Statut NVARCHAR(20) NOT NULL DEFAULT 'En attente' CHECK (Statut IN ('En attente', 'Confirmée', 'Expédiée', 'Livrée', 'Annulée')),
    DateCreation DATETIME NOT NULL DEFAULT GETDATE(),
    DateModification DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE LigneCommande (
    LigneID INT IDENTITY(1,1) PRIMARY KEY,
    CommandeID INT NOT NULL FOREIGN KEY REFERENCES CommandeClient(CommandeID),
    ProduitID INT NOT NULL FOREIGN KEY REFERENCES Produit(ProduitID),
    Quantite DECIMAL(12,3) NOT NULL CHECK (Quantite > 0),
    PrixUnitaireHT DECIMAL(10,2) NOT NULL CHECK (PrixUnitaireHT >= 0),
    DateCreation DATETIME NOT NULL DEFAULT GETDATE()
);

-- ============================================
-- 5. Qualité
-- ============================================

CREATE TABLE ControleQualite (
    ControleID INT IDENTITY(1,1) PRIMARY KEY,
    LotID INT NOT NULL FOREIGN KEY REFERENCES TraçabiliteLot(LotID),
    DateControle DATE NOT NULL,
    Parametre NVARCHAR(50) NOT NULL,
    ValeurMesure DECIMAL(10,3) NOT NULL,
    SeuilConformite DECIMAL(10,3) NOT NULL,
    Conforme BIT NOT NULL,
    DateCreation DATETIME NOT NULL DEFAULT GETDATE()
);

-- ============================================
-- 6. Ressources humaines
-- ============================================

CREATE TABLE Paie (
    PaieID INT IDENTITY(101,1) PRIMARY KEY,
    EmployeID INT NOT NULL FOREIGN KEY REFERENCES Employe(EmployeID),
    MoisAnnee DATE NOT NULL, -- premier du mois
    SalaireBrut DECIMAL(10,2) NOT NULL CHECK (SalaireBrut >= 0),
    Retenues DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (Retenues >= 0),
    SalaireNet DECIMAL(10,2) NOT NULL CHECK (SalaireNet >= 0),
    DateCreation DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT CK_SalaireNet CHECK (SalaireNet = SalaireBrut - Retenues)
);

CREATE TABLE Presence (
    PresenceID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeID INT NOT NULL FOREIGN KEY REFERENCES Employe(EmployeID),
    DatePresence DATE NOT NULL,
    HeuresTravaillees DECIMAL(5,2) NOT NULL CHECK (HeuresTravaillees >= 0),
    HeuresSup DECIMAL(5,2) NOT NULL DEFAULT 0 CHECK (HeuresSup >= 0),
    DateCreation DATETIME NOT NULL DEFAULT GETDATE(),
    UNIQUE (EmployeID, DatePresence)
);

-- ============================================
-- 7. Index pour performances (clés étrangères)
-- ============================================

CREATE INDEX IX_Employe_DepartementID ON Employe(DepartementID);
CREATE INDEX IX_Employe_UsineID ON Employe(UsineID);
CREATE INDEX IX_AchatMatierePremiere_FournisseurID ON AchatMatierePremiere(FournisseurID);
CREATE INDEX IX_AchatMatierePremiere_ProduitID ON AchatMatierePremiere(ProduitID);
CREATE INDEX IX_OrdreFabrication_UsineID ON OrdreFabrication(UsineID);
CREATE INDEX IX_OrdreFabrication_ProduitFiniID ON OrdreFabrication(ProduitFiniID);
CREATE INDEX IX_TraçabiliteLot_OrdreFabricationID ON TraçabiliteLot(OrdreFabricationID);
CREATE INDEX IX_MouvementStock_ProduitID ON MouvementStock(ProduitID);
CREATE INDEX IX_MouvementStock_UsineID ON MouvementStock(UsineID);
CREATE INDEX IX_CommandeClient_ClientID ON CommandeClient(ClientID);
CREATE INDEX IX_LigneCommande_CommandeID ON LigneCommande(CommandeID);
CREATE INDEX IX_LigneCommande_ProduitID ON LigneCommande(ProduitID);
CREATE INDEX IX_ControleQualite_LotID ON ControleQualite(LotID);
CREATE INDEX IX_Paie_EmployeID ON Paie(EmployeID);
CREATE INDEX IX_Presence_EmployeID ON Presence(EmployeID);

-- ============================================
-- 8. Trigger pour mise à jour automatique DateModification
-- ============================================

CREATE TRIGGER TRG_Usine_DateModification ON Usine AFTER UPDATE AS
BEGIN UPDATE Usine SET DateModification = GETDATE() FROM Usine u INNER JOIN inserted i ON u.UsineID = i.UsineID; END;
GO

CREATE TRIGGER TRG_Employe_DateModification ON Employe AFTER UPDATE AS
BEGIN UPDATE Employe SET DateModification = GETDATE() FROM Employe e INNER JOIN inserted i ON e.EmployeID = i.EmployeID; END;
GO

CREATE TRIGGER TRG_Fournisseur_DateModification ON Fournisseur AFTER UPDATE AS
BEGIN UPDATE Fournisseur SET DateModification = GETDATE() FROM Fournisseur f INNER JOIN inserted i ON f.FournisseurID = i.FournisseurID; END;
GO

CREATE TRIGGER TRG_Client_DateModification ON Client AFTER UPDATE AS
BEGIN UPDATE Client SET DateModification = GETDATE() FROM Client c INNER JOIN inserted i ON c.ClientID = i.ClientID; END;
GO

CREATE TRIGGER TRG_Produit_DateModification ON Produit AFTER UPDATE AS
BEGIN UPDATE Produit SET DateModification = GETDATE() FROM Produit p INNER JOIN inserted i ON p.ProduitID = i.ProduitID; END;
GO

CREATE TRIGGER TRG_OrdreFabrication_DateModification ON OrdreFabrication AFTER UPDATE AS
BEGIN UPDATE OrdreFabrication SET DateModification = GETDATE() FROM OrdreFabrication o INNER JOIN inserted i ON o.OF_ID = i.OF_ID; END;
GO

CREATE TRIGGER TRG_CommandeClient_DateModification ON CommandeClient AFTER UPDATE AS
BEGIN UPDATE CommandeClient SET DateModification = GETDATE() FROM CommandeClient cmd INNER JOIN inserted i ON cmd.CommandeID = i.CommandeID; END;
GO

-- ============================================
-- 9. Vue d'affichage employé (uniquement matricule enrichi)
-- ============================================

CREATE VIEW vw_Employe_Info AS
SELECT 
    e.EmployeID,
    CONCAT(d.Code, '-', e.Matricule) AS MatriculeEmp,
    e.Nom,
    e.Prenom,
    e.Poste,
    e.DateEmbauche,
    e.SalaireMensuel
FROM Employe e
LEFT JOIN Departement d ON e.DepartementID = d.DepartementID;
GO

-- Table Departement (avec les 3 existants + nouveaux)
INSERT INTO Departement (Code, Nom, Description) VALUES
('RH', 'Ressources Humaines', 'Gestion du personnel, paie, recrutement'),
('PROD', 'Production', 'Conduite des lignes de fabrication'),
('QUAL', 'Qualité', 'Contrôle qualité et laboratoire'),
('DIR', 'Direction Générale', 'Pilotage stratégique et direction'),
('MAINT', 'Maintenance', 'Entretien des équipements industriels'),
('LOG', 'Logistique', 'Gestion des stocks, magasin, transport'),
('COMM', 'Commercial', 'Ventes, marketing, export'),
('FIN', 'Finance', 'Comptabilité, contrôle de gestion, trésorerie'),
('ADMIN', 'Administration', 'Secrétariat, affaires générales');