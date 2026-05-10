-- =========================================================
-- FITNESS CENTER MEMBERSHIP SYSTEM (FCMS)
-- CORRECTED PROFESSIONAL MYSQL DATABASE
-- =========================================================

DROP DATABASE IF EXISTS fcms_db;

CREATE DATABASE fcms_db;

USE fcms_db;

-- =========================================================
-- MEMBERSHIP PLANS
-- =========================================================

CREATE TABLE membership_plans (

    plan_id VARCHAR(10) PRIMARY KEY,

    plan_name VARCHAR(100) NOT NULL,

    duration_days INT,

    price DECIMAL(10,2),

    class_access VARCHAR(20),

    features TEXT

);

-- =========================================================
-- TRAINERS
-- =========================================================

CREATE TABLE trainers (

    id VARCHAR(10) PRIMARY KEY,

    name VARCHAR(100),

    email VARCHAR(100),

    phone VARCHAR(20),

    specialization VARCHAR(100),

    certifications TEXT

);

-- =========================================================
-- MEMBERS
-- =========================================================

CREATE TABLE members (

    id VARCHAR(10) PRIMARY KEY,

    dtype VARCHAR(31) NOT NULL,

    name VARCHAR(100),

    email VARCHAR(100),

    phone VARCHAR(20),

    password VARCHAR(100),

    join_date DATE,

    status VARCHAR(20),

    type VARCHAR(20),

    locker_number INT,

    membership_plan_id VARCHAR(10),

    personal_trainer_id VARCHAR(10),

    CONSTRAINT fk_member_plan
        FOREIGN KEY (membership_plan_id)
        REFERENCES membership_plans(plan_id),

    CONSTRAINT fk_member_trainer
        FOREIGN KEY (personal_trainer_id)
        REFERENCES trainers(id)

);

-- =========================================================
-- FITNESS CLASSES
-- =========================================================

CREATE TABLE fitness_classes (

    class_id VARCHAR(10) PRIMARY KEY,

    class_name VARCHAR(100) NOT NULL,

    capacity INT,

    enrolled INT,

    schedule VARCHAR(50),

    status VARCHAR(20),

    trainer_id VARCHAR(10),

    CONSTRAINT fk_class_trainer
        FOREIGN KEY (trainer_id)
        REFERENCES trainers(id)

);

-- =========================================================
-- ENROLLMENTS
-- =========================================================

CREATE TABLE enrollments (

    enrollment_id VARCHAR(10) PRIMARY KEY,

    class_id VARCHAR(10),

    member_id VARCHAR(10),

    enroll_date DATE,

    CONSTRAINT fk_enrollment_member
        FOREIGN KEY (member_id)
        REFERENCES members(id),

    CONSTRAINT fk_enrollment_class
        FOREIGN KEY (class_id)
        REFERENCES fitness_classes(class_id)

);

-- =========================================================
-- ATTENDANCE
-- =========================================================

CREATE TABLE attendance (

    attendance_id VARCHAR(10) PRIMARY KEY,

    member_id VARCHAR(10),

    attendance_date DATE,

    check_in_time TIME,

    CONSTRAINT fk_attendance_member
        FOREIGN KEY (member_id)
        REFERENCES members(id)

);

-- =========================================================
-- EXERCISES
-- =========================================================

CREATE TABLE exercises (

    id VARCHAR(10) PRIMARY KEY,

    name VARCHAR(200) NOT NULL,

    category VARCHAR(50),

    muscle_group VARCHAR(50),

    equipment VARCHAR(100),

    description TEXT,

    styles TEXT

);

-- =========================================================
-- SUPPLEMENTS
-- =========================================================

CREATE TABLE supplements (

    id VARCHAR(10) PRIMARY KEY,

    name VARCHAR(200) NOT NULL,

    brand VARCHAR(100),

    category VARCHAR(50),

    description TEXT,

    image_url TEXT,

    in_stock BOOLEAN,

    price DECIMAL(10,2)

);

