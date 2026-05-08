package com.antigravity.fcms.modules.auth.backend.controller;

import com.antigravity.fcms.model.GymSettings;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * Public JSON API that exposes gym settings for the landing page
 * and any other front-end page that needs real-time settings data.
 *
 * <p>GET /api/settings → returns GymSettings as JSON (no auth required).</p>
 *
 * <p>This allows the static landing.html to fetch current settings
 * and update the DOM dynamically whenever the admin changes settings.</p>
 *
 */
@WebServlet("/api/settings")
public class SettingsApiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        // Allow CORS for same-origin fetches from static HTML
        resp.setHeader("Access-Control-Allow-Origin", "*");
        // Prevent caching so landing page always gets fresh settings
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

        GymSettings s = (GymSettings) getServletContext().getAttribute("gymSettings");
        if (s == null) {
            s = new GymSettings();
        }

        PrintWriter out = resp.getWriter();
        out.print(toJson(s));
        out.flush();
    }

    /**
     * Manually serializes GymSettings to JSON.
     * We avoid external library dependencies (no Jackson/Gson needed).
     */
    private String toJson(GymSettings s) {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        appendStr(sb, "gymName", s.getGymName()); sb.append(",");
        appendStr(sb, "tagline", s.getTagline()); sb.append(",");
        appendStr(sb, "address", s.getAddress()); sb.append(",");
        appendStr(sb, "phone", s.getPhone()); sb.append(",");
        appendStr(sb, "email", s.getEmail()); sb.append(",");
        appendStr(sb, "hoursWeekdays", s.getHoursWeekdays()); sb.append(",");
        appendStr(sb, "hoursWeekends", s.getHoursWeekends()); sb.append(",");
        appendStr(sb, "hoursHolidays", s.getHoursHolidays()); sb.append(",");
        appendStr(sb, "instagram", s.getInstagram()); sb.append(",");
        appendStr(sb, "facebook", s.getFacebook()); sb.append(",");
        appendStr(sb, "whatsapp", s.getWhatsapp()); sb.append(",");
        appendStr(sb, "mapsLink", s.getMapsLink()); sb.append(",");
        appendStr(sb, "website", s.getWebsite()); sb.append(",");
        appendStr(sb, "currency", s.getCurrency()); sb.append(",");
        appendStr(sb, "timezone", s.getTimezone()); sb.append(",");
        appendStr(sb, "language", s.getLanguage()); sb.append(",");
        sb.append("\"onlineBooking\":").append(s.isOnlineBooking()).append(",");
        sb.append("\"memberPortal\":").append(s.isMemberPortal()).append(",");
        sb.append("\"publicSchedule\":").append(s.isPublicSchedule());
        sb.append("}");
        return sb.toString();
    }

    /** Appends a JSON key-value pair with proper escaping. */
    private void appendStr(StringBuilder sb, String key, String value) {
        sb.append("\"").append(key).append("\":\"").append(escapeJson(value)).append("\"");
    }

    /** Escapes special characters for JSON string values. */
    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
