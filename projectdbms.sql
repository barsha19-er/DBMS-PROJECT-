CREATE DATABASE project


--Train ticket booking system

CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15)
);
select *from Passengers;

CREATE TABLE Stations (
    station_id INT PRIMARY KEY,
    station_name VARCHAR(100),
    city VARCHAR(100) 
);
select *from Stations;


CREATE TABLE Trains (
    train_id INT PRIMARY KEY,
    train_name VARCHAR(100),
    source_station_id INT,
    destination_station_id INT,
    total_seats INT,
    ticket_price DECIMAL(10,2),
    FOREIGN KEY (source_station_id) REFERENCES Stations(station_id),
    FOREIGN KEY (destination_station_id) REFERENCES Stations(station_id)
);

select *from Trains;


CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    passenger_id INT,
    train_id INT,
    booking_date DATE,
    seat_number INT,
    status VARCHAR(20),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (train_id) REFERENCES Trains(train_id)
);

select *from Bookings;


CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    booking_id INT UNIQUE,
    amount DECIMAL(10,2),
    payment_date DATE,
    payment_method VARCHAR(50),
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);

select *from Payments;

INSERT INTO Stations VALUES
(11, 'Kathmandu Central', 'Kathmandu'),
(22, 'Pokhara station', 'Pokhara'),
(33, 'Butwal Station', 'Butwal'),
(44, 'Chitwan station', 'Chitwan'),
(55, 'Biratnagar station', 'Biratnagar'),
(66, 'Dang station', 'Dang') 
;
select *from Stations;

INSERT INTO Passengers VALUES
(1, 'Arjita yadav', 'arjita@gmail.com', '9809800001'),
(2, 'Sita poudel', 'sita@gmail.com', '9805500002'),
(3, 'anurup jha', 'anurup@gmail.com', '9822000003'),
(4, 'Barsha gyawali', 'barsha@gmail.com', '9803234524'),
(5, 'Bipin gyawali', 'bipin@gmail.com', '9834565435'),
(6, 'Maya Lama', 'maya@gmail.com', '9845637206');
select *from Passengers;

INSERT INTO Trains VALUES
(101, 'Himal Express', 11, 22, 200, 1500),
(102, 'Everest Express', 22, 33, 150, 1600),
(103, 'Lumbini Rail', 33, 55, 160, 1900),
(104, 'Terai Fast Track', 44, 11, 220, 1800),
(105, 'Mountain Rider', 55, 66, 230, 2000);

select *from Trains;


INSERT INTO Bookings VALUES
(1001, 1, 101, '2026-02-27', 12, 'Confirmed'),
(1002, 2, 102, '2026-03-02', 15, 'Confirmed'),
(1003, 3, 103, '2026-03-03', 20, 'Cancelled'),
(1004, 1, 104, '2026-03-04', 25, 'Confirmed'),
(1005, 4, 101, '2026-02-28', 30, 'Confirmed'),
(1006, 5, 105, '2026-02-26', 10, 'Cancelled'),
(1007, 2, 101, '2026-03-07', 18, 'Confirmed');

select *from Bookings;


INSERT INTO Payments VALUES
(501, 1001, 1500, '2026-03-01', 'Card'),
(502, 1002, 1800, '2026-02-27', 'Card'),
(503, 1003, 1900, '2026-03-03', 'Cash'),
(504, 1007, 1800, '2026-02-25', 'Cash'),
(505, 1006, 1600, '2026-03-05', 'Cash'),
(506, 1005, 2000, '2026-03-06', 'Card'),
(507, 1004, 1500, '2026-02-07', 'Card');

select *from Payments;

--INNER JOIN
--show booking detail with passengers and train:

SELECT P.name, T.train_name, B.seat_number, B.status
FROM Bookings B
INNER JOIN Passengers P ON B.passenger_id = P.passenger_id
INNER JOIN Trains T ON B.train_id = T.train_id;

--LEFT JOIN
--Show all passengers and their bookings:

SELECT P.name, B.booking_id
FROM Passengers P
LEFT JOIN Bookings B ON P.passenger_id = B.passenger_id;


--AGGREGATE  COUNT , GROUP BY
--Total bookings per train:

SELECT T.train_name, COUNT(B.booking_id) AS total_bookings
FROM Trains T
LEFT JOIN Bookings B ON T.train_id = B.train_id
GROUP BY T.train_name;

--SUM 
-- Total AMOUNT Per Train

SELECT T.train_name, SUM(P.amount) AS total_revenue
FROM Payments P
JOIN Bookings B ON P.booking_id = B.booking_id
JOIN Trains T ON B.train_id = T.train_id
GROUP BY T.train_name;


--AVG 
-- Average Ticket Price

SELECT AVG(ticket_price) AS average_ticket_price
FROM Trains;

--SUBQUERY
--Select the train that has the highest count.

SELECT train_name
FROM Trains
WHERE train_id = (
    SELECT TOP 1 train_id
    FROM Bookings
    GROUP BY train_id
    ORDER BY COUNT(*) DESC
);


--VIEW
--show Confirmed booking detail

CREATE VIEW ConfirmedBookingss AS
SELECT P.name, T.train_name, B.seat_number, Pay.amount
FROM Bookings B
JOIN Passengers P ON B.passenger_id = P.passenger_id
JOIN Trains T ON B.train_id = T.train_id
JOIN Payments Pay ON B.booking_id = Pay.booking_id
WHERE B.status = 'Confirmed';

SELECT * FROM ConfirmedBookingss;


--TRANSACTION
--Example using COMMIT

BEGIN TRANSACTION;
INSERT INTO Bookings(booking_id,passenger_id,train_id,booking_date,seat_number,status)
VALUES (106, 2, 103, '2026-03-07', 18, 'Confirmed');
INSERT INTO Payments(payment_id,booking_id,amount,payment_date,payment_method) 
VALUES (508, 106, 1800, '2026-02-08', 'Card');
COMMIT;


--Example using ROLLBACK

BEGIN TRANSACTION;

INSERT INTO Bookings(booking_id,passenger_id,train_id,booking_date,seat_number,status)
VALUES (107, 2, 103, '2026-03-07', 18, 'Confirmed');
ROLLBACK;
