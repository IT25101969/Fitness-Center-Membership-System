package com.fcms.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Public-facing servlet that serves the Exercise Library page.
 * No authentication required.
 *
 */
@WebServlet("/exercises")
public class ExercisesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Forward to the static exercises HTML page
        req.getRequestDispatcher("/exercises.html").forward(req, resp);
    }
}
