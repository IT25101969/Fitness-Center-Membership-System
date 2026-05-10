package com.project.fcms.modules.shop.backend.repository;

import com.project.fcms.modules.shop.backend.model.Supplement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Spring Data JPA repository for {@link Supplement} entities.
 *
 */
@Repository
public interface SupplementRepository extends JpaRepository<Supplement, String> {
}
