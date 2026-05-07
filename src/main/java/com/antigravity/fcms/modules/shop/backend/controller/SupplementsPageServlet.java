package com.antigravity.fcms.modules.shop.backend.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Public-facing servlet that serves the Supplements Shop page.
 * No authentication required — similar to {@link ExercisesServlet}.
 *
 */
@WebServlet("/shop-supplements")
public class SupplementsPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/supplements.html").forward(req, resp);
    }
}
