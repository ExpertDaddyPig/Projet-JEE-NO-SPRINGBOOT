package com.main.model;

import jakarta.persistence.*;

public class Departement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "departement_name", length = 50, nullable = false)
    private String departement_name;

    @Column(name = "employees", length = 1000, nullable = true)
    private String employees;

    public Departement() {
    }

    public Departement(int id, String name, String employees) {
        this.id = id;
        this.departement_name = name;
        this.employees = employees;
    }
}
