use lesson_3;

CREATE TABLE `workers`
( `id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
 `name` VARCHAR(45),
 `surname`  VARCHAR(45),
 `specialty` VARCHAR(45),
 `salary` INT,
 `age` INT
);

ALTER TABLE `workers`
ADD `seniority` INT AFTER `specialty`;
ALTER TABLE `workers`
RENAME COLUMN `specialty` TO `speciality`;

SELECT * FROM `workers`;

-- INSERT `workers` (`name`, `surname`,`specialty`,`seniority`,`salary`,`age`)

INSERT `workers` (`name`, `surname`, `speciality`, `seniority`,`salary`, `age`)
VALUES
	("Вася", "Васькин", "начальник", 40, 100000, 60), -- id = 1
    ("Петя", "Петькин", "начальник", 8, 70000, 30), -- id = 2
    ("Катя", "Петькина", "инженер", 2, 70000, 25), -- id = 3
    ("Иван", "Иванов", "инженер", 12, 50000, 35), -- id = 4
	("Саша", "Сашкин", "рабочий", 20, 30000, 49), -- id = 5
    ("Петр", "Петров", "рабочий", 40, 30000, 59); -- id = 6

-- Cортировка
-- ORDER BY
-- 1 По возрасту

SELECT `id`,`name`, `surname`, `age`
FROM workers
ORDER BY age;

SELECT `id`,`name`, `surname`, `age`
FROM workers
ORDER BY `name`;

SELECT `id`,`name`, `surname`, `age`
FROM workers
ORDER BY `surname` DESC;

INSERT `workers` (`name`, `surname`, `speciality`, `seniority`,`salary`, `age`) -- `column`
VALUES
	("Петр", "Васькин", "начальник", 40, 100000, 60), -- id = 8
    ("Тимофей", "Васькин", "инженер", 40, 60000, 60);


SELECT `id`,`name`, `surname`, `age`
FROM workers
ORDER BY `name` DESC, `age` DESC;

-- Агрегатные функции
-- Уникальные имена

SELECT DISTINCT `name` -- уникальные значения принимают только ё столец в аргументы, сразу по нескольким нельзя
FROM `workers` AS uniq_w;

SELECT DISTINCT count(`name`) 
FROM uniq_w ;

SELECT  count(`name`)
FROM `workers`;

-- LIMIT

SELECT `id`,`name`
FROM `workers`
LIMIT 2;

SELECT `id`,`name`
FROM `workers`
LIMIT 2,4; -- первый параметр указывает число пропускаемых строк, второй -число выводимых строк

SELECT `id`,`name`
FROM `workers`
ORDER BY `id` DESC
LIMIT 2,3;

-- sum , avg, min, max, count

SELECT SUM(salary)
from workers;


SELECT *
FROM workers
WHERE `speciality` = "рабочий" ;


-- Группировка
SELECT speciality, 
AVG(salary) as `average_wage`,
SUM(SALARY) AS `total_wages`,
COUNT(salary) AS worker_number,
SUM(SALARY)/COUNT(salary) as manual_average,
MIN(salary),
MAX(salary)
FROM workers
-- WHERE worker_number >=3  -- WHERE не работает с агрегатными функциями в принципе
GROUP BY speciality
HAVING worker_number >=3 -- отсев после группировки
ORDER BY average_wage;

-- SELECT `id`,`name` 
-- FROM `workers`
-- OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;  -- fetch в новых версиях  mysql не работает на выдачу выборки, и работает с курсорами




