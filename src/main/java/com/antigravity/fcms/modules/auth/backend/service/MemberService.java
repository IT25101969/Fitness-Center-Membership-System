package com.antigravity.fcms.modules.auth.backend.service;

import com.antigravity.fcms.modules.auth.backend.model.Member;
import com.antigravity.fcms.modules.auth.backend.repository.MemberRepository;
import com.antigravity.fcms.modules.plan.backend.model.MembershipPlan;
import com.antigravity.fcms.modules.plan.backend.service.PlanService;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.logging.Logger;

/**
 * Service class providing all business logic for member management.
 * Uses Spring Data JPA for persistence.
 *
 */
@Service
public class MemberService {

    private static final Logger LOGGER = Logger.getLogger(MemberService.class.getName());

    private final MemberRepository memberRepository;
    private final PlanService planService;

    public MemberService(MemberRepository memberRepository, PlanService planService) {
        this.memberRepository = memberRepository;
        this.planService = planService;
    }

    // -----------------------------------------------------------------------
    // CREATE
    // -----------------------------------------------------------------------

    public Member create(String name, String email, String phone,
                         String planId, String joinDate, String status, String type,
                         String password) {
        String id = nextMemberId();
        if (joinDate == null || joinDate.isEmpty()) {
            joinDate = java.time.LocalDate.now().toString();
        }
        Member m = new Member(id, name, email, phone, planId, joinDate, status, type);
        m.setPassword(password != null ? password : "");
        memberRepository.save(m);
        LOGGER.info("Created member: " + id);
        resolvePlanName(m);
        return m;
    }

    // -----------------------------------------------------------------------
    // READ ALL
    // -----------------------------------------------------------------------

    public List<Member> findAll() {
        List<Member> members = memberRepository.findAll();
        members.forEach(this::resolvePlanName);
        return members;
    }

    // -----------------------------------------------------------------------
    // FIND BY ID
    // -----------------------------------------------------------------------

    public Member findById(String memberId) {
        Member m = memberRepository.findById(memberId).orElse(null);
        if (m != null) resolvePlanName(m);
        return m;
    }

    // -----------------------------------------------------------------------
    // UPDATE
    // -----------------------------------------------------------------------

    public void update(String id, String name, String email, String phone,
                       String planId, String joinDate, String status, String type) {
        Member existing = memberRepository.findById(id).orElse(null);
        if (existing == null) return;
        existing.setName(name);
        existing.setEmail(email);
        existing.setPhone(phone);
        existing.setMembershipPlanId(planId);
        existing.setJoinDate(joinDate);
        existing.setStatus(status);
        existing.setType(type);
        memberRepository.save(existing);
        LOGGER.info("Updated member: " + id);
    }

    // -----------------------------------------------------------------------
    // DELETE
    // -----------------------------------------------------------------------

    public void delete(String memberId) {
        memberRepository.deleteById(memberId);
        LOGGER.info("Deleted member: " + memberId);
    }

    // -----------------------------------------------------------------------
    // HELPERS
    // -----------------------------------------------------------------------

    private void resolvePlanName(Member member) {
        if ("FREE_TRIAL".equals(member.getMembershipPlanId())) {
            member.setPlanName("7-Day Free Trial");
            return;
        }
        MembershipPlan plan = planService.findById(member.getMembershipPlanId());
        if (plan != null) member.setPlanName(plan.getPlanName());
    }

    public long countActive() {
        return findAll().stream().filter(Member::isActive).count();
    }

    public int countAll() {
        return (int) memberRepository.count();
    }

    public List<Member> findRecent(int n) {
        List<Member> all = findAll();
        int start = Math.max(0, all.size() - n);
        List<Member> recent = new ArrayList<>(all.subList(start, all.size()));
        java.util.Collections.reverse(recent);
        return recent;
    }

    public long countByPlan(String planId) {
        return findAll().stream()
                .filter(m -> planId.equalsIgnoreCase(m.getMembershipPlanId()))
                .count();
    }

    public double monthlyRevenue() {
        List<Member> members = findAll();
        double total = 0;
        for (Member m : members) {
            if (m.isActive()) {
                MembershipPlan plan = planService.findById(m.getMembershipPlanId());
                if (plan != null) total += plan.getPrice();
            }
        }
        return total;
    }

    private String nextMemberId() {
        List<Member> all = memberRepository.findAll();
        int maxNum = 0;
        for (Member m : all) {
            String id = m.getId();
            if (id != null && id.startsWith("M")) {
                try {
                    int num = Integer.parseInt(id.substring(1));
                    if (num > maxNum) maxNum = num;
                } catch (NumberFormatException ignored) {}
            }
        }
        return "M" + String.format("%03d", maxNum + 1);
    }
}
