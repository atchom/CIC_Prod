-- ============================================
-- Insertion des usines (avant les employés)
-- ============================================
INSERT INTO Usine (Nom, Ville, Region, CapaciteProdTonnes, TypeSite) VALUES
('Usine Kribi Cacao', 'Kribi', 'Sud', 48000, 'Usine'),
('Usine Kekem Chocolat', 'Kekem', 'Ouest', 25000, 'Usine'),
('Usine Yaoundé Boissons', 'Yaoundé', 'Centre', 15000, 'Usine'),
('Direction Générale', 'Douala', 'Littoral', 0, 'Siege');

-- ============================================
-- Insertion des 25 employés
-- (DepartementID et UsineID récupérés par sous-requêtes)
-- ============================================

INSERT INTO Employe (DepartementID, Nom, Prenom, Poste, UsineID, DateEmbauche, SalaireMensuel) VALUES

-- Direction (DIR)
((SELECT DepartementID FROM Departement WHERE Code='DIR'), '', '', 'Directeur Général', (SELECT UsineID FROM Usine WHERE Nom='Direction Générale'), '2020-01-10', 4500000),

-- Ressources Humaines (RH)
((SELECT DepartementID FROM Departement WHERE Code='RH'), '', '', 'Responsable RH', (SELECT UsineID FROM Usine WHERE Nom='Direction Générale'), '2021-02-28', 1500000),
((SELECT DepartementID FROM Departement WHERE Code='RH'), '', '', 'Secrétaire direction', (SELECT UsineID FROM Usine WHERE Nom='Direction Générale'), '2020-05-22', 700000),

