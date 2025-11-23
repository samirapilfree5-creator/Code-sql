-- =====================================================
-- BASE DE DONNÉES : HÔPITAL DE LA MÈRE ET DE L'ENFANT
-- =====================================================

-- ====================================================
-- CRÉATION DES TABLES
-- ====================================================

DROP TABLE IF EXISTS Examen CASCADE;
DROP TABLE IF EXISTS Prescription CASCADE;
DROP TABLE IF EXISTS Consultation CASCADE;
DROP TABLE IF EXISTS Hospitalisation CASCADE;
DROP TABLE IF EXISTS Medicament CASCADE;
DROP TABLE IF EXISTS Administration CASCADE;
DROP TABLE IF EXISTS Infirmier CASCADE;
DROP TABLE IF EXISTS Medecin CASCADE;
DROP TABLE IF EXISTS Patients CASCADE;
DROP TABLE IF EXISTS Salle CASCADE;
DROP TABLE IF EXISTS Service CASCADE;

-- Table Service --
CREATE TABLE Service (
    id_service SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE,
    nbre_lits INT DEFAULT 0
);
-- Table Salle --
CREATE TABLE Salle (
    id_salle SERIAL PRIMARY KEY,
    type_salle VARCHAR(50) NOT NULL,
	id_service INT NOT NULL,
    FOREIGN KEY (id_service) REFERENCES Service(id_service),
    UNIQUE(type_salle, id_service)
);

-- Table Patients --
CREATE TABLE Patients (
    id_patient SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    sexe CHAR(1) NOT NULL CHECK (sexe IN ('M', 'F')),
    adresse VARCHAR(200),
    telephone VARCHAR(15)
);

-- Table Medecin --
CREATE TABLE Medecin (
    id_medecin SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    specialite VARCHAR(50) NOT NULL,
    telephone VARCHAR(15)NOT NULL,
    id_service INT NOT NULL,
    FOREIGN KEY (id_service) REFERENCES Service(id_service)
);

-- Table Infirmier --
CREATE TABLE Infirmier (
    id_infirmier SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    telephone VARCHAR(15),
    id_service INT,
    FOREIGN KEY (id_service) REFERENCES Service(id_service)
);

-- Table Administration --
CREATE TABLE Administration (
    id_admin SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    titre VARCHAR(30) NOT NULL CHECK (titre IN ('Secrétaire', 'Directeur', 'Comptable', 'Assistant')),
    id_service INT,
    FOREIGN KEY (id_service) REFERENCES Service(id_service) ON DELETE SET NULL
);

-- Table Consultation --
CREATE TABLE Consultation (
    id_consult SERIAL PRIMARY KEY,
    date_consult DATE NOT NULL,
    diagnostic TEXT,
    id_patient INT NOT NULL,
    id_medecin INT NOT NULL,
    id_service INT NOT NULL,
    FOREIGN KEY (id_patient) REFERENCES Patients(id_patient),
    FOREIGN KEY (id_medecin) REFERENCES Medecin(id_medecin),
    FOREIGN KEY (id_service) REFERENCES Service(id_service)
);

-- Table Hospitalisation --
CREATE TABLE Hospitalisation (
    id_hospi SERIAL PRIMARY KEY,
    date_admission DATE NOT NULL,
    date_sortie DATE,
    motif TEXT,
    id_patient INT NOT NULL,
    id_service INT NOT NULL,
    id_salle INT NOT NULL,
    FOREIGN KEY (id_patient) REFERENCES Patients(id_patient),
    FOREIGN KEY (id_service) REFERENCES Service(id_service),
    FOREIGN KEY (id_salle) REFERENCES Salle(id_salle),
    CHECK (date_sortie IS NULL OR date_sortie >= date_admission)
);

-- Table Medicament --
CREATE TABLE Medicament (
    id_medicament SERIAL PRIMARY KEY,
	nom VARCHAR(50) NOT NULL,
    nature VARCHAR(100) NOT NULL,
    stock INT DEFAULT 0 CHECK (stock >= 0)
);

-- Table Prescription --
CREATE TABLE Prescription (
    id_prescription SERIAL PRIMARY KEY,
    date_prescription DATE NOT NULL,
    id_patient INT NOT NULL,
    id_medecin INT NOT NULL,
    id_consult INT,
    FOREIGN KEY (id_patient) REFERENCES Patients(id_patient),
    FOREIGN KEY (id_medecin) REFERENCES Medecin(id_medecin),
    FOREIGN KEY (id_consult) REFERENCES Consultation(id_consult)
);
 
