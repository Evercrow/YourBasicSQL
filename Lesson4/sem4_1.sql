CREATE DATABASE lesson_4;
USE lesson_4;

CREATE TABLE teacher
(	
	id INT NOT NULL PRIMARY KEY,
    surname VARCHAR(45),
    salary INT
);

INSERT teacher
VALUES
	(1,"Авдеев", 17000),
    (2,"Гущенко",27000),
    (3,"Пчелкин",32000),
    (4,"Питошин",15000),
    (5,"Вебов",45000),
    (6,"Шарпов",30000),
    (7,"Шарпов",40000),
    (8,"Питошин",30000);
    
SELECT * from teacher; 

CREATE TABLE lesson
(	
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    course VARCHAR(45),
    teacher_id INT,
    FOREIGN KEY (teacher_id)  REFERENCES teacher(id)
);
INSERT INTO lesson(course,teacher_id)
VALUES
	("Знакомство с веб-технологиями",1),
    ("Знакомство с веб-технологиями",2),
    ("Знакомство с языками программирования",3),
    ("Базы данных и SQL",4);
    
-- JOIN'ы
-- вывести учителей , ведущих курсы
SELECT t.surname,l.course
FROM teacher t

JOIN  lesson l-- (в mysSQL JOIN=INNER JOIN , сокращается)
ON t.id = l.teacher_id ;
 -- ORDER BY course;
 
 
 -- вывести всех учителей при объединении
SELECT t.surname,l.course
FROM teacher t

LEFT OUTER JOIN  lesson l-- (в mysSQL  LEFT OUTER JOIN = LEFT JOIN,  сокращается)
ON t.id = l.teacher_id ;

-- вывести ТОЛЬКО учителей. НЕ ведущих курсы

-- 1-й способ c фильтром 
SELECT t.surname,l.course
FROM teacher t

LEFT OUTER JOIN  lesson l-- (в mysSQL  LEFT OUTER JOIN = LEFT JOIN,  сокращается)
ON t.id = l.teacher_id 
WHERE  teacher_id IS NULL ;

-- 2-й способ c подзапрос exists 

SELECT * FROM teacher
WHERE NOT EXISTS
(SELECT * FROM lesson
WHERE teacher.id = lesson.teacher_id) ;

-- 3-й способ меняя местами
SELECT t.surname,l.course
FROM lesson l

LEFT OUTER JOIN  teacher t -- (в mysSQL  LEFT OUTER JOIN = LEFT JOIN,  сокращается)
ON l.teacher_id = t.id  ;

-- Получить учителей которые ведут "Знакомство с языками программирования"

SELECT t.*,l.course   -- если просто SELECT *, l.course - он к ПОЛНОЙ СКЛЕЕНОЙ таблицесправа приклеет еще раз столбец course
FROM lesson l

LEFT JOIN  teacher t -- (в mysSQL  LEFT OUTER JOIN = LEFT JOIN,  сокращается)
ON l.teacher_id = t.id
WHERE l.course = "Знакомство с языками программирования"  ;

-- Подзапрос SELECT-ы
SELECT t.*,l.*
FROM teacher t
JOIN ( SELECT id ,course, teacher_id 
FROM lesson WHERE course = "Знакомство с веб-технологиями") l -- AS
ON t.id = l.teacher_id; 

SELECT t.*, l.*
FROM teacher t -- t = teachers
LEFT JOIN (SELECT * FROM lesson) l  -- LEFT OUTER JOIN  = LEFT JOIN
ON t.id = l.teacher_id 
WHERE l.course = "Знакомство с веб-технологиями";
 -- результат красивее так как удаляется столбец id лишний
 
 -- CROSS JOIN
 SELECT t.*, l.*
 FROM teacher t
 CROSS JOIN lesson l
 ORDER BY l.id;
 
  SELECT  l.*, t.* -- меняем местами колонки вывода
 FROM teacher t
 CROSS JOIN lesson l
 ORDER BY l.id;

