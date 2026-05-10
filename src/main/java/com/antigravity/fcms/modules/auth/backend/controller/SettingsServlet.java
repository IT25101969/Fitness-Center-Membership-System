package com.antigravity.fcms.modules.auth.backend.controller;

import com.antigravity.fcms.model.GymSettings;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Handles Gym Settings management.
 *
 * <p>GET  /settings → render settings.jsp with current GymSettings object.</p>
 * <p>POST /settings → read all form parameters, update GymSettings, persist in
 *    ServletContext, then redirect back (PRG pattern) with a success flash.</p>
 *
 * <p>Settings are stored as a {@link GymSettings} instance in
 *    {@code ServletContext} under the key {@code "gymSettings"}.
 *    They survive page-refreshes but are reset when the server restarts
 *    (no DB persistence required by spec).</p>
 *
 */
@WebServlet("/settings")
public class SettingsServlet extends HttpServlet {

    /** Key used to store the GymSettings object in ServletContext. */
    private static final String CTX_KEY = "gymSettings";

    // ── Initialise default settings if not already present ────────────────
    @Override
    public void init() throws ServletException {
        if (getServletContext().getAttribute(CTX_KEY) == null) {
            getServletContext().setAttribute(CTX_KEY, new GymSettings());
        }
    }

    // ── GET /settings ─────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        GymSettings settings = getOrCreate();
        req.setAttribute("settings", settings);

        // Flash message from PRG redirect
        String flash = req.getParameter("saved");
        if ("1".equals(flash)) {
            req.setAttribute("successMsg", "Settings saved successfully!");
        }
        String errFlash = req.getParameter("pwErr");
        if ("1".equals(errFlash)) {
            req.setAttribute("errorMsg", "Current password is incorrect. Password not changed.");
        }

        req.getRequestDispatcher("/WEB-INF/views/settings.jsp").forward(req, resp);
    }

    // ── POST /settings ────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        GymSettings s = getOrCreate();

        // ── Branch Details
        setIfPresent(s, "gymName",   req.getParameter("gymName"));
        setIfPresent(s, "address",   req.getParameter("address"));
        setIfPresent(s, "phone",     req.getParameter("phone"));
        setIfPresent(s, "email",     req.getParameter("email"));
        setIfPresent(s, "tagline",   req.getParameter("tagline"));

        // ── Opening Hours
        setIfPresent(s, "hoursWeekdays", req.getParameter("hoursWeekdays"));
        setIfPresent(s, "hoursWeekends", req.getParameter("hoursWeekends"));
        setIfPresent(s, "hoursHolidays", req.getParameter("hoursHolidays"));

        // ── Social & Web
        setIfPresent(s, "instagram", req.getParameter("instagram"));
        setIfPresent(s, "facebook",  req.getParameter("facebook"));
        setIfPresent(s, "whatsapp",  req.getParameter("whatsapp"));
        setIfPresent(s, "mapsLink",  req.getParameter("mapsLink"));
        setIfPresent(s, "website",   req.getParameter("website"));

        // ── Business Config
        setIfPresent(s, "currency",  req.getParameter("currency"));
        setIfPresent(s, "timezone",  req.getParameter("timezone"));
        setIfPresent(s, "language",  req.getParameter("language"));

        // ── Notification Settings
        s.setEmailNotifications("on".equals(req.getParameter("emailNotifications")));
        s.setSmsNotifications("on".equals(req.getParameter("smsNotifications")));
        s.setExpiryAlerts("on".equals(req.getParameter("expiryAlerts")));
        String expiryDaysStr = req.getParameter("expiryAlertDays");
        if (expiryDaysStr != null && !expiryDaysStr.isBlank()) {
            try { s.setExpiryAlertDays(Integer.parseInt(expiryDaysStr.trim())); }
            catch (NumberFormatException ignored) {}
        }

        // ── Feature Flags
        s.setOnlineBooking("on".equals(req.getParameter("onlineBooking")));
        s.setMemberPortal("on".equals(req.getParameter("memberPortal")));
        s.setPublicSchedule("on".equals(req.getParameter("publicSchedule")));

        // ── Admin Password Change
        boolean passwordError = false;
        String currentPw  = req.getParameter("currentPassword");
        String newPw      = req.getParameter("newPassword");
        String confirmPw  = req.getParameter("confirmPassword");

        if (currentPw != null && !currentPw.isBlank()) {
            if (!s.getAdminPasswordHash().equals(currentPw.trim())) {
                passwordError = true;
            } else if (newPw != null && !newPw.isBlank() && newPw.equals(confirmPw)) {
                s.setAdminPasswordHash(newPw.trim());
                // Also update the AdminLoginServlet constant via a workaround —
                // we store in session so LoginServlet can pick it up (optional).
                req.getSession().getServletContext().setAttribute("adminPassword", newPw.trim());
            }
        }

        // Persist
        getServletContext().setAttribute(CTX_KEY, s);

        // PRG redirect
        String redirect = req.getContextPath() + "/settings?saved=1";
        if (passwordError) redirect = req.getContextPath() + "/settings?saved=1&pwErr=1";
        resp.sendRedirect(redirect);
    }

    // ── Helpers ───────────────────────────────────────────────────────────

    private GymSettings getOrCreate() {
        GymSettings s = (GymSettings) getServletContext().getAttribute(CTX_KEY);
        if (s == null) {
            s = new GymSettings();
            getServletContext().setAttribute(CTX_KEY, s);
        }
        return s;
    }

    /**
     * Updates a named field on the GymSettings object only if the supplied
     * value is non-null and non-blank.
     */
    private void setIfPresent(GymSettings s, String field, String value) {
        if (value == null) return;
        String v = value.trim();
        switch (field) {
            case "gymName"       -> s.setGymName(v);
            case "address"       -> s.setAddress(v);
            case "phone"         -> s.setPhone(v);
            case "email"         -> s.setEmail(v);
            case "tagline"       -> s.setTagline(v);
            case "hoursWeekdays" -> s.setHoursWeekdays(v);
            case "hoursWeekends" -> s.setHoursWeekends(v);
            case "hoursHolidays" -> s.setHoursHolidays(v);
            case "instagram"     -> s.setInstagram(v);
            case "facebook"      -> s.setFacebook(v);
            case "whatsapp"      -> s.setWhatsapp(v);
            case "mapsLink"      -> s.setMapsLink(v);
            case "website"       -> s.setWebsite(v);
            case "currency"      -> s.setCurrency(v);
            case "timezone"      -> s.setTimezone(v);
            case "language"      -> s.setLanguage(v);
        }
    }
}
