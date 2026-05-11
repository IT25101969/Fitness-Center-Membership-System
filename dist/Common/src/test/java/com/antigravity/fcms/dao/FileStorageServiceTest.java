package com.antigravity.fcms.dao;

import org.junit.jupiter.api.*;
import org.junit.jupiter.api.io.TempDir;

import java.io.*;
import java.nio.file.*;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for {@link FileStorageService}.
 * Covers TC-05 (save), TC-06 (update), and TC-07 (delete) from the test plan.
 *
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class FileStorageServiceTest {

    @TempDir
    Path tempDir;

    private FileStorageService service;
    private String testFile;

    @BeforeEach
    void setUp() {
        service = new FileStorageService();
        testFile = tempDir.resolve("test.csv").toString();
    }

    // -----------------------------------------------------------------------
    // TC-05: FileStorageService.save()
    // -----------------------------------------------------------------------

    /**
     * TC-05: Verifies that save() appends the CSV line to the file and it can be read back.
     */
    @Test
    @Order(1)
    @DisplayName("TC-05: save() appends line to file")
    void testSave() throws Exception {
        String line = "\"R001\",\"Test Record\",\"test@mail.com\"";
        service.save(testFile, line);

        List<String> lines = Files.readAllLines(Path.of(testFile));
        assertEquals(1, lines.size(), "File should contain exactly 1 line");
        assertTrue(lines.get(0).contains("R001"), "Line should contain the ID");
    }

    /**
     * Verifies that multiple save() calls all append correctly.
     */
    @Test
    @Order(2)
    @DisplayName("TC-05b: Multiple save() calls append correctly")
    void testSaveMultiple() throws Exception {
        service.save(testFile, "\"R001\",\"Alice\",\"alice@mail.com\"");
        service.save(testFile, "\"R002\",\"Bob\",\"bob@mail.com\"");
        service.save(testFile, "\"R003\",\"Charlie\",\"charlie@mail.com\"");

        List<String[]> records = service.findAll(testFile);
        assertEquals(3, records.size(), "Should find 3 records");
    }

    // -----------------------------------------------------------------------
    // TC-06: FileStorageService.update()
    // -----------------------------------------------------------------------

    /**
     * TC-06: Writes 3 rows, updates row 2, asserts rows 1 & 3 unchanged.
     */
    @Test
    @Order(3)
    @DisplayName("TC-06: update() replaces only the target row")
    void testUpdate() throws Exception {
        service.save(testFile, "\"R001\",\"Alice\",\"alice@mail.com\"");
        service.save(testFile, "\"R002\",\"Bob\",\"bob@mail.com\"");
        service.save(testFile, "\"R003\",\"Charlie\",\"charlie@mail.com\"");

        service.update(testFile, "R002", "\"R002\",\"Bobby Updated\",\"bobby@mail.com\"");

        List<String[]> records = service.findAll(testFile);
        assertEquals(3, records.size(), "Should still have 3 records");

        assertEquals("R001", records.get(0)[0], "Row 1 ID unchanged");
        assertEquals("Alice", records.get(0)[1], "Row 1 Name unchanged");

        assertEquals("R002", records.get(1)[0], "Row 2 ID correct");
        assertEquals("Bobby Updated", records.get(1)[1], "Row 2 Name updated");

        assertEquals("R003", records.get(2)[0], "Row 3 ID unchanged");
        assertEquals("Charlie", records.get(2)[1], "Row 3 Name unchanged");
    }

    // -----------------------------------------------------------------------
    // TC-07: FileStorageService.delete()
    // -----------------------------------------------------------------------

    /**
     * TC-07: Writes 3 rows, deletes row 1, asserts only 2 rows remain.
     */
    @Test
    @Order(4)
    @DisplayName("TC-07: delete() removes only the target row")
    void testDelete() throws Exception {
        service.save(testFile, "\"R001\",\"Alice\",\"alice@mail.com\"");
        service.save(testFile, "\"R002\",\"Bob\",\"bob@mail.com\"");
        service.save(testFile, "\"R003\",\"Charlie\",\"charlie@mail.com\"");

        service.delete(testFile, "R001");

        List<String[]> records = service.findAll(testFile);
        assertEquals(2, records.size(), "Should have 2 records after delete");
        assertEquals("R002", records.get(0)[0], "First remaining should be R002");
        assertEquals("R003", records.get(1)[0], "Second remaining should be R003");

        // Verify R001 is gone
        assertNull(service.findById(testFile, "R001"), "Deleted record should not be found");
    }

    // -----------------------------------------------------------------------
    // CSV Parsing
    // -----------------------------------------------------------------------

    /**
     * Verifies that parseCsvLine handles quoted fields containing commas.
     */
    @Test
    @Order(5)
    @DisplayName("CSV parser handles quoted fields with commas")
    void testCsvParserWithCommaInField() {
        String line = "\"R001\",\"Smith, Jr.\",\"smith@mail.com\"";
        String[] fields = service.parseCsvLine(line);
        assertEquals(3, fields.length);
        assertEquals("R001", fields[0]);
        assertEquals("Smith, Jr.", fields[1]);
        assertEquals("smith@mail.com", fields[2]);
    }

    /**
     * Verifies findById returns null for non-existent ID.
     */
    @Test
    @Order(6)
    @DisplayName("findById returns null for missing record")
    void testFindByIdNotFound() {
        String[] result = service.findById(testFile, "NOTEXIST");
        assertNull(result, "Should return null for non-existent ID");
    }
}
