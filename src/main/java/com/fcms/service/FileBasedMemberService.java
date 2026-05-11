package com.fcms.service;

import com.antigravity.fcms.dao.FileStorageService;
import com.antigravity.fcms.modules.auth.backend.model.Member;
import com.antigravity.fcms.modules.plan.backend.service.PlanService;
import com.antigravity.fcms.modules.plan.backend.model.MembershipPlan;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.stream.Collectors;

/**
 * File-based implementation of member management using flat CSV file I/O.
 *
 * <p>This service demonstrates the File Handling requirement by performing
 * all CRUD operations directly on {@code members.csv} via {@link FileStorageService}.</p>
 *
 * <p>OOP Concepts demonstrated:</p>
 * <ul>
 *   <li>Encapsulation: All CSV parsing and formatting is private.</li>
 *   <li>Abstraction: Callers interact via high-level create/read/update/delete methods.</li>
 *   <li>Polymorphism: Internally creates {@link Member} objects whose
 *       {@link Member#getDetails()} is polymorphically resolved at runtime.</li>
 * </ul>
 *
 * <p>CSV Column Layout (members.csv):</p>
 * <pre>
 * [0] id | [1] name | [2] email | [3] phone |
 * [4] planId | [5] joinDate | [6] status | [7] type | [8] password (optional)
 * </pre>
 *
 */
@Service
public class FileBasedMemberService {

    private static final Logger LOGGER = Logger.getLogger(FileBasedMemberService.class.getName());

    /** Resolved from application.properties → app.data.path */
    @Value("${app.data.path}")
    private String dataPath;

    private final FileStorageService storage;
    private final PlanService planService;

    public FileBasedMemberService(FileStorageService storage, PlanService planService) {
        this.storage = storage;
        this.planService = planService;
    }

    // -----------------------------------------------------------------------
    // CREATE — Write a new member row to members.csv
    // -----------------------------------------------------------------------

    /**
     * Creates a new member record and appends it to {@code members.csv}.
     *
     * @param name     full name
     * @param email    email address
     * @param phone    10-digit phone number
     * @param planId   membership plan ID
     * @param joinDate date of joining (null defaults to today)
     * @param status   membership status (ACTIVE / INACTIVE / EXPIRED)
     * @param type     member type (STANDARD / PREMIUM / TRIAL)
     * @param password portal login password (optional)
     * @return the created {@link Member} object
     */
    public Member create(String name, String email, String phone,
                         String planId, String joinDate, String status,
                         String type, String password) {

        String id = nextMemberId();
        String date = (joinDate == null || joinDate.isEmpty())
                ? LocalDate.now().toString() : joinDate;
        String pass = (password != null) ? password : "";

        // Build CSV row and write to file
        String csvLine = buildCsvRow(id, name, email, phone, planId, date,
                                     status, type, pass);
        storage.save(filePath(), csvLine);
        LOGGER.info("[FileBasedMemberService] Created member: " + id);

        Member m = new Member(id, name, email, phone, planId, date, status, type);
        m.setPassword(pass);
        resolvePlanName(m);
        return m;
    }

    // -----------------------------------------------------------------------
    // READ ALL — Load every row from members.csv
    // -----------------------------------------------------------------------

    /**
     * Reads all member records from {@code members.csv}.
     *
     * @return list of all {@link Member} objects
     */
    public List<Member> findAll() {
        List<String[]> rows = storage.findAll(filePath());
        List<Member> members = new ArrayList<>();
        for (String[] r : rows) {
            Member m = rowToMember(r);
            if (m != null) {
                resolvePlanName(m);
                members.add(m);
            }
        }
        return members;
    }

    // -----------------------------------------------------------------------
    // READ BY ID — Search the CSV for a specific member ID
    // -----------------------------------------------------------------------

    /**
     * Finds a single member by their ID by scanning {@code members.csv}.
     *
     * @param memberId the member ID to find (e.g. "M001")
     * @return the matching {@link Member}, or {@code null} if not found
     */
    public Member findById(String memberId) {
        String[] row = storage.findById(filePath(), memberId);
        if (row == null) return null;
        Member m = rowToMember(row);
        if (m != null) resolvePlanName(m);
        return m;
    }

    // -----------------------------------------------------------------------
    // SEARCH — Filter members by name, email, or ID keyword
    // -----------------------------------------------------------------------

