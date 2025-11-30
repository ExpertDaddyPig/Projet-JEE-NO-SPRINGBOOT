-- Sélectionner la base de données
USE rhdatabase;

-- Désactiver temporairement la vérification des clés étrangères pour les insertions
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 1. Seeding de la table Departements 🏢
-- Note: 'Administration' (ID 1) existe déjà. On ajoute d'autres départements.
-- ----------------------------
INSERT INTO
    Departements (departement_name, employeesCount)
VALUES
    ('Ressources Humaines', 0), -- ID 2
    ('Développement IT', 0),    -- ID 3
    ('Marketing', 0),           -- ID 4
    ('Commercial', 0),          -- ID 5
    ('Comptabilité', 0);        -- ID 6

-- ----------------------------
-- 2. Seeding de la table Projects 🚀
-- ----------------------------
INSERT INTO
    Projects (project_name, project_state, employees)
VALUES
    ('Migration Cloud', 'in process', ''),
    ('Refonte Site Web', 'in process', ''),
    ('Campagne Q4 2025', 'finished', ''),
    ('Audit Financier', 'canceled', ''),
    ('ERP Implementation', 'in process', ''),
    ('Formation Sécurité', 'finished', '');

-- ----------------------------
-- 3. Seeding de la table Employees 👥
-- Le mot de passe haché ($2a$12$6Nl7m7yU8y7tXz9z3h5j..X0e8D8.4O0w7D6.8F1E9A0C3C9J2J3.) est pour 'password'
-- ----------------------------

-- Hachage bcrypt de 'password' (peut être utilisé pour tous les employés non-Admin)
SET @default_password_hash = '$2a$12$6Nl7m7yU8y7tXz9z3h5j..X0e8D8.4O0w7D6.8F1E9A0C3C9J2J3.';

INSERT INTO
    Employees (
        departement_id,
        first_name,
        last_name,
        gender,
        registration_number,
        projects,
        job_name,
        employe_rank,
        age,
        email,
        username,
        password_hash,
        createdAt,
        lastLogin,
        isActive
    )
VALUES
    -- RH (ID 2)
    (
        2,
        'Sophie',
        'Dubois',
        'Female',
        '2024000101',
        '[]',
        'Responsable RH',
        3,
        35,
        'sophie.dubois@company.com',
        'sdubois',
        @default_password_hash,
        '2023-01-15',
        CURRENT_TIMESTAMP(),
        TRUE
    ),
    (
        2,
        'Marc',
        'Lefevre',
        'Male',
        '2024000102',
        '[]',
        'Assistant RH',
        2,
        28,
        'marc.lefevre@company.com',
        'mlefevre',
        @default_password_hash,
        '2023-05-20',
        CURRENT_TIMESTAMP(),
        TRUE
    ),
    -- Dev IT (ID 3)
    (
        3,
        'David',
        'Martin',
        'Male',
        '2024000201',
        '[1, 2, 5]',
        'Développeur Senior',
        3,
        42,
        'david.martin@company.com',
        'dmartin',
        @default_password_hash,
        '2022-08-01',
        CURRENT_TIMESTAMP(),
        TRUE
    ),
    (
        3,
        'Alice',
        'Bernard',
        'Female',
        '2024000202',
        '[2]',
        'Développeur Junior',
        1,
        24,
        'alice.bernard@company.com',
        'abernard',
        @default_password_hash,
        '2024-03-10',
        CURRENT_TIMESTAMP(),
        TRUE
    ),
    (
        3,
        'Jean',
        'Petit',
        'Male',
        '2024000203',
        '[1, 5]',
        'Chef de Projet IT',
        4,
        48,
        'jean.petit@company.com',
        'jpetit',
        @default_password_hash,
        '2020-06-01',
        CURRENT_TIMESTAMP(),
        TRUE
    ),
    -- Marketing (ID 4)
    (
        4,
        'Chloé',
        'Rousseau',
        'Female',
        '2024000301',
        '[3]',
        'Spécialiste Marketing Digital',
        2,
        30,
        'chloe.rousseau@company.com',
        'crousseau',
        @default_password_hash,
        '2023-09-01',
        CURRENT_TIMESTAMP(),
        TRUE
    ),
    -- Commercial (ID 5)
    (
        5,
        'Thomas',
        'Leroy',
        'Male',
        '2024000401',
        '[]',
        'Directeur Commercial',
        4,
        55,
        'thomas.leroy@company.com',
        'tleroy',
        @default_password_hash,
        '2018-01-01',
        CURRENT_TIMESTAMP(),
        TRUE
    ),
    (
        5,
        'Marie',
        'Moreau',
        'Female',
        '2024000402',
        '[]',
        'Commercial Junior',
        1,
        22,
        'marie.moreau@company.com',
        'mmoreau',
        @default_password_hash,
        '2024-06-01',
        CURRENT_TIMESTAMP(),
        TRUE
    ),
    -- Comptabilité (ID 6)
    (
        6,
        'Lucas',
        'Fournier',
        'Male',
        '2024000501',
        '[4]',
        'Comptable Senior',
        3,
        38,
        'lucas.fournier@company.com',
        'lfournier',
        @default_password_hash,
        '2021-11-10',
        CURRENT_TIMESTAMP(),
        TRUE
    );

-- ----------------------------
-- 4. Seeding de la table Payslips (Bulletins de Paie) 💰
-- (ID Employé: 2-Sophie Dubois, 3-Marc Lefevre, 4-David Martin, 5-Alice Bernard, 6-Jean Petit, 7-Chloé Rousseau, 8-Thomas Leroy, 9-Marie Moreau, 10-Lucas Fournier)
-- ----------------------------
INSERT INTO
    Payslips (employe_id, month, salary, primes, deductions)
VALUES
    -- Pour Sophie Dubois (ID 2, Rank 3)
    (2, 9, 3500, 100, 500),
    (2, 10, 3500, 0, 500),
    -- Pour David Martin (ID 4, Rank 3)
    (4, 9, 4500, 500, 700),
    (4, 10, 4500, 200, 700),
    -- Pour Alice Bernard (ID 5, Rank 1)
    (5, 10, 2200, 0, 300),
    -- Pour Jean Petit (ID 6, Rank 4)
    (6, 10, 6000, 1000, 1000),
    -- Pour Thomas Leroy (ID 8, Rank 4)
    (8, 9, 7000, 2000, 1200),
    (8, 10, 7000, 500, 1200),
    -- Pour Lucas Fournier (ID 10, Rank 3)
    (10, 10, 3800, 0, 550);

-- ----------------------------
-- 5. Mise à jour des compteurs d'employés et des listes de projets/employés (Approximation simple)
-- ----------------------------

-- Mise à jour du employeesCount dans Departements
UPDATE Departements
SET employeesCount = (
    SELECT COUNT(id)
    FROM Employees
    WHERE departement_id = Departements.id
);

-- Mise à jour de la liste des employés dans les départements (pour l'exemple, on peut laisser tel quel ou le faire avec une jointure, mais le champ est un VARCHAR(1000) et n'est pas idéal pour cette tâche)

-- Activation de la vérification des clés étrangères
SET FOREIGN_KEY_CHECKS = 1;
