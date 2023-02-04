
USE lesson_5;

create table  if not exists academic_record (
	name varchar(45),
	quartal  varchar(45),
    subject varchar(45),
	grade int
);

TRUNCATE academic_record;
insert into academic_record
values
	('Александр','1 четверть', 'математика', 4),
	('Александр','2 четверть', 'русский', 4),
	('Александр', '3 четверть','физика', 5),
	('Александр', '4 четверть','история', 4),
	('Антон', '1 четверть','математика', 4),
	('Антон', '2 четверть','русский', 3),
	('Антон', '3 четверть','физика', 5),
	('Антон', '4 четверть','история', 3),
    ('Петя', '1 четверть', 'физика', 4),
	('Петя', '2 четверть', 'физика', 3),
	('Петя', '3 четверть', 'физика', 4),
	('Петя', '4 четверть', 'физика', 5);

select * 
from academic_record;

SELECT name, subject, grade,
	avg(grade) OVER (PARTITION BY name) AS avg_grade
FROM academic_record;
insert into academic_record
values
	('Александр','1 четверть', 'русский', 2); 
    
-- Средний балл ученика, наименьшую и наибольшую оценку
SELECT name, subject, grade,
	avg(grade) OVER (PARTITION BY name) AS avg_grade,
    min(grade) OVER (PARTITION BY name) AS min_grade,
    max(grade) OVER (PARTITION BY name) AS max_grade
FROM academic_record
WHERE subject = "русский";

SELECT name, subject, grade,
	avg(grade) OVER (PARTITION BY name ORDER BY grade) AS avg_grade,
    min(grade) OVER (PARTITION BY name ORDER BY grade) AS min_grade, -- order by лучше делать один раз(например, на общий запрос), иначе могут смещаться границы внутри групп (сравни с предыдущим результатом)
    max(grade) OVER (PARTITION BY name ORDER BY grade) AS max_grade
FROM academic_record
WHERE subject = "русский";

SELECT name, subject, grade, quartal,
	lag(grade) OVER (ORDER BY quartal) AS `Предыдущая оценка`,
    lead(grade) over (ORDER BY quartal) AS `Следующая оценка`
FROM academic_record
WHERE name = "Антон";

CREATE TABLE IF NOT EXISTS summer_medals 
(
	year INT,
    city VARCHAR(45),
    sport VARCHAR(45),
    discipline VARCHAR(45),
    athlete VARCHAR(45),
    country VARCHAR(45),
    gender VARCHAR(45),
    event VARCHAR(45),
    medal VARCHAR(45)
);

truncate summer_medals;
INSERT summer_medals
VALUES
	(1896, "Athens", "Aquatics", "Swimming", "HAJOS ALfred", "HUN", "Men","100M Freestyle", "Gold"),
	(1896, "Athens", "Archery", "Swimming", "HERSCHMANN Otto", "AUT", "Men","100M Freestyle", "Silver"),
    (1896, "Athens", "Athletics", "Swimming", "DRIVAC Dimitros", "GRE", "Men","100M Freestyle For Saliors", "Bronze"),
    (1900, "Athens", "Badminton", "Swimming", "MALOKINIS Ioannis", "GRE", "Men","100M Freestyle For Saliors", "Gold"),
    (1896, "Athens", "Aquatics", "Swimming", "CHASAPIS Spiridon", "GRE", "Men","100M Freestyle For Saliors", "Silver"),
    (1896, "Athens", "Aquatics", "Swimming", "CHOROPHAS Elfstathios", "GRE", "Men","1200M Freestele", "Bronze"),
    (1905, "Athens", "Aquatics", "Swimming", "HAJOS ALfred", "HUN", "Men","100M Freestyle For Saliors", "Gold"),
    (1896, "Athens", "Aquatics", "Swimming", "ANDREOU Joannis", "GRE", "Men","1200M Freestyle", "Silver"),
    (1896, "Athens", "Aquatics", "Swimming", "CHOROPHAS Elfstathios", "GRE", "Men","400M Freestyle", "Bronze");
    
SELECT *
FROM summer_medals;

 
 -- все виды спорта
CREATE OR REPLACE  VIEW sports_category AS
	SELECT sport ,
		ROW_NUMBER() OVER (ORDER BY sport) as `order`
	FROM (SELECT DISTINCT sport from summer_medals) as all_sports;
select * from sports_category;
	
SHOW FULL tables; -- список всех таблиц в БД

SHOW FULL tables
	WHERE table_type LIKE "VIEW "; -- список всех представлений в БД
    
-- список спортсменов из водных видов спорт

CREATE OR REPLACE VIEW  `aquatic_athlete` AS
	(SELECT athlete, gender, discipline 
		FROM summer_medals
        WHERE sport = "Aquatics");

SELECT * from `aquatic_athlete`;
        



    






