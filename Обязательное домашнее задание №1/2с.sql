DELETE FROM Users;
DELETE FROM Languages;
DELETE FROM CourseLevels;
DELETE FROM Courses;
DELETE FROM Lessons;
DELETE FROM UserProgress;
DELETE FROM Achievements;
DELETE FROM UserAchievements;


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

