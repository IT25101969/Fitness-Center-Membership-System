package com.antigravity.fcms.modules.booking.backend.repository;

import com.antigravity.fcms.modules.booking.backend.model.Enrollment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Spring Data JPA repository for {@link Enrollment} entities.
 *
 */
@Repository
public interface EnrollmentRepository extends JpaRepository<Enrollment, String> {
}
