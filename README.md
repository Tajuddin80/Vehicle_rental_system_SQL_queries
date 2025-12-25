# 🚗 Vehicle Rental Management System - Database

A comprehensive PostgreSQL database system for managing vehicle rentals, users, and bookings. This project demonstrates advanced SQL concepts including JOINs, subqueries, aggregations, and referential integrity.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Database Schema](#database-schema)
- [Installation](#installation)
- [Sample Queries](#sample-queries)
- [Query Explanations](#query-explanations)
- [Technologies Used](#technologies-used)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Overview

This Vehicle Rental Management System is a database-driven solution designed to handle the complete lifecycle of vehicle rentals. It manages:

- **User Management**: Admin and customer accounts with role-based access
- **Fleet Management**: Cars, bikes, and trucks with real-time availability tracking
- **Booking System**: Complete rental transaction management from pending to completed

The system enforces data integrity through foreign keys, constraints, and business rules, making it suitable for real-world rental applications.

---

## ✨ Features

- ✅ **Multi-Role User System** - Separate admin and customer roles
- ✅ **Diverse Vehicle Fleet** - Support for cars, bikes, and trucks
- ✅ **Status Tracking** - Real-time vehicle availability (available, rented, maintenance)
- ✅ **Booking Lifecycle** - Pending, confirmed, completed, and cancelled statuses
- ✅ **Data Integrity** - Foreign key constraints and validation rules
- ✅ **Cost Calculation** - Automated total cost based on rental duration
- ✅ **Advanced Queries** - JOINs, subqueries, aggregations, and filtering

---

## 📊 Database Schema

### Tables

#### 1️⃣ Users Table
```sql
user_id (PK) | name | role | email (UNIQUE) | password | phone
```
- Stores admin and customer information
- Email uniqueness enforced
- Passwords stored in hashed format

#### 2️⃣ Vehicles Table
```sql
vehicle_id (PK) | name | type | model | registration_number (UNIQUE) | rental_price | status
```
- Manages vehicle inventory
- Three types: car, bike, truck
- Three statuses: available, rented, maintenance

#### 3️⃣ Bookings Table
```sql
booking_id (PK) | user_id (FK) | vehicle_id (FK) | start_date | end_date | status | total_cost
```
- Records all rental transactions
- Links users to vehicles
- Tracks booking status and costs

### Entity Relationships
```
Users (1) ────< (Many) Bookings (Many) >──── (1) Vehicles
```

---

## 🚀 Installation

### Prerequisites

- PostgreSQL 12+ installed
- pgAdmin or psql command-line tool
- Basic SQL knowledge

### Setup Steps

1. **Clone or download this repository**
```bash
   git clone <your-repo-url>
   cd vehicle-rental-db
```

2. **Create a new database**
```sql
   CREATE DATABASE vehicle_rental_db;
```

3. **Connect to the database**
```bash
   psql -U postgres -d vehicle_rental_db
```

4. **Execute the schema file**
```bash
   psql -U postgres -d vehicle_rental_db -f queries.sql
```
   
   Or manually run the SQL commands in the following order:
   - Create Tables (Users → Vehicles → Bookings)
   - Insert Sample Data

5. **Verify installation**
```sql
   \dt  -- List all tables
   SELECT COUNT(*) FROM Users;    -- Should return 5
   SELECT COUNT(*) FROM Vehicles; -- Should return 10
   SELECT COUNT(*) FROM Bookings; -- Should return 10
```

---

## 📝 Sample Queries

### Query 1: Display All Bookings with Details (INNER JOIN)
```sql
SELECT 
    booking_id, 
    u.name AS customer_name, 
    v.name AS vehicle_name, 
    start_date, 
    end_date, 
    b.status AS booking_status
FROM Bookings b
INNER JOIN Vehicles v USING(vehicle_id)
INNER JOIN Users u USING(user_id);
```

**Purpose**: Retrieve complete booking information with readable customer and vehicle names.

---

### Query 2: Find Vehicles Never Booked (NOT EXISTS)
```sql
SELECT * 
FROM Vehicles v 
WHERE NOT EXISTS (
    SELECT 1 
    FROM Bookings b 
    WHERE b.vehicle_id = v.vehicle_id
);
```

**Purpose**: Identify vehicles that have never been rented (useful for inventory analysis).

---

### Query 3: Find Available Cars (WHERE Clause)
```sql
SELECT * 
FROM Vehicles v 
WHERE v.status = 'available' 
  AND v.type = 'car';
```

**Purpose**: Show all cars currently available for rent (customer search functionality).

---

### Query 4: Find Popular Vehicles (GROUP BY & HAVING)
```sql
SELECT 
    v.name AS vehicle_name, 
    COUNT(b.booking_id) AS total_bookings
FROM Bookings b
JOIN Vehicles v ON b.vehicle_id = v.vehicle_id
GROUP BY v.name
HAVING COUNT(b.booking_id) > 2;
```

**Purpose**: Identify vehicles with more than 2 bookings (high-demand inventory).

---

## 🔍 Query Explanations

### Query 1: INNER JOIN - Complete Booking View

**Concept**: Combines three tables to show complete booking information.

**How it works**:
- Joins `Bookings` with `Vehicles` using `vehicle_id`
- Joins result with `Users` using `user_id`
- Only returns rows where matches exist in all three tables
- Provides human-readable names instead of ID numbers

**Real-world use**: Generate booking reports for management, customer service lookups, or invoice generation.

---

### Query 2: NOT EXISTS - Unused Inventory

**Concept**: Uses a correlated subquery to find vehicles without bookings.

**How it works**:
- For each vehicle in `Vehicles` table
- Checks if ANY booking exists in `Bookings` table with that `vehicle_id`
- If subquery returns no rows, vehicle is included in results
- `NOT EXISTS` is more efficient than `LEFT JOIN` for existence checks

**Real-world use**: Identify underperforming inventory for marketing campaigns, price adjustments, or fleet optimization.

---

### Query 3: WHERE Clause - Filtered Search

**Concept**: Basic filtering to find specific vehicles.

**How it works**:
- `WHERE` clause filters rows BEFORE any processing
- Two conditions with `AND`: both must be true
- Returns only cars (`type = 'car'`) that are available (`status = 'available'`)

**Real-world use**: Customer-facing search feature when users want to rent a specific vehicle type.

---

### Query 4: GROUP BY & HAVING - Aggregated Analysis

**Concept**: Groups data and filters based on aggregate calculations.

**How it works**:
- `JOIN`: Combines Bookings and Vehicles tables
- `GROUP BY v.name`: Groups all bookings by vehicle name
- `COUNT(b.booking_id)`: Counts bookings per vehicle
- `HAVING`: Filters groups where count > 2 (executes AFTER grouping)

**Key difference**: `WHERE` filters rows before grouping, `HAVING` filters groups after aggregation.

**Real-world use**: Business intelligence for fleet management - identify popular vehicles for:
- Purchasing more similar models
- Dynamic pricing strategies
- Maintenance prioritization
- Revenue analysis

---

## 🛠 Technologies Used

- **Database**: PostgreSQL 12+
- **Language**: SQL (Structured Query Language)
- **Concepts Demonstrated**:
  - DDL (Data Definition Language) - CREATE TABLE
  - DML (Data Manipulation Language) - INSERT, SELECT
  - Constraints (PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK)
  - JOINs (INNER JOIN)
  - Subqueries (Correlated subquery with NOT EXISTS)
  - Aggregation (COUNT, GROUP BY, HAVING)
  - Filtering (WHERE clause)

---

## 📈 Sample Data

**Users**: 5 total (1 Admin, 4 Customers)  
**Vehicles**: 10 total (4 Cars, 3 Bikes, 3 Trucks)  
**Bookings**: 10 total (Various statuses across past, present, and future dates)

---

## 🔐 Security Features

- ✅ Passwords stored with bcrypt hashing ($2a$12$ prefix)
- ✅ Email uniqueness prevents duplicate accounts
- ✅ Registration number uniqueness prevents duplicate vehicles
- ✅ Role-based access control (Admin vs Customer)
- ✅ Foreign key constraints prevent orphaned records

---

## 📚 Learning Objectives

This project demonstrates proficiency in:

1. **Database Design**: Normalized schema with proper relationships
2. **Data Integrity**: Foreign keys, constraints, and validation
3. **Complex Queries**: JOINs, subqueries, and aggregations
4. **Business Logic**: Status management and cost calculations
5. **Real-world Application**: Practical rental management system

---

## 🚧 Future Enhancements

Potential improvements for production use:

- [ ] Add `Payments` table for transaction tracking
- [ ] Create `Maintenance_History` table for vehicle service records
- [ ] Implement `Reviews` table for customer feedback
- [ ] Add database indexes for query optimization
- [ ] Create stored procedures for common operations
- [ ] Build views for frequently accessed data combinations
- [ ] Add triggers for automatic status updates
- [ ] Implement date validation (end_date > start_date)
- [ ] Add pricing tiers based on rental duration

---

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👤 Author

**Your Name**
- GitHub: [https://github.com/Tajuddin80/](https://github.com/Tajuddin80/)
- LinkedIn: [https://www.linkedin.com/in/tajuddin80/](https://www.linkedin.com/in/tajuddin80/)
- Email: tajuddin.cse.dev@gmail.com

---

## 📞 Support

For questions or issues:
- Open an issue in the GitHub repository
- Contact via email
- Check existing documentation

---

## ⭐ Acknowledgments

- PostgreSQL Documentation
- Database Design Best Practices
- SQL Query Optimization Techniques

---

## 📸 Screenshots

### Database Schema Diagram
```
┌─────────────┐         ┌──────────────┐         ┌─────────────┐
│    Users    │         │   Bookings   │         │  Vehicles   │
├─────────────┤         ├──────────────┤         ├─────────────┤
│ user_id (PK)│←───────│ user_id (FK) │         │vehicle_id   │
│ name        │         │ vehicle_id   │────────→│   (PK)      │
│ role        │         │   (FK)       │         │ name        │
│ email       │         │ start_date   │         │ type        │
│ password    │         │ end_date     │         │ status      │
│ phone       │         │ status       │         │ price       │
└─────────────┘         │ total_cost   │         └─────────────┘
                        └──────────────┘
```

---

**⚡ Quick Start**: Clone → Create DB → Run queries.sql → Query!

**📖 Full Documentation**: See [queries.sql](https://github.com/Tajuddin80/Vehicle_rental_system_SQL_queries/blob/main/queries.sql) for complete implementation.

