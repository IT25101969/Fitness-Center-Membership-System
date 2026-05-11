package com.fcms.controller;

import com.project.fcms.modules.workout.backend.model.FitnessClass;
import com.project.fcms.modules.workout.backend.service.ClassService;
import com.project.fcms.modules.booking.backend.service.EnrollmentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import java.io.IOException;
import java.util.*;

/**
 * Servlet handling all fitness class schedule and class management routes.
 *
 * <p>Routes handled:</p>
 * <ul>
 *   <li>GET  /classes        → weekly class schedule grid</li>
 *   <li>POST /classes/create → create a new fitness class</li>
 *   <li>GET  /classes/delete → delete class and redirect</li>
 * </ul>
 *
 */
@WebServlet("/classes/*")
public class ClassServlet extends HttpServlet {

    @Autowired private ClassService classService;
    @Autowired private EnrollmentService enrollmentService;

    private static final String[] DAYS = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"};

    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, getServletContext());
    }

    /**
     * Handles GET requests for class routes.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/";

        switch (pathInfo) {
            case "/delete" -> {
                String id = req.getParameter("id");
                classService.delete(id);
                resp.sendRedirect(req.getContextPath() + "/classes?msg=deleted");
            }
            default -> showSchedule(req, resp);
        }
    }

    /**
     * Handles POST requests for class routes.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/";

        switch (pathInfo) {
            case "/create" -> createClass(req, resp);
            default -> resp.sendRedirect(req.getContextPath() + "/classes");
        }
    }

    // -----------------------------------------------------------------------
    // PRIVATE HANDLERS
    // -----------------------------------------------------------------------

    /**
     * Renders the weekly class schedule.
     * Organizes classes into a 7-day grid keyed by day abbreviation.
     */
    private void showSchedule(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<FitnessClass> allClasses = classService.findAll();

        // Build a map of day → list of classes for the weekly grid
        Map<String, List<FitnessClass>> schedule = new LinkedHashMap<>();
        for (String day : DAYS) schedule.put(day, new ArrayList<>());

        for (FitnessClass fc : allClasses) {
            String day = fc.getScheduleDay();
            if (day != null && schedule.containsKey(day)) {
                schedule.get(day).add(fc);
            }
        }

        req.setAttribute("schedule", schedule);
        req.setAttribute("days", DAYS);
        req.setAttribute("allClasses", allClasses);
        req.setAttribute("pageTitle", "Class Schedule");
        req.getRequestDispatcher("/WEB-INF/views/class-schedule.jsp").forward(req, resp);
    }

    /**
     * Creates a new fitness class with server-side validation.
     */
    private void createClass(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String className = trim(req.getParameter("className"));
        String trainerId = trim(req.getParameter("trainerId"));
        String scheduleDay = trim(req.getParameter("scheduleDay"));
        String scheduleTime = trim(req.getParameter("scheduleTime"));
        String capacityStr = trim(req.getParameter("capacity"));

        // Validate
        if (className == null || className.isEmpty()) {
            req.setAttribute("error", "Class name is required.");
            showSchedule(req, resp);
            return;
        }
        int capacity = 20;
        try {
            capacity = Integer.parseInt(capacityStr);
            if (capacity <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Capacity must be a positive number.");
            showSchedule(req, resp);
            return;
        }

        String schedule = (scheduleDay != null ? scheduleDay : "") + " " +
                          (scheduleTime != null ? scheduleTime : "");
        classService.create(className, trainerId != null ? trainerId : "TBA", schedule.trim(), capacity);
        resp.sendRedirect(req.getContextPath() + "/classes?msg=created");
    }

    /** Trims a parameter value safely. */
    private String trim(String val) {
        return val != null ? val.trim() : null;
    }
}
