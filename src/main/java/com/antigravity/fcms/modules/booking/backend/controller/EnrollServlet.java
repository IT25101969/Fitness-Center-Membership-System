package com.antigravity.fcms.modules.booking.backend.controller;

import com.antigravity.fcms.modules.booking.backend.model.Enrollment;
import com.antigravity.fcms.modules.booking.backend.service.EnrollmentService;
import com.antigravity.fcms.modules.auth.backend.service.MemberService;
import com.antigravity.fcms.modules.workout.backend.service.ClassService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import java.io.IOException;

/**
 * Servlet handling class enrollment operations.
 *
 * <p>Routes handled:</p>
 * <ul>
 *   <li>POST /classes/enroll → enroll a member in a class</li>
 *   <li>GET  /enrollments/delete → remove an enrollment</li>
 * </ul>
 *
 */
@WebServlet("/enrollments/*")
public class EnrollServlet extends HttpServlet {

    @Autowired private EnrollmentService enrollmentService;
    @Autowired private MemberService memberService;
    @Autowired private ClassService classService;

    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, getServletContext());
    }

    /**
     * Handles GET requests — currently handles deletion only.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        if ("/delete".equals(pathInfo)) {
            String id = req.getParameter("id");
            enrollmentService.delete(id);
            resp.sendRedirect(req.getContextPath() + "/classes?msg=unenrolled");
        } else {
            resp.sendRedirect(req.getContextPath() + "/classes");
        }
    }

    /**
     * Handles POST /enrollments/enroll — enrolls a member in a fitness class.
     * Validates that both memberId and classId are provided before enrollment.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String memberId = trim(req.getParameter("memberId"));
        String classId = trim(req.getParameter("classId"));

        // Validate inputs
        if (memberId == null || memberId.isEmpty() || classId == null || classId.isEmpty()) {
            req.setAttribute("error", "Member ID and Class ID are required for enrollment.");
            resp.sendRedirect(req.getContextPath() + "/classes?error=missing_params");
            return;
        }

        // Verify member exists
        if (memberService.findById(memberId) == null) {
            resp.sendRedirect(req.getContextPath() + "/classes?error=member_not_found");
            return;
        }

        // Attempt enrollment
        Enrollment enrollment = enrollmentService.enroll(memberId, classId);
        if (enrollment == null) {
            // Class is full
            resp.sendRedirect(req.getContextPath() + "/classes?error=class_full&classId=" + classId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/classes?msg=enrolled&classId=" + classId);
        }
    }

    /** Trims a parameter value safely. */
    private String trim(String val) {
        return val != null ? val.trim() : null;
    }
}
