-- https://drawsql.app/1968/diagrams/air-bnb-2#
-- https://www.youtube.com/watch?v=Cz3WcZLRaWc

-- @block
CREATE TABLE users(
  id INT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) NOT NULL UNIQUE, 
  bio TEXT, 
  country VARCHAR(2)
);

-- @block
INSERT INTO users(email, bio, country)
VALUES (
  'hola@monde.com',
  'grande nino hoy',
  'MX'
),
('bonjour@munda.com',
 'bar',
 'FR'
),
(
  'auchtung@germany.com',
  'biz',
  'GR'
)

-- @BLOCK
insert into users(email, bio, country)
VALUES (
  'poorman@japan.jp.co',
  'Japanese peasant',
  'JP'
);

-- @BLOCK
CREATE TABLE rooms(
  id INT AUTO_INCREMENT,
  street VARCHAR(255),
  owner_user_id INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (owner_user_id) REFERENCES users(id)
)

-- @block
CREATE INDEX email_index ON users(email);

-- @BLOCK -- street is the name of structure (not a street name)
INSERT INTO rooms(owner_user_id, street)
VALUES
  (1, 'san diego sailboat'),
  (1, 'nantucket cottage'),
  (1, 'vail cabin'),
  (1, 'sf cardboard box'),
  (2, 'mexican villa'),
  (3, 'French mansion'),
  (3, 'French cottage'),
  (4, 'German castle'),
  (4, 'German attic');

-- @BLOCK
CREATE TABLE bookings(
  id INT AUTO_INCREMENT,
  guest_id INT NOT NULL,
  room_id INT NOT NULL,
  check_in DATETIME,
  PRIMARY KEY (id),
  FOREIGN KEY (guest_id) REFERENCES users(id),
  FOREIGN KEY (room_id) REFERENCES rooms(owner_user_id)
);

-- @BLOCK
INSERT INTO bookings(guest_id, room_id, check_in)
VALUES
  (1, 2, '2013-10-01T11:12:07'),
  (2, 3, '2014-04-02T01:22:28'),
  (4, 3, '2015-02-03T14:32:49'),
  (1, 4, '2016-12-04T06:42:10');

-- @block
CREATE TABLE orders(
  customerid CHAR(15) NOT NULL,
  freight FLOAT NOT NULL
)

-- @BLOCK
ALTER TABLE orders
ADD shipcountry varchar(255);

-- @BLOCK
UPDATE orders
SET shipcountry='USA'
WHERE customerid='EVERGREEN';

-- @BLOCK
INSERT INTO orders(customerid, freight)
VALUES
  ('VINET', 32.32),
  ('HANAR', 16),
  ('QUICKSHIP', 23),
  ('EVERGREEN', 56);

-- @BLOCK
INSERT INTO orders(customerid, freight, shipcountry)
VALUES
  ('VINET', 15, 'Mexico'),
  ('VINET', 6, 'Mexico'),
  ('QUICKSHIP', 12, 'USA'),
  ('QUICKSHIP', 4, 'USA');


-- @BLOCK
SELECT customerid, freight, shipcountry, (SELECT AVG(freight) FROM ORDERS) 
FROM orders;

-- @BLOCK -- get number of orders per customer per country
SELECT customerid, shipcountry, COUNT(*) as num_orders 
FROM orders
GROUP BY customerid, shipcountry;

-- @BLOCK -- get avg number of orders per country
SELECT shipcountry, AVG(num_orders) FROM
  (SELECT customerid, shipcountry, COUNT(*) as num_orders 
   FROM orders
   GROUP BY customerid, shipcountry) SUB
GROUP BY shipcountry;

-- @BLOCK -- get number of orders per customer per country
SELECT * FROM
  (SELECT customerid, shipcountry, COUNT(*) as num_orders 
   FROM orders
   GROUP BY 1,2) SUB;

-- @BLOCK -- get # of orders for each customerid with orders>2
SELECT customerid, count(*)
FROM orders
GROUP BY customerid
HAVING COUNT(*) > 2
ORDER by COUNT(*) DESC;

-- @BLOCK
SELECT * FROM bookings;

-- @block
SHOW COLUMNS FROM bookings;

-- @block
DESCRIBE users;

-- @block
DESCRIBE rooms;

-- @block
SHOW COLUMNS FROM users;

-- @block
SHOW INDEXES FROM users;


-- @BLOCK
select * from users;

-- @BLOCK
select * from rooms;

-- @block
select email, id from users
ORDER BY id ASC
limit 2;

-- @block
select email, id from users
WHERE country = 'US'
OR id > 1
ORDER BY id DESC
limit 2;

-- @block
select email, id from users
WHERE country = 'US'
AND email LIKE 'hello%'
ORDER BY id DESC
limit 2;


-- @BLOCK
SELECT * FROM users
INNER JOIN rooms
ON rooms.owner_user_id = users.id;

-- @BLOCK
SELECT * FROM users
LEFT JOIN rooms
ON rooms.owner_user_id = users.id;

-- @BLOCK
SELECT * FROM users
RIGHT JOIN rooms
ON rooms.owner_user_id = users.id;

-- @BLOCK Renames the columns with the AS operator
SELECT 
  users.id AS user_id,
  rooms.owner_user_id as room_user_id,
  email,
  street
FROM users
INNER JOIN rooms on rooms.owner_user_id = users.id;

-- @BLOCK Which rooms a user(guest) has booked
SELECT 
  guest_id,
  rooms.id as room_id,
  street,
  check_in
FROM bookings
INNER JOIN rooms ON bookings.room_id = rooms.id
WHERE guest_id = 1;

-- @BLOCK Which guests have stayed in a specifc room
SELECT 
  room_id,
  guest_id,
  email,
  bio
FROM bookings
INNER JOIN users ON users.id = guest_id
WHERE room_id = 3;

-- @BLOCK room street & guest email for rooms that are booked by a specific guest
SELECT 
  guest_id,
  room_id,
  street,
  email
FROM bookings 
--   ^table         source             external table match
INNER JOIN rooms ON bookings.room_id = rooms.id
INNER JOIN users ON bookings.guest_id = users.id
-- WHERE is from bookings
WHERE room_id = 3; 