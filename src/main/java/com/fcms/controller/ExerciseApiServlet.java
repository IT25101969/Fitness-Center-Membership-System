package com.fcms.controller;

import com.project.fcms.modules.workout.backend.model.Exercise;
import com.project.fcms.modules.workout.backend.service.ExerciseService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import jakarta.servlet.ServletException;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Public JSON API for exercises (no auth required).
 *
 * <p>Routes:</p>
 * <ul>
 *   <li>GET /api/exercises → returns all exercises as JSON array</li>
 * </ul>
 *
 */
@WebServlet("/api/exercises")
public class ExerciseApiServlet extends HttpServlet {

    @Autowired
    private ExerciseService exerciseService;

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
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

        List<Exercise> exercises = exerciseService.findAll();
        PrintWriter out = resp.getWriter();
        out.print(toJson(exercises));
        out.flush();
    }

    private String toJson(List<Exercise> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) sb.append(",");
            Exercise e = list.get(i);
            sb.append("{");
            sb.append("\"id\":\"").append(esc(e.getId())).append("\",");
            sb.append("\"name\":\"").append(esc(e.getName())).append("\",");
            sb.append("\"desc\":\"").append(esc(e.getDescription())).append("\",");
            sb.append("\"m\":\"").append(esc(e.getMuscleGroup())).append("\",");
            sb.append("\"e\":\"").append(esc(e.getEquipment())).append("\",");
            sb.append("\"c\":\"").append(esc(e.getCategory())).append("\",");
            sb.append("\"slugId\":\"").append(esc(e.getSlugId())).append("\",");
            // styles as array
            sb.append("\"s\":[");
            String[] styles = e.getStylesArray();
            for (int j = 0; j < styles.length; j++) {
                if (j > 0) sb.append(",");
                sb.append("\"").append(esc(styles[j].trim())).append("\"");
            }
            sb.append("]");
            sb.append("}");
        }
        sb.append("]");
        return sb.toString();
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "");
    }
}
