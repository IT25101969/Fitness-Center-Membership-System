package com.antigravity.fcms.modules.booking.backend.model;

import jakarta.persistence.*;

/**
 * Represents a member's daily attendance check-in record.
 *
 * <p>Encapsulation: All fields are private and exposed via getters/setters.</p>
 *
 */
@Entity
@Table(name = "attendance")
public class Attendance {

    /** Unique attendance record ID (e.g., A001). */
    @Id
    @Column(name = "attendance_id", length = 10)
    private String attendanceId;

    /** The member ID who checked in. */
    @Column(name = "member_id", length = 10)
    private String memberId;

    /** The member name (resolved at runtime). */
    @Transient
    private String memberName;

    /** The date of check-in (ISO format: yyyy-MM-dd). */
    @Column(length = 20)
    private String date;

    /** The time of check-in (HH:mm:ss format). */
    @Column(name = "check_in_time", length = 20)
    private String checkInTime;

    /**
     * Default no-arg constructor.
     */
    public Attendance() {}

    /**
     * Full constructor for an Attendance record.
     *
     * @param attendanceId unique attendance ID
     * @param memberId     member ID who checked in
     * @param date         date of check-in
     * @param checkInTime  time of check-in
     */
    public Attendance(String attendanceId, String memberId, String date, String checkInTime) {
        this.attendanceId = attendanceId;
        this.memberId = memberId;
        this.date = date;
        this.checkInTime = checkInTime;
    }

    // -----------------------------------------------------------------------
    // Getters and Setters
    // -----------------------------------------------------------------------

    /** @return the attendance ID */
    public String getAttendanceId() { return attendanceId; }

    /** @param attendanceId the attendance ID to set */
    public void setAttendanceId(String attendanceId) { this.attendanceId = attendanceId; }

    /** @return the member ID */
    public String getMemberId() { return memberId; }

    /** @param memberId the member ID to set */
    public void setMemberId(String memberId) { this.memberId = memberId; }

    /** @return the member name */
    public String getMemberName() { return memberName; }

    /** @param memberName the member name to set */
    public void setMemberName(String memberName) { this.memberName = memberName; }

    /** @return the check-in date */
    public String getDate() { return date; }

    /** @param date the date to set */
    public void setDate(String date) { this.date = date; }

    /** @return the check-in time */
    public String getCheckInTime() { return checkInTime; }

    /** @param checkInTime the check-in time to set */
    public void setCheckInTime(String checkInTime) { this.checkInTime = checkInTime; }
}
