USE lesson_3;
-- допишем табличку, предварительно почистив лишнее
TRUNCATE workers;

/*
CREATE TABLE `workers`
( `id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
 `name` VARCHAR(45),
 `surname`  VARCHAR(45),
 `speciality` VARCHAR(45),
 `seniority` INT,
 `salary` INT,
 `age` INT
);
*/


-- И сделаем полный insert 

INSERT `workers` (`name`, `surname`, `speciality`, `seniority`,`salary`, `age`)
VALUES
	("Вася", "Васькин", "начальник", 40, 100000, 60), -- id = 1
    ("Петя", "Петькин", "начальник", 8, 70000, 30), -- id = 2
    ("Катя", "Каткина", "инженер", 2, 70000, 25), -- id = 3
    ("Иван", "Иванов", "рабочий", 40, 30000, 59), -- id = 4
	("Саша", "Сашкин", "инженер", 12, 50000, 35), -- id = 5
    ("Петр", "Петров", "рабочий", 20, 25000, 40), -- id = 6
    ("Сидор", "Сидоров", "рабочий", 10, 20000, 35),
    ("Антон","Антонов","рабочий", 8, 18000, 28),
    ("Юра","Юркин","рабочий", 5, 15000, 25),
    ("Максим","Воронин","рабочий", 2, 11000, 22),
    ("Юра","Галкин","рабочий", 3, 12000, 24),
    ("Люся","Люськина","уборщик", 10, 10000, 49); -- id = 12

SELECT * FROM workers;

-- 1. Отсортируйте поле “зарплата” (salary) в порядке убывания и возрастания
-- по возрастанию:
SELECT `name`,`surname`,`speciality`,`salary`
FROM workers
ORDER BY salary;
-- по убыванию:
SELECT `name`,`surname`,`speciality`,`salary` 
FROM workers
ORDER BY salary DESC;

-- 2.Выведите 5 максимальных зарплат (salary)
-- максимумальные зарплаты по должностям:
SELECT `speciality`,MAX(salary) as top_wage 
FROM `workers`
GROUP BY `speciality`
LIMIT 5;

-- просто 5 самых высоких зарплат
SELECT `name`,`surname`,`speciality`,`salary` 
FROM workers
ORDER BY salary DESC
LIMIT 5;

-- 3. Подсчитать суммарную зарплату(salary) по каждой специальности (speciality)
SELECT `speciality`,SUM(salary) as total_wage 
FROM `workers`
GROUP BY `speciality`;

-- кек, рабочие  начальников не переплюнут никогда

-- 4.Найти количество сотрудников по специальности “Рабочий” (speciality) в возрасте от 24 до 42 лет.

SELECT `speciality`,COUNT(*) as workers_num 
FROM `workers`
WHERE `speciality` = "рабочий" AND `age` BETWEEN 24 AND 42
GROUP BY `speciality`;

-- 5. Найти количество специальностей
SELECT COUNT(DISTINCT `speciality`) as `positions`
FROM `workers`;

-- 6. Вывести специальности, у которых средний возраст сотрудника меньше 44 лет

SELECT `speciality`,AVG(`age`) as average_age 
FROM `workers`
GROUP BY `speciality`
HAVING average_age < 44;


