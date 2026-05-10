package com.fcms.model;

import jakarta.persistence.*;
import java.util.Arrays;
import java.util.List;

/**
 * Represents a membership plan offered by the fitness center.
 * Plans define the price, duration, and features available to members.
 *
 * <p>Encapsulation: All fields are private and exposed via getters/setters.</p>
 *
 */
@Entity
@Table(name = "membership_plans")
public class MembershipPlan {

    /** Unique plan identifier (e.g., P001). */
    @Id
    @Column(name = "plan_id", length = 10)
    private String planId;

    /** Human-readable name of the plan (e.g., "Basic Monthly"). */
    @Column(name = "plan_name", length = 100, nullable = false)
    private String planName;

    /** Monthly price of the plan in LKR. */
    @Column
    private double price;

    /** Duration of the plan in days (e.g., 30, 90, 365). */
    @Column(name = "duration_days")
    private int durationDays;

    /** Class access level: LIMITED or UNLIMITED. */
    @Column(name = "class_access", length = 20)
    private String classAccess;

    /** Pipe-separated list of features included in this plan. */
    @Column(columnDefinition = "TEXT")
    private String features;

    /** Number of active members on this plan (computed at runtime). */
    @Transient
    private int activeMembers;

    /**
     * Default no-arg constructor.
     */
    public MembershipPlan() {}

    /**
     * Full constructor for a MembershipPlan.
     *
     * @param planId      unique plan ID
     * @param planName    plan display name
     * @param price       plan price
     * @param durationDays plan duration in days
     * @param classAccess  access type (LIMITED/UNLIMITED)
     * @param features    pipe-separated feature list
     */
    public MembershipPlan(String planId, String planName, double price,
                          int durationDays, String classAccess, String features) {
        this.planId = planId;
        this.planName = planName;
        this.price = price;
        this.durationDays = durationDays;
        this.classAccess = classAccess;
        this.features = features;
    }

    /**
     * Returns the list of features parsed from the pipe-separated features string.
     *
     * @return list of feature strings
     */
    public List<String> getFeatureList() {
        if (features == null || features.isEmpty()) {
            return List.of();
        }
        return Arrays.asList(features.split("\\|"));
    }

    /**
     * Formats the plan details as a readable string.
     *
     * @return plan details string
     */
    public String getPlanDetails() {
        return planName + " | Rs." + price + "/mo | " + durationDays + " days | " + classAccess;
    }

    // -----------------------------------------------------------------------
    // Getters and Setters
    // -----------------------------------------------------------------------

    /** @return the plan ID */
    public String getPlanId() { return planId; }

    /** @param planId the plan ID to set */
    public void setPlanId(String planId) { this.planId = planId; }

    /** @return the plan name */
    public String getPlanName() { return planName; }

    /** @param planName the plan name to set */
    public void setPlanName(String planName) { this.planName = planName; }

    /** @return the price */
    public double getPrice() { return price; }

    /** @param price the price to set */
    public void setPrice(double price) { this.price = price; }

    /** @return the duration in days */
    public int getDurationDays() { return durationDays; }

    /** @param durationDays the duration to set */
    public void setDurationDays(int durationDays) { this.durationDays = durationDays; }

    /** @return the class access level */
    public String getClassAccess() { return classAccess; }

    /** @param classAccess the class access to set */
    public void setClassAccess(String classAccess) { this.classAccess = classAccess; }

    /** @return the pipe-separated features string */
    public String getFeatures() { return features; }

    /** @param features the features string to set */
    public void setFeatures(String features) { this.features = features; }

    /** @return the number of active members on this plan */
    public int getActiveMembers() { return activeMembers; }

    /** @param activeMembers the active member count to set */
    public void setActiveMembers(int activeMembers) { this.activeMembers = activeMembers; }
}
