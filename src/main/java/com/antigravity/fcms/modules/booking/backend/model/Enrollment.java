package com.antigravity.fcms.modules.booking.backend.model;

import jakarta.persistence.*;

/**
 * Represents an enrollment of a member in a fitness class.
 *
 * <p>Encapsulation: All fields are private and exposed via getters/setters.</p>
 *
 */
@Entity
@Table(name = "enrollments")
public class Enrollment {

    /** Unique enrollment record ID (e.g., E001). */
    @Id
    @Column(name = "enrollment_id", length = 10)
    private String enrollmentId;

    /** The member ID being enrolled. */
    @Column(name = "member_id", length = 10)
    private String memberId;

    /** The member name (resolved at runtime). */
    @Transient
    private String memberName;

    /** The class ID the member is enrolling in. */
    @Column(name = "class_id", length = 10)
    private String classId;

    /** The class name (resolved at runtime). */
    @Transient
    private String className;

    /** The date of enrollment (ISO format: yyyy-MM-dd). */
    @Column(name = "enroll_date", length = 20)
    private String enrollDate;

    /**
     * Default no-arg constructor.
     */
    public Enrollment() {}

    /**
     * Full constructor for an Enrollment.
     *
     * @param enrollmentId unique enrollment ID
     * @param memberId     member ID
     * @param classId      class ID
     * @param enrollDate   enrollment date
     */
    public Enrollment(String enrollmentId, String memberId, String classId, String enrollDate) {
        this.enrollmentId = enrollmentId;
        this.memberId = memberId;
        this.classId = classId;
        this.enrollDate = enrollDate;
    }

    // -----------------------------------------------------------------------
    // Getters and Setters
    // -----------------------------------------------------------------------

    /** @return the enrollment ID */
    public String getEnrollmentId() { return enrollmentId; }

    /** @param enrollmentId the enrollment ID to set */
    public void setEnrollmentId(String enrollmentId) { this.enrollmentId = enrollmentId; }

    /** @return the member ID */
    public String getMemberId() { return memberId; }

    /** @param memberId the member ID to set */
    public void setMemberId(String memberId) { this.memberId = memberId; }

    /** @return the member name */
    public String getMemberName() { return memberName; }

    /** @param memberName the member name to set */
    public void setMemberName(String memberName) { this.memberName = memberName; }

    /** @return the class ID */
    public String getClassId() { return classId; }

    /** @param classId the class ID to set */
    public void setClassId(String classId) { this.classId = classId; }

    /** @return the class name */
    public String getClassName() { return className; }

    /** @param className the class name to set */
    public void setClassName(String className) { this.className = className; }

    /** @return the enrollment date */
    public String getEnrollDate() { return enrollDate; }

    /** @param enrollDate the enrollment date to set */
    public void setEnrollDate(String enrollDate) { this.enrollDate = enrollDate; }
}