    /**
     * Searches for members whose name, email, or ID contains the given keyword.
     * Search is case-insensitive. Reads all records from {@code members.csv}.
     *
     * @param keyword the search term (partial match is supported)
     * @return list of matching {@link Member} objects, empty list if none found
     */
    public List<Member> search(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) return findAll();
        String q = keyword.trim().toLowerCase();
        return findAll().stream()
                .filter(m -> (m.getId()    != null && m.getId().toLowerCase().contains(q))
                          || (m.getName()  != null && m.getName().toLowerCase().contains(q))
                          || (m.getEmail() != null && m.getEmail().toLowerCase().contains(q))
                          || (m.getPhone() != null && m.getPhone().contains(q)))
                .collect(Collectors.toList());
    }

    // -----------------------------------------------------------------------
    // UPDATE — Replace an existing row in members.csv
    // -----------------------------------------------------------------------

    /**
     * Updates an existing member record in {@code members.csv}.
     * Reads all rows, replaces the matching ID row, and rewrites the entire file.
     *
     * @param id       the member ID to update
     * @param name     updated full name
     * @param email    updated email address
     * @param phone    updated phone number
     * @param planId   updated membership plan ID
     * @param joinDate updated join date
     * @param status   updated status
     * @param type     updated member type
     */
    public void update(String id, String name, String email, String phone,
                       String planId, String joinDate, String status, String type) {

        Member existing = findById(id);
        String pass = (existing != null && existing.getPassword() != null)
                ? existing.getPassword() : "";

        String csvLine = buildCsvRow(id, name, email, phone, planId, joinDate,
                                     status, type, pass);
        storage.update(filePath(), id, csvLine);
        LOGGER.info("[FileBasedMemberService] Updated member: " + id);
    }

    // -----------------------------------------------------------------------
    // DELETE — Remove a row from members.csv
    // -----------------------------------------------------------------------

    /**
     * Deletes a member record from {@code members.csv} by ID.
     * Reads all rows, filters out the matching ID row, and rewrites the file.
     *
     * @param memberId the member ID to delete
     */
    public void delete(String memberId) {
        storage.delete(filePath(), memberId);
        LOGGER.info("[FileBasedMemberService] Deleted member: " + memberId);
    }

    // -----------------------------------------------------------------------
    // HELPERS
    // -----------------------------------------------------------------------

    /**
     * Returns the absolute path to the members CSV file.
     */
    private String filePath() {
        return dataPath + "members.csv";
    }

    /**
     * Converts a raw CSV String[] row into a {@link Member} object.
     * Column layout: id, name, email, phone, planId, joinDate, status, type, [password]
     *
     * @param r the parsed CSV fields
     * @return a {@link Member} object, or {@code null} if the row is malformed
     */
    private Member rowToMember(String[] r) {
        if (r == null || r.length < 8) return null;
        Member m = new Member(
                safe(r, 0), safe(r, 1), safe(r, 2), safe(r, 3),
                safe(r, 4), safe(r, 5), safe(r, 6), safe(r, 7)
        );
        if (r.length > 8) m.setPassword(safe(r, 8));
        return m;
    }

    /**
     * Builds a CSV-formatted line for writing to members.csv.
     * All fields are wrapped in double-quotes to handle commas safely.
     */
    private String buildCsvRow(String id, String name, String email, String phone,
                                String planId, String joinDate, String status,
                                String type, String password) {
        StringBuilder sb = new StringBuilder();
        sb.append(FileStorageService.csvField(id)).append(",")
          .append(FileStorageService.csvField(name)).append(",")
          .append(FileStorageService.csvField(email)).append(",")
          .append(FileStorageService.csvField(phone)).append(",")
          .append(FileStorageService.csvField(planId)).append(",")
          .append(FileStorageService.csvField(joinDate)).append(",")
          .append(FileStorageService.csvField(status)).append(",")
          .append(FileStorageService.csvField(type));
        if (password != null && !password.isEmpty()) {
            sb.append(",").append(FileStorageService.csvField(password));
        }
        return sb.toString();
    }

    /**
     * Generates the next sequential member ID by scanning all existing IDs.
     * Format: M001, M002, ... M999
     *
     * @return next available member ID string
     */
    private String nextMemberId() {
        List<String[]> rows = storage.findAll(filePath());
        int maxNum = 0;
        for (String[] r : rows) {
            if (r.length > 0 && r[0] != null && r[0].startsWith("M")) {
                try {
                    int num = Integer.parseInt(r[0].substring(1));
                    if (num > maxNum) maxNum = num;
                } catch (NumberFormatException ignored) {}
            }
        }
        return "M" + String.format("%03d", maxNum + 1);
    }

    /** Resolves and injects the human-readable plan name into a member object. */
    private void resolvePlanName(Member member) {
        if ("FREE_TRIAL".equals(member.getMembershipPlanId())) {
            member.setPlanName("7-Day Free Trial");
            return;
        }
        MembershipPlan plan = planService.findById(member.getMembershipPlanId());
        if (plan != null) member.setPlanName(plan.getPlanName());
    }

    /** Safely retrieves a field from a CSV row by index. */
    private String safe(String[] row, int index) {
        return (index < row.length && row[index] != null) ? row[index].trim() : "";
    }
}
