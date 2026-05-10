package com.project.fcms.modules.trainer.backend.model;

import com.project.fcms.modules.auth.backend.model.Person;
import jakarta.persistence.*;

/**
 * Represents a fitness trainer in the Fitness Center Membership System.
 * Extends {@link Person} with trainer-specific professional fields.
 *
 * <p>Inheritance: Extends the abstract {@link Person} class.</p>
 * <p>Polymorphism: Overrides {@link #getDetails()} with trainer-specific format.</p>
 *
 */
@Entity
@Table(name = "trainers")
public class Trainer extends Person {

    @Id
    @Column(name = "id", length = 10)
    private String trainerId;

    /** The area of fitness the trainer specializes in (e.g., Yoga, Cardio, Strength). */
    @Column(length = 100)
    private String specialization;

    /** Pipe-separated list of certifications held by this trainer. */
    @Column(columnDefinition = "TEXT")
    private String certifications;

    /**
     * Default no-arg constructor.
     */
    public Trainer() {}

    /**
     * Full constructor for a Trainer.
     *
     * @param id              unique trainer ID
     * @param name            full name
     * @param email           email address
     * @param phone           phone number
     * @param specialization  area of specialization
     * @param certifications  pipe-separated certifications
     */
    public Trainer(String id, String name, String email, String phone,
                   String specialization, String certifications) {
        super(id, name, email, phone);
        this.trainerId = id;
        this.specialization = specialization;
        this.certifications = certifications;
    }

    @Override
    public String getId() { return trainerId; }

    @Override
    public void setId(String id) {
        super.setId(id);
        this.trainerId = id;
    }

    /**
     * Returns a formatted description of this trainer.
     * Format: "Trainer: [name] | Specialization: [yoga/cardio/etc]"
     *
     * @return formatted details string
     */
    @Override
    public String getDetails() {
        return "Trainer: " + getName() + " | Specialization: " + specialization;
    }

    /**
     * Returns the trainer's weekly schedule description.
     * Placeholder for future schedule integration.
     *
     * @return schedule description
     */
    public String getSchedule() {
        return "Trainer " + getName() + " schedule not yet defined.";
    }

    // -----------------------------------------------------------------------
    // Getters and Setters
    // -----------------------------------------------------------------------

    /** @return the specialization */
    public String getSpecialization() { return specialization; }

    /** @param specialization the specialization to set */
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    /** @return the certifications string */
    public String getCertifications() { return certifications; }

    /** @param certifications the certifications to set */
    public void setCertifications(String certifications) { this.certifications = certifications; }
}
