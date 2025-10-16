package com.src.servlets;

import java.io.IOException;

import javax.ejb.EJB;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.src.ejb.EventServiceBean;

@WebServlet("/approveEvent")
public class ApproveEventServlet extends HttpServlet {
	@EJB
	private EventServiceBean eventService;

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
	    int eventId = Integer.parseInt(req.getParameter("eventId"));
	    String action = req.getParameter("action"); // approve / decline / reapprove or deleteCompleted
	    boolean ok = false;
	    if ("approve".equalsIgnoreCase(action)) ok = eventService.approveEvent(eventId);
	    else if ("decline".equalsIgnoreCase(action)) ok = eventService.declineEvent(eventId);
	    else if ("reapprove".equalsIgnoreCase(action)) ok = eventService.reapproveEvent(eventId);
	    // redirect back to admin home
	    try {
			resp.sendRedirect("admin-home.jsp?msg=" + (ok ? "Success" : "Failed"));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}