package com.main.model;

import java.util.*;

import jakarta.persistence.*;

@Entity
@Table(name = "employees")
public class Employe {

    private String candidateChars = "1234567890";

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "first_name", length = 50, nullable = false)
    private String first_name;
    
    @Column(name = "last_name", length = 50, nullable = false)
    private String last_name;
    
    @Column(name = "gender", length = 50, nullable = false)
    private String gender;
    
    @Column(name = "registration_number", length = 10, nullable = false)
    private String registration_number;
    
    @Column(name = "departement_id", nullable = true)
    private int departement_id;
    
    @Column(name = "projects", length = 200, nullable = true)
    private String projects;
    
    @Column(name = "job_name", length = 100, nullable = true)
    private String job_name;
    
    @Column(name = "employe_rank", nullable = false)
    private int employe_rank;
    
    @Column(name = "age", nullable = false)
    private int age;

    public Employe() {
    }

    // Creation of one employe with no additionnal information
    public Employe(String first_name, String last_name, String gender, int employe_rank, int age) {
        this.first_name = first_name;
        this.last_name = last_name;
        this.gender = gender;
        this.age = age;
        this.employe_rank = employe_rank;
        this.registration_number = generateRegistrationNumber();
    }

    public Employe(String first_name, String last_name, String gender, String job_name, int departement_id,
            int employe_rank, int age) {
        this.first_name = first_name;
        this.last_name = last_name;
        this.gender = gender;
        this.age = age;
        this.employe_rank = employe_rank;
        this.registration_number = generateRegistrationNumber();
        this.job_name = job_name;
        this.departement_id = departement_id;
    }

    public Employe(String first_name, String last_name, String gender, String job_name, int projects_id[],
            int departement_id, int employe_rank, int age) {
        this.first_name = first_name;
        this.last_name = last_name;
        this.gender = gender;
        this.age = age;
        this.employe_rank = employe_rank;
        this.registration_number = generateRegistrationNumber();
        this.job_name = job_name;
        this.departement_id = departement_id;
        this.employe_rank = employe_rank;
        StringBuilder projectsIdStrings = new StringBuilder();
        for (int project_id : projects_id) {
            projectsIdStrings.append(project_id);
            projectsIdStrings.append("|");
        }
        this.projects = projectsIdStrings.toString();
    }

    private String generateRegistrationNumber() {
        StringBuilder generated = new StringBuilder();
        Random random = new Random();
        for (int i = 0; i < 10; i++) {
            generated.append(candidateChars.charAt(random.nextInt(candidateChars.length())));
        }
        return generated.toString();
    }

}