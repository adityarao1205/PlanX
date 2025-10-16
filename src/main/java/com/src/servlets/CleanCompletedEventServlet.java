package com.src.servlets;

import java.io.IOException;

import javax.ejb.EJB;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.src.ejb.EventServiceBean;

@WebServlet("/cleanCompleted")
public class CleanCompletedEventServlet extends HttpServlet {
    @EJB
    private EventServiceBean eventService;

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        boolean ok = eventService.deleteCompletedEvents();
        resp.sendRedirect("admin-home.jsp?msg=" + (ok ? "Completed+events+deleted" : "Delete+failed"));
    }
}
