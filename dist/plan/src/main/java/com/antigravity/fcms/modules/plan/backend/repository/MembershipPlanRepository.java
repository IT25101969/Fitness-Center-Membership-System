package com.antigravity.fcms.modules.plan.backend.repository;

import com.antigravity.fcms.modules.plan.backend.model.MembershipPlan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Spring Data JPA repository for {@link MembershipPlan} entities.
 *
 */
@Repository
public interface MembershipPlanRepository extends JpaRepository<MembershipPlan, String> {
}
