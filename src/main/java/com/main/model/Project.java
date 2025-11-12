package com.main.model;

import jakarta.persistence.*;

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
}
