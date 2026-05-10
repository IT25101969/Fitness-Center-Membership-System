package com.antigravity.fcms;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * Main entry point for the Fitness Center Membership System (FCMS).
 * Bootstraps the Spring Boot application with embedded Tomcat.
 *
 * <p>{@code @ServletComponentScan} enables auto-registration of all
 * {@code @WebServlet}, {@code @WebFilter}, and {@code @WebListener} annotations.</p>
 *
 * <p>Run this class to start the server at http://localhost:8080/</p>
 *
 */
@SpringBootApplication
@ServletComponentScan("com.antigravity.fcms.modules")
public class FcmsApplication extends SpringBootServletInitializer {

    /**
     * Application entry point.
     *
     * @param args command-line arguments
     */
    public static void main(String[] args) {
        SpringApplication.run(FcmsApplication.class, args);
    }
}
