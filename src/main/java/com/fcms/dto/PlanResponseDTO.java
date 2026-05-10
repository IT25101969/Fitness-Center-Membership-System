package com.fcms.dto;

import com.project.fcms.modules.plan.backend.model.MembershipPlan;

import java.util.Arrays;
import java.util.List;

/**
 * Data Transfer Object for a membership plan.
 * Carries plan data from the service layer to the controller/view.
 * Includes computed fields (e.g. featureList, activeMembers) ready for display.
 */
public class PlanResponseDTO {

    private final String planId;
    private final String planName;
    private final double price;
    private final int durationDays;
    private final String classAccess;
    private final String features;
    private final int activeMembers;

    /**
     * Builds a PlanResponseDTO directly from a MembershipPlan entity.
     *
     * @param plan          the source MembershipPlan entity
     * @param activeMembers number of active members on this plan
     */
    public PlanResponseDTO(MembershipPlan plan, int activeMembers) {
        this.planId        = plan.getPlanId();
        this.planName      = plan.getPlanName();
        this.price         = plan.getPrice();
        this.durationDays  = plan.getDurationDays();
        this.classAccess   = plan.getClassAccess();
        this.features      = plan.getFeatures();
        this.activeMembers = activeMembers;
    }

    /**
     * Returns the list of features parsed from the pipe-separated features string.
     * Example: "Gym Access|Locker|Shower" → ["Gym Access", "Locker", "Shower"]
     *
     * @return list of feature strings, empty list if none
     */
    public List<String> getFeatureList() {
        if (features == null || features.isBlank()) return List.of();
        return Arrays.asList(features.split("\\|"));
    }

    /**
     * Returns a formatted summary of the plan for display purposes.
     *
     * @return human-readable plan summary string
     */
    public String getSummary() {
        return planName + " | Rs." + price + "/mo | " + durationDays + " days | " + classAccess;
    }

    // ── Getters ──────────────────────────────────────────────────────────────

    public String getPlanId()      { return planId; }
    public String getPlanName()    { return planName; }
    public double getPrice()       { return price; }
    public int getDurationDays()   { return durationDays; }
    public String getClassAccess() { return classAccess; }
    public String getFeatures()    { return features; }
    public int getActiveMembers()  { return activeMembers; }
}
