package com.main.model;

import jakarta.persistence.*;

public class Payslip {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;
    
    @Column(name = "employe_id")
    private int employe_id;
    
    @Column(name = "month", nullable = false)
    private int month;
    
    @Column(name = "salary", nullable = false)
    private int salary;

    @Column(name = "primes", nullable = false)
    private int primes;
    
    @Column(name = "deductions", nullable = false)
    private int deductions;

    public Payslip() {
    }

    public Payslip(int employe_id, int month, int salary, int primes, int deductions) {
        this.employe_id = employe_id;
        this.month = month;
        this.salary = salary;
        this.primes = primes;
        this.deductions = deductions;
    }
}
