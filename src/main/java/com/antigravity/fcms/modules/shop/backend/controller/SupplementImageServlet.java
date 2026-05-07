package com.antigravity.fcms.modules.shop.backend.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Handles supplement image uploads and serving.
 *
 * <ul>
 *   <li>POST /api/supplement-images?id=S001 → Upload an image for the given supplement</li>
 *   <li>GET  /api/supplement-images?id=S001 → Serve the image for the given supplement</li>
 *   <li>GET  /api/supplement-images/list → Return JSON list of supplement IDs that have images</li>
 * </ul>
 *
 * Images are stored under {project}/data/supplement-images/{id}.jpg
 *
 */
@WebServlet("/api/supplement-images/*")
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,       // 5 MB per file
    maxRequestSize = 10 * 1024 * 1024,    // 10 MB total
    fileSizeThreshold = 256 * 1024        // 256 KB before writing to disk
)
public class SupplementImageServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SupplementImageServlet.class.getName());
    private Path imageDir;

    @Override
    public void init() throws ServletException {
        imageDir = Paths.get(System.getProperty("user.dir"), "data", "supplement-images");
        try {
            Files.createDirectories(imageDir);
            LOGGER.info("Supplement images directory: " + imageDir.toAbsolutePath());
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to create supplement images directory", e);
            throw new ServletException("Cannot create image storage directory", e);
        }
    }

    // ─── GET: Serve image or list ────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();

        // GET /api/supplement-images/list → return JSON array of IDs with images
        if (pathInfo != null && pathInfo.equals("/list")) {
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");

            File[] files = imageDir.toFile().listFiles((dir, name) ->
                name.endsWith(".jpg") || name.endsWith(".jpeg") || name.endsWith(".png") || name.endsWith(".webp")
            );

            StringBuilder json = new StringBuilder("[");
            if (files != null) {
                for (int i = 0; i < files.length; i++) {
                    String name = files[i].getName();
                    String id = name.substring(0, name.lastIndexOf('.'));
                    if (i > 0) json.append(",");
                    json.append("\"").append(escapeJson(id)).append("\"");
                }
            }
            json.append("]");
            resp.getWriter().write(json.toString());
            return;
        }

        // GET /api/supplement-images?id=xxx → serve the image
        String id = req.getParameter("id");
        if (id == null || id.isBlank()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing 'id' parameter");
            return;
        }

        id = sanitizeId(id);

        Path imagePath = findImage(id);
        if (imagePath == null || !Files.exists(imagePath)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "No image found for supplement: " + id);
            return;
        }

        String contentType = Files.probeContentType(imagePath);
        if (contentType == null) contentType = "image/jpeg";
        resp.setContentType(contentType);
        resp.setHeader("Cache-Control", "public, max-age=86400");
        resp.setContentLengthLong(Files.size(imagePath));

        try (InputStream is = Files.newInputStream(imagePath)) {
            is.transferTo(resp.getOutputStream());
        }
    }

    // ─── POST: Upload image ─────────────────────────────────────────────
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

        Part filePart = null;
        try {
            filePart = req.getPart("image");
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error getting file part", e);
        }

        if (filePart == null || filePart.getSize() == 0) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            sendJson(resp, false, "No image file provided");
            return;
        }

        // Validate content type
        String ct = filePart.getContentType();
        if (ct == null || !ct.startsWith("image/")) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            sendJson(resp, false, "File must be an image (JPEG, PNG, WebP)");
            return;
        }

        // Determine file extension from content type
        String ext = ".jpg";
        if (ct.contains("png")) ext = ".png";
        else if (ct.contains("webp")) ext = ".webp";
        else if (ct.contains("gif")) ext = ".gif";

        // Delete any existing image for this supplement
        deleteExistingImages(id);

        // Save the new image
        Path targetPath = imageDir.resolve(id + ext);
        try (InputStream is = filePart.getInputStream()) {
            Files.copy(is, targetPath, StandardCopyOption.REPLACE_EXISTING);
        }

        LOGGER.info("Supplement image saved: " + targetPath.getFileName());

        resp.setStatus(HttpServletResponse.SC_OK);
        sendJson(resp, true, "Image saved successfully for: " + id);
    }

    // ─── Helpers ────────────────────────────────────────────────────────

    /** Finds the image file for a given supplement ID (checks multiple extensions). */
    private Path findImage(String id) {
        String[] exts = {".jpg", ".jpeg", ".png", ".webp", ".gif"};
        for (String ext : exts) {
            Path p = imageDir.resolve(id + ext);
            if (Files.exists(p)) return p;
        }
        return null;
    }

    /** Deletes all image files for a given supplement ID. */
    private void deleteExistingImages(String id) {
        String[] exts = {".jpg", ".jpeg", ".png", ".webp", ".gif"};
        for (String ext : exts) {
            Path p = imageDir.resolve(id + ext);
            try { Files.deleteIfExists(p); } catch (IOException e) { /* ignore */ }
        }
    }

    /** Sanitizes a supplement ID to prevent path traversal attacks. */
    private String sanitizeId(String id) {
        return id.replaceAll("[^a-zA-Z0-9\\-]", "");
    }

    /** Sends a simple JSON response. */
    private void sendJson(HttpServletResponse resp, boolean success, String message) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write("{\"success\":" + success + ",\"message\":\"" + escapeJson(message) + "\"}");
    }

    /** Escapes special characters for JSON string values. */
    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
