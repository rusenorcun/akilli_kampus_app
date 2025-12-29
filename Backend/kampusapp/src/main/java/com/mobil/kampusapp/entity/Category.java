package com.mobil.kampusapp.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "categories", schema = "dbo")
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "category_id")
    private Long id;

    @Column(name = "category_name", length = 45)
    private String name;

    @Column(name = "icon_name", length = 100)
    private String iconName;

    public Category() {}

    public Long getId() { return id; }
    public String getName() { return name; }
    public String getIconName() { return iconName; }

    public void setId(Long id) { this.id = id; }
    public void setName(String name) { this.name = name; }
    public void setIconName(String iconName) { this.iconName = iconName; }
}
