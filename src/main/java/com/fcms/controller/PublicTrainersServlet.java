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
 * Public-facing servlet that displays all trainers to website visitors.
 * No authentication required — accessible from the landing page.
 */
@WebServlet("/our-trainers")
public class PublicTrainersServlet extends HttpServlet {

    @Autowired
    private TrainerService trainerService;

    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Trainer> trainers = trainerService.findAll();
        req.setAttribute("trainers", trainers);
        req.getRequestDispatcher("/WEB-INF/views/public-trainers.jsp").forward(req, resp);
    }
}