-- Table Examen --
CREATE TABLE Examen (
    id_examen SERIAL PRIMARY KEY,
    type_examen VARCHAR(50) NOT NULL,
    date_examen DATE NOT NULL,
    resultat TEXT,
    id_patient INT NOT NULL,
    id_medecin INT,
    id_service INT,
    FOREIGN KEY (id_patient) REFERENCES Patients(id_patient),
    FOREIGN KEY (id_medecin) REFERENCES Medecin(id_medecin),
    FOREIGN KEY (id_service) REFERENCES Service(id_service)
   
);



-- =====================================================
-- INSERTION DE DONNÉES D'EXEMPLE
-- =====================================================

-- Services --
INSERT INTO Service (nom, nbre_lits) VALUES
('Chirurgie générale', 20),
('Urgences', 15),
('Gynécologie et obstétrique', 25),
('Cardiologie', 12),
('Radiologie', 0),
('Anesthésie & Réanimation', 8),
('Neurologie', 10),
('Laboratoire d\analyses', 0),
('Pédiatrie', 30),
('Oncologie', 15);

-- Salles --
INSERT INTO Salle (id_salle, type_salle, id_service) VALUES
('101', 'Consultation', 1),
('102', 'Bloc opératoire', 1),
('201', 'Urgence', 2),
('301', 'Consultation', 3),
('302', 'Salle accouchement', 3),
('401', 'Consultation', 4),
('501', 'Radiologie', 5),
('601', 'Réanimation', 6),
('701', 'Consultation', 7),
('801', 'Laboratoire', 8),
('901', 'Pédiatrie', 9),
('1001', 'Chimiothérapie', 10);

-- Médecins --
INSERT INTO Medecin (nom, prenom, specialite, telephone, id_service) VALUES
('DUBOIS', 'Marie', 'Gynécologie', '0601020304', 3),
('MARTIN', 'Jean', 'Pédiatrie', '0602030405', 9),
('LEFEBVRE', 'Sophie', 'Cardiologie', '0603040506', 4),
('BERNARD', 'Paul', 'Chirurgie générale', '0604050607', 1),
('ROUSSEAU', 'Claire', 'Anesthésie', '0605060708', 6),
('MOREAU', 'Pierre', 'Neurologie', '0606070809', 7),
('LAURENT', 'Anne', 'Oncologie', '0607080910', 10),
('SIMON', 'Luc', 'Radiologie', '0608091011', 5),
('MICHEL', 'Emma', 'Urgentiste', '0609101112', 2),
('GARCIA', 'Thomas', 'Pédiatrie', '0610111213', 9);

-- Infirmiers --
INSERT INTO Infirmier (nom, prenom, telephone, id_service) VALUES
('PETIT', 'Julie', '0611121314', 3),
('ROBERT', 'Marc', '0612131415', 9),
('RICHARD', 'Lucie', '0613141516', 2),
('DURAND', 'Céline', '0614151617', 1),
('LEROY', 'Nicolas', '0615161718', 4);

-- Administration --
INSERT INTO Administration (nom, prenom, titre, id_service) VALUES
('BLANC', 'Christine', 'Directeur', NULL),
('GIRARD', 'François', 'Comptable', NULL),
('BONNET', 'Isabelle', 'Secrétaire', 3),
('FOURNIER', 'David', 'Secrétaire', 9);

-- Patients --
INSERT INTO Patients (nom, prenom, sexe, adresse, telephone) VALUES
('DUPONT', 'Alice', 'F', '12 rue de la Paix, Paris', '0620212223'),
('DURAND', 'Sophie','F', '45 avenue Victor Hugo, Lyon', '0621222324'),
('MARTIN', 'Lucas','M', '78 boulevard Saint-Michel, Marseille', '0622232425'),
('BERNARD', 'Emma','F', '23 rue Nationale, Lille', '0623242526'),
('PETIT', 'Léa','F', '56 rue de Rivoli, Paris', '0624252627'),
('ROBERT', 'Hugo','M', '89 cours Mirabeau, Aix', '0625262728'),
('RICHARD', 'Chloé','F', '34 rue du Commerce, Bordeaux', '0626272829'),
('SIMON', 'Nathan','M', '67 avenue de la République, Nantes', '0627282930');

