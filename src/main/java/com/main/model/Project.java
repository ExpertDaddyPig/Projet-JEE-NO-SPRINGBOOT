package com.main.model;

import jakarta.persistence.*;

@Entity
@Table(name = "Projects")

public class Project {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "project_name", length = 50, nullable = false)
    private String project_name;

    @Column(name = "project_state", length = 50, nullable = false)
    private String project_state;

    @Column(name = "employees", length = 1000, nullable = true)
    private String employees;

    public Project() {
    }

    public Project(String name) {
        this.project_name = name;
        this.project_state = "in process";
    }

    public String getEmployees() {
        return employees;
    }

    public int getId() {
        return id;
    }

    public String getProject_name() {
        return project_name;
    }

    public String getProject_state() {
        return project_state;
    }

    public void setEmployees(String employees) {
        this.employees = employees;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setProject_name(String project_name) {
        this.project_name = project_name;
    }

    public void setProject_state(String project_state) {
        this.project_state = project_state;
    }
}
