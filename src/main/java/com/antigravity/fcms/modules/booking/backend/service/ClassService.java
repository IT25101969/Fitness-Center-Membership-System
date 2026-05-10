package com.antigravity.fcms.modules.booking.backend.service;

import com.antigravity.fcms.modules.trainer.backend.service.TrainerService;
import com.antigravity.fcms.modules.workout.backend.model.FitnessClass;
import com.antigravity.fcms.modules.workout.backend.repository.FitnessClassRepository;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * Service class providing all business logic for fitness class management.
 * Uses Spring Data JPA for persistence.
 *
 */
@Service
public class ClassService {

    private static final Logger LOGGER = Logger.getLogger(ClassService.class.getName());

    private final FitnessClassRepository classRepository;
    private final TrainerService trainerService;

    public ClassService(FitnessClassRepository classRepository,
                        @Lazy TrainerService trainerService) {
        this.classRepository = classRepository;
        this.trainerService = trainerService;
    }

    public FitnessClass create(String className, String trainerId, String schedule, int capacity) {
        String id = nextClassId();
        FitnessClass fc = new FitnessClass(id, className, trainerId, schedule, capacity, 0, "OPEN");
        classRepository.save(fc);
        LOGGER.info("Created class: " + id);
        return fc;
    }

    public List<FitnessClass> findAll() {
        List<FitnessClass> classes = classRepository.findAll();
        classes.forEach(fc -> fc.setTrainerName(trainerService.resolveTrainerName(fc.getTrainerId())));
        return classes;
    }

    public FitnessClass findById(String classId) {
        FitnessClass fc = classRepository.findById(classId).orElse(null);
        if (fc != null) {
            fc.setTrainerName(trainerService.resolveTrainerName(fc.getTrainerId()));
        }
        return fc;
    }

    public void update(String classId, String className, String trainerId,
                       String schedule, int capacity, int enrolled, String status) {
        FitnessClass fc = classRepository.findById(classId).orElse(null);
        if (fc == null) return;
        fc.setClassName(className);
        fc.setTrainerId(trainerId);
        fc.setSchedule(schedule);
        fc.setCapacity(capacity);
        fc.setEnrolled(enrolled);
        fc.setStatus(status);
        classRepository.save(fc);
        LOGGER.info("Updated class: " + classId);
    }

    public void delete(String classId) {
        classRepository.deleteById(classId);
        LOGGER.info("Deleted class: " + classId);
    }

    public boolean incrementEnrolled(String classId) {
        FitnessClass fc = classRepository.findById(classId).orElse(null);
        if (fc == null || fc.isFull()) return false;
        fc.setEnrolled(fc.getEnrolled() + 1);
        if (fc.getEnrolled() >= fc.getCapacity()) fc.setStatus("FULL");
        classRepository.save(fc);
        return true;
    }

    public List<FitnessClass> findByDay(String dayAbbr) {
        List<FitnessClass> result = new ArrayList<>();
        for (FitnessClass fc : findAll()) {
            if (dayAbbr.equalsIgnoreCase(fc.getScheduleDay())) {
                result.add(fc);
            }
        }
        return result;
    }

    public List<FitnessClass> findToday() {
        String[] days = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
        java.util.Calendar cal = java.util.Calendar.getInstance();
        String today = days[cal.get(java.util.Calendar.DAY_OF_WEEK) - 1];
        return findByDay(today);
    }

    public int countAll() {
        return (int) classRepository.count();
    }

    private String nextClassId() {
        List<FitnessClass> all = classRepository.findAll();
        int maxNum = 0;
        for (FitnessClass fc : all) {
            String id = fc.getClassId();
            if (id != null && id.startsWith("C")) {
                try {
                    int num = Integer.parseInt(id.substring(1));
                    if (num > maxNum) maxNum = num;
                } catch (NumberFormatException ignored) {}
            }
        }
        return "C" + String.format("%03d", maxNum + 1);
    }
}
