package com.ecotrack;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    // Encrypt the password before storing it in MySQL
    public static String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt(12));
    }

    // Check whether the entered password matches the stored hash
    public static boolean checkPassword(String password, String passwordHash) {
        return BCrypt.checkpw(password, passwordHash);
    }
}