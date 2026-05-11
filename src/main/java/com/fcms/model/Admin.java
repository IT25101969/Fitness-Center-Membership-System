package com.fcms.model;

/**
 * Represents an administrative user in the Fitness Center Membership System.
 * Extends {@link Person} with role and access level fields.
 *
 * <p>Inheritance: Extends the abstract {@link Person} class.</p>
 * <p>Polymorphism: Overrides {@link #getDetails()} with admin-specific format.</p>
 *
 */
public class Admin extends Person {

    /** The role of this admin (e.g., Manager, Staff). */
    private String role;

    /** The access level granted to this admin (e.g., Full, Limited). */
    private String accessLevel;

    /**
     * Default no-arg constructor.
     */
    public Admin() {}

    /**
     * Full constructor for an Admin.
     *
     * @param id          unique admin ID
     * @param name        full name
     * @param email       email address
     * @param phone       phone number
     * @param role        admin role
     * @param accessLevel access level
     */
    public Admin(String id, String name, String email, String phone,
                 String role, String accessLevel) {
        super(id, name, email, phone);
        this.role = role;
        this.accessLevel = accessLevel;
    }

    /**
     * Returns a formatted description of this admin.
     * Format: "Admin: [name] | Role: [Manager/Staff] | Access: [Full/Limited]"
     *
     * @return formatted details string
     */
    @Override
    public String getDetails() {
        return "Admin: " + getName() + " | Role: " + role + " | Access: " + accessLevel;
    }

    /**
     * Determines whether this admin has management capabilities.
     * Admins with "Full" access level or the "Manager" role are considered managers.
     *
     * @return true if this admin can manage the system
     */
    public boolean canManage() {
        return "Full".equalsIgnoreCase(accessLevel) || "Manager".equalsIgnoreCase(role);
    }

    // -----------------------------------------------------------------------
    // Getters and Setters
    // -----------------------------------------------------------------------

    /** @return the admin role */
    public String getRole() { return role; }

    /** @param role the role to set */
    public void setRole(String role) { this.role = role; }

    /** @return the access level */
    public String getAccessLevel() { return accessLevel; }

    /** @param accessLevel the access level to set */
    public void setAccessLevel(String accessLevel) { this.accessLevel = accessLevel; }
}
