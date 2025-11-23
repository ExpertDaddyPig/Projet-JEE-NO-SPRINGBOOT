package com.main.model;

import jakarta.persistence.*;

@Entity
@Table(name = "payslips")
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

    public int getDeductions() {
        return deductions;
    }

    public int getEmploye_id() {
        return employe_id;
    }

    public int getId() {
        return id;
    }

    public int getMonth() {
        return month;
    }

    public int getPrimes() {
        return primes;
    }

    public int getSalary() {
        return salary;
    }

    public void setDeductions(int deductions) {
        this.deductions = deductions;
    }

    public void setEmploye_id(int employe_id) {
        this.employe_id = employe_id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    public void setPrimes(int primes) {
        this.primes = primes;
    }

    public void setSalary(int salary) {
        this.salary = salary;
    }
}
