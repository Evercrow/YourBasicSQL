-- DDL 

CREATE DATABASE seminar_2;
USE lesson_2;

CREATE TABLE movies
	( id INT AUTO_INCREMENT	NOT NULL PRIMARY KEY,
	 title VARCHAR(66) ,
     title_eng VARCHAR(45),
     year_movie YEAR,
     count_min  INT NOT NULL,
     storyline VARCHAR(500)
     );
     
RENAME TABLE movies TO films;
 -- RENAME COLUMN 
-- ALTER

-- DML

/*
		INSERT films
		VALUES (3 , "Игры Разума", "A Beautiful Mind", "2001",135,"...",100),
				(4, "Форрест Гамп","Forrest Gump","1994",142,"...",100);
    
INSERT films(title_ru, title_eng,year_movie,count_min)
VALUES ("Иван Васильевич меняет профессию","","1998",128),
		("Назад в будущее", "Back to the Future", "1985", 116);
*/


ALTER TABLE films
ADD `language` VARCHAR(45);
ALTER TABLE films
DROP `language`;

ALTER TABLE films
ADD price INT DEFAULT 100;

ALTER TABLE films
 RENAME COLUMN title TO title_ru; -- здесь обхекты column уже распознаются 


ALTER TABLE films
 MODIFY storyline VARCHAR(500); -- modify для типов
 
ALTER TABLE films
 ALTER storyline SET DEFAULT "без описания"; -- второй alter для доступа к ограничениям колонки

UPDATE films
SET price = price + 150; -- 100 + 150

UPDATE films
SET storyline = "без описания"; 

UPDATE films
SET price = price + 50 -- 100 + 150
WHERE title_ru = "Иван Васильевич меняет профессию" ;

UPDATE films
SET price = price + 60 -- 100 + 150
WHERE title_ru = "Форрест Гамп" ;

CREATE TABLE test 
( id INT );

 -- DROP TABLE test;
-- DROP DATABASE test


-- Оператор TRUNCATE очмщает все значения

-- TRUNCATE TABLE films;

SELECT *
FROM films;

-- CASE , IF

SELECT title_ru, price ,-- запятая перед CASE (будет как отдельный столбец)
CASE
	WHEN price >=100 AND price <= 149 THEN "Не самый популярный фильм"
    WHEN price >=150 AND price < 200 THEN "популярный фильм"
    WHEN price >=200 AND price <= 250 THEN "хит"
    ELSE "Error 404"
END AS result
FROM films;


 -- IF (условие, значение для истины, значение для лжи)
 
SELECT IF(200 > 100, "аа, больше", "нет, не больше") as `check`;

SELECT title_ru, price, count_min, IF
	 (count_min>130, "Полнометражка", "короткометражка") as `movie length`
FROM films;









		
	


