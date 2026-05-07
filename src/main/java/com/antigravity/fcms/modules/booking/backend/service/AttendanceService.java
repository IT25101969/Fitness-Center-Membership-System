package com.antigravity.fcms.modules.booking.backend.service;

import com.antigravity.fcms.modules.auth.backend.service.MemberService;
import com.antigravity.fcms.modules.booking.backend.model.Attendance;
import com.antigravity.fcms.modules.booking.backend.repository.AttendanceRepository;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.logging.Logger;
import java.util.stream.Collectors;

/**
 * Service class providing all business logic for attendance tracking.
 * Uses Spring Data JPA for persistence.
 *
 */
@Service
public class AttendanceService {

    private static final Logger LOGGER = Logger.getLogger(AttendanceService.class.getName());

    private final AttendanceRepository attendanceRepository;
    private final MemberService memberService;

    public AttendanceService(AttendanceRepository attendanceRepository,
                             @Lazy MemberService memberService) {
        this.attendanceRepository = attendanceRepository;
        this.memberService = memberService;
    }

    public Attendance checkIn(String memberId) {
        var member = memberService.findById(memberId);
        if (member == null) return null;

        String id = nextAttendanceId();
        String date = java.time.LocalDate.now().toString();
        String time = java.time.LocalTime.now().format(java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss"));

        Attendance att = new Attendance(id, memberId, date, time);
        attendanceRepository.save(att);
        LOGGER.info("Check-in recorded: " + id + " for member " + memberId);

        att.setMemberName(member.getName());
        return att;
    }

    public List<Attendance> findAll() {
        List<Attendance> list = attendanceRepository.findAll();
        list.forEach(this::resolveMemberName);
        return list;
    }

    public List<Attendance> findByDate(String date) {
        return findAll().stream()
                .filter(a -> date.equals(a.getDate()))
                .collect(Collectors.toList());
    }

    public List<Attendance> findToday() {
        return findByDate(java.time.LocalDate.now().toString());
    }

    public Map<String, Set<String>> monthlyFrequency(String yearMonth) {
        Map<String, Set<String>> freq = new LinkedHashMap<>();
        for (Attendance att : findAll()) {
            if (att.getDate().startsWith(yearMonth)) {
                freq.computeIfAbsent(att.getMemberId(), k -> new HashSet<>())
                    .add(att.getDate());
            }
        }
        return freq;
    }

    public long monthlyTotal(String yearMonth) {
        return findAll().stream()
                .filter(a -> a.getDate().startsWith(yearMonth))
                .count();
    }

    public long monthlyUniqueMembers(String yearMonth) {
        return findAll().stream()
                .filter(a -> a.getDate().startsWith(yearMonth))
                .map(Attendance::getMemberId)
                .distinct()
                .count();
    }

    public String peakDay(String yearMonth) {
        Map<String, Long> dayCounts = new HashMap<>();
        for (Attendance att : findAll()) {
            if (att.getDate().startsWith(yearMonth)) {
                dayCounts.merge(att.getDate(), 1L, Long::sum);
            }
        }
        return dayCounts.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse("N/A");
    }

    public int todayCount() {
        return findToday().size();
    }

    private void resolveMemberName(Attendance att) {
        var member = memberService.findById(att.getMemberId());
        if (member != null) att.setMemberName(member.getName());
        else att.setMemberName(att.getMemberId());
    }

    private String nextAttendanceId() {
        List<Attendance> all = attendanceRepository.findAll();
        int maxNum = 0;
        for (Attendance a : all) {
            String id = a.getAttendanceId();
            if (id != null && id.startsWith("A")) {
                try {
                    int num = Integer.parseInt(id.substring(1));
                    if (num > maxNum) maxNum = num;
                } catch (NumberFormatException ignored) {}
            }
        }
        return "A" + String.format("%03d", maxNum + 1);
    }
}
