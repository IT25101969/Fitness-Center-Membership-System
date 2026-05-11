package com.fcms.service;

import com.project.fcms.modules.trainer.backend.model.Trainer;
import com.project.fcms.modules.trainer.backend.repository.TrainerRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.logging.Logger;

/**
 * Service class providing CRUD operations for fitness trainers.
 * Uses Spring Data JPA for persistence.
 *
 */
@Service
public class TrainerService {

    private static final Logger LOGGER = Logger.getLogger(TrainerService.class.getName());

    private final TrainerRepository trainerRepository;

    public TrainerService(TrainerRepository trainerRepository) {
        this.trainerRepository = trainerRepository;
    }

    public Trainer create(String name, String email, String phone,
                          String specialization, String certifications) {
        String id = nextTrainerId();
        Trainer t = new Trainer(id, name, email, phone, specialization,
                certifications != null ? certifications : "");
        trainerRepository.save(t);
        LOGGER.info("Created trainer: " + id);
        return t;
    }

    public List<Trainer> findAll() {
        return trainerRepository.findAll();
    }

    public Trainer findById(String trainerId) {
        if (trainerId == null || trainerId.isEmpty()) return null;
        return trainerRepository.findById(trainerId).orElse(null);
    }

    public void update(String id, String name, String email, String phone,
                       String specialization, String certifications) {
        Trainer t = trainerRepository.findById(id).orElse(null);
        if (t == null) return;
        t.setName(name);
        t.setEmail(email);
        t.setPhone(phone);
        t.setSpecialization(specialization);
        t.setCertifications(certifications != null ? certifications : "");
        trainerRepository.save(t);
        LOGGER.info("Updated trainer: " + id);
    }

    public void delete(String trainerId) {
        trainerRepository.deleteById(trainerId);
        LOGGER.info("Deleted trainer: " + trainerId);
    }

    public String resolveTrainerName(String trainerId) {
        Trainer trainer = findById(trainerId);
        return (trainer != null) ? trainer.getName() : trainerId;
    }

    private String nextTrainerId() {
        List<Trainer> all = trainerRepository.findAll();
        int maxNum = 0;
        for (Trainer t : all) {
            String id = t.getId();
            if (id != null && id.startsWith("T")) {
                try {
                    int num = Integer.parseInt(id.substring(1));
                    if (num > maxNum) maxNum = num;
                } catch (NumberFormatException ignored) {}
            }
        }
        return "T" + String.format("%03d", maxNum + 1);
    }
}
