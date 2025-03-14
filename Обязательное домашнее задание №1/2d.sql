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