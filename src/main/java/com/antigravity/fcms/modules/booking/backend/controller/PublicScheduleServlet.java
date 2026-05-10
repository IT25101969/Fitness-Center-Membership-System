package com.antigravity.fcms.modules.booking.backend.controller;

import com.antigravity.fcms.modules.workout.backend.model.FitnessClass;
import com.antigravity.fcms.modules.workout.backend.service.ClassService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import java.io.IOException;
import java.util.*;

import com.antigravity.fcms.modules.booking.backend.service.EnrollmentService;
import com.antigravity.fcms.modules.booking.backend.model.Enrollment;

/**
 * Public-facing servlet that serves the class schedule to all visitors.
 * No authentication required — this is accessible from the landing page.
 *
 */
@WebServlet("/schedule/*")
public class PublicScheduleServlet extends HttpServlet {

    @Autowired
    private ClassService classService;
    
    @Autowired
    private EnrollmentService enrollmentService;

    private static final String[] DAYS = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"};

    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<FitnessClass> allClasses = classService.findAll();

        // Build a day → classes map
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

        req.getRequestDispatcher("/WEB-INF/views/public-schedule.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
            
        String pathInfo = req.getPathInfo();
        if ("/book".equals(pathInfo)) {
            String classId = req.getParameter("classId");
            String guestName = req.getParameter("guestName");
            if (guestName == null || guestName.trim().isEmpty()) {
                guestName = "Guest User";
            }
            
            // Enroll using a pseudo-member ID for guests
            String guestMemberId = "GUEST-" + System.currentTimeMillis() % 10000;
            Enrollment e = enrollmentService.enroll(guestMemberId, classId);
            
            if (e != null) {
                resp.sendRedirect(req.getContextPath() + "/schedule?msg=booked");
            } else {
                resp.sendRedirect(req.getContextPath() + "/schedule?msg=full");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/schedule");
        }
    }
}
