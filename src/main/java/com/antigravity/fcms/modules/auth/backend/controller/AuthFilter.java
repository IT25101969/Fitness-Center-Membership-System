package com.antigravity.fcms.modules.auth.backend.controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/home", "/dashboard", "/members", "/members/*", "/plans", "/plans/*",
        "/classes", "/classes/*", "/trainers", "/trainers/*", "/attendance", "/attendance/*", "/settings",
        "/supplements", "/supplements/*", "/exercise-mgmt", "/exercise-mgmt/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        boolean isLoggedIn = (session != null && "admin".equals(session.getAttribute("role")));
        
        if (isLoggedIn) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(req.getContextPath() + "/admin-login");
        }
    }
}
