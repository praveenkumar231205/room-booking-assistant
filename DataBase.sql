-- Switch to the correct database
USE room_booking;

-- Show existing tables
SHOW TABLES;

-- Create Rooms Table
CREATE TABLE IF NOT EXISTS rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    capacity INT NOT NULL,
    amenities TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'user') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Bookings Table
CREATE TABLE IF NOT EXISTS bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    status ENUM('confirmed', 'cancelled') DEFAULT 'confirmed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE
);

-- Insert Admin User
INSERT INTO users (name, email, password_hash, role) 
VALUES ('Admin', 'admin@example.com', 'hashedpassword123', 'admin')
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- Insert Sample Room
INSERT INTO rooms (name, capacity, amenities) 
VALUES ('Conference Room A', 10, 'Projector, Whiteboard, WiFi')
ON DUPLICATE KEY UPDATE capacity = VALUES(capacity), amenities = VALUES(amenities);

-- Insert Booking (Only if user and room exist)
INSERT INTO bookings (user_id, room_id, start_time, end_time)  
VALUES (
    (SELECT id FROM users WHERE email = 'admin@example.com' LIMIT 1),
    (SELECT id FROM rooms WHERE name = 'Conference Room A' LIMIT 1),
    '2025-02-28 10:00:00', '2025-02-28 11:00:00'
);

-- Verify Insertions
SELECT * FROM users;
SELECT * FROM rooms;
SELECT * FROM bookings;
