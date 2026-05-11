package com.project.fcms.modules.shop.backend.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.logging.Logger;

/**
 * Handles supplement image deletion via POST (no @MultipartConfig needed).
 *
 * <p>POST /api/supplement-images-delete?id=S001 → Remove image</p>
 *
 * Separated from SupplementImageServlet because @MultipartConfig on that
 * servlet blocks non-multipart POST requests.
 *
 */
@WebServlet("/api/supplement-images-delete")
public class SupplementImageDeleteServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SupplementImageDeleteServlet.class.getName());
    private Path imageDir;

    @Override
    public void init() throws ServletException {
        imageDir = Paths.get(System.getProperty("user.dir"), "data", "supplement-images");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Admin session check
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            sendJson(resp, false, "Admin access required");
            return;
        }

        String id = req.getParameter("id");
        if (id == null || id.isBlank()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            sendJson(resp, false, "Missing 'id' parameter");
            return;
        }

        id = sanitizeId(id);

        // Delete all image variants for this supplement
        String[] exts = {".jpg", ".jpeg", ".png", ".webp", ".gif"};
        boolean found = false;
        for (String ext : exts) {
            Path p = imageDir.resolve(id + ext);
            if (Files.deleteIfExists(p)) {
                found = true;
                LOGGER.info("Deleted supplement image: " + p.getFileName());
            }
        }

        resp.setStatus(HttpServletResponse.SC_OK);
        sendJson(resp, true, found ? "Image removed for: " + id : "No image found for: " + id);
    }

    private String sanitizeId(String id) {
        return id.replaceAll("[^a-zA-Z0-9\\-]", "");
    }

    private void sendJson(HttpServletResponse resp, boolean success, String message) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write("{\"success\":" + success + ",\"message\":\"" + escapeJson(message) + "\"}");
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
