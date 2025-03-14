DROP TABLE UserAchievements CASCADE;
DROP TABLE UserProgress CASCADE;
DROP TABLE Achievements CASCADE;
DROP TABLE Lessons CASCADE;
DROP TABLE Courses CASCADE;
DROP TABLE Users CASCADE;
DROP TABLE CourseLevels CASCADE;
DROP TABLE Languages CASCADE;


-- Таблица языков
CREATE TABLE Languages (
    language_id SERIAL PRIMARY KEY,
    language_name VARCHAR(50) NOT NULL UNIQUE
);

-- Таблица уровней сложности
CREATE TABLE CourseLevels (
    level_id SERIAL PRIMARY KEY,
    level_name VARCHAR(50) NOT NULL UNIQUE
);

-- Таблица пользователей
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);

-- Таблица курсов
CREATE TABLE Courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    language_id INT REFERENCES Languages(language_id),
    level_id INT REFERENCES CourseLevels(level_id)
);

-- Таблица уроков
CREATE TABLE Lessons (
    lesson_id SERIAL PRIMARY KEY,
    course_id INT REFERENCES Courses(course_id),
    lesson_name VARCHAR(100) NOT NULL,
    content TEXT,
    lesson_order INT, 
    duration INT 
);

-- Таблица достижений
CREATE TABLE Achievements (
    achievement_id SERIAL PRIMARY KEY,
    achievement_name VARCHAR(100) NOT NULL,
    description TEXT, 
    course_id INT REFERENCES Courses(course_id),
    lesson_id INT REFERENCES Lessons(lesson_id)
);

-- Таблица прогресса 
CREATE TABLE UserProgress (
    user_id INT REFERENCES Users(user_id), 
    lesson_id INT REFERENCES Lessons(lesson_id),
    score INT CHECK (score BETWEEN 0 AND 100),
    PRIMARY KEY (user_id, lesson_id)
);

-- Таблица достижений пользователю
CREATE TABLE UserAchievements (
    user_id INT REFERENCES Users(user_id),
    achievement_id INT REFERENCES Achievements(achievement_id),
    achieved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, achievement_id)
);