-- Médicaments --
INSERT INTO Medicament (nom, nature, stock) VALUES
('Paracétamol', 'Antalgique', 50),
('Ibuprofène', 'AINS', 800),
('Amoxicilline', 'Antibiotique', 500),
('Doliprane', 'Antalgique', 300),
('Aspirine', 'AIS', 600),
('Ventoline', 'Bronchodilatateur',200),
('Augmentin', 'Suspension', 200),
('Spasfon', 'Antispasmodique', 400);

-- Consultations --
INSERT INTO Consultation (date_consult,diagnostic, id_patient, id_medecin, id_service) VALUES
('2025-01-15 09:30:00','Grossesse normale 20 SA', 1, 1, 3),
('2025-01-16 10:00:00','Bronchite aiguë', 3, 2, 9),
('2025-01-17 14:30:00','Suspicion angine de poitrine', 2, 3, 4),
('2025-01-18 11:00:00','Cicatrisation normale', 4, 4, 1),
('2025-01-19 16:00:00','Vaccination à jour', 6, 2, 9);

-- Hospitalisations --
INSERT INTO Hospitalisation (date_admission, date_sortie, motif, id_patient, id_service, id_salle) VALUES
('2025-01-10 08:00:00', '2025-01-15 10:00:00', 'Appendicectomie', 4, 1, 102),
('2025-01-18 22:30:00', NULL, 'Accouchement en cours', 1, 3, 301),
('2025-01-12 15:00:00', '2025-01-14 09:00:00', 'Bronchiolite sévère', 3, 9, 701);

-- Prescriptions --
INSERT INTO Prescription (date_prescription, id_patient, id_medecin, id_consult) VALUES
('2025-01-16 10:15:00', 3, 2, 2),
('2025-01-19 16:10:00', 6, 2, 5),
('2025-01-15 09:45:00', 1, 1, 1);

-- Examens --
INSERT INTO Examen (type_examen, date_examen, resultat, id_patient, id_medecin, id_service) VALUES
('Échographie', '2025-01-15', 'Fœtus normal, 20 SA', 1, 1, 5),
('Radiographie thorax', '2025-01-16', 'Opacités bilatérales', 3, 8, 5),
('ECG', '2025-01-17', 'Suspicion ischémie', 2, 3, 4),
('Analyse sanguine', '2025-01-18', 'Leucocytes élevés', 4, 4, 8);

-- =====================================================
-- FIN DE LA CRÉATION
-- =====================================================

SELECT 'Base de données créée avec succès!' AS Message;



-- =====================================================
-- REQUÊTES SQL - GESTION ET ANALYSE
-- HÔPITAL DE LA MÈRE ET DE L'ENFANT
-- =====================================================

-- =====================================================
-- 1. REQUÊTES DE SÉLECTION (SELECT)
-- =====================================================

-- 1.1 Liste complète des patients--
SELECT 
    id_patient,
    CONCAT(nom, '', prenom) AS nom_complet,
    sexe,
    telephone
FROM Patients
ORDER BY nom, prenom;

-- 1.2 Liste des médecins par service --
SELECT 
    s.nom AS service,
    CONCAT(m.nom, ' ', m.prenom) AS medecin,
    m.specialite,
    m.telephone
FROM Medecin m
JOIN Service s ON m.id_service = s.id_service
ORDER BY s.nom, m.nom;

-- 1.3 Liste des patients actuellement hospitalisés --
SELECT 
    CONCAT(p.nom, ' ', p.prenom) AS patient,
    s.nom AS service,
    T.type_salle AS salle,
    h.date_admission,
    (CURRENT_DATE - h.date_admission) AS duree_sejour,
    h.motif
FROM Hospitalisation h
JOIN Patients p ON h.id_patient = p.id_patient
JOIN Service s ON h.id_service = s.id_service
LEFT JOIN Salle T ON h.id_salle = T.id_salle
WHERE h.date_sortie IS NULL
ORDER BY h.date_admission;


-- 1.4 Historique médical complet d'un patient (exemple: patient id=1)
SELECT 
    'Consultation' AS type_intervention,
    c.date_consult AS date_intervention,
    s.nom AS service,
    CONCAT(m.nom, ' ', m.prenom) AS praticien,
    c.diagnostic AS details
FROM Consultation c
JOIN Service s ON c.id_service = s.id_service
JOIN Medecin m ON c.id_medecin = m.id_medecin
WHERE c.id_patient = 1

