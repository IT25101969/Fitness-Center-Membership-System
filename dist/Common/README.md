# Fitness Center Membership System (FCMS)
### Antigravity Software | Project v1.0

![Java](https://img.shields.io/badge/Java-17-orange?style=flat-square&logo=java)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.5-brightgreen?style=flat-square&logo=springboot)
![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3-purple?style=flat-square&logo=bootstrap)
![Maven](https://img.shields.io/badge/Maven-Build-red?style=flat-square&logo=apachemaven)

A fully functional web-based Fitness Center Membership System built with **Spring Boot**, **JSP/Servlet**, **Bootstrap 5**, and **CSV flat-file storage** — no database required.

---

## 🚀 Quick Start

### Prerequisites
- Java 17+
- Maven 3.8+
- IntelliJ IDEA (recommended)

### Run the Application

```bash
# 1. Clone the repository
git clone https://github.com/antigravity/fcms.git
cd fcms

# 2. Build with Maven
mvn clean install

# 3. Run the Spring Boot application
mvn spring-boot:run
```

Open your browser at **http://localhost:8080/**

> The `/data/` directory contains seed CSV files and is created automatically if missing.

---

## 📁 Project Structure

```
src/
├── main/
│   ├── java/com/antigravity/fcms/
│   │   ├── FcmsApplication.java         # Spring Boot entry point
│   │   ├── model/                       # POJO classes (Person hierarchy)
│   │   │   ├── Person.java              # Abstract base class
│   │   │   ├── Member.java
│   │   │   ├── PremiumMember.java
│   │   │   ├── Trainer.java
│   │   │   ├── Admin.java
│   │   │   ├── MembershipPlan.java
│   │   │   ├── FitnessClass.java
│   │   │   ├── Attendance.java
│   │   │   └── Enrollment.java
│   │   ├── dao/
│   │   │   ├── StorageService.java      # Interface (abstraction)
│   │   │   └── FileStorageService.java  # CSV CRUD implementation
│   │   ├── service/
│   │   │   ├── MemberService.java
│   │   │   ├── PlanService.java
│   │   │   ├── ClassService.java
│   │   │   ├── AttendanceService.java
│   │   │   └── EnrollmentService.java
│   │   ├── servlet/
│   │   │   ├── HomeServlet.java
│   │   │   ├── MemberServlet.java
│   │   │   ├── PlanServlet.java
│   │   │   ├── ClassServlet.java
│   │   │   ├── AttendanceServlet.java
│   │   │   └── EnrollServlet.java
│   │   └── util/
│   │       ├── IdGenerator.java
│   │       ├── DateParser.java
│   │       └── FileUtil.java
│   ├── resources/
│   │   └── application.properties
│   └── webapp/
│       ├── WEB-INF/views/               # All JSP views
│       │   ├── navbar.jsp               # Shared navbar partial
│       │   ├── dashboard.jsp            # UI-01: Admin Dashboard
│       │   ├── member-list.jsp          # UI-02: Member Management
│       │   ├── member-form.jsp          # UI-03: Member Form (create/edit)
│       │   ├── plan-list.jsp            # UI-04: Plan Cards
│       │   ├── plan-form.jsp            # Plan Edit Form
│       │   ├── class-schedule.jsp       # UI-05: Weekly Schedule
│       │   ├── attendance.jsp           # UI-06: Check-In
│       │   └── attendance-report.jsp    # UI-07: Monthly Report
│       └── static/
│           ├── css/style.css            # Custom design system
│           └── js/fcms.js              # Client-side JS
data/
├── members.csv                          # Member records (seed: 5)
├── plans.csv                            # Plan records (seed: 3)
├── classes.csv                          # Class records (seed: 5)
├── attendance.txt                       # Attendance logs (seed: 10)
└── enrollments.csv                      # Enrollment records (seed: 5)
```

---

## 🌐 URL Routes

| URL | Method | Description |
|-----|--------|-------------|
| `/` | GET | Admin Dashboard |
| `/members` | GET | Member list |
| `/members/new` | GET | New member form |
| `/members/create` | POST | Save new member |
| `/members/edit?id=M001` | GET | Edit member form |
| `/members/update` | POST | Update member |
| `/members/delete?id=M001` | GET | Delete member |
| `/plans` | GET | Plan card grid |
| `/plans/create` | POST | Save new plan |
| `/plans/edit?id=P001` | GET | Edit plan |
| `/plans/update` | POST | Update plan |
| `/plans/delete?id=P001` | GET | Delete plan |
| `/classes` | GET | Weekly schedule |
| `/classes/create` | POST | Create class |
| `/enrollments/enroll` | POST | Enroll member in class |
| `/attendance` | GET | Daily check-in page |
| `/attendance/checkin` | POST | Record check-in |
| `/attendance/report` | GET | Monthly report |

---

## 🏗 OOP Design

```
Person (abstract)
├── Member          extends Person
│   └── PremiumMember extends Member
├── Trainer         extends Person
└── Admin           extends Person

StorageService (interface — Abstraction)
└── FileStorageService implements StorageService
```

**Pillars applied:**
- **Encapsulation** — All fields private, public getters/setters only
- **Inheritance** — Person → Member → PremiumMember, Trainer, Admin
- **Polymorphism** — `getDetails()` overridden in every subclass
- **Abstraction** — `StorageService` interface decouples DAO from services

---

## 📦 Data Files (CSV Schema)

```
members.csv:      memberId, name, email, phone, planId, joinDate, status, type
plans.csv:        planId, planName, price, durationDays, classAccess, features(|)
classes.csv:      classId, className, trainerId, schedule, capacity, enrolled, status
attendance.txt:   attendanceId, memberId, date, checkInTime
enrollments.csv:  enrollmentId, memberId, classId, enrollDate
```

---

## 🧪 Running Tests

```bash
mvn test
```

Test cases covered:
| TC | Description |
|----|-------------|
| TC-05 | `FileStorageService.save()` — appends line correctly |
| TC-06 | `FileStorageService.update()` — replaces only target row |
| TC-07 | `FileStorageService.delete()` — removes target, keeps others |
| TC-08 | CSV parser handles quoted fields with commas |

---

## 🎨 Design System

| Token | Value | Usage |
|-------|-------|-------|
| `--primary-dark` | `#1A1A2E` | Navbar, sidebar |
| `--accent-blue` | `#0F3460` | Buttons, links |
| `--accent-red` | `#E94560` | CTAs, danger |
| `--success-green` | `#27AE60` | Active badges |
| `--warning-yellow` | `#F39C12` | Expiring warnings |

Font: **Poppins** (Google Fonts)

---

## 📋 Git Strategy

```
main        ← Production-ready only (phase milestones)
develop     ← Integration branch

feature/member-crud
feature/plan-management
feature/class-scheduling
fix/attendance-csv-write
ui/dashboard-layout
docs/readme-update
```

Commit format: `[type]: description` (feat|fix|ui|docs|refactor|test|chore)

---

## ⚙ Configuration

```properties
# application.properties
spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp
server.port=8080
app.data.path=./data/
```

---

## 📄 License

Proprietary — Antigravity Software © 2025. All rights reserved.
