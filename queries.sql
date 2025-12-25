-- Users Table
CREATE TABLE Users (
  user_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  role VARCHAR(20) CHECK (role IN ('Admin', 'Customer')) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(150) NOT NULL,
  phone VARCHAR(50)
);

-- Vehicles Table
CREATE TABLE Vehicles (
  vehicle_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  type VARCHAR(20) CHECK (type IN ('car', 'bike', 'truck')) NOT NULL,
  model VARCHAR(100) NOT NULL,
  registration_number VARCHAR(100) UNIQUE NOT NULL,
  rental_price DECIMAL(10, 2) NOT NULL,
  status VARCHAR(20) CHECK (status IN ('available', 'rented', 'maintenance')) NOT NULL
);

-- Bookings Table
CREATE TABLE Bookings (
  booking_id SERIAL PRIMARY KEY,
  user_id INT REFERENCES Users(user_id) NOT NULL,
  vehicle_id INT REFERENCES Vehicles(vehicle_id) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status VARCHAR(20) CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled')) NOT NULL,
  total_cost DECIMAL(10, 2) NOT NULL
);

-- Insert Users (5 users: 1 Admin, 4 Customers)
INSERT INTO Users (name, role, email, password, phone) VALUES
('Sarah Admin', 'Admin', 'admin@vehiclerental.com', '$2a$12$hashedpassword123', '+1-555-0001'),
('John Smith', 'Customer', 'john.smith@email.com', '$2a$12$hashedpassword456', '+1-555-0102'),
('Emily Chen', 'Customer', 'emily.chen@email.com', '$2a$12$hashedpassword789', '+1-555-0203'),
('Michael Brown', 'Customer', 'michael.b@email.com', '$2a$12$hashedpasswordabc', '+1-555-0304'),
('Lisa Anderson', 'Customer', 'lisa.a@email.com', '$2a$12$hashedpassworddef', '+1-555-0405');


-- Insert Vehicles (10 vehicles: 4 cars, 3 bikes, 3 trucks)
INSERT INTO Vehicles (name, type, model, registration_number, rental_price, status) VALUES
-- Cars
('Toyota Camry', 'car', '2023 LE', 'ABC-1234', 45.00, 'available'),
('Honda Accord', 'car', '2024 Sport', 'XYZ-5678', 50.00, 'rented'),
('Tesla Model 3', 'car', '2024 Long Range', 'TES-9999', 85.00, 'available'),
('Ford Mustang', 'car', '2023 GT', 'MUS-4567', 95.00, 'maintenance'),

-- Bikes
('Harley Davidson', 'bike', 'Street 750', 'HD-2468', 35.00, 'available'),
('Yamaha R15', 'bike', 'V4', 'YAM-1357', 25.00, 'available'),
('Kawasaki Ninja', 'bike', '400', 'KAW-8642', 40.00, 'rented'),

-- Trucks
('Ford F-150', 'truck', '2024 XLT', 'TRK-1111', 75.00, 'available'),
('Chevrolet Silverado', 'truck', '2023 LT', 'TRK-2222', 70.00, 'available'),
('Ram 1500', 'truck', '2024 Big Horn', 'TRK-3333', 80.00, 'maintenance');

-- Insert Bookings (8 bookings with various statuses)
INSERT INTO Bookings (user_id, vehicle_id, start_date, end_date, status, total_cost) VALUES
-- Confirmed bookings
(2, 1, '2025-01-05', '2025-01-08', 'confirmed', 135.00),  
(3, 5, '2025-01-10', '2025-01-12', 'confirmed', 70.00),  
(4, 8, '2025-01-15', '2025-01-20', 'confirmed', 375.00), 

-- Active/Rented bookings
(2, 2, '2025-12-23', '2025-12-27', 'confirmed', 200.00),  
(5, 7, '2025-12-24', '2025-12-26', 'confirmed', 80.00),   

-- Completed bookings
(3, 3, '2025-12-01', '2025-12-05', 'completed', 340.00), 
(2, 3, '2025-12-12', '2025-12-16', 'completed', 340.00),
(4, 6, '2025-12-10', '2025-12-12', 'completed', 50.00),   

-- Pending/Cancelled bookings
(5, 9, '2026-01-05', '2026-01-10', 'pending', 350.00),   
(2, 3, '2025-11-20', '2025-11-22', 'cancelled', 170.00); 


-- Query 01
select booking_id, u.name as customer_name, v.name as vehicle_name, start_date, end_date, v.status as status from Bookings b
 inner join Vehicles v using(vehicle_id)
 inner join Users u using(user_id);

-- Query 02
select * from vehicles v where NOT EXISTS ( select vehicle_id from Bookings b where b.vehicle_id = v.vehicle_id );

-- Query 03
select * from Vehicles v where v.status = 'available' and v.type = 'car';

-- Query 04
SELECT v.name AS vehicle_name, 
       COUNT(b.booking_id) AS total_bookings
FROM Bookings b
JOIN Vehicles v ON b.vehicle_id = v.vehicle_id
GROUP BY v.name
HAVING COUNT(b.booking_id) > 2;
