package com.example.fitness.center;

import java.util.List;

/**
 * Storage service interface defining the contract for all flat-file CRUD operations.
 * Abstraction: Decouples the service layer from the concrete file storage implementation.
 *
 * <p>The generic type {@code T} represents the line data type (String[] for CSV records).</p>
 *
 */
public interface StorageService {

    /**
     * Appends a single CSV-formatted line to the specified file.
     *
     * @param filePath the absolute or relative path to the target file
     * @param csvLine  the formatted CSV line to append
     */
    void save(String filePath, String csvLine);

    /**
     * Reads all records from the specified file.
     * Each record is returned as a String array of field values.
     *
     * @param filePath the absolute or relative path to the target file
     * @return a list of String[] arrays representing each record
     */
    List<String[]> findAll(String filePath);

    /**
     * Finds a single record by its ID (first column).
     *
     * @param filePath the absolute or relative path to the target file
     * @param id       the record ID to search for
     * @return the matching String[] record, or null if not found
     */
    String[] findById(String filePath, String id);

    /**
     * Updates an existing record identified by its ID.
     * Replaces the matching row with the new CSV line and rewrites the entire file.
     *
     * @param filePath the absolute or relative path to the target file
     * @param id       the record ID to update
     * @param newLine  the new CSV line to replace the existing record
     */
    void update(String filePath, String id, String newLine);

    /**
     * Deletes an existing record identified by its ID.
     * Filters out the matching row and rewrites the remaining records.
     *
     * @param filePath the absolute or relative path to the target file
     * @param id       the record ID to delete
     */
    void delete(String filePath, String id);
}
