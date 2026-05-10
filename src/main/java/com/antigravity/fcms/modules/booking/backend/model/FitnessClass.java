package com.antigravity.fcms.modules.booking.backend.model;

import jakarta.persistence.*;

/**
 * Represents a fitness class offered by the fitness center.
 * Contains scheduling, capacity, and enrollment tracking information.
 *
 * <p>Encapsulation: All fields are private and exposed via getters/setters.</p>
 *
 */
@Entity
@Table(name = "fitness_classes")
public class FitnessClass {

    /** Unique class identifier (e.g., C001). */
    @Id
    @Column(name = "class_id", length = 10)
    private String classId;

    /** Human-readable class name (e.g., "Morning Yoga"). */
    @Column(name = "class_name", length = 100, nullable = false)
    private String className;

    /** ID of the trainer leading this class. */
    @Column(name = "trainer_id", length = 10)
    private String trainerId;

    /** Name of the trainer (resolved at runtime). */
    @Transient
    private String trainerName;

    /** Schedule string (e.g., "Mon 07:00"). */
    @Column(length = 50)
    private String schedule;

    /** Day of the week extracted from schedule (e.g., "Mon"). */
    @Transient
    private String scheduleDay;

    /** Time of day extracted from schedule (e.g., "07:00"). */
    @Transient
    private String scheduleTime;

    /** Maximum number of members that can enroll. */
    @Column
    private int capacity;

    /** Current number of enrolled members. */
    @Column
    private int enrolled;

    /** Class status: OPEN or FULL or CANCELLED. */
    @Column(length = 20)
    private String status;

    /**
     * Default no-arg constructor.
     */
    public FitnessClass() {}

    /**
     * Full constructor for a FitnessClass.
     *
     * @param classId   unique class ID
     * @param className class display name
     * @param trainerId assigned trainer ID
     * @param schedule  schedule string (e.g., "Mon 07:00")
     * @param capacity  max enrollment capacity
     * @param enrolled  current enrolled count
     * @param status    class status
     */
    public FitnessClass(String classId, String className, String trainerId,
                        String schedule, int capacity, int enrolled, String status) {
        this.classId = classId;
        this.className = className;
        this.trainerId = trainerId;
        this.schedule = schedule;
        this.capacity = capacity;
        this.enrolled = enrolled;
        this.status = status;
        parseSchedule(schedule);
    }

    /**
     * JPA lifecycle callback — parse schedule after load from DB.
     */
    @PostLoad
    private void onLoad() {
        parseSchedule(this.schedule);
    }

    /**
     * Parses the schedule string to extract day and time components.
     *
     * @param schedule schedule string in "Day HH:mm" format
     */
    private void parseSchedule(String schedule) {
        if (schedule != null && schedule.contains(" ")) {
            String[] parts = schedule.split(" ", 2);
            this.scheduleDay = parts[0];
            this.scheduleTime = parts[1];
        } else {
            this.scheduleDay = schedule;
            this.scheduleTime = "";
        }
    }

    /**
     * Returns the enrollment percentage for this class (0–100).
     *
     * @return percentage full as an integer
     */
    public int getCapacityPercent() {
        if (capacity <= 0) return 0;
        return (int) ((enrolled * 100.0) / capacity);
    }

    /**
     * Returns the Bootstrap color class based on the capacity percentage.
     *
     * @return "bg-success", "bg-warning", or "bg-danger"
     */
    public String getCapacityColorClass() {
        int pct = getCapacityPercent();
        if (pct < 70) return "bg-success";
        if (pct <= 90) return "bg-warning";
        return "bg-danger";
    }

    /**
     * Determines whether the class is full.
     *
     * @return true if enrolled >= capacity
     */
    public boolean isFull() {
        return enrolled >= capacity;
    }

    // -----------------------------------------------------------------------
    // Getters and Setters
    // -----------------------------------------------------------------------

    /** @return the class ID */
    public String getClassId() { return classId; }

    /** @param classId the class ID to set */
    public void setClassId(String classId) { this.classId = classId; }

    /** @return the class name */
    public String getClassName() { return className; }

    /** @param className the class name to set */
    public void setClassName(String className) { this.className = className; }

    /** @return the trainer ID */
    public String getTrainerId() { return trainerId; }

    /** @param trainerId the trainer ID to set */
    public void setTrainerId(String trainerId) { this.trainerId = trainerId; }

    /** @return the trainer name */
    public String getTrainerName() { return trainerName; }

    /** @param trainerName the trainer name to set */
    public void setTrainerName(String trainerName) { this.trainerName = trainerName; }

    /** @return the schedule string */
    public String getSchedule() { return schedule; }

    /** @param schedule the schedule to set */
    public void setSchedule(String schedule) {
        this.schedule = schedule;
        parseSchedule(schedule);
    }

    /** @return the schedule day */
    public String getScheduleDay() { return scheduleDay; }

    /** @return the schedule time */
    public String getScheduleTime() { return scheduleTime; }

    /** @return the capacity */
    public int getCapacity() { return capacity; }

    /** @param capacity the capacity to set */
    public void setCapacity(int capacity) { this.capacity = capacity; }

    /** @return the enrolled count */
    public int getEnrolled() { return enrolled; }

    /** @param enrolled the enrolled count to set */
    public void setEnrolled(int enrolled) { this.enrolled = enrolled; }

    /** @return the class status */
    public String getStatus() { return status; }

    /** @param status the status to set */
    public void setStatus(String status) { this.status = status; }
}
