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
```

# Le reste c'est turbo ez
