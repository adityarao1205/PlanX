package com.src.ejb;

import java.util.Date;
import java.util.List;

import javax.ejb.Stateless;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;

import com.src.daoimpl.EventDaoImpl;
import com.src.model.Event;

/**
 * Stateless EJB providing higher-level event operations.
 * No-interface view (inject by class).
 */
@Stateless
public class EventServiceBean {

    private final EventDaoImpl dao = new EventDaoImpl(); // DAO uses DBConnection (ok inside EJB)

    /**
     * Create an event. If autoApprove==true, set status to APPROVED directly.
     */
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public boolean createEvent(Event e, boolean autoApprove) {
        if (autoApprove) {
            e.setStatus("APPROVED");
        } else {
            e.setStatus("PENDING");
        }
        return dao.createEvent(e);
    }

    public List<Event> getPendingEvents() {
        return dao.getPendingEvents();
    }

    public List<Event> getApprovedEvents() {
        return dao.getApprovedEvents();
    }

    /**
     * Approve or decline
     */
    public boolean approveEvent(int eventId) {
        return dao.approveEvent(eventId, "APPROVED");
    }

    public boolean declineEvent(int eventId) {
        return dao.approveEvent(eventId, "DECLINED");
    }

    /**
     * Remove events whose date is strictly before today (completed).
     * Returns number removed (optional: your DAO may implement deleteEventsBeforeDate).
     */
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public boolean deleteCompletedEvents() {
        try {
            // Implement a simple DAO helper (or add below) that deletes events with event_date < current_date
            return dao.deleteEventsBeforeDate(new java.sql.Date(new Date().getTime()));
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        }
    }

    /**
     * Helper to re-approve a previously declined event.
     */
    public boolean reapproveEvent(int eventId) {
        return dao.approveEvent(eventId, "APPROVED");
    }
}