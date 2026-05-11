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

@WebServlet("/member-register")
public class MemberRegisterServlet extends HttpServlet {

    @Autowired
    private MemberService memberService;

    @Autowired
    private PlanService planService;

    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("plans", planService.findAll());
        req.getRequestDispatcher("/WEB-INF/views/member-register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password"); // We don't store passwords yet, but we collect it to match the UI

        if (name == null || name.trim().isEmpty() || email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Name and Email are required.");
            req.getRequestDispatcher("/WEB-INF/views/member-register.jsp").forward(req, resp);
            return;
        }

        String planId = req.getParameter("planId");
        if (planId == null || planId.trim().isEmpty()) {
            planId = "NONE";
        }
        
        String type = "STANDARD";
        if ("FREE_TRIAL".equals(planId)) {
            type = "TRIAL";
        }

        try {
            // Create the member. Status: ACTIVE
            memberService.create(name, email, phone, planId, null, "ACTIVE", type, password);
            
            // Redirect to login page with success flag
            resp.sendRedirect(req.getContextPath() + "/member-login?registered=true");
        } catch (Exception e) {
            req.setAttribute("error", "Registration failed. Please try again.");
            req.getRequestDispatcher("/WEB-INF/views/member-register.jsp").forward(req, resp);
        }
    }
}
