package com.antigravity.fcms.modules.booking.backend.repository;

import com.antigravity.fcms.modules.booking.backend.model.Attendance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Spring Data JPA repository for {@link Attendance} entities.
 *
 */
@Repository
public interface AttendanceRepository extends JpaRepository<Attendance, String> {
}
