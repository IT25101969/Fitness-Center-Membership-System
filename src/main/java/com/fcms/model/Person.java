package com.fcms.model;

import jakarta.persistence.Column;
import jakarta.persistence.MappedSuperclass;
import jakarta.persistence.Transient;

/**
 * Abstract base class representing a person in the Fitness Center Membership System.
 * Serves as the root of the OOP inheritance hierarchy for Member, Trainer, and Admin.
 *
 * <p>Encapsulation: All fields are private and exposed via public getters/setters.</p>
 * <p>Abstraction: Declares the abstract method {@code getDetails()} that all subclasses must implement.</p>
 *
 */
@MappedSuperclass
public abstract class Person {

    /** Unique identifier for this person. */
    @Transient
    private String id;

    /** Full name of this person. */
    @Column(length = 100)
    private String name;

    /** Email address of this person. */
    @Column(length = 100)
    private String email;

    /** Phone number of this person. */
    @Column(length = 20)
    private String phone;

    /**
     * Default no-arg constructor required for bean instantiation.
     */
    public Person() {}

    /**
     * Constructs a Person with all core fields.
     *
     * @param id    unique identifier
     * @param name  full name
     * @param email email address
     * @param phone phone number
     */
    public Person(String id, String name, String email, String phone) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.phone = phone;
    }

    /**
     * Returns a formatted string describing this person.
     * Polymorphism: overridden in every subclass to produce a role-specific description.
     *
     * @return formatted details string
     */
    public abstract String getDetails();

    // -----------------------------------------------------------------------
    // Getters and Setters (Encapsulation)
    // -----------------------------------------------------------------------

    /**
     * Returns the person's unique ID.
     * @return id string
     */
    public String getId() { return id; }

    /**
     * Sets the person's unique ID.
     * @param id unique identifier
     */
    public void setId(String id) { this.id = id; }

    /**
     * Returns the person's full name.
     * @return name string
     */
    public String getName() { return name; }

    /**
     * Sets the person's full name.
     * @param name full name
     */
    public void setName(String name) { this.name = name; }

    /**
     * Returns the person's email address.
     * @return email string
     */
    public String getEmail() { return email; }

    /**
     * Sets the person's email address.
     * @param email email address
     */
    public void setEmail(String email) { this.email = email; }

    /**
     * Returns the person's phone number.
     * @return phone string
     */
    public String getPhone() { return phone; }

    /**
     * Sets the person's phone number.
     * @param phone phone number
     */
    public void setPhone(String phone) { this.phone = phone; }
}
