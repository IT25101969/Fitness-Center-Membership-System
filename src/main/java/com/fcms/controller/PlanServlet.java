package com.fcms.controller;

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
 * Servlet handling all membership plan-related HTTP routes.
 *
 * <p>Routes handled:</p>
 * <ul>
 *   <li>GET  /plans        → list all plans in card view</li>
 *   <li>GET  /plans/new    → show plan creation form</li>
 *   <li>POST /plans/create → save new plan</li>
 *   <li>GET  /plans/edit   → load plan into edit form</li>
 *   <li>POST /plans/update → update existing plan</li>
 *   <li>GET  /plans/delete → delete plan and redirect</li>
 * </ul>
 *
 */
@WebServlet("/plans/*")
public class PlanServlet extends HttpServlet {

    @Autowired private PlanService planService;
    @Autowired private MemberService memberService;

    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, getServletContext());
    }

    /**
     * Handles GET requests for plan routes.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/";

        switch (pathInfo) {
            case "/new" -> showForm(req, resp, null);
            case "/edit" -> {
                String id = req.getParameter("id");
                MembershipPlan plan = planService.findById(id);
                if (plan == null) {
                    resp.sendRedirect(req.getContextPath() + "/plans");
                    return;
                }
                showForm(req, resp, plan);
            }
            case "/delete" -> {
                String id = req.getParameter("id");
                planService.delete(id);
                resp.sendRedirect(req.getContextPath() + "/plans?msg=deleted");
            }
            default -> listPlans(req, resp);
        }
    }

    /**
     * Handles POST requests for plan routes.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/";

        switch (pathInfo) {
            case "/create" -> createPlan(req, resp);
            case "/update" -> updatePlan(req, resp);
            default -> resp.sendRedirect(req.getContextPath() + "/plans");
        }
    }

    // -----------------------------------------------------------------------
    // PRIVATE HANDLERS
    // -----------------------------------------------------------------------

    /**
     * Lists all plans enriched with active member counts.
     */
    private void listPlans(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<MembershipPlan> plans = planService.findAll();
        // Enrich each plan with its active member count
        for (MembershipPlan plan : plans) {
            plan.setActiveMembers((int) memberService.countByPlan(plan.getPlanId()));
        }
        req.setAttribute("plans", plans);
        req.setAttribute("pageTitle", "Membership Plans");
        req.getRequestDispatcher("/WEB-INF/views/plan-list.jsp").forward(req, resp);
    }

    /**
     * Shows the plan form (create or edit).
     *
     * @param plan the plan to edit, or null for new plan
     */
    private void showForm(HttpServletRequest req, HttpServletResponse resp, MembershipPlan plan)
            throws ServletException, IOException {
        req.setAttribute("plan", plan);
        req.setAttribute("isEdit", plan != null);
        req.setAttribute("pageTitle", plan != null ? "Edit Plan" : "Add New Plan");
        req.getRequestDispatcher("/WEB-INF/views/plan-form.jsp").forward(req, resp);
    }

    /**
     * Creates a new plan with server-side validation.
     */
    private void createPlan(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String planName = trim(req.getParameter("planName"));
        String priceStr = trim(req.getParameter("price"));
        String durationStr = trim(req.getParameter("durationDays"));
        String classAccess = trim(req.getParameter("classAccess"));
        String features = trim(req.getParameter("features"));

        String error = validatePlanFields(planName, priceStr, durationStr, classAccess);
        if (error != null) {
            req.setAttribute("error", error);
            showForm(req, resp, null);
            return;
        }

        double price = Double.parseDouble(priceStr);
        int duration = Integer.parseInt(durationStr);
        planService.create(planName, price, duration, classAccess, features != null ? features : "");
        resp.sendRedirect(req.getContextPath() + "/plans?msg=created");
    }

    /**
     * Updates an existing plan with server-side validation.
     */
    private void updatePlan(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String id = trim(req.getParameter("planId"));
        String planName = trim(req.getParameter("planName"));
        String priceStr = trim(req.getParameter("price"));
        String durationStr = trim(req.getParameter("durationDays"));
        String classAccess = trim(req.getParameter("classAccess"));
        String features = trim(req.getParameter("features"));

        String error = validatePlanFields(planName, priceStr, durationStr, classAccess);
        if (error != null) {
            MembershipPlan plan = planService.findById(id);
            req.setAttribute("error", error);
            showForm(req, resp, plan);
            return;
        }

        double price = Double.parseDouble(priceStr);
        int duration = Integer.parseInt(durationStr);
        planService.update(id, planName, price, duration, classAccess, features != null ? features : "");
        resp.sendRedirect(req.getContextPath() + "/plans?msg=updated");
    }

    /**
     * Validates plan form fields.
     *
     * @return error message, or null if valid
     */
    private String validatePlanFields(String planName, String priceStr, String durationStr, String classAccess) {
        if (planName == null || planName.isEmpty())
            return "Plan name is required.";
        if (priceStr == null || priceStr.isEmpty())
            return "Price is required.";
        try { double price = Double.parseDouble(priceStr); if (price < 0) return "Price must be positive."; }
        catch (NumberFormatException e) { return "Price must be a valid number."; }
        if (durationStr == null || durationStr.isEmpty())
            return "Duration is required.";
        try { int dur = Integer.parseInt(durationStr); if (dur <= 0) return "Duration must be greater than 0."; }
        catch (NumberFormatException e) { return "Duration must be a valid integer."; }
        if (classAccess == null || classAccess.isEmpty())
            return "Class access level is required.";
        return null;
    }

    /** Trims a parameter value safely. */
    private String trim(String val) {
        return val != null ? val.trim() : null;
    }
}
