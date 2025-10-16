package com.src.util;

import java.lang.reflect.Method;
import com.src.model.Event;

public class ReflectionApi{
    public static void main(String[] args) {
        try {
            // Dynamically load the Event class
            Class<?> cls = Class.forName("com.src.model.Event");

            // Create a new instance dynamically
            Object obj = cls.getDeclaredConstructor().newInstance();

            // Get the setEventName() method
            Method setName = cls.getMethod("setEventName", String.class);

            // Invoke the setter dynamically
            setName.invoke(obj, "Reflection TechFest");

            // Get the getEventName() method and invoke it
            Method getName = cls.getMethod("getEventName");
            String eventName = (String) getName.invoke(obj);

            System.out.println("Dynamically created event using Reflection:");
            System.out.println("Event Name = " + eventName);

            // Print all methods
            System.out.println("\nAll Methods in Event class:");
            for (Method m : cls.getDeclaredMethods()) {
                System.out.println(" - " + m.getName());
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}