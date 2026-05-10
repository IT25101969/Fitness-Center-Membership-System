package com.antigravity.fcms.modules.booking.backend.controller;

import com.antigravity.fcms.modules.workout.backend.model.Exercise;
import com.antigravity.fcms.modules.workout.backend.service.ExerciseService;
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
 * Servlet handling exercise management routes (admin).
 *
 * <p>Routes:</p>
 * <ul>
 *   <li>GET  /exercise-mgmt         → list all exercises</li>
 *   <li>GET  /exercise-mgmt/new     → show creation form</li>
 *   <li>GET  /exercise-mgmt/edit    → show edit form</li>
 *   <li>GET  /exercise-mgmt/delete  → delete and redirect</li>
 *   <li>POST /exercise-mgmt/create  → save new exercise</li>
 *   <li>POST /exercise-mgmt/update  → update existing exercise</li>
 * </ul>
 *
 */
@WebServlet("/exercise-mgmt/*")
public class ExerciseManagementServlet extends HttpServlet {

    @Autowired
    private ExerciseService exerciseService;

    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/";

        switch (pathInfo) {
            case "/new" -> {
                req.setAttribute("pageTitle", "Add Exercise");
                req.setAttribute("exercise", null);
                req.getRequestDispatcher("/WEB-INF/views/exercise-form.jsp").forward(req, resp);
            }
            case "/edit" -> {
                String editId = req.getParameter("id");
                Exercise existing = exerciseService.findById(editId);
                if (existing == null) {
                    resp.sendRedirect(req.getContextPath() + "/exercise-mgmt?msg=notfound");
                    return;
                }
                req.setAttribute("exercise", existing);
                req.setAttribute("pageTitle", "Edit Exercise");
                req.getRequestDispatcher("/WEB-INF/views/exercise-form.jsp").forward(req, resp);
            }
            case "/delete" -> {
                String id = req.getParameter("id");
                exerciseService.delete(id);
                resp.sendRedirect(req.getContextPath() + "/exercise-mgmt?msg=deleted");
            }
            default -> listExercises(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/";

        if ("/create".equals(pathInfo)) {
            createExercise(req, resp);
        } else if ("/update".equals(pathInfo)) {
            updateExercise(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/exercise-mgmt");
        }
    }

    // -----------------------------------------------------------------------
    // PRIVATE HANDLERS
    // -----------------------------------------------------------------------

    private void listExercises(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Exercise> exercises = exerciseService.findAll();
        req.setAttribute("exercises", exercises);
        req.setAttribute("pageTitle", "Exercise Management");
        req.getRequestDispatcher("/WEB-INF/views/exercise-list.jsp").forward(req, resp);
    }

    private void createExercise(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name = trim(req.getParameter("name"));
        String description = trim(req.getParameter("description"));
        String muscleGroup = trim(req.getParameter("muscleGroup"));
        String equipment = trim(req.getParameter("equipment"));
        String category = trim(req.getParameter("category"));
        String styles = trim(req.getParameter("styles"));

        if (name == null || name.length() < 2) {
            req.setAttribute("error", "Exercise name must be at least 2 characters.");
            req.setAttribute("pageTitle", "Add Exercise");
            req.getRequestDispatcher("/WEB-INF/views/exercise-form.jsp").forward(req, resp);
            return;
        }

        exerciseService.create(name,
                description != null ? description : "",
                muscleGroup != null ? muscleGroup : "legs",
                equipment != null ? equipment : "bodyweight",
                category != null ? category : "build",
                styles != null ? styles : "Strength");
        resp.sendRedirect(req.getContextPath() + "/exercise-mgmt?msg=created");
    }

    private void updateExercise(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String id = trim(req.getParameter("id"));
        String name = trim(req.getParameter("name"));
        String description = trim(req.getParameter("description"));
        String muscleGroup = trim(req.getParameter("muscleGroup"));
        String equipment = trim(req.getParameter("equipment"));
        String category = trim(req.getParameter("category"));
        String styles = trim(req.getParameter("styles"));

        if (id == null || id.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/exercise-mgmt");
            return;
        }
        if (name == null || name.length() < 2) {
            Exercise ex = exerciseService.findById(id);
            req.setAttribute("exercise", ex);
            req.setAttribute("error", "Exercise name must be at least 2 characters.");
            req.setAttribute("pageTitle", "Edit Exercise");
            req.getRequestDispatcher("/WEB-INF/views/exercise-form.jsp").forward(req, resp);
            return;
        }

        exerciseService.update(id, name,
                description != null ? description : "",
                muscleGroup != null ? muscleGroup : "legs",
                equipment != null ? equipment : "bodyweight",
                category != null ? category : "build",
                styles != null ? styles : "Strength");
        resp.sendRedirect(req.getContextPath() + "/exercise-mgmt?msg=updated");
    }

    private String trim(String val) {
        return val != null ? val.trim() : null;
    }
}
