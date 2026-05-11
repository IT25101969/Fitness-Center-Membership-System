package com.fcms.repository;

import com.antigravity.fcms.modules.auth.backend.model.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Spring Data JPA repository for {@link Member} entities.
 *
 */
@Repository
public interface MemberRepository extends JpaRepository<Member, String> {
}
