package com.antigravity.fcms.modules.auth.backend.controller;

import com.antigravity.fcms.modules.auth.backend.model.Member;
import com.antigravity.fcms.modules.auth.backend.service.MemberService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import java.io.IOException;
import java.util.List;

/**
 * Unified login servlet — handles both admin and member authentication.
 *
 * <p>POST /member-login → checks admin credentials first, then member credentials.</p>
 * <ul>
 *   <li>If username/password matches admin → redirect to /home (admin dashboard)</li>
 *   <li>If email/password matches a member → redirect to /member-profile</li>
 * </ul>
 *
 * @version 2.0
 */
@WebServlet("/member-login")
public class MemberLoginServlet extends HttpServlet {

    private static final String ADMIN_USERNAME = "admin";
    private static final String DEFAULT_ADMIN_PASSWORD = "admin123";

    @Autowired
    private MemberService memberService;

    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, getServletContext());
    }

    /** Returns the current admin password — prefers any runtime change from Settings. */
    private String getAdminPassword(HttpServletRequest req) {
        Object overridden = req.getServletContext().getAttribute("adminPassword");
        return (overridden instanceof String && !((String) overridden).isBlank())
                ? (String) overridden
                : DEFAULT_ADMIN_PASSWORD;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // If already logged in, redirect to appropriate dashboard
        HttpSession session = req.getSession(false);
        if (session != null) {
            if ("admin".equals(session.getAttribute("role"))) {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }
            if ("member".equals(session.getAttribute("role"))) {
                resp.sendRedirect(req.getContextPath() + "/landing.html");
                return;
            }
        }
        req.getRequestDispatcher("/WEB-INF/views/member-login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String rawIdentifier = req.getParameter("email"); // field name is "email" but can also be admin username
        String rawPass = req.getParameter("password");

        final String identifier = (rawIdentifier != null) ? rawIdentifier.trim() : "";
        final String pass = (rawPass != null) ? rawPass : "";

        // ── 1. Try admin login first ──
        if (ADMIN_USERNAME.equals(identifier) && getAdminPassword(req).equals(pass)) {
            // Invalidate any existing session (clean slate)
            HttpSession oldSession = req.getSession(false);
            if (oldSession != null) oldSession.invalidate();

            // Create a fresh admin session
            HttpSession session = req.getSession(true);
            session.setAttribute("role",      "admin");
            session.setAttribute("adminUser", ADMIN_USERNAME);
            session.setMaxInactiveInterval(60 * 60); // 1 hour

            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // ── 2. Try member login ──
        List<Member> all = memberService.findAll();
        Member found = all.stream()
                .filter(m -> m.getEmail() != null && m.getEmail().equalsIgnoreCase(identifier.trim()))
                .findFirst()
                .orElse(null);

        if (found != null) {
            // Use stored password if available, otherwise fall back to email-prefix as default
            String storedPassword = found.getPassword();
            String defaultPassword = (found.getEmail() != null && found.getEmail().contains("@"))
                    ? found.getEmail().substring(0, found.getEmail().indexOf('@'))
                    : "member123";
            String effectivePassword = (storedPassword != null && !storedPassword.isEmpty())
                    ? storedPassword : defaultPassword;

            if (effectivePassword.equals(pass)) {
                // Successful member login
                HttpSession session = req.getSession();
                session.setAttribute("role",        "member");
                session.setAttribute("memberId",    found.getId());
                session.setAttribute("memberName",  found.getName());
                session.setAttribute("memberEmail", found.getEmail());
                resp.sendRedirect(req.getContextPath() + "/landing.html");
                return;
            }
        }

        req.setAttribute("error", "Invalid credentials. Please try again.");
        req.getRequestDispatcher("/WEB-INF/views/member-login.jsp").forward(req, resp);
    }
}