-- Production (PROD)
((SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'Responsable Production Kribi', (SELECT UsineID FROM Usine WHERE Nom='Usine Kribi Cacao'), '2021-03-15', 1800000),
((SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'Chef d''équipe Kekem', (SELECT UsineID FROM Usine WHERE Nom='Usine Kekem Chocolat'), '2022-06-20', 1200000),
((SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'Opératrice broyeur', (SELECT UsineID FROM Usine WHERE Nom='Usine Kribi Cacao'), '2023-01-15', 650000),
((SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'Ouvrier conditionnement', (SELECT UsineID FROM Usine WHERE Nom='Usine Kekem Chocolat'), '2023-02-10', 550000),
((SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'Opératrice concheuse', (SELECT UsineID FROM Usine WHERE Nom='Usine Kekem Chocolat'), '2023-03-14', 620000),
((SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'Chef d''équipe Kribi nuit', (SELECT UsineID FROM Usine WHERE Nom='Usine Kribi Cacao'), '2023-04-01', 720000),
((SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'Opérateur torréfaction', (SELECT UsineID FROM Usine WHERE Nom='Usine Yaoundé Boissons'), '2023-05-10', 600000),
((SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'Opérateur presse', (SELECT UsineID FROM Usine WHERE Nom='Usine Kribi Cacao'), '2023-07-18', 630000),
((SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'Conditionneuse Kekem', (SELECT UsineID FROM Usine WHERE Nom='Usine Kekem Chocolat'), '2023-06-20', 540000),
((SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'Conducteur chariot', (SELECT UsineID FROM Usine WHERE Nom='Usine Kribi Cacao'), '2023-09-12', 550000),

-- Qualité (QUAL)
((SELECT DepartementID FROM Departement WHERE Code='QUAL'), '', '', 'Superviseur Qualité Yaoundé', (SELECT UsineID FROM Usine WHERE Nom='Usine Yaoundé Boissons'), '2021-11-01', 1350000),
((SELECT DepartementID FROM Departement WHERE Code='QUAL'), '', '', 'Laborantine', (SELECT UsineID FROM Usine WHERE Nom='Usine Yaoundé Boissons'), '2022-12-12', 950000),
((SELECT DepartementID FROM Departement WHERE Code='QUAL'), '', '', 'Technicien laboratoire', (SELECT UsineID FROM Usine WHERE Nom='Usine Yaoundé Boissons'), '2022-08-17', 880000),
((SELECT DepartementID FROM Departement WHERE Code='QUAL'), '', '', 'Assistante qualité', (SELECT UsineID FROM Usine WHERE Nom='Usine Kekem Chocolat'), '2023-08-22', 510000),

-- Maintenance (MAINT)
((SELECT DepartementID FROM Departement WHERE Code='MAINT'), '', '', 'Maintenancier', (SELECT UsineID FROM Usine WHERE Nom='Usine Kribi Cacao'), '2022-09-05', 850000),
((SELECT DepartementID FROM Departement WHERE Code='MAINT'), '', '', 'Maintenancier électricien', (SELECT UsineID FROM Usine WHERE Nom='Usine Yaoundé Boissons'), '2022-10-30', 800000),

-- Logistique (LOG)
((SELECT DepartementID FROM Departement WHERE Code='LOG'), '', '', 'Magasinier Kribi', (SELECT UsineID FROM Usine WHERE Nom='Usine Kribi Cacao'), '2022-11-11', 580000),
((SELECT DepartementID FROM Departement WHERE Code='LOG'), '', '', 'Responsable logistique', (SELECT UsineID FROM Usine WHERE Nom='Direction Générale'), '2021-12-05', 1400000),
((SELECT DepartementID FROM Departement WHERE Code='LOG'), '', '', 'Chauffeur', (SELECT UsineID FROM Usine WHERE Nom='Direction Générale'), '2021-07-19', 500000),

-- Commercial (COMM)
((SELECT DepartementID FROM Departement WHERE Code='COMM'), '', '', 'Responsable commercial', (SELECT UsineID FROM Usine WHERE Nom='Direction Générale'), '2019-11-30', 2000000),
((SELECT DepartementID FROM Departement WHERE Code='COMM'), '', '', 'Agent commercial', (SELECT UsineID FROM Usine WHERE Nom='Direction Générale'), '2023-01-05', 900000),

-- Finance (FIN)
((SELECT DepartementID FROM Departement WHERE Code='FIN'), '', '', 'Contrôleur de gestion', (SELECT UsineID FROM Usine WHERE Nom='Direction Générale'), '2020-09-25', 1700000);

-- Insertion de 25 employés (EmployeID auto-incrémenté de 301 à 325)
SET IDENTITY_INSERT Employe ON;

INSERT INTO Employe (EmployeID, DepartementID, Nom, Prenom, Sexe, DateNaissance, Nationalite, NumeroIdentite, Telephone, SituationMaritale, Poste, UsineID, DateEmbauche, SalaireMensuel, EstActif)
VALUES
-- Direction Générale (DIR)
(301, (SELECT DepartementID FROM Departement WHERE Code='DIR'), '', '', 'M', '1975-04-12', 'Suedoise', 'PASS-00123456', '', 'Marié(e)', 'Directeur Général', (SELECT UsineID FROM Usine WHERE TypeSite='Siege'), '2020-01-10', 4500000, 1),

-- Ressources Humaines (RH)
(302, (SELECT DepartementID FROM Departement WHERE Code='RH'), '', '', 'F', '1985-08-22', 'Camerounaise', 'CNI-00234567', '', 'Marié(e)', 'Responsable RH', (SELECT UsineID FROM Usine WHERE TypeSite='Siege'), '2021-02-28', 1500000, 1),
(303, (SELECT DepartementID FROM Departement WHERE Code='RH'), '', '', 'F', '1990-12-05', 'Camerounaise', 'CNI-00345678', '', 'Célibataire', 'Secrétaire direction', (SELECT UsineID FROM Usine WHERE TypeSite='Siege'), '2020-05-22', 700000, 1),

-- Production (PROD)
(304, (SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'F', '1982-03-10', 'Camerounaise', 'CNI-00456789', '', 'Marié(e)', 'Responsable Production Kribi', (SELECT UsineID FROM Usine WHERE Nom LIKE '%Kribi%'), '2021-03-15', 1800000, 1),
(305, (SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'M', '1973-07-19', 'Ghanéen', 'PASS-00567890', '', 'Veuf/Veuve', 'Chef d''équipe Kekem', (SELECT UsineID FROM Usine WHERE Nom LIKE '%Kekem%'), '2022-06-20', 1200000, 1),
(306, (SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'F', '1995-11-02', 'Camerounaise', 'CNI-00678901', '', 'Célibataire', 'Opératrice broyeur', (SELECT UsineID FROM Usine WHERE Nom LIKE '%Kribi%'), '2023-01-15', 650000, 1),
(307, (SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'M', '1992-09-25', 'Camerounaise', 'CNI-00789012', '', 'Marié(e)', 'Ouvrier conditionnement', (SELECT UsineID FROM Usine WHERE Nom LIKE '%Kekem%'), '2023-02-10', 550000, 1),
(308, (SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'F', '1991-04-17', 'Camerounaise', 'CNI-00890123', '', 'Divorcé(e)', 'Opératrice concheuse', (SELECT UsineID FROM Usine WHERE Nom LIKE '%Kekem%'), '2023-03-14', 620000, 1),
(309, (SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'M', '1987-12-30', 'Camerounaise', 'CNI-00901234', '', 'Marié(e)', 'Chef d''équipe Kribi nuit', (SELECT UsineID FROM Usine WHERE Nom LIKE '%Kribi%'), '2023-04-01', 720000, 1),
(310, (SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'M', '1993-06-08', 'Camerounaise', 'CNI-01012345', '', 'Célibataire', 'Opérateur torréfaction', (SELECT UsineID FROM Usine WHERE Nom LIKE '%Yaoundé%'), '2023-05-10', 600000, 1),
(311, (SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'M', '1994-02-14', 'Camerounaise', 'CNI-01123456', '', 'Célibataire', 'Opérateur presse', (SELECT UsineID FROM Usine WHERE Nom LIKE '%Kribi%'), '2023-07-18', 630000, 1),
(312, (SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'F', '1990-10-21', 'Camerounaise', 'CNI-01234567', '', 'Marié(e)', 'Conditionneuse Kekem', (SELECT UsineID FROM Usine WHERE Nom LIKE '%Kekem%'), '2023-06-20', 540000, 1),
(313, (SELECT DepartementID FROM Departement WHERE Code='PROD'), '', '', 'M', '1989-05-09', 'Camerounaise', 'CNI-01345678', '', 'Marié(e)', 'Conducteur chariot', (SELECT UsineID FROM Usine WHERE Nom LIKE '%Kribi%'), '2023-09-12', 550000, 1),

-- Qualité (QUAL)
(314, (SELECT DepartementID FROM Departement WHERE Code='QUAL'), '', '', 'F', '1986-09-18', 'Camerounaise', 'CNI-01456789', '', 'Marié(e)', 'Superviseur Qualité Yaoundé', (SELECT UsineID FROM Usine WHERE Nom LIKE '%Yaoundé%'), '2021-11-01', 1350000, 1),
(315, (SELECT DepartementID FROM Departement WHERE Code='QUAL'), '', '', 'F', '1992-03-27', 'Canadien', 'PASS-01567890', '', 'Célibataire', 'Laborantine', (SELECT UsineID FROM Usine WHERE Nom LIKE '%Yaoundé%'), '2022-12-12', 950000, 1),
(316, (SELECT DepartementID FROM Departement WHERE Code='QUAL'), '', '', 'M', '1985-07-03', 'Camerounaise', 'CNI-01678901', '', 'Marié(e)', 'Technicien laboratoire', (SELECT UsineID FROM Usine WHERE Nom LIKE '%Yaoundé%'), '2022-08-17', 880000, 1),
(317, (SELECT DepartementID FROM Departement WHERE Code='QUAL'), '', '', 'F', '1994-11-11', 'Camerounaise', 'CNI-01789012', '', 'Célibataire', 'Assistante qualité', (SELECT UsineID FROM Usine WHERE Nom LIKE '%Kekem%'), '2023-08-22', 510000, 1),

-- Maintenance (MAINT)
(318, (SELECT DepartementID FROM Departement WHERE Code='MAINT'), '', '', 'M', '1983-12-14', 'Camerounaise', 'CNI-01890123', '', 'Marié(e)', 'Maintenancier', (SELECT UsineID FROM Usine WHERE Nom LIKE '%Kribi%'), '2022-09-05', 850000, 1),
(319, (SELECT DepartementID FROM Departement WHERE Code='MAINT'), '', '', 'M', '1988-06-29', 'Camerounaise', 'CNI-01901234', '', 'Marié(e)', 'Maintenancier électricien', (SELECT UsineID FROM Usine WHERE Nom LIKE '%Yaoundé%'), '2022-10-30', 800000, 1),

-- Logistique (LOG)
(320, (SELECT DepartementID FROM Departement WHERE Code='LOG'), '', '', 'M', '1991-01-20', 'Camerounaise', 'CNI-02012345', '', 'Marié(e)', 'Magasinier Kribi', (SELECT UsineID FROM Usine WHERE Nom LIKE '%Kribi%'), '2022-11-11', 580000, 1),
(321, (SELECT DepartementID FROM Departement WHERE Code='LOG'), '', '', 'M', '1984-08-07', 'Camerounaise', 'CNI-02123456', '', 'Marié(e)', 'Responsable logistique', (SELECT UsineID FROM Usine WHERE TypeSite='Siege'), '2021-12-05', 1400000, 1),
(322, (SELECT DepartementID FROM Departement WHERE Code='LOG'), '', '', 'M', '1992-04-25', 'Camerounaise', 'CNI-02234567', '', 'Célibataire', 'Chauffeur', (SELECT UsineID FROM Usine WHERE TypeSite='Siege'), '2021-07-19', 500000, 1),

-- Commercial (COMM)
(323, (SELECT DepartementID FROM Departement WHERE Code='COMM'), '', '', 'M', '1980-10-03', 'Camerounaise', 'CNI-02345678', '', 'Marié(e)', 'Responsable commercial', (SELECT UsineID FROM Usine WHERE TypeSite='Siege'), '2019-11-30', 2000000, 1),
(324, (SELECT DepartementID FROM Departement WHERE Code='COMM'), '', '', 'F', '1990-05-16', 'Camerounaise', 'CNI-02456789', '', 'Célibataire', 'Agent commercial', (SELECT UsineID FROM Usine WHERE TypeSite='Siege'), '2023-01-05', 900000, 1),

-- Finance (FIN)
(325, (SELECT DepartementID FROM Departement WHERE Code='FIN'), '', '', 'F', '1987-09-09', 'Camerounaise', 'CNI-02567890', '', 'Marié(e)', 'Contrôleur de gestion', (SELECT UsineID FROM Usine WHERE TypeSite='Siege'), '2020-09-25', 1700000, 1);

SET IDENTITY_INSERT Employe OFF;

-- Insertion des 25 fournisseurs (FournisseurID auto-incrémenté à partir de 401)
INSERT INTO Fournisseur (NomSociete, TypeProduit, Adresse, Ville, Pays, EstActif)
VALUES
-- Fèves cacao (10 fournisseurs locaux)
('Coopérative Sud-Ouest', 'fèves cacao', 'Route de Kumba', 'Buea', 'Cameroun', 1),
('Coopérative Centre', 'fèves cacao', 'PK 10 Mbankomo', 'Yaoundé', 'Cameroun', 1),
('Coopérative Littoral', 'fèves cacao', 'Bonabéri', 'Douala', 'Cameroun', 1),
('Coopérative Sud', 'fèves cacao', 'Kribi ville', 'Kribi', 'Cameroun', 1),
('Coopérative Est', 'fèves cacao', 'Bertoua', 'Bertoua', 'Cameroun', 1),
('Coopérative Ouest', 'fèves cacao', 'Bafoussam', 'Bafoussam', 'Cameroun', 1),
('Coopérative Nord', 'fèves cacao', 'Garoua', 'Garoua', 'Cameroun', 1),
('Coopérative Mifi', 'fèves cacao', 'Mifi', 'Bafang', 'Cameroun', 1),
('Cacao Bio Cameroun SARL', 'fèves cacao', 'Quartier industriel', 'Douala', 'Cameroun', 1),
('Plantations du Sud', 'fèves cacao', 'Akom II', 'Ebolowa', 'Cameroun', 1),

-- Sucre (4 fournisseurs : 1 local + 3 internationaux)
('SOSUCAM', 'sucre', 'Quartier industriel', 'Douala', 'Cameroun', 1),
('Sucre Mondial', 'sucre', 'Le Havre', 'Le Havre', 'France', 1),
('Sucre Brésil', 'sucre', 'São Paulo', 'São Paulo', 'Brésil', 1),
('Sucre Afrique', 'sucre', 'Abidjan', 'Abidjan', 'Côte d''Ivoire', 1),

-- Lait en poudre (5 fournisseurs : 1 local (revente) + 4 internationaux)
('Laitpoudre SARL', 'lait', 'Rue des Fermes', 'Douala', 'Cameroun', 1),
('Laiterie Normande', 'lait', 'Caen', 'Caen', 'France', 1),
('Lait Irlande', 'lait', 'Dublin', 'Dublin', 'Irlande', 1),
('Dairy International', 'lait', 'Rotterdam', 'Rotterdam', 'Pays-Bas', 1),
('Africa Dairy Supply', 'lait', 'Johannesburg', 'Johannesburg', 'Afrique du Sud', 1),

-- Café vert (6 fournisseurs tous camerounais)
('Café Vert Ouest', 'café vert', 'Dschang', 'Dschang', 'Cameroun', 1),
('Coopérative Café de Dschang', 'café vert', 'Dschang centre', 'Dschang', 'Cameroun', 1),
('Coopérative Café de Bafoussam', 'café vert', 'Quartier administratif', 'Bafoussam', 'Cameroun', 1),
('Coopérative Café de l''Ouest', 'café vert', 'Bangangté', 'Bangangté', 'Cameroun', 1),
('Union des Coopératives Café du Centre', 'café vert', 'Mvog Mbi', 'Yaoundé', 'Cameroun', 1),
('Plantations Café du Sud', 'café vert', 'Ebolowa centre', 'Ebolowa', 'Cameroun', 1);


-- Insertion de 25 clients (ClientID auto-incrémenté à partir de 501)
INSERT INTO Client (NomSociete, TypeClient, Adresse, Ville, Pays, EstActif)
VALUES
-- Clients camerounais
('ChocSARL', 'grossiste', 'Avenue Manguier', 'Douala', 'Cameroun', 1),
('Cameroun Distribution', 'grossiste', 'Rue Joss', 'Douala', 'Cameroun', 1),
('Yaoundé Delices', 'grossiste', 'Mvog Mbi', 'Yaoundé', 'Cameroun', 1),
('Cacao Premium Cameroun', 'exportateur', 'Bonabéri', 'Douala', 'Cameroun', 1),
('Saveurs du Cameroun', 'distributeur', 'Bastos', 'Yaoundé', 'Cameroun', 1),
('Chocolaterie Artisanale', 'industriel', 'Bafoussam', 'Bafoussam', 'Cameroun', 1),
('Caféothèque', 'grossiste', 'Garoua', 'Garoua', 'Cameroun', 1),
('Boissons du Centre', 'distributeur', 'Obala', 'Obala', 'Cameroun', 1),
('Douala Choc SARL', 'grossiste', 'Akwa', 'Douala', 'Cameroun', 1),
('Kribi Saveurs', 'distributeur', 'Kribi plage', 'Kribi', 'Cameroun', 1),

-- Clients internationaux (Europe)
('EuroCacao', 'exportateur', 'Rue de la Loi', 'Bruxelles', 'Belgique', 1),
('CacaoFrance', 'industriel', 'Quai de la Loire', 'Nantes', 'France', 1),
('ChocolatBelge', 'exportateur', 'Grand Place', 'Liège', 'Belgique', 1),
('SaveursDuMonde', 'distributeur', 'Rue de Rivoli', 'Paris', 'France', 1),
('Suisse Choc SA', 'exportateur', 'Bahnhofstrasse', 'Zurich', 'Suisse', 1),
('Italia Cioccolato', 'industriel', 'Via Roma', 'Turin', 'Italie', 1),
('España Cacao', 'exportateur', 'Gran Via', 'Madrid', 'Espagne', 1),
('Deutschland Schoko', 'industriel', 'Hauptstrasse', 'Hambourg', 'Allemagne', 1),
('Netherlands Cocoa', 'exportateur', 'Damrak', 'Amsterdam', 'Pays-Bas', 1),
('UK Chocolate Ltd', 'grossiste', 'Baker Street', 'Londres', 'Royaume-Uni', 1),

-- Autres pays (Afrique, Asie, Amériques)
('USA Cocoa Inc', 'exportateur', 'Broadway', 'New York', 'USA', 1),
('Japan Cocoa', 'industriel', 'Ginza', 'Tokyo', 'Japon', 1),
('Maroc Chocolat', 'grossiste', 'Casablanca', 'Casablanca', 'Maroc', 1),
('Côte d''Ivoire Distri', 'distributeur', 'Abidjan', 'Abidjan', 'Côte d''Ivoire', 1),
('Gabon Saveurs', 'grossiste', 'Libreville', 'Libreville', 'Gabon', 1);

-- Insertion de 3 matières premières (ProduitID auto-incrémenté)
INSERT INTO Produit (CodeProduit, NomProduit, Famille, Unite, PrixUnitaireHT, EstActif)
VALUES
('MP001', 'Fèves de cacao', 'cacao semi-fini', 'kg', 1.80, 1),
('MP002', 'Sucre blanc', 'cacao semi-fini', 'kg', 0.90, 1),
('MP003', 'Lait en poudre', 'cacao semi-fini', 'kg', 3.20, 1);

-- Insertion de 25 achats de matières premières
INSERT INTO AchatMatierePremiere (FournisseurID, ProduitID, DateAchat, QuantiteTonnes, PrixTotalHT, NumeroLotFournisseur, StatutControle)
VALUES
-- Fèves cacao (fournisseurs 401 à 410)
(401, 26, '2025-02-10', 25.5, 45900, 'SW240210', 'Conforme'),
(402, 26, '2025-02-12', 18.2, 32760, 'CE240212', 'Conforme'),
(403, 26, '2025-02-22', 22.0, 39600, 'LI240222', 'En attente'),
(404, 26, '2025-02-25', 14.5, 26100, 'SUD240225', 'Conforme'),
(405, 26, '2025-03-01', 30.0, 54000, 'ES240301', 'Conforme'),
(406, 26, '2025-03-07', 20.0, 36000, 'OU240307', 'Non conforme'),
(407, 26, '2025-03-13', 35.0, 63000, 'NOR240313', 'En attente'),
(408, 26, '2025-03-18', 16.0, 28800, 'MIF240318', 'Conforme'),
(409, 26, '2025-03-20', 28.0, 50400, 'BIO240320', 'Conforme'),
(410, 26, '2025-03-22', 12.5, 22500, 'PLA240322', 'Conforme'),

-- Sucre (fournisseurs 411 à 414)
(411, 27, '2025-02-15', 10.0, 9000, 'SUCRE0215', 'Conforme'),
(412, 27, '2025-03-03', 15.0, 13500, 'SUCRE0303', 'Conforme'),
(413, 27, '2025-03-15', 12.0, 10800, 'SUCBR0315', 'En attente'),
(414, 27, '2025-03-17', 8.0, 7200, 'SUCAF0317', 'Conforme'),

-- Lait en poudre (fournisseurs 415 à 419)
(415, 28, '2025-02-18', 8.5, 27200, 'LAIT0218', 'Conforme'),
(416, 28, '2025-03-05', 9.0, 28800, 'LAIT0305', 'Conforme'),
(417, 28, '2025-03-16', 7.0, 22400, 'IRL0316', 'Non conforme'),
(418, 28, '2025-03-19', 10.0, 32000, 'DAIRY0319', 'Conforme'),
(419, 28, '2025-03-21', 6.5, 20800, 'AFR0321', 'En attente'),

-- Café vert (fournisseurs 420 à 425)
(420, 23, '2025-02-20', 6.0, 21000, 'CAFE0220', 'Conforme'),
(421, 23, '2025-03-06', 4.5, 15750, 'CAFDSCH0306', 'Conforme'),
(422, 23, '2025-03-10', 5.2, 18200, 'CAFBFS0310', 'En attente'),
(423, 23, '2025-03-12', 3.8, 13300, 'CAFOUEST0312', 'Conforme'),
(424, 23, '2025-03-14', 7.0, 24500, 'UNICAF0314', 'Conforme'),
(425, 23, '2025-03-20', 4.0, 14000, 'PLACAF0320', 'Non conforme');


-- Insertion de 25 ordres de fabrication (OF_ID auto-incrémenté à partir de 21)
INSERT INTO OrdreFabrication (UsineID, ProduitFiniID, DateLancement, DateFinPrevue, DateFinReelle, QuantitePrevue, QuantiteReelle, Statut)
VALUES
-- Usine Kribi (UsineID = 1001) : production de semi-finis (beurre, poudre) et quelques finis
(1001, 1, '2025-02-15', '2025-02-18', '2025-02-18', 20.0, 19.8, 'terminé'),   -- Beurre brut
(1001, 2, '2025-02-20', '2025-02-23', '2025-02-23', 15.0, 15.2, 'terminé'),   -- Beurre désodorisé
(1001, 3, '2025-02-25', '2025-02-28', '2025-02-28', 12.0, 11.5, 'terminé'),   -- Beurre bio
(1001, 4, '2025-03-01', '2025-03-04', '2025-03-04', 18.0, 17.9, 'terminé'),   -- Poudre nature
(1001, 5, '2025-03-05', '2025-03-08', '2025-03-09', 14.0, 13.5, 'terminé'),   -- Poudre alcalinisée
(1001, 26, '2025-03-10', '2025-03-13', NULL, 25.0, 0, 'en cours'),            -- Fèves (matière première) - ordre de réception
(1001, 1, '2025-03-14', '2025-03-17', NULL, 22.0, 0, 'planifié'),
(1001, 4, '2025-03-18', '2025-03-21', NULL, 16.0, 0, 'planifié'),
(1001, 5, '2025-03-22', '2025-03-25', NULL, 13.0, 0, 'planifié'),
(1001, 2, '2025-03-26', '2025-03-29', NULL, 17.0, 0, 'annulé'),

-- Usine Kekem (UsineID = 1002) : chocolats et pâtes
(1002, 6, '2025-02-22', '2025-02-25', '2025-02-25', 8.0, 7.9, 'terminé'),    -- Chocolat noir 70%
(1002, 7, '2025-02-26', '2025-03-01', '2025-03-01', 5.0, 5.1, 'terminé'),    -- Chocolat noir 85%
(1002, 8, '2025-03-02', '2025-03-05', '2025-03-05', 6.0, 5.8, 'terminé'),    -- Chocolat au lait
(1002, 9, '2025-03-06', '2025-03-09', '2025-03-09', 4.0, 4.0, 'terminé'),    -- Chocolat blanc
(1002, 10, '2025-03-10', '2025-03-13', '2025-03-13', 3.5, 3.4, 'terminé'),   -- Chocolat praliné
(1002, 11, '2025-03-14', '2025-03-17', NULL, 10.0, 0, 'en cours'),            -- Tablettes noir 100g
(1002, 12, '2025-03-18', '2025-03-21', NULL, 8.0, 0, 'planifié'),             -- Tablettes lait
(1002, 13, '2025-03-22', '2025-03-25', NULL, 5.0, 0, 'planifié'),             -- Pâte à tartiner
(1002, 8, '2025-03-24', '2025-03-27', NULL, 7.0, 0, 'annulé'),

-- Usine Yaoundé (UsineID = 1003) : boissons et café
(1003, 14, '2025-02-28', '2025-03-02', '2025-03-02', 5000, 4950, 'terminé'),  -- Boisson UHT 1L (en litres)
(1003, 15, '2025-03-03', '2025-03-05', '2025-03-05', 3000, 2980, 'terminé'),  -- Brique 1L
(1003, 16, '2025-03-06', '2025-03-08', '2025-03-08', 2500, 2480, 'terminé'),  -- Lait chocolaté poudre
(1003, 17, '2025-03-09', '2025-03-11', '2025-03-11', 1800, 1790, 'terminé'),  -- Boisson café-chocolat
(1003, 18, '2025-03-12', '2025-03-14', NULL, 4000, 0, 'en cours'),            -- Boisson instantanée
(1003, 19, '2025-03-15', '2025-03-17', NULL, 2000, 0, 'planifié'),            -- Mélange cacao-café
(1003, 20, '2025-03-16', '2025-03-18', NULL, 1500, 0, 'planifié'),            -- Café torréfié moulu
(1003, 21, '2025-03-19', '2025-03-21', NULL, 800, 0, 'planifié'),             -- Café soluble
(1003, 22, '2025-03-22', '2025-03-24', NULL, 1200, 0, 'planifié'),            -- Café en grains
(1003, 23, '2025-03-25', '2025-03-27', NULL, 600, 0, 'planifié');             -- Café soluble 200g


ALTER TABLE TraçabiliteLot
ALTER COLUMN QualiteControle NVARCHAR(20) NOT NULL;
-- Insertion de 25 lots (LotID auto-incrémenté à partir de 31)
-- On utilise des OF_ID existants (21 à 45) en évitant les annulés (30 et 39)
-- On ajoute quelques lots supplémentaires pour les OF en cours ou planifiés
INSERT INTO TraçabiliteLot (OrdreFabricationID, MatierePremiereLot, ProduitFiniLot, DateProduction, QuantiteProduite, QualiteControle)
VALUES
-- Lots pour OF terminés (21 à 25, 31 à 35, 40 à 43)
(21, 'SW240210', 'BP-20250218-001', '2025-02-18', 19.8, 'OK'),
(22, 'CE240212', 'BD-20250223-001', '2025-02-23', 15.2, 'OK'),
(23, 'BIO240220', 'BB-20250228-001', '2025-02-28', 11.5, 'OK'),
(24, 'SUD240225', 'PN-20250304-001', '2025-03-04', 17.9, 'OK'),
(25, 'ES240301', 'PA-20250309-001', '2025-03-09', 13.5, 'non conforme'),
(31, 'CAFE0220', 'CH70-20250225-001', '2025-02-25', 7.9, 'OK'),
(32, 'CAFBFS0306', 'CH85-20250301-001', '2025-03-01', 5.1, 'OK'),
(33, 'LAIT0218', 'CHL-20250305-001', '2025-03-05', 5.8, 'OK'),
(34, 'IRL0316', 'CHB-20250309-001', '2025-03-09', 4.0, 'OK'),
(35, 'SUCRE0303', 'CHP-20250313-001', '2025-03-13', 3.4, 'OK'),
(40, 'SUCBR0315', 'UHT-20250302-001', '2025-03-02', 4950, 'OK'),
(41, 'LAIT0305', 'BRI-20250305-001', '2025-03-05', 2980, 'OK'),
(42, 'CAFOUEST0312', 'LCP-20250308-001', '2025-03-08', 2480, 'OK'),
(43, 'PLACAF0320', 'MCC-20250311-001', '2025-03-11', 1790, 'OK'),

-- Lots pour OF en cours (26, 36, 44) avec production partielle
(26, 'NOR240313', 'FEVE-20250313-001', '2025-03-13', 8.2, 'En attente'),
(36, 'DAIRY0319', 'TABN-20250317-001', '2025-03-17', 3.5, 'En attente'),
(44, 'AFR0321', 'BOI-20250314-001', '2025-03-14', 1200, 'En attente'),

-- Lots pour OF planifiés (27, 28, 29, 37, 38, 45) avec production anticipée (qualité en attente)
(27, 'UNICAF0314', 'BP-20250317-002', '2025-03-17', 5.0, 'En attente'),
(28, 'CAFDSCH0306', 'PN-20250321-002', '2025-03-21', 6.0, 'En attente'),
(29, 'CAFBFS0310', 'PA-20250325-002', '2025-03-25', 4.0, 'En attente'),
(37, 'SUCRE0303', 'TABL-20250321-001', '2025-03-21', 2.5, 'En attente'),
(38, 'SUCBR0315', 'PT-20250325-001', '2025-03-25', 1.8, 'En attente'),
(45, 'PLACAF0320', 'CAFE-20250327-001', '2025-03-27', 0.5, 'En attente'),

-- Deux lots supplémentaires pour OF déjà utilisés (21 et 31) pour atteindre 25
(21, 'SW240210', 'BP-20250218-002', '2025-02-19', 0.2, 'non conforme'), -- lot résiduel
(31, 'CAFE0220', 'CH70-20250226-002', '2025-02-26', 0.1, 'OK');

-- Insertion de 25 mouvements de stock (MouvementID auto-incrémenté à partir de 1)
INSERT INTO MouvementStock (ProduitID, UsineID, DateMouvement, TypeMouvement, Quantite, DocumentReference)
VALUES
-- Entrées liées aux achats de matières premières (fèves, sucre, lait, café) - usine Kribi et Yaoundé
(26, 1001, '2025-02-10', 'entrée', 25.5, 'ACH-0011'),   -- fèves
(26, 1001, '2025-02-12', 'entrée', 18.2, 'ACH-0012'),   -- fèves
(27, 1001, '2025-02-15', 'entrée', 10.0, 'ACH-0013'),   -- sucre
(28, 1001, '2025-02-18', 'entrée', 8.5, 'ACH-0014'),    -- lait
(23, 1003, '2025-02-20', 'entrée', 6.0, 'ACH-0015'),    -- café vert (usine Yaoundé)
(26, 1001, '2025-02-22', 'entrée', 22.0, 'ACH-0016'),   -- fèves
(26, 1001, '2025-02-25', 'entrée', 14.5, 'ACH-0017'),   -- fèves
(28, 1001, '2025-03-05', 'entrée', 9.0, 'ACH-0022'),    -- lait
(23, 1003, '2025-03-06', 'entrée', 4.5, 'ACH-0023'),    -- café vert
(27, 1001, '2025-03-15', 'entrée', 12.0, 'ACH-0024'),   -- sucre

-- Entrées liées aux productions (OF terminés) - produits finis
(1, 1001, '2025-02-18', 'entrée', 19.8, 'OF-0021'),     -- beurre brut
(2, 1001, '2025-02-23', 'entrée', 15.2, 'OF-0022'),     -- beurre désodorisé
(3, 1001, '2025-02-28', 'entrée', 11.5, 'OF-0023'),     -- beurre bio
(4, 1001, '2025-03-04', 'entrée', 17.9, 'OF-0024'),     -- poudre nature
(6, 1002, '2025-02-25', 'entrée', 7.9, 'OF-0031'),      -- chocolat noir 70%
(8, 1002, '2025-03-05', 'entrée', 5.8, 'OF-0033'),      -- chocolat au lait
(14, 1003, '2025-03-02', 'entrée', 4950, 'OF-0040'),    -- boisson UHT (litres)
(15, 1003, '2025-03-05', 'entrée', 2980, 'OF-0041'),    -- brique 1L

-- Sorties (ventes ou transferts inter-usines)
(1, 1001, '2025-02-25', 'sortie', 5.0, 'TRF-001'),      -- transfert beurre vers Kekem
(2, 1001, '2025-02-28', 'sortie', 4.0, 'TRF-002'),      -- transfert beurre désodorisé vers Kekem
(6, 1002, '2025-03-01', 'sortie', 2.0, 'CMD-1001'),     -- vente à ChocSARL
(14, 1003, '2025-03-03', 'sortie', 1200, 'CMD-1002'),   -- vente à SaveursDuMonde
(8, 1002, '2025-03-10', 'sortie', 1.5, 'CMD-1003'),     -- vente chocolat au lait
(4, 1001, '2025-03-12', 'sortie', 2.0, 'TRF-003'),      -- transfert poudre vers Yaoundé
(23, 1003, '2025-03-15', 'sortie', 0.5, 'CMD-1004');    -- vente café soluble

-- Insertion de 25 commandes clients (CommandeID auto-incrémenté à partir de 1001)
INSERT INTO CommandeClient (ClientID, DateCommande, DateLivraisonPrevue, MontantTotalHT, Statut)
VALUES
-- Clients camerounais (IDs 501 à 510)
(501, '2025-02-20', '2025-02-25', 29500.00, 'Livrée'),
(502, '2025-02-22', '2025-03-05', 156000.00, 'Livrée'),
(503, '2025-02-25', '2025-03-10', 87500.00, 'Livrée'),
(504, '2025-02-28', '2025-03-15', 210000.00, 'Expédiée'),
(505, '2025-03-01', '2025-03-20', 45000.00, 'Confirmée'),
(506, '2025-03-02', '2025-03-08', 12500.00, 'Livrée'),
(507, '2025-03-03', '2025-03-12', 34000.00, 'Livrée'),
(508, '2025-03-04', '2025-03-25', 98000.00, 'Expédiée'),
(509, '2025-03-05', '2025-03-30', 67000.00, 'Confirmée'),
(510, '2025-03-06', '2025-04-05', 112000.00, 'En attente'),

-- Clients internationaux (Europe, IDs 511 à 520)
(511, '2025-03-07', '2025-04-10', 43000.00, 'Confirmée'),
(512, '2025-03-08', '2025-03-28', 76000.00, 'Expédiée'),
(513, '2025-03-09', '2025-03-31', 92000.00, 'Confirmée'),
(514, '2025-03-10', '2025-04-15', 184000.00, 'Confirmée'),
(515, '2025-03-11', '2025-04-20', 27000.00, 'En attente'),
(516, '2025-03-12', '2025-03-22', 15500.00, 'Livrée'),
(517, '2025-03-13', '2025-03-27', 62000.00, 'Expédiée'),
(518, '2025-03-14', '2025-03-29', 8800.00, 'Confirmée'),
(519, '2025-03-15', '2025-04-01', 41500.00, 'Confirmée'),
(520, '2025-03-16', '2025-04-05', 22900.00, 'En attente'),

-- Autres pays (IDs 521 à 525)
(521, '2025-03-17', '2025-04-08', 37300.00, 'Confirmée'),
(522, '2025-03-18', '2025-04-12', 141000.00, 'Confirmée'),
(523, '2025-03-19', '2025-03-30', 56500.00, 'Expédiée'),
(524, '2025-03-20', '2025-04-02', 19800.00, 'Confirmée'),
(525, '2025-03-21', '2025-04-07', 33500.00, 'En attente');

-- Insertion de 25 lignes de commande (LigneID auto-incrémenté)
INSERT INTO LigneCommande (CommandeID, ProduitID, Quantite, PrixUnitaireHT)
VALUES
-- Commande 1001 (ChocSARL) : chocolats
(1001, 6, 1000, 15.00),   -- Chocolat noir 70% (kg)
(1001, 8, 800, 14.00),    -- Chocolat au lait (kg)

-- Commande 1002 (Cameroun Distribution) : beurre et poudre
(1002, 1, 12000, 6.50),   -- Beurre brut (kg)
(1002, 4, 10000, 7.20),   -- Poudre nature (kg)

-- Commande 1003 (Yaoundé Delices) : boissons
(1003, 14, 20000, 2.50),  -- Boisson UHT (litres)
(1003, 20, 1500, 18.00),  -- Café torréfié moulu (kg)

-- Commande 1004 (Cacao Premium Cameroun) : beurre désodorisé et poudre alcalinisée
(1004, 2, 15000, 7.80),   -- Beurre désodorisé
(1004, 5, 8000, 8.50),    -- Poudre alcalinisée

-- Commande 1005 (Saveurs du Cameroun) : chocolat praliné
(1005, 10, 3000, 18.00),  -- Chocolat praliné

-- Commande 1006 (Chocolaterie Artisanale) : boisson UHT
(1006, 14, 5000, 2.50),

-- Commande 1007 (Caféothèque) : chocolat noir
(1007, 6, 2000, 15.00),

-- Commande 1008 (Boissons du Centre) : beurre et poudre
(1008, 1, 10000, 6.50),
(1008, 4, 5000, 7.20),

-- Commande 1009 (Douala Choc SARL) : pâte à tartiner
(1009, 13, 5000, 4.00),  -- Pâte à tartiner (pots)

-- Commande 1010 (Kribi Saveurs) : chocolat au lait
(1010, 8, 8000, 14.00),

-- Commande 1011 (EuroCacao) : beurre brut
(1011, 1, 2000, 6.50),    -- petite quantité pour test

-- Commande 1012 (CacaoFrance) : poudre nature
(1012, 4, 10000, 7.20),

-- Commande 1013 (ChocolatBelge) : chocolat noir 85%
(1013, 7, 4000, 17.00),

-- Commande 1014 (SaveursDuMonde) : boisson brique
(1014, 15, 30000, 2.20),  -- brique 1L

-- Commande 1015 (Suisse Choc SA) : beurre bio
(1015, 3, 2000, 9.00),

-- Commande 1016 (Italia Cioccolato) : chocolat blanc
(1016, 9, 1500, 16.00),

-- Commande 1017 (España Cacao) : poudre alcalinisée
(1017, 5, 5000, 8.50),

-- Commande 1018 (Deutschland Schoko) : tablette noir
(1018, 11, 2000, 1.50),   -- tablette 100g (pièces)

-- Commande 1019 (Netherlands Cocoa) : beurre désodorisé
(1019, 2, 8000, 7.80),

-- Commande 1020 (UK Chocolate Ltd) : chocolat au lait
(1020, 8, 3000, 14.00),

-- Commande 1021 (USA Cocoa Inc) : poudre nature
(1021, 4, 2000, 7.20),

-- Commande 1022 (Japan Cocoa) : chocolat noir 70%
(1022, 6, 5000, 15.00),

-- Commande 1023 (Maroc Chocolat) : boisson UHT
(1023, 14, 10000, 2.50),

-- Commande 1024 (Côte d'Ivoire Distri) : café soluble
(1024, 21, 1000, 25.00),  -- café soluble (kg)

-- Commande 1025 (Gabon Saveurs) : pâte à tartiner
(1025, 13, 2000, 4.00);

-- Insertion de 25 contrôles qualité (ControleID auto-incrémenté)
INSERT INTO ControleQualite (LotID, DateControle, Parametre, ValeurMesure, SeuilConformite, Conforme)
VALUES
-- LOTS OK
(36, '2025-03-10', 'Humidité (%)', 0.8, 1.0, 1),
(37, '2025-03-11', 'Teneur en beurre (%)', 99.1, 99.0, 1),
(38, '2025-03-12', 'pH', 6.7, 6.5, 1),
(39, '2025-03-13', 'Couleur (L*ab)', 45.0, 44.0, 1),
(42, '2025-03-14', 'Viscosité (Pa.s)', 8400, 9000, 1),
(43, '2025-03-15', 'Cendres (%)', 3.1, 3.5, 1),
(45, '2025-03-16', 'Densité', 1.06, 1.10, 1),
(46, '2025-03-17', 'Sucre résiduel (g/L)', 11.8, 12.5, 1),
(47, '2025-03-18', 'Amertume (1-5)', 2.1, 2.5, 1),
(50, '2025-03-19', 'Acidité (mg KOH/g)', 1.6, 2.0, 1),

-- LOTS NON CONFORMES
(52, '2025-03-20', 'Fermentation (%)', 70, 85, 0),
(53, '2025-03-21', 'Bactéries totales (UFC/g)', 1600, 1000, 0),
(54, '2025-03-22', 'Taille particules (µm)', 90, 80, 0),
(55, '2025-03-23', 'Humidité (%)', 1.3, 1.0, 0),
(56, '2025-03-24', 'Arôme (score)', 3.5, 4.0, 0),

-- LOTS EN ATTENTE
(57, '2025-03-25', 'Texture (N)', 5.1, 5.0, 0),
(58, '2025-03-26', 'Couleur (L*ab)', 43.0, 44.0, 0),
(59, '2025-03-27', 'Viscosité (Pa.s)', 9100, 9000, 0),
(60, '2025-03-28', 'pH', 6.3, 6.5, 0),
(61, '2025-03-29', 'Cendres (%)', 3.8, 3.5, 0),
(63, '2025-03-30', 'Humidité (%)', 0.9, 1.0, 1),
(64, '2025-03-31', 'Teneur en beurre (%)', 98.7, 99.0, 0),
(48, '2025-03-20', 'Densité', 1.04, 1.10, 1),
(49, '2025-03-21', 'Sucre résiduel (g/L)', 13.0, 12.5, 0),
(44, '2025-03-22', 'Couleur (L*ab)', 41.5, 44.0, 0);

-- Insertion de 25 lignes de paie (PaieID auto-incrémenté à partir de 101)
-- MoisAnnee = 2025-02-01 pour toutes (paie de février 2025)
INSERT INTO Paie (EmployeID, MoisAnnee, SalaireBrut, Retenues, SalaireNet)
VALUES
-- Employés 301 à 325 (dans l'ordre)
(301, '2025-02-01', 4500000, 675000, 3825000),
(302, '2025-02-01', 1500000, 225000, 1275000),
(303, '2025-02-01', 700000, 105000, 595000),
(304, '2025-02-01', 1800000, 270000, 1530000),
(305, '2025-02-01', 1200000, 180000, 1020000),
(306, '2025-02-01', 650000, 97500, 552500),
(307, '2025-02-01', 550000, 82500, 467500),
(308, '2025-02-01', 620000, 93000, 527000),
(309, '2025-02-01', 720000, 108000, 612000),
(310, '2025-02-01', 600000, 90000, 510000),
(311, '2025-02-01', 630000, 94500, 535500),
(312, '2025-02-01', 540000, 81000, 459000),
(313, '2025-02-01', 550000, 82500, 467500),
(314, '2025-02-01', 1350000, 202500, 1147500),
(315, '2025-02-01', 950000, 142500, 807500),
(316, '2025-02-01', 880000, 132000, 748000),
(317, '2025-02-01', 510000, 76500, 433500),
(318, '2025-02-01', 850000, 127500, 722500),
(319, '2025-02-01', 800000, 120000, 680000),
(320, '2025-02-01', 580000, 87000, 493000),
(321, '2025-02-01', 1400000, 210000, 1190000),
(322, '2025-02-01', 500000, 75000, 425000),
(323, '2025-02-01', 2000000, 300000, 1700000),
(324, '2025-02-01', 900000, 135000, 765000),
(325, '2025-02-01', 1700000, 255000, 1445000);

-- Insertion de 25 présences (PresenceID auto-incrémenté)
-- Dates en février 2025 (semaine du 3 au 7 février par exemple)
INSERT INTO Presence (EmployeID, DatePresence, HeuresTravaillees, HeuresSup)
VALUES
-- Employés variés, avec quelques heures supplémentaires
(301, '2025-02-03', 8.0, 0),   -- Directeur général
(302, '2025-02-03', 8.5, 0.5), -- RH
(303, '2025-02-03', 8.0, 0),
(304, '2025-02-03', 9.0, 1.0), -- Responsable production Kribi
(305, '2025-02-03', 8.0, 0),
(306, '2025-02-03', 7.5, 0),
(307, '2025-02-04', 8.0, 0),
(308, '2025-02-04', 10.0, 2.0), -- Opératrice concheuse (heures sup)
(309, '2025-02-04', 8.0, 0),
(310, '2025-02-04', 4.0, 0),    -- Demi-journée
(311, '2025-02-04', 8.0, 0),
(312, '2025-02-05', 8.5, 0.5),
(313, '2025-02-05', 9.0, 1.0),
(314, '2025-02-05', 8.0, 0),
(315, '2025-02-05', 7.0, 0),
(316, '2025-02-06', 8.0, 0),
(317, '2025-02-06', 8.0, 0),
(318, '2025-02-06', 12.0, 4.0), -- Maintenancier (heures sup importantes)
(319, '2025-02-06', 8.0, 0),
(320, '2025-02-06', 8.0, 0),
(321, '2025-02-07', 8.0, 0),
(322, '2025-02-07', 8.0, 0),
(323, '2025-02-07', 8.5, 0.5),
(324, '2025-02-07', 8.0, 0),
(325, '2025-02-07', 7.0, 0);
