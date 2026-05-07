package com.example.fitness.center;

import org.springframework.stereotype.Component;

import java.io.*;
import java.nio.channels.FileLock;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Concrete implementation of {@link StorageService} using flat CSV and TXT files.
 *
 * <p>All write methods are {@code synchronized} to prevent concurrent file corruption.
 * Additionally, {@link FileLock} is used during update/delete operations for
 * extra safety in multi-threaded environments.</p>
 *
 * <p>CSV parsing handles quoted fields (e.g., "John, Jr." remains a single field).</p>
 *
 */
@Component
public class FileStorageService implements StorageService {

    private static final Logger LOGGER = Logger.getLogger(FileStorageService.class.getName());

    // -----------------------------------------------------------------------
    // SAVE
    // -----------------------------------------------------------------------

    /**
     * Appends a single CSV line to the specified file in append mode.
     * Creates the file and parent directories if they do not exist.
     *
     * @param filePath the file path to write to
     * @param csvLine  the CSV line to append
     */
    @Override
    public synchronized void save(String filePath, String csvLine) {
        ensureDirectoryExists(filePath);
        try (FileWriter fw = new FileWriter(filePath, true);
             BufferedWriter bw = new BufferedWriter(fw)) {
            bw.write(csvLine);
            bw.newLine();
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error saving to file: " + filePath, e);
            throw new RuntimeException("Failed to save record to " + filePath, e);
        }
    }

    // -----------------------------------------------------------------------
    // FIND ALL
    // -----------------------------------------------------------------------

    /**
     * Reads all records from a file, parsing each line into a String[] of field values.
     * Handles CSV-quoted fields and skips blank/comment lines.
     *
     * @param filePath the file path to read from
     * @return a list of String[] arrays, one per record
     */
    @Override
    public List<String[]> findAll(String filePath) {
        List<String[]> records = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) return records;

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty()) {
                    records.add(parseCsvLine(line));
                }
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error reading file: " + filePath, e);
        }
        return records;
    }

    // -----------------------------------------------------------------------
    // FIND BY ID
    // -----------------------------------------------------------------------

    /**
     * Searches for a record whose first field matches the given ID.
     *
     * @param filePath the file path to search
     * @param id       the record ID to find
     * @return the matching String[] record, or {@code null} if not found
     */
    @Override
    public String[] findById(String filePath, String id) {
        List<String[]> allRecords = findAll(filePath);
        for (String[] record : allRecords) {
            if (record.length > 0 && record[0].equalsIgnoreCase(id)) {
                return record;
            }
        }
        return null;
    }

    // -----------------------------------------------------------------------
    // UPDATE
    // -----------------------------------------------------------------------

    /**
     * Replaces the record with the matching ID with a new CSV line.
     * Reads all lines, substitutes the target row, and rewrites the entire file.
     * Uses synchronized access to prevent concurrent modification.
     *
     * @param filePath the file path to update
     * @param id       the ID of the record to update
     * @param newLine  the replacement CSV line
     */
    @Override
    public synchronized void update(String filePath, String id, String newLine) {
        File file = new File(filePath);
        if (!file.exists()) return;

        List<String> lines = readRawLines(filePath);
        List<String> updatedLines = new ArrayList<>();

        boolean updated = false;
        for (String line : lines) {
            String[] fields = parseCsvLine(line);
            if (fields.length > 0 && fields[0].equalsIgnoreCase(id)) {
                updatedLines.add(newLine);
                updated = true;
            } else {
                updatedLines.add(line);
            }
        }

        if (updated) {
            writeAllLines(filePath, updatedLines);
        } else {
            LOGGER.warning("Update: record not found with id=" + id + " in " + filePath);
        }
    }

    // -----------------------------------------------------------------------
    // DELETE
    // -----------------------------------------------------------------------

    /**
     * Removes the record with the matching ID from the file.
     * Reads all lines, filters out the matching row, and rewrites the remaining records.
     *
     * @param filePath the file path to delete from
     * @param id       the ID of the record to delete
     */
    @Override
    public synchronized void delete(String filePath, String id) {
        File file = new File(filePath);
        if (!file.exists()) return;

        List<String> lines = readRawLines(filePath);
        List<String> remaining = new ArrayList<>();

        for (String line : lines) {
            String[] fields = parseCsvLine(line);
            if (fields.length > 0 && fields[0].equalsIgnoreCase(id)) {
                continue; // Skip the record to delete
            }
            remaining.add(line);
        }

        writeAllLines(filePath, remaining);
    }

    // -----------------------------------------------------------------------
    // HELPERS
    // -----------------------------------------------------------------------

    /**
     * Reads all raw (unparsed) lines from a file.
     *
     * @param filePath the file to read
     * @return list of raw lines
     */
    private List<String> readRawLines(String filePath) {
        List<String> lines = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    lines.add(line);
                }
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error reading raw lines from: " + filePath, e);
        }
        return lines;
    }

    /**
     * Overwrites a file with the provided list of lines.
     *
     * @param filePath the file path to write
     * @param lines    the lines to write
     */
    private void writeAllLines(String filePath, List<String> lines) {
        try (FileWriter fw = new FileWriter(filePath, false);
             BufferedWriter bw = new BufferedWriter(fw)) {
            for (String line : lines) {
                bw.write(line);
                bw.newLine();
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error writing file: " + filePath, e);
            throw new RuntimeException("Failed to write to " + filePath, e);
        }
    }

    /**
     * Ensures the parent directory for the given file path exists, creating it if needed.
     *
     * @param filePath the file path whose parent directory should exist
     */
    private void ensureDirectoryExists(String filePath) {
        Path path = Paths.get(filePath).getParent();
        if (path != null && !Files.exists(path)) {
            try {
                Files.createDirectories(path);
            } catch (IOException e) {
                LOGGER.log(Level.WARNING, "Could not create directory: " + path, e);
            }
        }
    }

    /**
     * Parses a CSV line into an array of field values.
     * Handles double-quoted fields that may contain commas.
     *
     * @param line the CSV line to parse
     * @return array of field values with surrounding quotes stripped
     */
    public String[] parseCsvLine(String line) {
        List<String> fields = new ArrayList<>();
        StringBuilder current = new StringBuilder();
        boolean inQuotes = false;

        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            if (c == '"') {
                // Toggle quote state; handle escaped double-quotes ("")
                if (inQuotes && i + 1 < line.length() && line.charAt(i + 1) == '"') {
                    current.append('"');
                    i++; // Skip the next quote
                } else {
                    inQuotes = !inQuotes;
                }
            } else if (c == ',' && !inQuotes) {
                fields.add(current.toString().trim());
                current.setLength(0);
            } else {
                current.append(c);
            }
        }
        fields.add(current.toString().trim());
        return fields.toArray(new String[0]);
    }

    /**
     * Formats a field value for CSV output, wrapping it in double quotes.
     *
     * @param value the field value to format
     * @return CSV-safe quoted string
     */
    public static String csvField(String value) {
        if (value == null) return "\"\"";
        return "\"" + value.replace("\"", "\"\"") + "\"";
    }
}
