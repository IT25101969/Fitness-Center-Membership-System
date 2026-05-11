package com.antigravity.fcms.modules.plan.backend.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Public-facing servlet that serves the Meal Plans / Nutrition page.
 * No authentication required.
 *
 */
@WebServlet("/meal-plans")
public class MealPlansServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Goal filter param
        String goal = req.getParameter("goal");
        if (goal == null || goal.isBlank()) goal = "all";
        req.setAttribute("selectedGoal", goal);

        req.getRequestDispatcher("/WEB-INF/views/meal-plans.jsp").forward(req, resp);
    }
}
