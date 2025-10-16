package com.src.dao;

import com.src.model.User;
import java.util.List;

public interface UserDAO {
    User findByEmailAndPassword(String email, String password);
    boolean registerUser(User user);
    
    // ✅ New method
    List<User> getAllUsers(); 
}
