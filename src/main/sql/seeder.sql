SET
    FOREIGN_KEY_CHECKS = 0;

INSERT INTO
    Departements (departement_name, employees, employeesCount)
VALUES
    ('Ressources Humaines', '', 0),
    ('Développement IT', '', 0),
    ('Marketing', '', 0),
    ('Commercial', '', 0),
    ('Comptabilité', '', 0);

INSERT INTO
    Projects (project_name, project_state, employees)
VALUES
    ('Migration Cloud', 'in process', ''),
    ('Refonte Site Web', 'in process', ''),
    ('Campagne Q4 2025', 'finished', ''),
    ('Audit Financier', 'canceled', ''),
    ('ERP Implementation', 'in process', ''),
    ('Formation Sécurité', 'finished', '');

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
    (
        1,
        'System',
        'Admin',
        'Other',
        '6900420067',
        '',
        'Administrator',
        4,
        40,
        'admin@admin.com',
        'sys_admin',
        '$2a$12$b7Acw.axAnGB4Vhng1yPUOLtvC1GKx0nuz/IBALwrThaS6DH6YpaS',
        CURDATE(),
        CURDATE(),
        TRUE
    ),
    (
        2,
        'Sophie',
        'Dubois',
        'Female',
        '2024000101',
        '',
        'Responsable RH',
        3,
        35,
        'sophie.dubois@company.com',
        'sdubois',
        '$2a$12$6Nl7m7yU8y7tXz9z3h5j..X0e8D8.4O0w7D6.8F1E9A0C3C9J2J3.',
        '2023-01-15',
        CURDATE(),
        TRUE
    ),
    (
        2,
        'Marc',
        'Lefevre',
        'Male',
        '2024000102',
        '',
        'Assistant RH',
        2,
        28,
        'marc.lefevre@company.com',
        'mlefevre',
        '$2a$12$6Nl7m7yU8y7tXz9z3h5j..X0e8D8.4O0w7D6.8F1E9A0C3C9J2J3.',
        '2023-05-20',
        CURDATE(),
        TRUE
    ),
    (
        3,
        'David',
        'Martin',
        'Male',
        '2024000201',
        '1,2,5',
        'Développeur Senior',
        3,
        42,
        'david.martin@company.com',
        'dmartin',
        '$2a$12$6Nl7m7yU8y7tXz9z3h5j..X0e8D8.4O0w7D6.8F1E9A0C3C9J2J3.',
        '2022-08-01',
        CURDATE(),
        TRUE
    ),
    (
        3,
        'Alice',
        'Bernard',
        'Female',
        '2024000202',
        '2',
        'Développeur Junior',
        1,
        24,
        'alice.bernard@company.com',
        'abernard',
        '$2a$12$6Nl7m7yU8y7tXz9z3h5j..X0e8D8.4O0w7D6.8F1E9A0C3C9J2J3.',
        '2024-03-10',
        CURDATE(),
        TRUE
    ),
    (
        3,
        'Jean',
        'Petit',
        'Male',
        '2024000203',
        '1,5',
        'Chef de Projet IT',
        4,
        48,
        'jean.petit@company.com',
        'jpetit',
        '$2a$12$6Nl7m7yU8y7tXz9z3h5j..X0e8D8.4O0w7D6.8F1E9A0C3C9J2J3.',
        '2020-06-01',
        CURDATE(),
        TRUE
    ),
    (
        4,
        'Chloé',
        'Rousseau',
        'Female',
        '2024000301',
        '3',
        'Spécialiste Marketing Digital',
        2,
        30,
        'chloe.rousseau@company.com',
        'crousseau',
        '$2a$12$6Nl7m7yU8y7tXz9z3h5j..X0e8D8.4O0w7D6.8F1E9A0C3C9J2J3.',
        '2023-09-01',
        CURDATE(),
        TRUE
    ),
    (
        5,
        'Thomas',
        'Leroy',
        'Male',
        '2024000401',
        '',
        'Directeur Commercial',
        4,
        55,
        'thomas.leroy@company.com',
        'tleroy',
        '$2a$12$6Nl7m7yU8y7tXz9z3h5j..X0e8D8.4O0w7D6.8F1E9A0C3C9J2J3.',
        '2018-01-01',
        CURDATE(),
        TRUE
    ),
    (
        5,
        'Marie',
        'Moreau',
        'Female',
        '2024000402',
        '',
        'Commercial Junior',
        1,
        22,
        'marie.moreau@company.com',
        'mmoreau',
        '$2a$12$6Nl7m7yU8y7tXz9z3h5j..X0e8D8.4O0w7D6.8F1E9A0C3C9J2J3.',
        '2024-06-01',
        CURDATE(),
        TRUE
    ),
    (
        6,
        'Lucas',
        'Fournier',
        'Male',
        '2024000501',
        '4',
        'Comptable Senior',
        3,
        38,
        'lucas.fournier@company.com',
        'lfournier',
        '$2a$12$6Nl7m7yU8y7tXz9z3h5j..X0e8D8.4O0w7D6.8F1E9A0C3C9J2J3.',
        '2021-11-10',
        CURDATE(),
        TRUE
    ),
    (
        3,
        'Paul',
        'Durand',
        'Male',
        '2024000204',
        '1',
        'DevOps Engineer',
        3,
        33,
        'paul.durand@company.com',
        'pdurand',
        '$2a$12$6Nl7m7yU8y7tXz9z3h5j..X0e8D8.4O0w7D6.8F1E9A0C3C9J2J3.',
        '2023-02-01',
        CURDATE(),
        TRUE
    ),
    (
        4,
        'Emma',
        'Petit',
        'Female',
        '2024000302',
        '3',
        'Community Manager',
        2,
        26,
        'emma.petit@company.com',
        'epetit',
        '$2a$12$6Nl7m7yU8y7tXz9z3h5j..X0e8D8.4O0w7D6.8F1E9A0C3C9J2J3.',
        '2024-01-15',
        CURDATE(),
        TRUE
    ),
    (
        5,
        'Karim',
        'Benali',
        'Male',
        '2024000403',
        '',
        'Commercial Confirmé',
        3,
        39,
        'karim.benali@company.com',
        'kbenali',
        '$2a$12$6Nl7m7yU8y7tXz9z3h5j..X0e8D8.4O0w7D6.8F1E9A0C3C9J2J3.',
        '2020-11-20',
        CURDATE(),
        TRUE
    ),
    (
        6,
        'Sarah',
        'Cohen',
        'Female',
        '2024000502',
        '4',
        'Assistante Comptable',
        2,
        29,
        'sarah.cohen@company.com',
        'scohen',
        '$2a$12$6Nl7m7yU8y7tXz9z3h5j..X0e8D8.4O0w7D6.8F1E9A0C3C9J2J3.',
        '2022-07-04',
        CURDATE(),
        TRUE
    ),
    (
        2,
        'Julie',
        'Meyer',
        'Female',
        '2024000103',
        '',
        'Chargée de Recrutement',
        2,
        31,
        'julie.meyer@company.com',
        'jmeyer',
        '$2a$12$6Nl7m7yU8y7tXz9z3h5j..X0e8D8.4O0w7D6.8F1E9A0C3C9J2J3.',
        '2023-09-10',
        CURDATE(),
        TRUE
    ),
    (
        3,
        'Robert',
        'Lang',
        'Male',
        '2024000205',
        '1,5,6',
        'Architecte Logiciel',
        4,
        50,
        'robert.lang@company.com',
        'rlang',
        '$2a$12$6Nl7m7yU8y7tXz9z3h5j..X0e8D8.4O0w7D6.8F1E9A0C3C9J2J3.',
        '2019-03-12',
        CURDATE(),
        TRUE
    ),
    (
        4,
        'Nina',
        'Simone',
        'Female',
        '2024000303',
        '2,3',
        'UX/UI Designer',
        3,
        34,
        'nina.simone@company.com',
        'nsimone',
        '$2a$12$6Nl7m7yU8y7tXz9z3h5j..X0e8D8.4O0w7D6.8F1E9A0C3C9J2J3.',
        '2021-05-22',
        CURDATE(),
        TRUE
    );

INSERT INTO
    Payslips (employe_id, month, salary, primes, deductions)
VALUES
    (2, 9, 3500, 100, 500),
    (2, 10, 3500, 0, 500),
    (4, 9, 4500, 500, 700),
    (4, 10, 4500, 200, 700),
    (5, 10, 2200, 0, 300),
    (6, 10, 6000, 1000, 1000),
    (8, 9, 7000, 2000, 1200),
    (8, 10, 7000, 500, 1200),
    (10, 10, 3800, 0, 550),
    (11, 10, 4200, 100, 600),
    (12, 10, 2600, 50, 350),
    (13, 10, 4800, 1500, 800),
    (14, 10, 2900, 0, 400),
    (15, 10, 3100, 200, 450),
    (16, 10, 6500, 800, 1100),
    (17, 10, 3600, 150, 500);

UPDATE Departements
SET
    employeesCount = (
        SELECT
            COUNT(id)
        FROM
            Employees
        WHERE
            departement_id = Departements.id
    ),
    employees = (
        SELECT
            GROUP_CONCAT(id SEPARATOR ',')
        FROM
            Employees
        WHERE
            departement_id = Departements.id
    )
WHERE
    id > -1;

SET
    FOREIGN_KEY_CHECKS = 1;