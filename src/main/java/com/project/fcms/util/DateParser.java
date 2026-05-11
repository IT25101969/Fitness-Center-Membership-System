package com.project.fcms.util;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

/**
 * Utility class providing date and time parsing and formatting helpers.
 * Used across the service layer for consistent date operations.
 *
 */
public class DateParser {

    /** Standard date format used throughout FCMS. */
    public static final String DATE_FORMAT = "yyyy-MM-dd";

    /** Standard date-time format for attendance timestamps. */
    public static final String DATETIME_FORMAT = "HH:mm:ss";

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern(DATE_FORMAT);
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern(DATETIME_FORMAT);

    /**
     * Private constructor — utility class, no instantiation needed.
     */
    private DateParser() {}

    /**
     * Returns today's date as a formatted string.
     *
     * @return current date in yyyy-MM-dd format
     */
    public static String today() {
        return LocalDate.now().format(DATE_FORMATTER);
    }

    /**
     * Returns the current time as a formatted string.
     *
     * @return current time in HH:mm:ss format
     */
    public static String nowTime() {
        return LocalDateTime.now().format(TIME_FORMATTER);
    }

    /**
     * Parses a date string into a {@link LocalDate}.
     *
     * @param dateStr the date string in yyyy-MM-dd format
     * @return parsed LocalDate, or null if parsing fails
     */
    public static LocalDate parse(String dateStr) {
        try {
            return LocalDate.parse(dateStr, DATE_FORMATTER);
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    /**
     * Formats a {@link LocalDate} to the standard FCMS date string.
     *
     * @param date the date to format
     * @return formatted date string, or empty string if null
     */
    public static String format(LocalDate date) {
        if (date == null) return "";
        return date.format(DATE_FORMATTER);
    }

    /**
     * Extracts the month and year from a date string.
     *
     * @param dateStr the date string in yyyy-MM-dd format
     * @return "YYYY-MM" format string, or empty string on failure
     */
    public static String toYearMonth(String dateStr) {
        if (dateStr == null || dateStr.length() < 7) return "";
        return dateStr.substring(0, 7);
    }
}
