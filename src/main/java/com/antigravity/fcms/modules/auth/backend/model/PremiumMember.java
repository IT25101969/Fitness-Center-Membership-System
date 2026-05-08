package com.antigravity.fcms.modules.auth.backend.model;

import jakarta.persistence.*;

/**
 * Represents a Premium gym member with extended benefits.
 * Extends {@link Member} and adds personal trainer assignment and locker allocation.
 *
 * <p>Inheritance: Extends {@link Member} which extends {@link Person}.</p>
 * <p>Polymorphism: Overrides {@link #getDetails()} with premium-specific format.</p>
 *
 */
@Entity
@DiscriminatorValue("PREMIUM")
public class PremiumMember extends Member {

    /** The ID of the assigned personal trainer. */
    @Column(name = "personal_trainer_id", length = 10)
    private String personalTrainerId;

    /** Name of the personal trainer (resolved from TrainerService). */
    @Transient
    private String trainerName;

    /** The locker number allocated to this premium member. */
    @Column(name = "locker_number")
    private int lockerNumber;

    /**
     * Default no-arg constructor.
     */
    public PremiumMember() {}

    /**
     * Full constructor for PremiumMember.
     *
     * @param id                unique member ID
     * @param name              full name
     * @param email             email address
     * @param phone             phone number
     * @param membershipPlanId  associated plan ID
     * @param joinDate          date of joining
     * @param status            membership status
     * @param personalTrainerId assigned trainer ID
     * @param lockerNumber      allocated locker number
     */
    public PremiumMember(String id, String name, String email, String phone,
                         String membershipPlanId, String joinDate, String status,
                         String personalTrainerId, int lockerNumber) {
        super(id, name, email, phone, membershipPlanId, joinDate, status, "PREMIUM");
        this.personalTrainerId = personalTrainerId;
        this.lockerNumber = lockerNumber;
    }

    /**
     * Returns a formatted description of this premium member.
     * Format: "Premium Member: [name] | Trainer: [trainerName] | Locker: [#]"
     *
     * @return formatted details string
     */
    @Override
    public String getDetails() {
        String trainer = (trainerName != null && !trainerName.isEmpty()) ? trainerName : personalTrainerId;
        return "Premium Member: " + getName() + " | Trainer: " + trainer + " | Locker: " + lockerNumber;
    }

    /**
     * Returns a descriptive string about the assigned trainer.
     *
     * @return trainer information string
     */
    public String getTrainerInfo() {
        return "Personal Trainer ID: " + personalTrainerId + ", Name: " + trainerName;
    }

    // -----------------------------------------------------------------------
    // Getters and Setters
    // -----------------------------------------------------------------------

    /** @return the personal trainer ID */
    public String getPersonalTrainerId() { return personalTrainerId; }

    /** @param personalTrainerId the trainer ID to set */
    public void setPersonalTrainerId(String personalTrainerId) { this.personalTrainerId = personalTrainerId; }

    /** @return the trainer name */
    public String getTrainerName() { return trainerName; }

    /** @param trainerName the trainer name to set */
    public void setTrainerName(String trainerName) { this.trainerName = trainerName; }

    /** @return the locker number */
    public int getLockerNumber() { return lockerNumber; }

    /** @param lockerNumber the locker number to set */
    public void setLockerNumber(int lockerNumber) { this.lockerNumber = lockerNumber; }
}