UNION ALL

SELECT 
    'Hospitalisation' AS type_intervention,
    h.date_admission AS date_intervention,
    s.nom AS service,
    NULL AS praticien,
    h.motif AS details
FROM Hospitalisation h
JOIN Service s ON h.id_service = s.id_service
WHERE h.id_patient = 1

UNION ALL

SELECT 
    'Examen' AS type_intervention,
    e.date_examen AS date_intervention,
    s.nom AS service,
    CONCAT(m.nom, ' ', m.prenom) AS praticien,
    CONCAT(e.type_examen, ' - ', COALESCE(e.resultat, 'En attente')) AS details
FROM Examen e
LEFT JOIN Service s ON e.id_service = s.id_service
LEFT JOIN Medecin m ON e.id_medecin = m.id_medecin
WHERE e.id_patient = 1

ORDER BY date_intervention DESC;


-- =====================================================
-- 2. REQUÊTES D'AGRÉGATION ET STATISTIQUES
-- =====================================================

-- 2.1 Nombre de consultations par service (mois en cours) --

SELECT 
    s.nom AS service,
    COUNT(c.id_consult) AS nombre_consultations,
    COUNT(DISTINCT c.id_patient) AS patients_uniques
FROM Service s
LEFT JOIN Consultation c ON s.id_service = c.id_service
    AND EXTRACT(MONTH FROM c.date_consult) = EXTRACT(MONTH FROM CURRENT_DATE)
    AND EXTRACT(YEAR FROM c.date_consult) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY s.id_service, s.nom
ORDER BY nombre_consultations DESC;


-- 2.2 Taux d'occupation des lits par service -- 

SELECT 
    s.nom AS service,
    s.nbre_lits AS lits_disponibles,
    COUNT(h.id_hospi) AS lits_occupes,
    ROUND((COUNT(h.id_hospi) / s.nbre_lits) * 100, 2) AS taux_occupation
FROM Service s
LEFT JOIN Hospitalisation h ON s.id_service = h.id_service 
    AND h.date_sortie IS NULL
WHERE s.nbre_lits > 0
GROUP BY s.id_service, s.nom, s.nbre_lits
ORDER BY taux_occupation DESC;

-- 2.3 Nombre de consultations par médecin (mois en cours) --

SELECT 
    m.nom || ' ' || m.prenom AS medecin,
    m.specialite,
    s.nom AS service,
    COUNT(c.id_consult) AS consultations_mois
FROM Medecin m
LEFT JOIN Consultation c ON m.id_medecin = c.id_medecin
    AND EXTRACT(MONTH FROM c.date_consult) = EXTRACT(MONTH FROM CURRENT_DATE)
    AND EXTRACT(YEAR FROM c.date_consult) = EXTRACT(YEAR FROM CURRENT_DATE)
LEFT JOIN Service s ON m.id_service = s.id_service
GROUP BY m.id_medecin, m.nom, m.prenom, m.specialite, s.nom
ORDER BY consultations_mois DESC;


-- 2.4 Durée moyenne d'hospitalisation par patient --

SELECT 
    h.id_patient,
    p.nom || ' ' || p.prenom AS nom_complet,
    COUNT(h.id_hospi) AS nombre_hospitalisations,
    ROUND(AVG(CURRENT_DATE - h.date_admission), 1) AS duree_moyenne_jours,
    MIN(CURRENT_DATE - h.date_admission) AS duree_min,
    MAX(CURRENT_DATE - h.date_admission) AS duree_max
FROM Hospitalisation h
JOIN Patients p ON h.id_patient = p.id_patient
GROUP BY h.id_patient, p.nom, p.prenom
ORDER BY duree_moyenne_jours DESC;


-- 2.5 Activité mensuelle des 6 derniers mois --
SELECT 
    TO_CHAR(date_consult, 'YYYY-MM') AS mois,
    COUNT(*) AS nombre_consultations,
    COUNT(DISTINCT id_patient) AS patients_uniques,
    COUNT(DISTINCT id_medecin) AS medecins_actifs
FROM Consultation
WHERE date_consult >= CURRENT_DATE - INTERVAL '6 months'
GROUP BY TO_CHAR(date_consult, 'YYYY-MM')
ORDER BY mois;



-- =====================================================
-- 3. REQUÊTES DE RECHERCHE 
-- =====================================================

