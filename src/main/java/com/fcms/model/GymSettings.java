package com.fcms.model;

import java.io.Serializable;

/**
 * Holds all configurable Gym Settings for the Fitness Center.
 * Stored as a ServletContext attribute so settings persist across requests
 * (in-memory; no database required for this feature).
 *
 */
public class GymSettings implements Serializable {

    private static final long serialVersionUID = 1L;

    // ── Branch Details ────────────────────────────────────────
    private String gymName      = "APEX FITNESS";
    private String address      = "28 St Michaels Rd, Colombo 00300";
    private String phone        = "+94 11 234 5678";
    private String email        = "hello@apexfitness.lk";
    private String tagline      = "Transform Your Body. Transform Your Life.";

    // ── Opening Hours ─────────────────────────────────────────
    private String hoursWeekdays = "5:00 AM – 11:00 PM";
    private String hoursWeekends = "6:00 AM – 10:00 PM";
    private String hoursHolidays = "7:00 AM – 8:00 PM";

    // ── Social & Web ──────────────────────────────────────────
    private String instagram    = "@apexfitness.lk";
    private String facebook     = "facebook.com/apexfitnesslk";
    private String whatsapp     = "+94 77 123 4567";
    private String mapsLink     = "https://maps.google.com/...";
    private String website      = "https://apexfitness.lk";

    // ── Business Config ───────────────────────────────────────
    private String currency     = "LKR";
    private String timezone     = "Asia/Colombo";
    private String language     = "en";

    // ── Admin credentials (in-memory only) ───────────────────
    private String adminUsername = "admin";
    private String adminPasswordHash = "admin123"; // plain for demo; hash in production

    // ── Notifications ─────────────────────────────────────────
    private boolean emailNotifications  = true;
    private boolean smsNotifications    = false;
    private boolean expiryAlerts        = true;
    private int     expiryAlertDays     = 7;

    // ── Feature Flags ─────────────────────────────────────────
    private boolean onlineBooking       = true;
    private boolean memberPortal        = true;
    private boolean publicSchedule      = true;

    /** Default constructor — all fields initialised to sensible defaults above. */
    public GymSettings() {}

    // ── Getters / Setters ─────────────────────────────────────

    public String getGymName()          { return gymName; }
    public void   setGymName(String v)  { this.gymName = v; }

    public String getAddress()          { return address; }
    public void   setAddress(String v)  { this.address = v; }

    public String getPhone()            { return phone; }
    public void   setPhone(String v)    { this.phone = v; }

    public String getEmail()            { return email; }
    public void   setEmail(String v)    { this.email = v; }

    public String getTagline()          { return tagline; }
    public void   setTagline(String v)  { this.tagline = v; }

    public String getHoursWeekdays()        { return hoursWeekdays; }
    public void   setHoursWeekdays(String v){ this.hoursWeekdays = v; }

    public String getHoursWeekends()        { return hoursWeekends; }
    public void   setHoursWeekends(String v){ this.hoursWeekends = v; }

    public String getHoursHolidays()        { return hoursHolidays; }
    public void   setHoursHolidays(String v){ this.hoursHolidays = v; }

    public String getInstagram()        { return instagram; }
    public void   setInstagram(String v){ this.instagram = v; }

    public String getFacebook()         { return facebook; }
    public void   setFacebook(String v) { this.facebook = v; }

    public String getWhatsapp()         { return whatsapp; }
    public void   setWhatsapp(String v) { this.whatsapp = v; }

    public String getMapsLink()         { return mapsLink; }
    public void   setMapsLink(String v) { this.mapsLink = v; }

    public String getWebsite()          { return website; }
    public void   setWebsite(String v)  { this.website = v; }

    public String getCurrency()         { return currency; }
    public void   setCurrency(String v) { this.currency = v; }

    public String getTimezone()         { return timezone; }
    public void   setTimezone(String v) { this.timezone = v; }

    public String getLanguage()         { return language; }
    public void   setLanguage(String v) { this.language = v; }

    public String getAdminUsername()         { return adminUsername; }
    public void   setAdminUsername(String v) { this.adminUsername = v; }

    public String getAdminPasswordHash()         { return adminPasswordHash; }
    public void   setAdminPasswordHash(String v) { this.adminPasswordHash = v; }

    public boolean isEmailNotifications()          { return emailNotifications; }
    public void    setEmailNotifications(boolean v){ this.emailNotifications = v; }

    public boolean isSmsNotifications()            { return smsNotifications; }
    public void    setSmsNotifications(boolean v)  { this.smsNotifications = v; }

    public boolean isExpiryAlerts()                { return expiryAlerts; }
    public void    setExpiryAlerts(boolean v)      { this.expiryAlerts = v; }

    public int  getExpiryAlertDays()               { return expiryAlertDays; }
    public void setExpiryAlertDays(int v)          { this.expiryAlertDays = v; }

    public boolean isOnlineBooking()               { return onlineBooking; }
    public void    setOnlineBooking(boolean v)     { this.onlineBooking = v; }

    public boolean isMemberPortal()                { return memberPortal; }
    public void    setMemberPortal(boolean v)      { this.memberPortal = v; }

    public boolean isPublicSchedule()              { return publicSchedule; }
    public void    setPublicSchedule(boolean v)    { this.publicSchedule = v; }
}
