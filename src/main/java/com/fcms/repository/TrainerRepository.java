package com.project.fcms.modules.trainer.backend.repository;

import com.project.fcms.modules.trainer.backend.model.Trainer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Spring Data JPA repository for {@link Trainer} entities.
 *
 */
@Repository
public interface TrainerRepository extends JpaRepository<Trainer, String> {
}
