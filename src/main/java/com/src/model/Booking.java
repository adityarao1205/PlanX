package com.src.model;

import java.util.Date;

public class Booking {
    private int bookingId;
    private int eventId;
    private int userId;
    private int noOfTickets;
    private double totalAmount;
    private String paymentStatus;
    private Date bookingTime;
	public int getBookingId() {
		return bookingId;
	}
	public void setBookingId(int bookingId) {
		this.bookingId = bookingId;
	}
	public int getEventId() {
		return eventId;
	}
	public void setEventId(int eventId) {
		this.eventId = eventId;
	}
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public int getNoOfTickets() {
		return noOfTickets;
	}
	public void setNoOfTickets(int noOfTickets) {
		this.noOfTickets = noOfTickets;
	}
	public double getTotalAmount() {
		return totalAmount;
	}
	public void setTotalAmount(double totalAmount) {
		this.totalAmount = totalAmount;
	}
	public String getPaymentStatus() {
		return paymentStatus;
	}
	public void setPaymentStatus(String paymentStatus) {
		this.paymentStatus = paymentStatus;
	}
	public Date getBookingTime() {
		return bookingTime;
	}
	public void setBookingTime(Date bookingTime) {
		this.bookingTime = bookingTime;
	}
	public Booking(int bookingId, int eventId, int userId, int noOfTickets, double totalAmount, String paymentStatus,
			Date bookingTime) {
		super();
		this.bookingId = bookingId;
		this.eventId = eventId;
		this.userId = userId;
		this.noOfTickets = noOfTickets;
		this.totalAmount = totalAmount;
		this.paymentStatus = paymentStatus;
		this.bookingTime = bookingTime;
	}

    // getters & setters
}