package com.fcms.controller;

import com.antigravity.fcms.modules.auth.backend.model.Member;
import com.antigravity.fcms.modules.plan.backend.model.MembershipPlan;
import com.antigravity.fcms.modules.auth.backend.service.MemberService;
import com.antigravity.fcms.modules.plan.backend.service.PlanService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import java.io.IOException;
import java.util.List;

/**
 * Servlet handling all member-related HTTP routes.
 * Supports GET/POST for list, create, edit, update, and delete operations.
 *
 * <p>Routes handled:</p>
 * <ul>
 *   <li>GET  /members        → list all members</li>
 *   <li>GET  /members/new    → show empty registration form</li>
 *   <li>POST /members/create → save new member</li>
 *   <li>GET  /members/edit   → load member into edit form</li>
 *   <li>POST /members/update → update existing member</li>
 *   <li>GET  /members/delete → delete member and redirect</li>
 * </ul>
 *
 */
@WebServlet("/members/*")
public class MemberServlet extends HttpServlet {

    @Autowired private MemberService memberService;
    @Autowired private PlanService planService;

    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, getServletContext());
    }

    /**
     * Handles all GET requests for member routes.
     *
     * @param req  the HTTP request
     * @param resp the HTTP response
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo(); // e.g., "/new", "/edit", "/delete"
        if (pathInfo == null) pathInfo = "/";

        switch (pathInfo) {
            case "/new" -> showForm(req, resp, null);
            case "/edit" -> {
                String id = req.getParameter("id");
                Member member = memberService.findById(id);
                if (member == null) {
                    resp.sendRedirect(req.getContextPath() + "/members");
                    return;
                }
                showForm(req, resp, member);
            }
            case "/delete" -> {
                String id = req.getParameter("id");
                memberService.delete(id);
                resp.sendRedirect(req.getContextPath() + "/members?msg=deleted");
            }
            default -> listMembers(req, resp);
        }
    }

    /**
     * Handles all POST requests for member routes.
     *
     * @param req  the HTTP request
     * @param resp the HTTP response
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/";

        switch (pathInfo) {
            case "/create" -> createMember(req, resp);
            case "/update" -> updateMember(req, resp);
            default -> resp.sendRedirect(req.getContextPath() + "/members");
        }
    }

    // -----------------------------------------------------------------------
    // PRIVATE HANDLERS
    // -----------------------------------------------------------------------

    /**
     * Loads and renders the member list view with all members.
     */
    private void listMembers(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Member> members = memberService.findAll();
        req.setAttribute("members", members);
        req.setAttribute("pageTitle", "Member Management");
        req.getRequestDispatcher("/WEB-INF/views/member-list.jsp").forward(req, resp);
    }

    /**
     * Shows the member registration/edit form.
     * If member is null, renders an empty (create) form.
     *
     * @param member the member to pre-populate, or null for new member form
     */
    private void showForm(HttpServletRequest req, HttpServletResponse resp, Member member)
            throws ServletException, IOException {
        List<MembershipPlan> plans = planService.findAll();
        req.setAttribute("plans", plans);
        req.setAttribute("member", member);
        req.setAttribute("isEdit", member != null);
        req.setAttribute("pageTitle", member != null ? "Edit Member" : "Register Member");
        req.getRequestDispatcher("/WEB-INF/views/member-form.jsp").forward(req, resp);
    }

    /**
     * Creates a new member after server-side validation.
     * On validation failure, re-renders the form with error attributes.
     */
    private void createMember(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name = trim(req.getParameter("name"));
        String email = trim(req.getParameter("email"));
        String phone = trim(req.getParameter("phone"));
        String planId = trim(req.getParameter("planId"));
        String joinDate = trim(req.getParameter("joinDate"));
        String status = trim(req.getParameter("status"));
        String type = trim(req.getParameter("type"));

        // Server-side validation
        String error = validateMemberFields(name, email, phone, planId);
        if (error != null) {
            req.setAttribute("error", error);
            req.setAttribute("formData", buildFormData(name, email, phone, planId, joinDate, status, type));
            showForm(req, resp, null);
            return;
        }

        memberService.create(name, email, phone, planId, joinDate,
                status != null ? status : "ACTIVE", type != null ? type : "STANDARD", null);
        resp.sendRedirect(req.getContextPath() + "/members?msg=created");
    }

    /**
     * Updates an existing member record after server-side validation.
     */
    private void updateMember(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String id = trim(req.getParameter("id"));
        String name = trim(req.getParameter("name"));
        String email = trim(req.getParameter("email"));
        String phone = trim(req.getParameter("phone"));
        String planId = trim(req.getParameter("planId"));
        String joinDate = trim(req.getParameter("joinDate"));
        String status = trim(req.getParameter("status"));
        String type = trim(req.getParameter("type"));

        String error = validateMemberFields(name, email, phone, planId);
        if (error != null) {
            Member member = memberService.findById(id);
            req.setAttribute("error", error);
            showForm(req, resp, member);
            return;
        }

        memberService.update(id, name, email, phone, planId, joinDate, status, type);
        resp.sendRedirect(req.getContextPath() + "/members?msg=updated");
    }

    /**
     * Validates mandatory member form fields.
     *
     * @return error message string, or null if valid
     */
    private String validateMemberFields(String name, String email, String phone, String planId) {
        if (name == null || name.length() < 2)
            return "Full name is required (minimum 2 characters).";
        if (email == null || !email.contains("@"))
            return "A valid email address is required.";
        if (phone == null || !phone.matches("\\d{10}"))
            return "Phone number must be exactly 10 digits.";
        if (planId == null || planId.isEmpty())
            return "A membership plan must be selected.";
        return null;
    }

    /**
     * Builds a simple form data object for re-populating the form after validation failure.
     */
    private java.util.Map<String, String> buildFormData(String name, String email, String phone,
                                                         String planId, String joinDate,
                                                         String status, String type) {
        java.util.Map<String, String> data = new java.util.HashMap<>();
        data.put("name", name);
        data.put("email", email);
        data.put("phone", phone);
        data.put("planId", planId);
        data.put("joinDate", joinDate);
        data.put("status", status);
        data.put("type", type);
        return data;
    }

    /** Trims a parameter value safely. */
    private String trim(String val) {
        return val != null ? val.trim() : null;
    }
}
