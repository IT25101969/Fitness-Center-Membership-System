package com.antigravity.fcms.modules.plan.backend.service;

import com.antigravity.fcms.modules.plan.backend.model.MembershipPlan;
import com.antigravity.fcms.modules.plan.backend.repository.MembershipPlanRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.logging.Logger;

/**
 * Service class providing all business logic for membership plan management.
 * Uses Spring Data JPA for persistence.
 *
 */
@Service
public class PlanService {

    private static final Logger LOGGER = Logger.getLogger(PlanService.class.getName());

    private final MembershipPlanRepository planRepository;

    public PlanService(MembershipPlanRepository planRepository) {
        this.planRepository = planRepository;
    }

    public MembershipPlan create(String planName, double price, int durationDays,
                                  String classAccess, String features) {
        String id = nextPlanId();
        MembershipPlan plan = new MembershipPlan(id, planName, price, durationDays, classAccess, features);
        planRepository.save(plan);
        LOGGER.info("Created plan: " + id);
        return plan;
    }

    public List<MembershipPlan> findAll() {
        return planRepository.findAll();
    }

    public MembershipPlan findById(String planId) {
        if (planId == null || planId.isEmpty()) return null;
        return planRepository.findById(planId).orElse(null);
    }

    public void update(String planId, String planName, double price, int durationDays,
                       String classAccess, String features) {
        MembershipPlan plan = planRepository.findById(planId).orElse(null);
        if (plan == null) return;
        plan.setPlanName(planName);
        plan.setPrice(price);
        plan.setDurationDays(durationDays);
        plan.setClassAccess(classAccess);
        plan.setFeatures(features);
        planRepository.save(plan);
        LOGGER.info("Updated plan: " + planId);
    }

    public void delete(String planId) {
        planRepository.deleteById(planId);
        LOGGER.info("Deleted plan: " + planId);
    }

    public int countAll() {
        return (int) planRepository.count();
    }

    private String nextPlanId() {
        List<MembershipPlan> all = planRepository.findAll();
        int maxNum = 0;
        for (MembershipPlan p : all) {
            String id = p.getPlanId();
            if (id != null && id.startsWith("P")) {
                try {
                    int num = Integer.parseInt(id.substring(1));
                    if (num > maxNum) maxNum = num;
                } catch (NumberFormatException ignored) {}
            }
        }
        return "P" + String.format("%03d", maxNum + 1);
    }
}
