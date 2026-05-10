package com.fcms.util;

import com.example.fitness.center.FileStorageService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Utility class for generating unique, sequential IDs for all FCMS entities.
 * Uses a prefix-based format (e.g., M001, P001, C001).
 *
 * <p>Uses {@link AtomicInteger} to safely generate IDs in concurrent environments.</p>
 *
 */
@Component
public class IdGenerator {

    @Value("${app.data.path}")
    private String dataPath;

    private final FileStorageService storageService;

    /**
     * Constructs IdGenerator with a FileStorageService dependency.
     *
     * @param storageService the storage service for reading existing records
     */
    public IdGenerator(FileStorageService storageService) {
        this.storageService = storageService;
    }

    /**
     * Generates the next sequential ID for a given entity type.
     * Reads all existing records to find the highest current number.
     *
     * @param prefix   the ID prefix (e.g., "M" for members, "P" for plans)
     * @param filePath the CSV file to scan for existing IDs
     * @return the next unique ID string (e.g., "M006")
     */
    public synchronized String nextId(String prefix, String filePath) {
        List<String[]> records = storageService.findAll(filePath);
        int maxNum = 0;
        for (String[] record : records) {
            if (record.length > 0 && record[0].startsWith(prefix)) {
                try {
                    int num = Integer.parseInt(record[0].substring(prefix.length()));
                    if (num > maxNum) maxNum = num;
                } catch (NumberFormatException ignored) {}
            }
        }
        return prefix + String.format("%03d", maxNum + 1);
    }

    /**
     * Generates the next member ID (M###).
     *
     * @return next member ID
     */
    public String nextMemberId() {
        return nextId("M", dataPath + "members.csv");
    }

    /**
     * Generates the next plan ID (P###).
     *
     * @return next plan ID
     */
    public String nextPlanId() {
        return nextId("P", dataPath + "plans.csv");
    }

    /**
     * Generates the next class ID (C###).
     *
     * @return next class ID
     */
    public String nextClassId() {
        return nextId("C", dataPath + "classes.csv");
    }

    /**
     * Generates the next attendance ID (A###).
     *
     * @return next attendance ID
     */
    public String nextAttendanceId() {
        return nextId("A", dataPath + "attendance.txt");
    }

    /**
     * Generates the next enrollment ID (E###).
     *
     * @return next enrollment ID
     */
    public String nextEnrollmentId() {
        return nextId("E", dataPath + "enrollments.csv");
    }
}
