package com.antigravity.fcms.modules.booking.backend.repository;

import com.antigravity.fcms.modules.workout.backend.model.Exercise;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Spring Data JPA repository for {@link Exercise} entities.
 *
 */
@Repository
public interface ExerciseRepository extends JpaRepository<Exercise, String> {
}
