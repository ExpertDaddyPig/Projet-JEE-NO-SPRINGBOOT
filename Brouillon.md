# COMMENT ON VA GERER LES DONNES

## Gestion de la base de donnee

```
// Gestion des employés:
Employe => {
    String first_name;
    String last_name;
    String gender;
    String registration_number; (matricule)
    Departement departement;
    String job_name;
    String rank; (ptet un rank en mode rank 1 pour les hauts placés)
    Project projects[];
    Int age;
}

// Gestion des departements:
Departement => {
    String name;
    Employe members[];
}

// Gestion des projets:
Project => {
    String name;
    String state = "in process" | "finished" | "canceled";
    Employe members[];
}

// Gestion des fiches de paies:
Payslip => {
    Int month;
    Employe employe;
    Int salary;
    Int primes;
    Int deductions;
}
```

## Gestion des functions
```
// Gestion des employés:
addEmploye(String first_name, String last_name, String gender, Departement departement, String job_name, String rank, Int age) {
    String registration_number = | générer une suite de chiffres aléatoires de 15-20 caractères |;
    | Chercher dans la base si le numéro de matricule n'est pas déjà pris, si il est déjà pris il faudra le regénérer (et ce en boucle tant qu'il n'est pas unique) |
    | Sauvegarder les données dans la BDD |
}

deleteEmploye(String registration_number) {
    | Trouver l'employé correspondant dans la BDD et supprimer (plutot simple) |
}

getEmploye(String registration_number) {
    | Trouver l'employé correspondant dans la BDD et le sauvegarder dans une classe (plutot simple aussi) |
}

updateEmploye()
```

# Le reste c'est turbo ez
