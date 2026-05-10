package com.antigravity.fcms.modules.booking.backend.model;

import jakarta.persistence.*;

/**
 * Represents an exercise in the Fitness Center's exercise library.
 *
 * <p>Exercises can be managed through the admin dashboard
 * and displayed on the public exercise library page.</p>
 *
 */
@Entity
@Table(name = "exercises")
public class Exercise {

    @Id
    @Column(length = 10)
    private String id;

    @Column(length = 200, nullable = false)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "muscle_group", length = 50)
    private String muscleGroup;   // abs, arms, back, chest, glutes, legs, shoulders

    @Column(length = 100)
    private String equipment;     // barbell, dumbbell, bodyweight, cable, machine, band, kettlebell, stability

    @Column(length = 50)
    private String category;      // build, focus, goals

    @Column(columnDefinition = "TEXT")
    private String styles;        // pipe-separated: Strength|Bodybuilding|HIIT

    /** Default no-arg constructor. */
    public Exercise() {}

    /**
     * Full constructor.
     *
     * @param id          unique exercise ID (E001, E002, etc.)
     * @param name        exercise name
     * @param description exercise description
     * @param muscleGroup target muscle group
     * @param equipment   required equipment
     * @param category    training category
     * @param styles      pipe-separated training styles
     */
    public Exercise(String id, String name, String description, String muscleGroup,
                    String equipment, String category, String styles) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.muscleGroup = muscleGroup;
        this.equipment = equipment;
        this.category = category;
        this.styles = styles;
    }

    // -----------------------------------------------------------------------
    // Getters and Setters
    // -----------------------------------------------------------------------

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getMuscleGroup() { return muscleGroup; }
    public void setMuscleGroup(String muscleGroup) { this.muscleGroup = muscleGroup; }

    public String getEquipment() { return equipment; }
    public void setEquipment(String equipment) { this.equipment = equipment; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getStyles() { return styles; }
    public void setStyles(String styles) { this.styles = styles; }

    /**
     * Returns styles as an array, splitting by pipe character.
     * @return array of training styles
     */
    public String[] getStylesArray() {
        if (styles == null || styles.isEmpty()) return new String[0];
        return styles.split("\\|");
    }

    /**
     * Returns a slug-format ID for image lookup (lowercase, hyphenated).
     * @return slug ID
     */
    public String getSlugId() {
        if (name == null) return id;
        // Keep hyphens from original name (e.g. "Pull-Up" → "pull-up"), then convert spaces to hyphens
        return name.toLowerCase()
                .replaceAll("[^a-z0-9\\s\\-]", "")  // keep letters, digits, spaces, hyphens
                .replaceAll("\\s+", "-")              // spaces become hyphens
                .replaceAll("-+", "-");               // collapse multiple hyphens
    }
}
