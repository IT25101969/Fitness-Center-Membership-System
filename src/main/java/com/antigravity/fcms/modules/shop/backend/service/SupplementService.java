package com.antigravity.fcms.modules.shop.backend.service;

import com.antigravity.fcms.modules.shop.backend.model.Supplement;
import com.antigravity.fcms.modules.shop.backend.repository.SupplementRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.logging.Logger;

/**
 * Service class providing CRUD operations for supplement products.
 * Uses Spring Data JPA for persistence.
 *
 */
@Service
public class SupplementService {

    private static final Logger LOGGER = Logger.getLogger(SupplementService.class.getName());

    private final SupplementRepository supplementRepository;

    public SupplementService(SupplementRepository supplementRepository) {
        this.supplementRepository = supplementRepository;
    }

    public Supplement create(String name, String brand, String category,
                             String price, String description, String imageUrl, boolean inStock) {
        String id = nextId();
        Supplement s = new Supplement(id, name, brand, category, price, description, imageUrl, inStock);
        supplementRepository.save(s);
        LOGGER.info("Created supplement: " + id);
        return s;
    }

    public List<Supplement> findAll() {
        return supplementRepository.findAll();
    }

    public Supplement findById(String supplementId) {
        if (supplementId == null || supplementId.isEmpty()) return null;
        return supplementRepository.findById(supplementId).orElse(null);
    }

    public void update(String id, String name, String brand, String category,
                       String price, String description, String imageUrl, boolean inStock) {
        Supplement s = supplementRepository.findById(id).orElse(null);
        if (s == null) return;
        s.setName(name);
        s.setBrand(brand);
        s.setCategory(category);
        s.setPrice(price);
        s.setDescription(description);
        s.setImageUrl(imageUrl);
        s.setInStock(inStock);
        supplementRepository.save(s);
        LOGGER.info("Updated supplement: " + id);
    }

    public void delete(String supplementId) {
        supplementRepository.deleteById(supplementId);
        LOGGER.info("Deleted supplement: " + supplementId);
    }

    private String nextId() {
        List<Supplement> all = supplementRepository.findAll();
        int maxNum = 0;
        for (Supplement s : all) {
            String id = s.getId();
            if (id != null && id.startsWith("S")) {
                try {
                    int num = Integer.parseInt(id.substring(1));
                    if (num > maxNum) maxNum = num;
                } catch (NumberFormatException ignored) {}
            }
        }
        return "S" + String.format("%03d", maxNum + 1);
    }
}
