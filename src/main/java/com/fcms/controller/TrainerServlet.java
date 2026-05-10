package com.fcms.controller;

import com.antigravity.fcms.modules.trainer.backend.model.Trainer;
import com.antigravity.fcms.modules.trainer.backend.service.TrainerService;
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
 * Servlet handling trainer management routes.
 *
 * <p>Routes handled:</p>
 * <ul>
 *   <li>GET  /trainers        → list all trainers</li>
 *   <li>GET  /trainers/new    → show creation form</li>
 *   <li>POST /trainers/create → save new trainer</li>
 *   <li>GET  /trainers/delete → delete trainer and redirect</li>
 * </ul>
 *
 */
@WebServlet("/trainers/*")
public class TrainerServlet extends HttpServlet {

    @Autowired
    private TrainerService trainerService;

    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, getServletContext());
    }

    /**
     * Handles GET requests for trainer routes.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/";

        switch (pathInfo) {
            case "/new" -> {
                req.setAttribute("pageTitle", "Add Trainer");
                req.setAttribute("trainer", null);
                req.getRequestDispatcher("/WEB-INF/views/trainer-form.jsp").forward(req, resp);
            }
            case "/edit" -> {
                String editId = req.getParameter("id");
                com.antigravity.fcms.modules.trainer.backend.model.Trainer existing = trainerService.findById(editId);
                if (existing == null) {
                    resp.sendRedirect(req.getContextPath() + "/trainers?msg=notfound");
                    return;
                }
                req.setAttribute("trainer", existing);
                req.setAttribute("pageTitle", "Edit Trainer");
                req.getRequestDispatcher("/WEB-INF/views/trainer-form.jsp").forward(req, resp);
            }
            case "/delete" -> {
                String id = req.getParameter("id");
                trainerService.delete(id);
                resp.sendRedirect(req.getContextPath() + "/trainers?msg=deleted");
            }
            default -> listTrainers(req, resp);
        }
    }

    /**
     * Handles POST requests for trainer routes.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/";

        if ("/create".equals(pathInfo)) {
            createTrainer(req, resp);
        } else if ("/update".equals(pathInfo)) {
            updateTrainer(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/trainers");
        }
    }

    // -----------------------------------------------------------------------
    // PRIVATE HANDLERS
    // -----------------------------------------------------------------------

    /**
     * Lists all trainers.
     */
    private void listTrainers(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Trainer> trainers = trainerService.findAll();
        req.setAttribute("trainers", trainers);
        req.setAttribute("pageTitle", "Trainer Management");
        req.getRequestDispatcher("/WEB-INF/views/trainer-list.jsp").forward(req, resp);
    }

    /**
     * Creates a new trainer after server-side validation.
     */
    private void createTrainer(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name = trim(req.getParameter("name"));
        String email = trim(req.getParameter("email"));
        String phone = trim(req.getParameter("phone"));
        String specialization = trim(req.getParameter("specialization"));
        String certifications = trim(req.getParameter("certifications"));

        // Server-side validation
        if (name == null || name.length() < 2) {
            req.setAttribute("error", "Trainer name must be at least 2 characters.");
            req.setAttribute("pageTitle", "Add Trainer");
            req.getRequestDispatcher("/WEB-INF/views/trainer-form.jsp").forward(req, resp);
            return;
        }
        if (email == null || !email.contains("@")) {
            req.setAttribute("error", "A valid email address is required.");
            req.setAttribute("pageTitle", "Add Trainer");
            req.getRequestDispatcher("/WEB-INF/views/trainer-form.jsp").forward(req, resp);
            return;
        }

        trainerService.create(name, email, phone != null ? phone : "",
                specialization != null ? specialization : "",
                certifications != null ? certifications : "");
        resp.sendRedirect(req.getContextPath() + "/trainers?msg=created");
    }

    /**
     * Updates an existing trainer after server-side validation.
     */
    private void updateTrainer(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String id = trim(req.getParameter("id"));
        String name = trim(req.getParameter("name"));
        String email = trim(req.getParameter("email"));
        String phone = trim(req.getParameter("phone"));
        String specialization = trim(req.getParameter("specialization"));
        String certifications = trim(req.getParameter("certifications"));

        if (id == null || id.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/trainers");
            return;
        }
        if (name == null || name.length() < 2) {
            com.antigravity.fcms.modules.trainer.backend.model.Trainer t = trainerService.findById(id);
            req.setAttribute("trainer", t);
            req.setAttribute("error", "Trainer name must be at least 2 characters.");
            req.setAttribute("pageTitle", "Edit Trainer");
            req.getRequestDispatcher("/WEB-INF/views/trainer-form.jsp").forward(req, resp);
            return;
        }
        if (email == null || !email.contains("@")) {
            com.antigravity.fcms.modules.trainer.backend.model.Trainer t = trainerService.findById(id);
            req.setAttribute("trainer", t);
            req.setAttribute("error", "A valid email address is required.");
            req.setAttribute("pageTitle", "Edit Trainer");
            req.getRequestDispatcher("/WEB-INF/views/trainer-form.jsp").forward(req, resp);
            return;
        }

        trainerService.update(id, name, email, phone != null ? phone : "",
                specialization != null ? specialization : "",
                certifications != null ? certifications : "");
        resp.sendRedirect(req.getContextPath() + "/trainers?msg=updated");
    }

    /** Trims a parameter value safely. */
    private String trim(String val) {
        return val != null ? val.trim() : null;
    }
}
