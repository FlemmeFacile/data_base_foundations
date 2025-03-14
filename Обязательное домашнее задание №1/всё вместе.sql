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

-- Добавление пользователей
INSERT INTO Users (username, email, password_hash)
VALUES 
    ('Lucía Fernández', 'lucia_f@mail.com', 'hashed_password_1'),
    ('Alejandro López', 'alejandro_l@mail.com', 'hashed_password_2'),
    ('Sofía Martínez', 'sofia_m@mail.com', 'hashed_password_3'),
    ('Carlos Ramírez', 'carlos_r@mail.com', 'hashed_password_4');
SELECT * FROM Users;

-- Добавление языков
INSERT INTO Languages (language_name)
VALUES ('Español'), ('Francés'), ('Inglés'), ('Japonés');
SELECT * FROM Languages;

-- Добавление уровней сложности
INSERT INTO CourseLevels (level_name)
VALUES ('Principiante'), ('Intermedio'), ('Avanzado');
SELECT * FROM CourseLevels;

-- Добавление курсов
INSERT INTO Courses (course_name, language_id, level_id)
VALUES 
    ('Francés', 
     (SELECT language_id FROM Languages WHERE language_name = 'Francés'),
     (SELECT level_id FROM CourseLevels WHERE level_name = 'Principiante')),
    ('Inglés', 
     (SELECT language_id FROM Languages WHERE language_name = 'Inglés'),
     (SELECT level_id FROM CourseLevels WHERE level_name = 'Avanzado')),
    ('Japonés', 
     (SELECT language_id FROM Languages WHERE language_name = 'Japonés'),
     (SELECT level_id FROM CourseLevels WHERE level_name = 'Principiante'));
SELECT * FROM Courses;

-- Добавление уроков
INSERT INTO Lessons (course_id, lesson_name, content, lesson_order, duration)
VALUES 
    ((SELECT course_id FROM Courses WHERE course_name = 'Francés'),
     'Saludos', 'Aprende cómo saludar en Francés.', 1, 30),
    ((SELECT course_id FROM Courses WHERE course_name = 'Inglés'),
     'Presentaciones', 'Aprende cómo presentarte en Inglés.', 1, 45),
    ((SELECT course_id FROM Courses WHERE course_name = 'Japonés'),
     'Verbos', 'Aprende los verbos en Japonés.', 1, 40),
    ((SELECT course_id FROM Courses WHERE course_name = 'Japonés'),
     'Adjetivos', 'Aprende los adjetivos en Japonés.', 2, 50);
SELECT * FROM Lessons;

-- Добавление прогресса
INSERT INTO UserProgress (user_id, lesson_id, score)
VALUES 
    ((SELECT user_id FROM Users WHERE username = 'Lucía Fernández'), 
     (SELECT lesson_id FROM Lessons WHERE lesson_name = 'Saludos'), 99),
    ((SELECT user_id FROM Users WHERE username = 'Alejandro López'), 
     (SELECT lesson_id FROM Lessons WHERE lesson_name = 'Saludos'), 35),
    ((SELECT user_id FROM Users WHERE username = 'Sofía Martínez'), 
     (SELECT lesson_id FROM Lessons WHERE lesson_name = 'Verbos'), 86),
    ((SELECT user_id FROM Users WHERE username = 'Carlos Ramírez'), 
     (SELECT lesson_id FROM Lessons WHERE lesson_name = 'Adjetivos'), 91);
SELECT * FROM UserProgress;

-- Добавление достижений 
INSERT INTO Achievements (achievement_name, description, course_id, lesson_id)
VALUES (
    'Primera Lección Completada', 
    '¡{username} completó su primera lección de {course_name}!',
    (SELECT course_id FROM Courses WHERE course_name = 'Francés'), 
    (SELECT lesson_id FROM Lessons WHERE lesson_name = 'Saludos')  
);
SELECT * FROM Achievements;

INSERT INTO Achievements (achievement_name, description, course_id, lesson_id)
VALUES (
    'Lección de Presentaciones Completada', 
    '¡{username} completó la lección de presentaciones en {course_name}!',
    (SELECT course_id FROM Courses WHERE course_name = 'Inglés'), 
    (SELECT lesson_id FROM Lessons WHERE lesson_name = 'Presentaciones') 
);
SELECT * FROM Achievements;

INSERT INTO Achievements (achievement_name, description, course_id, lesson_id)
VALUES (
    '5 Lecciones Completadas', 
    '¡{username} completó 5 lecciones en {course_name}!',
    (SELECT course_id FROM Courses WHERE course_name = 'Inglés'), 
    NULL  
);
SELECT * FROM Achievements;

-- Добавление достижений пользователю
INSERT INTO UserAchievements (user_id, achievement_id)
VALUES 
    ((SELECT user_id FROM Users WHERE username = 'Lucía Fernández'), 
     (SELECT achievement_id FROM Achievements WHERE achievement_name = 'Primera Lección Completada')),
    ((SELECT user_id FROM Users WHERE username = 'Alejandro López'), 
     (SELECT achievement_id FROM Achievements WHERE achievement_name = '5 Lecciones Completadas'));
SELECT * FROM UserAchievements;






-- Добавление лишних строк
INSERT INTO Languages (language_name)
VALUES ('Alemán');
SELECT * FROM Languages;

-- Удаление лишних строк
DELETE FROM Languages WHERE language_name = 'Alemán';
SELECT * FROM Languages;

-- Добавление столбцов
ALTER TABLE UserProgress
ADD COLUMN course_id INT;
SELECT * FROM UserProgress;

UPDATE UserProgress up
SET course_id = l.course_id
FROM Lessons l
WHERE up.lesson_id = l.lesson_id;
SELECT * FROM UserProgress;

-- Удаление столбцов
ALTER TABLE UserProgress
DROP COLUMN course_id;
SELECT * FROM UserProgress;










-- У кого какие достижения
SELECT u.username, a.achievement_name
FROM Users u
LEFT JOIN UserAchievements ua ON u.user_id = ua.user_id
LEFT JOIN Achievements a ON ua.achievement_id = a.achievement_id;

-- Какие уроки в каком курсе длиннее 3 минут
SELECT c.course_name, l.lesson_name, l.duration
FROM Courses c
JOIN Lessons l ON c.course_id = l.course_id
WHERE l.duration > 3;

-- Кто и какие уроки проходит в курсе японского
SELECT u.username, l.lesson_name
FROM Users u
JOIN UserProgress up ON u.user_id = up.user_id
JOIN Lessons l ON up.lesson_id = l.lesson_id
JOIN Courses c ON l.course_id = c.course_id
WHERE c.course_name = 'Japonés';

-- Количество уроков в каждом курсе
SELECT c.course_name, COUNT(l.lesson_id) AS lesson_count
FROM Courses c
LEFT JOIN Lessons l ON c.course_id = l.course_id
GROUP BY c.course_name;