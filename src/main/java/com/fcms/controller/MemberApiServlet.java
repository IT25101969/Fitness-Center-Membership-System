package com.fcms.controller;

import com.antigravity.fcms.modules.auth.backend.model.Member;
import com.antigravity.fcms.modules.auth.backend.service.MemberService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * Lightweight API servlet providing JSON-style member lookup by ID.
 * Used by the attendance page to auto-populate member names via JavaScript.
 *
 * <p>Route: GET /api/member?id=M001</p>
 * <p>Returns: plain-text name if found, or empty 404 response if not found.</p>
 *
 */
@WebServlet("/api/member")
public class MemberApiServlet extends HttpServlet {

    @Autowired
    private MemberService memberService;

    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, getServletContext());
    }

    /**
     * Handles GET /api/member?id={memberId}.
     * Returns a simple JSON object with member name and status.
     *
     * @param req  the HTTP request (expects "id" query parameter)
     * @param resp the HTTP response (JSON or 404)
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String memberId = req.getParameter("id");
        resp.setContentType("application/json;charset=UTF-8");

        if (memberId == null || memberId.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"id parameter is required\"}");
            return;
        }

        Member member = memberService.findById(memberId.trim().toUpperCase());

        if (member == null) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.getWriter().write("{\"found\":false}");
            return;
        }

        PrintWriter out = resp.getWriter();
        out.write("{");
        out.write("\"found\":true,");
        out.write("\"id\":\"" + escapeJson(member.getId()) + "\",");
        out.write("\"name\":\"" + escapeJson(member.getName()) + "\",");
        out.write("\"status\":\"" + escapeJson(member.getStatus()) + "\",");
        out.write("\"plan\":\"" + escapeJson(member.getPlanName() != null ? member.getPlanName() : "") + "\"");
        out.write("}");
    }

    /**
     * Escapes special characters for safe JSON string embedding.
     *
     * @param value the string to escape
     * @return JSON-safe escaped string
     */
    private String escapeJson(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r");
    }
}
