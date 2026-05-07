package com.antigravity.fcms.modules.booking.backend.service;

import com.antigravity.fcms.modules.booking.backend.model.Enrollment;
import com.antigravity.fcms.modules.booking.backend.repository.EnrollmentRepository;
import com.antigravity.fcms.modules.workout.backend.service.ClassService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.logging.Logger;
import java.util.stream.Collectors;

/**
 * Service class providing business logic for class enrollment management.
 * Uses Spring Data JPA for persistence.
 *
 */
@Service
public class EnrollmentService {

    private static final Logger LOGGER = Logger.getLogger(EnrollmentService.class.getName());

    private final EnrollmentRepository enrollmentRepository;
    private final ClassService classService;

    public EnrollmentService(EnrollmentRepository enrollmentRepository, ClassService classService) {
        this.enrollmentRepository = enrollmentRepository;
        this.classService = classService;
    }

    public Enrollment enroll(String memberId, String classId) {
        if (!classService.incrementEnrolled(classId)) {
            LOGGER.warning("Class is full or not found: " + classId);
            return null;
        }
        String id = nextEnrollmentId();
        String date = java.time.LocalDate.now().toString();
        Enrollment e = new Enrollment(id, memberId, classId, date);
        enrollmentRepository.save(e);
        LOGGER.info("Enrolled member " + memberId + " in class " + classId);
        return e;
    }

    public List<Enrollment> findAll() {
        return enrollmentRepository.findAll();
    }

    public List<Enrollment> findByClass(String classId) {
        return findAll().stream()
                .filter(e -> classId.equalsIgnoreCase(e.getClassId()))
                .collect(Collectors.toList());
    }

    public List<Enrollment> findByMember(String memberId) {
        return findAll().stream()
                .filter(e -> memberId.equalsIgnoreCase(e.getMemberId()))
                .collect(Collectors.toList());
    }

    public void delete(String enrollmentId) {
        enrollmentRepository.deleteById(enrollmentId);
        LOGGER.info("Deleted enrollment: " + enrollmentId);
    }

    private String nextEnrollmentId() {
        List<Enrollment> all = enrollmentRepository.findAll();
        int maxNum = 0;
        for (Enrollment e : all) {
            String id = e.getEnrollmentId();
            if (id != null && id.startsWith("E")) {
                try {
                    int num = Integer.parseInt(id.substring(1));
                    if (num > maxNum) maxNum = num;
                } catch (NumberFormatException ignored) {}
            }
        }
        return "E" + String.format("%03d", maxNum + 1);
    }
}
