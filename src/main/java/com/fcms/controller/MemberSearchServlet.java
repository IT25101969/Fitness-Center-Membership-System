package com.fcms.controller;

import com.antigravity.fcms.modules.auth.backend.model.Member;
import com.antigravity.fcms.modules.auth.backend.service.FileBasedMemberService;
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
 * Servlet handling server-side member search operations.
 *
 * <p>Demonstrates the READ operation of CRUD using file handling.
 * Searches members.csv directly via {@link FileBasedMemberService#search(String)}
 * and renders results in member-search.jsp.</p>
 *
 * <p>Routes:</p>
 * <ul>
 *   <li>GET  /members/search          → renders the search form</li>
 *   <li>GET  /members/search?q=keyword → returns filtered results from CSV</li>
 * </ul>
 *
 */
@WebServlet("/members/search")
public class MemberSearchServlet extends HttpServlet {

    @Autowired
    private FileBasedMemberService fileBasedMemberService;

    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, getServletContext());
    }

    /**
     * Handles GET /members/search?q={keyword}
     *
     * <p>Reads the search query from the request parameter {@code q},
     * delegates to {@link FileBasedMemberService#search(String)} which reads
     * directly from {@code members.csv}, and forwards results to the JSP view.</p>
     *
     * @param req  the HTTP request containing optional query param {@code q}
     * @param resp the HTTP response
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String keyword = req.getParameter("q");
        boolean hasQuery = (keyword != null && !keyword.trim().isEmpty());

        List<Member> results = hasQuery
                ? fileBasedMemberService.search(keyword)
                : null; // No results until user submits a query

        req.setAttribute("keyword", keyword != null ? keyword : "");
        req.setAttribute("results", results);
        req.setAttribute("hasQuery", hasQuery);
        req.setAttribute("resultCount", results != null ? results.size() : 0);
        req.setAttribute("pageTitle", "Search Members");

        req.getRequestDispatcher("/WEB-INF/views/member-search.jsp").forward(req, resp);
    }
}
