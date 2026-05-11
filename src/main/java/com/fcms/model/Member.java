package com.fcms.model;

import jakarta.persistence.*;

/**
 * Represents a gym member in the Fitness Center Membership System.
 * Extends {@link Person} with membership-specific fields.
 *
 * <p>Encapsulation: All fields are private; exposed via getters/setters.</p>
 * <p>Inheritance: Extends the abstract {@link Person} class.</p>
 * <p>Polymorphism: Overrides {@link #getDetails()} to return a member-specific description.</p>
 *
 */
@Entity
@Table(name = "members")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "dtype", discriminatorType = DiscriminatorType.STRING)
@DiscriminatorValue("STANDARD")
public class Member extends Person {

    @Id
    @Column(name = "id", length = 10)
    private String memberId;

    /** The ID of the membership plan this member is subscribed to. */
    @Column(name = "membership_plan_id", length = 10)
    private String membershipPlanId;

    /** Name of the membership plan (resolved from PlanService). */
    @Transient
    private String planName;

    /** The date the member joined (ISO format: yyyy-MM-dd). */
    @Column(name = "join_date", length = 20)
    private String joinDate;

    /** Membership status: ACTIVE, INACTIVE, or EXPIRED. */
    @Column(length = 20)
    private String status;

    /** The member type: STANDARD or PREMIUM. */
    @Column(length = 20)
    private String type;

    /** Optional password for portal login. Null means use email-prefix as default. */
    @Column(length = 100)
    private String password;

    /**
     * Default no-arg constructor.
     */
    public Member() {}

    /**
     * Full constructor for a Member.
     *
     * @param id               unique member ID
     * @param name             full name
     * @param email            email address
     * @param phone            phone number
     * @param membershipPlanId associated plan ID
     * @param joinDate         date of joining
     * @param status           membership status
     * @param type             member type (STANDARD / PREMIUM)
     */
    public Member(String id, String name, String email, String phone,
                  String membershipPlanId, String joinDate, String status, String type) {
        super(id, name, email, phone);
        this.memberId = id;
        this.membershipPlanId = membershipPlanId;
        this.joinDate = joinDate;
        this.status = status;
        this.type = type;
    }

    // Override getId/setId to sync with memberId (JPA @Id)
    @Override
    public String getId() { return memberId; }

    @Override
    public void setId(String id) {
        super.setId(id);
        this.memberId = id;
    }

    /**
     * Returns a formatted description of this member.
     * Format: "Member: [name] | Plan: [planName] | Status: [Active/Inactive]"
     *
     * @return formatted details string
     */
    @Override
    public String getDetails() {
        String planDisplay = (planName != null && !planName.isEmpty()) ? planName : membershipPlanId;
        return "Member: " + getName() + " | Plan: " + planDisplay + " | Status: " + status;
    }

    /**
     * Determines whether this member's status is ACTIVE.
     *
     * @return true if the member status equals "ACTIVE"
     */
    public boolean isActive() {
        return "ACTIVE".equalsIgnoreCase(status);
    }

    // -----------------------------------------------------------------------
    // Getters and Setters
    // -----------------------------------------------------------------------

    /** @return the membership plan ID */
    public String getMembershipPlanId() { return membershipPlanId; }

    /** @param membershipPlanId the plan ID to set */
    public void setMembershipPlanId(String membershipPlanId) { this.membershipPlanId = membershipPlanId; }

    /** @return the plan name */
    public String getPlanName() { return planName; }

    /** @param planName the plan name to set */
    public void setPlanName(String planName) { this.planName = planName; }

    /** @return the join date */
    public String getJoinDate() { return joinDate; }

    /** @param joinDate the join date to set */
    public void setJoinDate(String joinDate) { this.joinDate = joinDate; }

    /** @return the membership status */
    public String getStatus() { return status; }

    /** @param status the status to set */
    public void setStatus(String status) { this.status = status; }

    /** @return the member type */
    public String getType() { return type; }

    /** @param type the type to set */
    public void setType(String type) { this.type = type; }

    /** @return the member's portal password (null if using email-prefix default) */
    public String getPassword() { return password; }

    /** @param password the portal password to set */
    public void setPassword(String password) { this.password = password; }
}
