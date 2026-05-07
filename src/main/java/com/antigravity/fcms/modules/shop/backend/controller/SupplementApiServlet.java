package com.antigravity.fcms.modules.shop.backend.controller;

import com.antigravity.fcms.modules.shop.backend.model.Supplement;
import com.antigravity.fcms.modules.shop.backend.service.SupplementService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import jakarta.servlet.ServletException;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

/**
 * Public JSON API for supplements (no auth required).
 *
 * <p>GET /api/supplements → returns all supplements as JSON array.</p>
 * <p>Used by the landing page to dynamically load supplement products.</p>
 *
 * @version 1.1
 */
@WebServlet("/api/supplements")
public class SupplementApiServlet extends HttpServlet {

    @Autowired
    private SupplementService supplementService;

    private Path imageDir;

    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, getServletContext());
        imageDir = Paths.get(System.getProperty("user.dir"), "data", "supplement-images");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

        List<Supplement> supplements = supplementService.findAll();
        PrintWriter out = resp.getWriter();
        out.print(toJson(supplements));
        out.flush();
    }

    /** Check if a local image exists for a given supplement ID. */
    private boolean hasLocalImage(String id) {
        if (id == null) return false;
        String safeId = id.replaceAll("[^a-zA-Z0-9\\-]", "");
        String[] exts = {".jpg", ".jpeg", ".png", ".webp", ".gif"};
        for (String ext : exts) {
            File f = imageDir.resolve(safeId + ext).toFile();
            if (f.exists()) return true;
        }
        return false;
    }

    private String toJson(List<Supplement> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) sb.append(",");
            Supplement s = list.get(i);
            boolean localImg = hasLocalImage(s.getId());
            sb.append("{");
            sb.append("\"id\":\"").append(esc(s.getId())).append("\",");
            sb.append("\"name\":\"").append(esc(s.getName())).append("\",");
            sb.append("\"brand\":\"").append(esc(s.getBrand())).append("\",");
            sb.append("\"category\":\"").append(esc(s.getCategory())).append("\",");
            sb.append("\"price\":\"").append(esc(s.getPrice())).append("\",");
            sb.append("\"description\":\"").append(esc(s.getDescription())).append("\",");
            sb.append("\"imageUrl\":\"").append(esc(s.getImageUrl())).append("\",");
            sb.append("\"hasLocalImage\":").append(localImg).append(",");
            if (localImg) {
                sb.append("\"localImageUrl\":\"/api/supplement-images?id=").append(esc(s.getId())).append("\",");
            }
            sb.append("\"inStock\":").append(s.isInStock()).append(",");
            sb.append("\"formattedPrice\":\"").append(esc(s.getFormattedPrice())).append("\"");
            sb.append("}");
        }
        sb.append("]");
        return sb.toString();
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "");
    }
}
