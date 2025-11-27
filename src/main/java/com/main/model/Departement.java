package com.main.model;

import jakarta.persistence.*;

@Entity
@Table(name = "departements")
public class Departement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "departement_name", length = 50, nullable = false)
    private String departement_name;

    @Column(name = "employees", length = 1000, nullable = true)
    private String employees;

    @Column(name = "employeesCount", nullable = true)
    private int employeesCount;

    public Departement() {
    }

    public Departement(int id, String name, String employees) {
        this.id = id;
        this.departement_name = name;
        this.employees = employees;
        setEmployeesCount();
    }

    public String getDepartement_name() {
        return departement_name;
    }

    public int getEmployeesCount() {
        return employeesCount;
    }

    public void setEmployeesCount() {
        employeesCount = employees.split(",").length;
    }

    public String getEmployees() {
        return employees;
    }

    public int getId() {
        return id;
    }

    public void setDepartement_name(String departement_name) {
        this.departement_name = departement_name;
    }

    public void setEmployees(String employees) {
        this.employees = employees;
    }

    public void setId(int id) {
        this.id = id;
    }
}
