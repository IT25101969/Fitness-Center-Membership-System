package com.fcms.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Spring Data JPA repository for {@link MembershipPlan} entities.
 *
 */
@Repository
public interface MembershipPlan extends JpaRepository<MembershipPlan, String> {
}
