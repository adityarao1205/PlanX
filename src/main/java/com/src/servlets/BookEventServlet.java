package com.src.servlets;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.src.daoimpl.EventDaoImpl;
import com.src.model.Event;

@WebServlet("/BookEventServlet")
public class BookEventServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int eventId = Integer.parseInt(req.getParameter("eventId"));
        EventDaoImpl dao = new EventDaoImpl();
        Event e = null;

        for (Event ev : dao.getApprovedEvents()) {
            if (ev.getEventId() == eventId) {
                e = ev;
                break;
            }
        }

        req.setAttribute("event", e);
        RequestDispatcher rd = req.getRequestDispatcher("payment.jsp");
        rd.forward(req, resp);
    }
}