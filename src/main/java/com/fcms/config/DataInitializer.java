package com.fcms.config;

import com.antigravity.fcms.dao.FileStorageService;
import com.antigravity.fcms.modules.auth.backend.model.Member;
import com.antigravity.fcms.modules.auth.backend.repository.MemberRepository;
import com.antigravity.fcms.modules.booking.backend.model.Attendance;
import com.antigravity.fcms.modules.booking.backend.model.Enrollment;
import com.antigravity.fcms.modules.booking.backend.repository.AttendanceRepository;
import com.antigravity.fcms.modules.booking.backend.repository.EnrollmentRepository;
import com.antigravity.fcms.modules.plan.backend.model.MembershipPlan;
import com.antigravity.fcms.modules.plan.backend.repository.MembershipPlanRepository;
import com.antigravity.fcms.modules.shop.backend.model.Supplement;
import com.antigravity.fcms.modules.shop.backend.repository.SupplementRepository;
import com.antigravity.fcms.modules.trainer.backend.model.Trainer;
import com.antigravity.fcms.modules.trainer.backend.repository.TrainerRepository;
import com.antigravity.fcms.modules.workout.backend.model.Exercise;
import com.antigravity.fcms.modules.workout.backend.model.FitnessClass;
import com.antigravity.fcms.modules.workout.backend.repository.ExerciseRepository;
import com.antigravity.fcms.modules.workout.backend.repository.FitnessClassRepository;
import com.fcms.util.FileUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

import java.io.File;
import java.util.List;
import java.util.logging.Logger;

/**
 * Initializes the database with data from CSV files on first startup.
 * Only imports data when the database tables are empty.
 *
 */
@Component
public class DataInitializer {

    private static final Logger LOGGER = Logger.getLogger(DataInitializer.class.getName());

    @Value("${app.data.path}")
    private String dataPath;

    private final FileStorageService csvStorage;
    private final MembershipPlanRepository planRepo;
    private final TrainerRepository trainerRepo;
    private final MemberRepository memberRepo;
    private final FitnessClassRepository classRepo;
    private final EnrollmentRepository enrollmentRepo;
    private final AttendanceRepository attendanceRepo;
    private final SupplementRepository supplementRepo;
    private final ExerciseRepository exerciseRepo;

    public DataInitializer(FileStorageService csvStorage,
                           MembershipPlanRepository planRepo,
                           TrainerRepository trainerRepo,
                           MemberRepository memberRepo,
                           FitnessClassRepository classRepo,
                           EnrollmentRepository enrollmentRepo,
                           AttendanceRepository attendanceRepo,
                           SupplementRepository supplementRepo,
                           ExerciseRepository exerciseRepo) {
        this.csvStorage = csvStorage;
        this.planRepo = planRepo;
        this.trainerRepo = trainerRepo;
        this.memberRepo = memberRepo;
        this.classRepo = classRepo;
        this.enrollmentRepo = enrollmentRepo;
        this.attendanceRepo = attendanceRepo;
        this.supplementRepo = supplementRepo;
        this.exerciseRepo = exerciseRepo;
    }

    /**
     * Runs at startup to migrate CSV data to MySQL if tables are empty.
     */
    @EventListener(ApplicationReadyEvent.class)
    public void migrateDataFromCsv() {
        LOGGER.info("DataInitializer: Checking for CSV data migration...");

        // Import order matters due to foreign key relationships
        importPlans();
        importTrainers();
        importMembers();
        importClasses();
        importEnrollments();
        importAttendance();
        importSupplements();
        importExercises();

        LOGGER.info("DataInitializer: Migration check complete.");
    }

    private void importPlans() {
        if (planRepo.count() > 0) return;
        String file = dataPath + "plans.csv";
        if (!new File(file).exists()) return;
        List<String[]> records = csvStorage.findAll(file);
        for (String[] r : records) {
            if (r.length < 6) continue;
            try {
                MembershipPlan p = new MembershipPlan(
                    FileUtil.safeGet(r, 0), FileUtil.safeGet(r, 1),
                    Double.parseDouble(FileUtil.safeGet(r, 2)),
                    Integer.parseInt(FileUtil.safeGet(r, 3)),
                    FileUtil.safeGet(r, 4), FileUtil.safeGet(r, 5)
                );
                planRepo.save(p);
            } catch (Exception e) {
                LOGGER.warning("Skip plan record: " + e.getMessage());
            }
        }
        LOGGER.info("Imported " + planRepo.count() + " plans from CSV");
    }

    private void importTrainers() {
        if (trainerRepo.count() > 0) return;
        String file = dataPath + "trainers.csv";
        if (!new File(file).exists()) return;
        List<String[]> records = csvStorage.findAll(file);
        for (String[] r : records) {
            if (r.length < 4) continue;
            Trainer t = new Trainer(
                FileUtil.safeGet(r, 0), FileUtil.safeGet(r, 1),
                FileUtil.safeGet(r, 2), FileUtil.safeGet(r, 3),
                FileUtil.safeGet(r, 4), FileUtil.safeGet(r, 5)
            );
            trainerRepo.save(t);
        }
        LOGGER.info("Imported " + trainerRepo.count() + " trainers from CSV");
    }

