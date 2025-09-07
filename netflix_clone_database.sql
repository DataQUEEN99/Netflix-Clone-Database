--users
CREATE TABLE users(
user_id SERIAL PRIMARY KEY,
name VARCHAR(100),
email VARCHAR(150) UNIQUE NOT NULL,
join_date DATE DEFAULT CURRENT_DATE
);
SELECT * FROM users;



-- Subscription Plans

CREATE TABLE subscription_plans (
    plan_id SERIAL PRIMARY KEY,
    plan_name VARCHAR(50),
    price DECIMAL(5,2),
    resolution VARCHAR(20),  -- e.g., HD, 4K
    max_devices INT
);



-- Payments
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    plan_id INT REFERENCES subscription_plans(plan_id),
    payment_date DATE DEFAULT CURRENT_DATE,
    amount DECIMAL(5,2)
);


-- Genres
CREATE TABLE genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(50)
);




-- Movies
CREATE TABLE movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(150),
    release_year INT,
    genre_id INT REFERENCES genres(genre_id),
    duration INT  -- in minutes
);

-- Ratings
CREATE TABLE ratings (
    rating_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    movie_id INT REFERENCES movies(movie_id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    rating_date DATE DEFAULT CURRENT_DATE
);

-- Viewing History
CREATE TABLE viewing_history (
    history_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    movie_id INT REFERENCES movies(movie_id),
    watch_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    watch_duration INT  -- minutes watched
);

-- Recommendations
CREATE TABLE recommendations (
    rec_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    movie_id INT REFERENCES movies(movie_id),
    rec_date DATE DEFAULT CURRENT_DATE
);




--insert sampe data


-- Users
INSERT INTO users (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com');

-- Plans
INSERT INTO subscription_plans (plan_name, price, resolution, max_devices) VALUES
('Basic', 5.99, 'HD', 1),
('Premium', 11.99, '4K', 4);


-- Payments
INSERT INTO payments (user_id, plan_id, amount) VALUES
(1, 2, 11.99),
(2, 1, 5.99);

-- Genres
INSERT INTO genres (genre_name) VALUES
('Action'), ('Comedy'), ('Drama');

-- Movies
INSERT INTO movies (title, release_year, genre_id, duration) VALUES
('Inception', 2010, 1, 148),
('The Hangover', 2009, 2, 100),
('Titanic', 1997, 3, 195);

-- Ratings
INSERT INTO ratings (user_id, movie_id, rating) VALUES
(1, 1, 5), 
(2, 2, 4);

-- Viewing History
INSERT INTO viewing_history (user_id, movie_id, watch_duration) VALUES
(1, 1, 148),
(2, 3, 120);

-- Recommendations
INSERT INTO recommendations (user_id, movie_id) VALUES
(1, 3), 
(2, 1);

--some queries
-- Popular movies by views
SELECT m.title, COUNT(vh.history_id) AS views
FROM movies m
JOIN viewing_history vh ON m.movie_id = vh.movie_id
GROUP BY m.title
ORDER BY views DESC;

--  Average rating per movie
SELECT m.title, ROUND(AVG(r.rating),2) AS avg_rating
FROM movies m
JOIN ratings r ON m.movie_id = r.movie_id
GROUP BY m.title
ORDER BY avg_rating DESC;

--  Top recommendations for a user (e.g., user_id = 1)
SELECT u.name, m.title, r.rec_date
FROM recommendations r
JOIN users u ON r.user_id = u.user_id
JOIN movies m ON r.movie_id = m.movie_id
WHERE u.user_id = 1;

--  Revenue per subscription plan
SELECT sp.plan_name, SUM(p.amount) AS total_revenue
FROM payments p
JOIN subscription_plans sp ON p.plan_id = sp.plan_id
GROUP BY sp.plan_name;


