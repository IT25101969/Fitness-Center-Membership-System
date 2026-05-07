package com.antigravity.fcms.modules.shop.backend.model;

import jakarta.persistence.*;

/**
 * Represents a supplement product in the Fitness Center.
 *
 * <p>Supplements can be managed through the admin dashboard
 * and displayed on the public landing page.</p>
 *
 */
@Entity
@Table(name = "supplements")
public class Supplement {

    @Id
    @Column(length = 10)
    private String id;

    @Column(length = 200, nullable = false)
    private String name;

    @Column(length = 100)
    private String brand;

    @Column(length = 50)
    private String category;

    @Column(length = 20)
    private String price;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "image_url", columnDefinition = "TEXT")
    private String imageUrl;

    @Column(name = "in_stock")
    private boolean inStock;

    /** Default no-arg constructor. */
    public Supplement() {}

    /**
     * Full constructor for a Supplement.
     *
     * @param id          unique supplement ID (S001, S002, etc.)
     * @param name        product name
     * @param brand       manufacturer/brand name
     * @param category    product category (Protein, Creatine, Pre-Workout, etc.)
     * @param price       price as string (e.g., "8500.00")
     * @param description product description
     * @param imageUrl    URL to product image
     * @param inStock     whether the product is currently in stock
     */
    public Supplement(String id, String name, String brand, String category,
                      String price, String description, String imageUrl, boolean inStock) {
        this.id = id;
        this.name = name;
        this.brand = brand;
        this.category = category;
        this.price = price;
        this.description = description;
        this.imageUrl = imageUrl;
        this.inStock = inStock;
    }

    // -----------------------------------------------------------------------
    // Getters and Setters
    // -----------------------------------------------------------------------

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getPrice() { return price; }
    public void setPrice(String price) { this.price = price; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public boolean isInStock() { return inStock; }
    public void setInStock(boolean inStock) { this.inStock = inStock; }

    /**
     * Returns formatted price with "Rs." prefix.
     * @return formatted price string
     */
    public String getFormattedPrice() {
        try {
            double p = Double.parseDouble(price);
            return "Rs. " + String.format("%,.0f", p);
        } catch (Exception e) {
            return "Rs. " + price;
        }
    }
}
