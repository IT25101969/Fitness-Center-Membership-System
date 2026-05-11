package com.fcms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * Session API — returns the currently logged-in member's info as JSON.
 *
 * <p>GET /api/me → returns { "loggedIn": true, "name": "...", "email": "...", "role": "member" }
 * or            → { "loggedIn": false } when no session exists.</p>
 *
 * <p>Used by the landing page navbar to dynamically show the member profile
 * avatar + dropdown instead of the generic Login button.</p>
 *
 */
@WebServlet("/api/me")
public class MemberSessionApiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

        PrintWriter out = resp.getWriter();

        HttpSession session = req.getSession(false);
        if (session == null) {
            out.print("{\"loggedIn\":false}");
            out.flush();
            return;
        }

        String role = (String) session.getAttribute("role");
        if (role == null) {
            out.print("{\"loggedIn\":false}");
            out.flush();
            return;
        }

        if ("member".equals(role)) {
            String name  = escapeJson((String) session.getAttribute("memberName"));
            String email = escapeJson((String) session.getAttribute("memberEmail"));
            out.print("{\"loggedIn\":true,\"role\":\"member\",\"name\":\"" + name + "\",\"email\":\"" + email + "\"}");
        } else if ("admin".equals(role)) {
            String adminUser = escapeJson((String) session.getAttribute("adminUser"));
            out.print("{\"loggedIn\":true,\"role\":\"admin\",\"name\":\"" + adminUser + "\",\"email\":\"\"}");
        } else {
            out.print("{\"loggedIn\":false}");
        }

        out.flush();
    }

    /** Escapes special characters for a JSON string value. */
    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
