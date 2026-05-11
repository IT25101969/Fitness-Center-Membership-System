package com.project.fcms.modules.shop.backend.controller;

import com.project.fcms.modules.shop.backend.model.Supplement;
import com.project.fcms.modules.shop.backend.service.SupplementService;
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
 * Servlet handling supplement management routes (admin).
 *
 * <p>Routes:</p>
 * <ul>
 *   <li>GET  /supplements         → list all supplements</li>
 *   <li>GET  /supplements/new     → show creation form</li>
 *   <li>GET  /supplements/edit    → show edit form</li>
 *   <li>GET  /supplements/delete  → delete and redirect</li>
 *   <li>POST /supplements/create  → save new supplement</li>
 *   <li>POST /supplements/update  → update existing supplement</li>
 * </ul>
 *
 */
@WebServlet("/supplements/*")
public class SupplementServlet extends HttpServlet {

    @Autowired
    private SupplementService supplementService;

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
                req.setAttribute("pageTitle", "Add Supplement");
                req.setAttribute("supplement", null);
                req.getRequestDispatcher("/WEB-INF/views/supplement-form.jsp").forward(req, resp);
            }
            case "/edit" -> {
                String editId = req.getParameter("id");
                Supplement existing = supplementService.findById(editId);
                if (existing == null) {
                    resp.sendRedirect(req.getContextPath() + "/supplements?msg=notfound");
                    return;
                }
                req.setAttribute("supplement", existing);
                req.setAttribute("pageTitle", "Edit Supplement");
                req.getRequestDispatcher("/WEB-INF/views/supplement-form.jsp").forward(req, resp);
            }
            case "/delete" -> {
                String id = req.getParameter("id");
                supplementService.delete(id);
                resp.sendRedirect(req.getContextPath() + "/supplements?msg=deleted");
            }
            default -> listSupplements(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/";

        if ("/create".equals(pathInfo)) {
            createSupplement(req, resp);
        } else if ("/update".equals(pathInfo)) {
            updateSupplement(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/supplements");
        }
    }

    // -----------------------------------------------------------------------
    // PRIVATE HANDLERS
    // -----------------------------------------------------------------------

    private void listSupplements(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Supplement> supplements = supplementService.findAll();
        req.setAttribute("supplements", supplements);
        req.setAttribute("pageTitle", "Supplement Management");
        req.getRequestDispatcher("/WEB-INF/views/supplement-list.jsp").forward(req, resp);
    }

    private void createSupplement(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name = trim(req.getParameter("name"));
        String brand = trim(req.getParameter("brand"));
        String category = trim(req.getParameter("category"));
        String price = trim(req.getParameter("price"));
        String description = trim(req.getParameter("description"));
        String imageUrl = trim(req.getParameter("imageUrl"));
        boolean inStock = "on".equals(req.getParameter("inStock")) || "true".equals(req.getParameter("inStock"));

        if (name == null || name.length() < 2) {
            req.setAttribute("error", "Product name must be at least 2 characters.");
            req.setAttribute("pageTitle", "Add Supplement");
            req.getRequestDispatcher("/WEB-INF/views/supplement-form.jsp").forward(req, resp);
            return;
        }
        if (price == null || price.isEmpty()) {
            req.setAttribute("error", "Price is required.");
            req.setAttribute("pageTitle", "Add Supplement");
            req.getRequestDispatcher("/WEB-INF/views/supplement-form.jsp").forward(req, resp);
            return;
        }

        supplementService.create(name,
                brand != null ? brand : "",
                category != null ? category : "Other",
                price,
                description != null ? description : "",
                imageUrl != null ? imageUrl : "",
                inStock);
        resp.sendRedirect(req.getContextPath() + "/supplements?msg=created");
    }

    private void updateSupplement(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String id = trim(req.getParameter("id"));
        String name = trim(req.getParameter("name"));
        String brand = trim(req.getParameter("brand"));
        String category = trim(req.getParameter("category"));
        String price = trim(req.getParameter("price"));
        String description = trim(req.getParameter("description"));
        String imageUrl = trim(req.getParameter("imageUrl"));
        boolean inStock = "on".equals(req.getParameter("inStock")) || "true".equals(req.getParameter("inStock"));

        if (id == null || id.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/supplements");
            return;
        }
        if (name == null || name.length() < 2) {
            Supplement s = supplementService.findById(id);
            req.setAttribute("supplement", s);
            req.setAttribute("error", "Product name must be at least 2 characters.");
            req.setAttribute("pageTitle", "Edit Supplement");
            req.getRequestDispatcher("/WEB-INF/views/supplement-form.jsp").forward(req, resp);
            return;
        }

        supplementService.update(id, name,
                brand != null ? brand : "",
                category != null ? category : "Other",
                price != null ? price : "0",
                description != null ? description : "",
                imageUrl != null ? imageUrl : "",
                inStock);
        resp.sendRedirect(req.getContextPath() + "/supplements?msg=updated");
    }

    private String trim(String val) {
        return val != null ? val.trim() : null;
    }
}
