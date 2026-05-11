package com.fcms.controller;

import com.project.fcms.modules.workout.backend.model.FitnessClass;
import com.project.fcms.modules.workout.backend.service.ClassService;
import com.project.fcms.modules.trainer.backend.model.Trainer;
import com.project.fcms.modules.trainer.backend.service.TrainerService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import jakarta.servlet.ServletException;
import java.io.IOException;
import java.util.List;

/**
 * Public JSON API that returns live class data for the landing page.
 * No authentication required.
 */
@WebServlet("/api/classes")
public class ClassApiServlet extends HttpServlet {

    @Autowired
    private ClassService classService;

    @Autowired
    private TrainerService trainerService;

    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        // Allow CORS for local dev
        resp.setHeader("Access-Control-Allow-Origin", "*");

        List<FitnessClass> classes = classService.findAll();

        StringBuilder json = new StringBuilder("[");
        boolean first = true;
        for (FitnessClass fc : classes) {
            if (!first) json.append(",");
            first = false;

            // Resolve trainer name
            String trainerName = "TBA";
            if (fc.getTrainerId() != null) {
                Trainer t = trainerService.findById(fc.getTrainerId());
                if (t != null) trainerName = t.getName();
            }

            int available = Math.max(0, fc.getCapacity() - fc.getEnrolled());
            int pct = fc.getCapacityPercent();

            json.append("{")
                .append("\"id\":\"").append(esc(fc.getClassId())).append("\",")
                .append("\"name\":\"").append(esc(fc.getClassName())).append("\",")
                .append("\"trainer\":\"").append(esc(trainerName)).append("\",")
                .append("\"day\":\"").append(esc(fc.getScheduleDay())).append("\",")
                .append("\"time\":\"").append(esc(fc.getScheduleTime())).append("\",")
                .append("\"capacity\":").append(fc.getCapacity()).append(",")
                .append("\"enrolled\":").append(fc.getEnrolled()).append(",")
                .append("\"available\":").append(available).append(",")
                .append("\"pct\":").append(pct).append(",")
                .append("\"status\":\"").append(esc(fc.getStatus())).append("\",")
                .append("\"full\":").append(fc.isFull())
                .append("}");
        }
        json.append("]");

        resp.getWriter().write(json.toString());
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
