package com.antigravity.fcms.modules.booking.backend.controller;

import com.antigravity.fcms.modules.booking.backend.model.Attendance;
import com.antigravity.fcms.modules.booking.backend.service.AttendanceService;
import com.antigravity.fcms.util.DateParser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Servlet handling attendance check-in and reporting routes.
 *
 * <p>Routes handled:</p>
 * <ul>
 *   <li>GET  /attendance         → daily check-in view</li>
 *   <li>POST /attendance/checkin → record a check-in</li>
 *   <li>GET  /attendance/report  → monthly report view</li>
 * </ul>
 *
 */
@WebServlet("/attendance/*")
public class AttendanceServlet extends HttpServlet {

    @Autowired private AttendanceService attendanceService;

    @Override
    public void init() throws ServletException {
        super.init();
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, getServletContext());
    }

    /**
     * Handles GET requests for attendance routes.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/";

        switch (pathInfo) {
            case "/report" -> showReport(req, resp);
            default -> showAttendancePage(req, resp);
        }
    }

    /**
     * Handles POST requests for attendance routes.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/";

        switch (pathInfo) {
            case "/checkin" -> processCheckIn(req, resp);
            default -> resp.sendRedirect(req.getContextPath() + "/attendance");
        }
    }

    // -----------------------------------------------------------------------
    // PRIVATE HANDLERS
    // -----------------------------------------------------------------------

    /**
     * Renders the attendance check-in page.
     * Loads today's attendance or a date-picker-selected day's records.
     */
    private void showAttendancePage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String date = req.getParameter("date");
        if (date == null || date.isEmpty()) date = DateParser.today();

        List<Attendance> records = attendanceService.findByDate(date);
        req.setAttribute("attendanceList", records);
        req.setAttribute("selectedDate", date);
        req.setAttribute("today", DateParser.today());
        req.setAttribute("pageTitle", "Attendance Check-In");
        req.getRequestDispatcher("/WEB-INF/views/attendance.jsp").forward(req, resp);
    }

    /**
     * Processes a member check-in submission.
     * Validates the member ID before recording.
     */
    private void processCheckIn(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String memberId = req.getParameter("memberId");
        if (memberId == null || memberId.trim().isEmpty()) {
            req.setAttribute("error", "Member ID is required.");
            showAttendancePage(req, resp);
            return;
        }

        Attendance att = attendanceService.checkIn(memberId.trim().toUpperCase());
        if (att == null) {
            req.setAttribute("error", "Member not found: " + memberId);
            showAttendancePage(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/attendance?msg=checkin_success");
    }

    /**
     * Renders the monthly attendance report page.
     */
    private void showReport(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String yearMonth = req.getParameter("yearMonth");
        if (yearMonth == null || yearMonth.isEmpty()) {
            yearMonth = DateParser.today().substring(0, 7); // YYYY-MM
        }

        long totalCheckIns = attendanceService.monthlyTotal(yearMonth);
        long uniqueMembers = attendanceService.monthlyUniqueMembers(yearMonth);
        String peakDay = attendanceService.peakDay(yearMonth);
        Map<String, Set<String>> frequency = attendanceService.monthlyFrequency(yearMonth);

        req.setAttribute("yearMonth", yearMonth);
        req.setAttribute("totalCheckIns", totalCheckIns);
        req.setAttribute("uniqueMembers", uniqueMembers);
        req.setAttribute("peakDay", peakDay);
        req.setAttribute("frequency", frequency);
        req.setAttribute("pageTitle", "Attendance Report — " + yearMonth);
        req.getRequestDispatcher("/WEB-INF/views/attendance-report.jsp").forward(req, resp);
    }
}
