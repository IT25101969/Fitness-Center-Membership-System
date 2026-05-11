package com.fcms.service;

import com.project.fcms.modules.workout.backend.model.Exercise;
import com.project.fcms.modules.workout.backend.repository.ExerciseRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.logging.Logger;

/**
 * Service class providing CRUD operations for exercises.
 * Uses Spring Data JPA for persistence.
 *
 */
@Service
public class ExerciseService {

    private static final Logger LOGGER = Logger.getLogger(ExerciseService.class.getName());

    private final ExerciseRepository exerciseRepository;

    public ExerciseService(ExerciseRepository exerciseRepository) {
        this.exerciseRepository = exerciseRepository;
    }

    public Exercise create(String name, String description, String muscleGroup,
                           String equipment, String category, String styles) {
        String id = nextId();
        Exercise ex = new Exercise(id, name, description, muscleGroup, equipment, category, styles);
        exerciseRepository.save(ex);
        LOGGER.info("Created exercise: " + id + " - " + name);
        return ex;
    }

    public List<Exercise> findAll() {
        return exerciseRepository.findAll();
    }

    public Exercise findById(String exerciseId) {
        if (exerciseId == null || exerciseId.isEmpty()) return null;
        return exerciseRepository.findById(exerciseId).orElse(null);
    }

    public void update(String id, String name, String description, String muscleGroup,
                       String equipment, String category, String styles) {
        Exercise ex = exerciseRepository.findById(id).orElse(null);
        if (ex == null) return;
        ex.setName(name);
        ex.setDescription(description);
        ex.setMuscleGroup(muscleGroup);
        ex.setEquipment(equipment);
        ex.setCategory(category);
        ex.setStyles(styles);
        exerciseRepository.save(ex);
        LOGGER.info("Updated exercise: " + id);
    }

    public void delete(String exerciseId) {
        exerciseRepository.deleteById(exerciseId);
        LOGGER.info("Deleted exercise: " + exerciseId);
    }

    private String nextId() {
        List<Exercise> all = exerciseRepository.findAll();
        int maxNum = 0;
        for (Exercise ex : all) {
            String id = ex.getId();
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
