/*
-- Таблица с информацией о студентах
SHOW DATABASES; -- Показ всех баз данных
USE lesson_1; -- указание бд lesson_1, как активной
*/
-- 1. Показать всех учителей
SELECT 
    *
FROM
    teacher;

-- 2. Показать учителя с фамилией Смит
SELECT 
    surname, salary
FROM
    teacher
WHERE
    surname = 'Смит';

-- 4. Выбрать учителей, фамилии которых начинаются с буквы "С"
-- оператор LIKE включает распознование спец символов внутри строки(регулярки) 
-- % - строка любой длины (включая нулевую)
-- _ - любой один символ
SELECT 
    surname, salary
FROM
    teacher
WHERE
    surname LIKE '%р%';

-- 5.Сотрудники, у которых зарплата больше или равна 100000
SELECT 
    surname, salary
FROM
    teacher
WHERE
    salary >= 100000;

-- 5.Сотрудники, которые не профессора
SELECT 
    *
FROM
    teacher
WHERE
    post != 'Профессор';

