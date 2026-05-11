package com.fcms.controller;

import com.antigravity.fcms.modules.workout.backend.model.FitnessClass;
import com.antigravity.fcms.modules.auth.backend.model.Member;
import com.antigravity.fcms.modules.booking.backend.service.AttendanceService;
import com.antigravity.fcms.modules.workout.backend.service.ClassService;
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
 * Servlet handling the admin dashboard at route GET /.
 * Aggregates statistics from all services and renders dashboard.jsp.
 *
 */
@WebServlet({"/home", "/dashboard"})
public class HomeServlet extends HttpServlet {

    @Autowired private MemberService memberService;
    @Autowired private PlanService planService;
    @Autowired private ClassService classService;
    @Autowired private AttendanceService attendanceService;

    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, getServletContext());
    }

    /**
     * Handles GET / — loads dashboard statistics and renders dashboard.jsp.
     *
     * @param req  the HTTP request
     * @param resp the HTTP response
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Aggregate stats
        req.setAttribute("totalMembers", memberService.countAll());
        req.setAttribute("activeMembers", memberService.countActive());
        req.setAttribute("totalPlans", planService.countAll());
        req.setAttribute("totalClasses", classService.countAll());
        req.setAttribute("monthlyRevenue", memberService.monthlyRevenue());
        req.setAttribute("todayCheckIns", attendanceService.todayCount());

        // Recent members (last 5)
        List<Member> recentMembers = memberService.findRecent(5);
        req.setAttribute("recentMembers", recentMembers);

        // Today's classes
        List<FitnessClass> todayClasses = classService.findToday();
        req.setAttribute("todayClasses", todayClasses);

        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
    }
}