    private void importMembers() {
        if (memberRepo.count() > 0) return;
        String file = dataPath + "members.csv";
        if (!new File(file).exists()) return;
        List<String[]> records = csvStorage.findAll(file);
        for (String[] r : records) {
            if (r.length < 8) continue;
            Member m = new Member(
                FileUtil.safeGet(r, 0), FileUtil.safeGet(r, 1),
                FileUtil.safeGet(r, 2), FileUtil.safeGet(r, 3),
                FileUtil.safeGet(r, 4), FileUtil.safeGet(r, 5),
                FileUtil.safeGet(r, 6), FileUtil.safeGet(r, 7)
            );
            if (r.length > 8) m.setPassword(FileUtil.safeGet(r, 8));
            memberRepo.save(m);
        }
        LOGGER.info("Imported " + memberRepo.count() + " members from CSV");
    }

    private void importClasses() {
        if (classRepo.count() > 0) return;
        String file = dataPath + "classes.csv";
        if (!new File(file).exists()) return;
        List<String[]> records = csvStorage.findAll(file);
        for (String[] r : records) {
            if (r.length < 7) continue;
            try {
                FitnessClass fc = new FitnessClass(
                    FileUtil.safeGet(r, 0), FileUtil.safeGet(r, 1),
                    FileUtil.safeGet(r, 2), FileUtil.safeGet(r, 3),
                    Integer.parseInt(FileUtil.safeGet(r, 4)),
                    Integer.parseInt(FileUtil.safeGet(r, 5)),
                    FileUtil.safeGet(r, 6)
                );
                classRepo.save(fc);
            } catch (Exception e) {
                LOGGER.warning("Skip class record: " + e.getMessage());
            }
        }
        LOGGER.info("Imported " + classRepo.count() + " classes from CSV");
    }

    private void importEnrollments() {
        if (enrollmentRepo.count() > 0) return;
        String file = dataPath + "enrollments.csv";
        if (!new File(file).exists()) return;
        List<String[]> records = csvStorage.findAll(file);
        for (String[] r : records) {
            if (r.length < 4) continue;
            Enrollment e = new Enrollment(
                FileUtil.safeGet(r, 0), FileUtil.safeGet(r, 1),
                FileUtil.safeGet(r, 2), FileUtil.safeGet(r, 3)
            );
            enrollmentRepo.save(e);
        }
        LOGGER.info("Imported " + enrollmentRepo.count() + " enrollments from CSV");
    }

    private void importAttendance() {
        if (attendanceRepo.count() > 0) return;
        String file = dataPath + "attendance.txt";
        if (!new File(file).exists()) return;
        List<String[]> records = csvStorage.findAll(file);
        for (String[] r : records) {
            if (r.length < 4) continue;
            Attendance a = new Attendance(
                FileUtil.safeGet(r, 0), FileUtil.safeGet(r, 1),
                FileUtil.safeGet(r, 2), FileUtil.safeGet(r, 3)
            );
            attendanceRepo.save(a);
        }
        LOGGER.info("Imported " + attendanceRepo.count() + " attendance records from CSV");
    }

    private void importSupplements() {
        if (supplementRepo.count() > 0) return;
        String file = dataPath + "supplements.csv";
        if (!new File(file).exists()) return;
        List<String[]> records = csvStorage.findAll(file);
        for (String[] r : records) {
            if (r.length < 6) continue;
            Supplement s = new Supplement(
                FileUtil.safeGet(r, 0), FileUtil.safeGet(r, 1),
                FileUtil.safeGet(r, 2), FileUtil.safeGet(r, 3),
                FileUtil.safeGet(r, 4), FileUtil.safeGet(r, 5),
                FileUtil.safeGet(r, 6),
                "true".equalsIgnoreCase(FileUtil.safeGet(r, 7))
            );
            supplementRepo.save(s);
        }
        LOGGER.info("Imported " + supplementRepo.count() + " supplements from CSV");
    }

    private void importExercises() {
        if (exerciseRepo.count() > 0) return;
        String file = dataPath + "exercises.csv";
        if (!new File(file).exists()) return;
        List<String[]> records = csvStorage.findAll(file);
        for (String[] r : records) {
            if (r.length < 5) continue;
            Exercise ex = new Exercise(
                FileUtil.safeGet(r, 0), FileUtil.safeGet(r, 1),
                FileUtil.safeGet(r, 2), FileUtil.safeGet(r, 3),
                FileUtil.safeGet(r, 4), FileUtil.safeGet(r, 5),
                FileUtil.safeGet(r, 6)
            );
            exerciseRepo.save(ex);
        }
        LOGGER.info("Imported " + exerciseRepo.count() + " exercises from CSV");
    }
}
