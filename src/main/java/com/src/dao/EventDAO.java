package com.src.dao;

import java.util.List;

import com.src.model.Event;

public interface EventDAO {
    boolean createEvent(Event e);
    List<Event> getEventsByOrganizer(int organizerId);
    List<Event> getPendingEvents();
    
    boolean updateEvent(Event e);
    boolean approveEvent(int eventId, String status);
    List<Event> getApprovedEvents();
}