-- =========================================================
-- INSERT MEMBERSHIP PLANS
-- =========================================================

INSERT INTO membership_plans VALUES
('FREE_TRIAL','Free Trial',7,0,'LIMITED',
 'Gym Access|Locker'),

('P001','Basic Monthly',30,2500,'LIMITED',
 'Gym Access|Locker|Shower'),

('P002','Standard Monthly',30,4500,'UNLIMITED',
 'Gym Access|Locker|Shower|Group Classes|Sauna'),

('P003','Premium Monthly',30,7500,'UNLIMITED',
 'Gym Access|Locker|Shower|All Classes|Sauna|Personal Trainer|Nutrition Advice');

-- =========================================================
-- INSERT TRAINERS
-- =========================================================

INSERT INTO trainers VALUES
('T001','Ashan Jayawardena',
 'ashan.j@fcms.lk',
 '0771001001',
 'Strength Training|Bodybuilding',
 'NSCA Certified|CPR Certified'),

('T002','Kasun Bandara',
 'kasun.b@fcms.lk',
 '0772002002',
 'Cardio|HIIT',
 'ACE Certified|CPR Certified'),

('T003','Nadeesha Perera',
 'nadeesha.p@fcms.lk',
 '0773003003',
 'Zumba|Dance Fitness',
 'Zumba Instructor|ACE Certified');

-- =========================================================
-- INSERT MEMBERS
-- =========================================================

INSERT INTO members VALUES
('M001','STANDARD',
 'John Doe',
 'john.doe@mail.com',
 '0771234567',
 NULL,
 '2025-01-15',
 'ACTIVE',
 'STANDARD',
 NULL,
 'P002',
 'T001'),

('M002','STANDARD',
 'Sarah Perera',
 'sarah.perera@mail.com',
 '0779876543',
 NULL,
 '2025-02-01',
 'ACTIVE',
 'PREMIUM',
 NULL,
 'P003',
 'T002'),

('M003','STANDARD',
 'Kasun Silva',
 'kasun.silva@gmail.com',
 '0701122334',
 NULL,
 '2025-03-10',
 'ACTIVE',
 'STANDARD',
 NULL,
 'P001',
 NULL),

('M004','STANDARD',
 'Nimasha Fernando',
 'nimasha@mail.com',
 '0762233445',
 NULL,
 '2025-04-05',
 'INACTIVE',
 'STANDARD',
 NULL,
 'P002',
 NULL),

('M005','STANDARD',
 'Lakshan Wijesinghe',
 'lakshan@mail.com',
 '0753344556',
 NULL,
 '2025-04-20',
 'ACTIVE',
 'PREMIUM',
 NULL,
 'P003',
 'T003');

-- =========================================================
-- INSERT FITNESS CLASSES
-- =========================================================

INSERT INTO fitness_classes VALUES
('C002','Evening Cardio',
 25,25,'Tue 18:00',
 'FULL','T002'),

('C003','Strength Training',
 15,15,'Wed 09:00',
 'FULL','T001'),

('C004','Zumba Dance',
 30,12,'Thu 17:00',
 'OPEN','T003'),

('C005','Weekend HIIT',
 20,19,'Sat 08:00',
 'OPEN','T002');

-- =========================================================
-- INSERT ENROLLMENTS
-- =========================================================

INSERT INTO enrollments VALUES
('E001','C002','M001','2025-06-01'),
('E002','C002','M002','2025-06-01'),
('E003','C003','M003','2025-06-02'),
('E004','C004','M005','2025-06-03'),
('E005','C003','M002','2025-06-04');

-- =========================================================
-- INSERT ATTENDANCE
-- =========================================================

INSERT INTO attendance VALUES
('A001','M001','2025-06-10','07:35:22'),
('A002','M002','2025-06-10','08:12:05'),
('A003','M003','2025-06-10','09:00:41'),
('A004','M001','2025-06-11','07:28:15'),
('A005','M004','2025-06-11','10:05:33');

-- =========================================================
-- CHECK TABLES
-- =========================================================

SHOW TABLES;