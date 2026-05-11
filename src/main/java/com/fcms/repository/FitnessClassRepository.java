package com.fcms.repository;

import com.project.fcms.modules.workout.backend.model.FitnessClass;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Spring Data JPA repository for {@link FitnessClass} entities.
 *
 */
@Repository
public interface FitnessClassRepository extends JpaRepository<FitnessClass, String> {
}
