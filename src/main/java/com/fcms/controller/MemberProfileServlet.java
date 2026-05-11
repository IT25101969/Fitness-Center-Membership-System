package com.fcms.controller;

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

/**
 * Handles the member profile page. Requires member session.
 */
@WebServlet("/member-profile")
public class MemberProfileServlet extends HttpServlet {

    @Autowired
    private MemberService memberService;

    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"member".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/member-login");
            return;
        }

        String memberId = (String) session.getAttribute("memberId");
        Member member = memberService.findById(memberId);
        if (member == null) {
            resp.sendRedirect(req.getContextPath() + "/member-login");
            return;
        }

        req.setAttribute("member", member);
        req.getRequestDispatcher("/WEB-INF/views/member-profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"member".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/member-login");
            return;
        }

        String action = req.getParameter("action");
        if ("logout".equals(action)) {
            session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/landing.html");
            return;
        } else if ("renew".equals(action)) {
            String memberId = (String) session.getAttribute("memberId");
            Member member = memberService.findById(memberId);
            if (member != null) {
                memberService.update(member.getId(), member.getName(), member.getEmail(), member.getPhone(),
                        member.getMembershipPlanId(), member.getJoinDate(), "ACTIVE", member.getType());
            }
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":true}");
            return;
        } else if ("upgrade".equals(action)) {
            String memberId = (String) session.getAttribute("memberId");
            Member member = memberService.findById(memberId);
            if (member != null) {
                memberService.update(member.getId(), member.getName(), member.getEmail(), member.getPhone(),
                        "P003", member.getJoinDate(), "ACTIVE", "PREMIUM");
            }
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":true}");
            return;
        } else {
            doGet(req, resp);
        }
    }
}
