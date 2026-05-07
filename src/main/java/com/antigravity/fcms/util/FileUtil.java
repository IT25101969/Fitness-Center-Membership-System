package com.antigravity.fcms.util;

import com.example.fitness.center.FileStorageService;

/**
 * Utility class providing common file-related helper methods.
 * Specifically provides consistent CSV line building for all entities.
 *
 */
public class FileUtil {

    /**
     * Private constructor — utility class, no instantiation needed.
     */
    private FileUtil() {}

    /**
     * Builds a CSV line from an array of field values.
     * All fields are wrapped in double quotes for safety.
     *
     * @param fields the field values to join as CSV
     * @return comma-separated CSV line with all fields quoted
     */
    public static String buildCsvLine(String... fields) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < fields.length; i++) {
            sb.append(FileStorageService.csvField(fields[i]));
            if (i < fields.length - 1) sb.append(",");
        }
        return sb.toString();
    }

    /**
     * Builds a plain (unquoted) CSV line from an array of field values.
     * Used for attendance.txt which uses plain comma-delimited format.
     *
     * @param fields the field values to join as CSV
     * @return comma-separated CSV line without quotes
     */
    public static String buildPlainCsvLine(String... fields) {
        return String.join(",", fields);
    }

    /**
     * Safely retrieves an element from a String array, returning an empty string
     * if the index is out of bounds or the element is null.
     *
     * @param arr   the String array
     * @param index the index to retrieve
     * @return the element value, or empty string
     */
    public static String safeGet(String[] arr, int index) {
        if (arr == null || index >= arr.length || arr[index] == null) return "";
        return arr[index].trim();
    }
}