-- 3.1 Rechercher un patient à partir de son nom "lo"--  

SELECT 
    id_patient,
    nom || ' ' || prenom AS nom_complet,
    telephone
FROM Patients
WHERE UPPER(nom) LIKE '%lo%' OR UPPER(prenom) LIKE '%lo%'
ORDER BY nom, prenom;


-- 3.2 Trouver le résultat d'un patient --

SELECT 
    e.id_examen,
    TO_CHAR(e.date_examen, 'DD/MM/YYYY') AS date_examen,
    p.nom || ' ' || p.prenom AS patient,
    e.type_examen,
    s.nom AS service,
    COALESCE(e.resultat, 'En attente') AS resultat,
    CURRENT_DATE - e.date_examen AS jours_depuis_examen
FROM Examen e
JOIN Patients p ON e.id_patient = p.id_patient
LEFT JOIN Service s ON e.id_service = s.id_service
WHERE e.id_patient = 1
ORDER BY e.date_examen DESC;


-- =====================================================
-- FIN DES REQUÊTES
-- =====================================================



-- =====================================================
-- PROCÉDURES AUTOMATISATION DES TACHES --
-- =====================================================

-- 1.Enregistrer un nouveau patient --

-- Mise ne place d'un fonction qui retournera le nouvel ID et un message de confirmation --

CREATE OR REPLACE FUNCTION sp_enregistrer_patient(
    p_nom VARCHAR,
    p_prenom VARCHAR,
    p_sexe CHAR(1),
    p_adresse VARCHAR,
    p_telephone VARCHAR
)
RETURNS TABLE (
    id_patient INT,
    message TEXT
) AS $$
BEGIN
    -- Insérer le patient et récupérer l'ID
    INSERT INTO Patients (nom, prenom, sexe, adresse, telephone)
    VALUES (p_nom, p_prenom, p_sexe, p_adresse, p_telephone)
    RETURNING Patients.id_patient INTO id_patient;

    -- Construire le message
    message := 'Patient enregistré avec succès. ID: ' || id_patient;

    RETURN NEXT;
END;
$$ LANGUAGE plpgsql;


-- 2.Créer une nouvelle consultation --

CREATE OR REPLACE FUNCTION sp_creer_consultation(
    p_id_patient INT,
    p_id_medecin INT,
    p_id_service INT,
    p_date_consult TIMESTAMP,
    p_motif TEXT
)
RETURNS TABLE (
    id_consult INT,
    message TEXT
)
LANGUAGE plpgsql AS $$
DECLARE
    patient_exists INT;
    medecin_exists INT;
BEGIN
    -- Vérifier l'existence du patient
    SELECT COUNT(*) INTO patient_exists
    FROM Patients
    WHERE id_patient = p_id_patient;

    IF patient_exists = 0 THEN
        RAISE EXCEPTION 'Patient introuvable';
    END IF;

    -- Vérifier l'existence du médecin
    SELECT COUNT(*) INTO medecin_exists
    FROM Medecin
    WHERE id_medecin = p_id_medecin;

    IF medecin_exists = 0 THEN
        RAISE EXCEPTION 'Médecin introuvable';
    END IF;

    -- Insérer la consultation et récupérer l'ID
    INSERT INTO Consultation (date_consult, motif, id_patient, id_medecin, id_service)
    VALUES (p_date_consult, p_motif, p_id_patient, p_id_medecin, p_id_service)
    RETURNING Consultation.id_consult INTO id_consult;

    -- Retourner le message
    message := 'Consultation créée avec succès. ID: ' || id_consult;
    RETURN NEXT;
END;
$$;



--3.Modifier le diagnostic d'un patient --

CREATE OR REPLACE FUNCTION sp_maj_diagnostic_consultation(
    p_id_consult INT,
    p_diagnostic TEXT
)
RETURNS TEXT
LANGUAGE plpgsql AS $$
DECLARE
    rows_updated INT;
BEGIN
    -- Mettre à jour le diagnostic
    UPDATE Consultation
    SET diagnostic = p_diagnostic
    WHERE id_consult = p_id_consult;

    -- Récupérer le nombre de lignes affectées
    GET DIAGNOSTICS rows_updated = ROW_COUNT;

    -- Retourner le message
    IF rows_updated > 0 THEN
        RETURN 'Diagnostic mis à jour avec succès';
    ELSE
        RETURN 'Consultation introuvable';
    END IF;
END;
$$;




