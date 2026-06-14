-- Football Ticket Booking System Database Setup Template

-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

--CREATE USERS TABLE
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20),
    
    -- role constraint
    CONSTRAINT check_user_role CHECK (role IN ('Ticket Manager', 'Football Fan'))
);

-- CREATE MATCHES TABLE
CREATE TABLE Matches (
    match_id INT PRIMARY KEY,
    fixture VARCHAR(150) NOT NULL,
    tournament_category VARCHAR(100) NOT NULL,
    base_ticket_price DECIMAL(10, 2) NOT NULL,
    match_status VARCHAR(50) NOT NULL,
    
    -- ensure 'total_cost' is non-negative
    CONSTRAINT check_ticket_price CHECK (base_ticket_price >= 0),
    -- match_status constraint
    CONSTRAINT check_match_status CHECK (match_status IN ('Available', 'Selling Fast', 'Sold Out', 'Postponed'))
);

-- CREATE BOOKINGS TABLE
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    user_id INT,
    match_id INT,
    seat_number VARCHAR(10),
    payment_status VARCHAR(50),
    total_cost DECIMAL(10, 2) NOT NULL,
    
    -- Foreign Key
    CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_booking_match FOREIGN KEY (match_id) REFERENCES Matches(match_id) ON DELETE CASCADE,
    
    -- ensure 'total_cost' is non-negative
    CONSTRAINT check_total_cost CHECK (total_cost >= 0),
    -- constraint to restrict 'payment_status' values
    CONSTRAINT check_payment_status CHECK (payment_status IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded'))
);

-- Insert Users Data
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);

INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');

INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);

-- Query: 1
select match_id, fixture, base_ticket_price from matches
 where tournament_category = 'Champions League'
 and match_status = 'Available'

-- Query: 2
select user_id, full_name, email 
from Users
where full_name like 'Tanvir%'
 or full_name ilike '%Haque%';

-- Query: 3
select booking_id, user_id, match_id,
  coalesce(payment_status, 'Action Required') as systematic_status
from bookings
where payment_status is null;

-- Query: 4  
select b.booking_id, u.full_name, m.fixture, b.total_cost
from bookings b
inner join users u on b.user_id = u.user_id 
inner join matches m on b.match_id = m.match_id;
