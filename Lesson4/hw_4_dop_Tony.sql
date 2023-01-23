-- Собеседования
use lesson_4;
DROP TABLE IF EXISTS AUTO,CITY,MAN ;

CREATE TABLE  AUTO 
(       
	REGNUM VARCHAR(10) PRIMARY KEY, 
	MARK VARCHAR(10), 
	COLOR VARCHAR(15),
	RELEASEDT DATE, 
	PHONENUM VARCHAR(15)
);

 -- AUTO
INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111114,'LADA', 'КРАСНЫЙ', date'2008-01-01', '9152222221');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111115,'VOLVO', 'КРАСНЫЙ', date'2013-01-01', '9173333334');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111116,'BMW', 'СИНИЙ', date'2015-01-01', '9173333334');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111121,'AUDI', 'СИНИЙ', date'2009-01-01', '9173333332');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111122,'AUDI', 'СИНИЙ', date'2011-01-01', '9213333336');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111113,'BMW', 'ЗЕЛЕНЫЙ', date'2007-01-01', '9214444444');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111126,'LADA', 'ЗЕЛЕНЫЙ', date'2005-01-01', null);


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111117,'BMW', 'СИНИЙ', date'2005-01-01', null);


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111119,'LADA', 'СИНИЙ', date'2017-01-01', 9213333331);



-- 1. Вывести на экран сколько машин каждого цвета для машин марок BMW и LADA

SELECT *
FROM auto;
SELECT  a.mark,a.color, COUNT(*) `Cars total` 
FROM (SELECT * FROM Auto WHERE mark IN ('BMW' ,'LADA')) a
GROUP BY a.color,a.mark
ORDER BY a.mark,a.color ;

-- 2. Вывести на экран марку авто и количество AUTO не этой марки
SELECT  a.mark,a.color, ((SELECT COUNT(*) FROM AUTO) - COUNT(*)) AS `Other cars total` 
FROM AUTO a
GROUP BY a.mark
ORDER BY a.mark;

/*
Задание №3.
Даны 2 таблицы, созданные следующим образом:
create table test_a (id number, data varchar(45));
create table test_b (id number);
insert into test_a(id, data) values
(10, 'A'),
(20, 'A'),
(30, 'F'),
(40, 'D'),
(50, 'C');
insert into test_b(id) values
(10),
(30),
(50);
Напишите запрос, который вернет строки из таблицы test_a, id которых нет в таблице test_b, НЕ используя ключевого слова NOT. 
*/

DROP TABLE IF EXISTS test_a,test_b ;
create table test_a (id INT, `data` varchar(45));
create table test_b (id INT);
insert into test_a(id, `data`) values
(10, 'A'),
(20, 'A'),
(30, 'F'),
(40, 'D'),
(50, 'C');
insert into test_b(id) values
(10),
(30),
(50);

-- Напишите запрос, который вернет строки из таблицы test_a, id которых нет в таблице test_b, НЕ используя ключевого слова NOT.

-- 1) через JOIN - NULL , делаем объединение по бОльшей табличке, и показываем только строчки где есть NULL
SELECT a.`data` 
FROM test_a a   
LEFT JOIN test_b b
ON a.id = b.id
WHERE b.id IS NULL;

-- 2) через СOALESCE и фильтр <> (!=)  ( узнал, что SELECT * FROM test_a,test_b   - это равносильно cross join , а NULL  с равенствами не работает)
SELECT a.`data`
FROM test_a a
LEFT JOIN test_b b
ON a.id = b.id
WHERE a.id <> COALESCE(b.id,0);  

-- *3) Через IN ? Тоже не дался без NOT.  

SELECT a.`data`
FROM test_a a
WHERE a.id  NOT IN ( SELECT b.id FROM test_b b);  




-- 4) через DELETE, радикально (здесь работаю с промежуточной просто чтобы заново test_a не записывать)
CREATE TABLE IF NOT EXISTS test_4 SELECT* FROM test_a;
SELECT * FROM test_4;

DELETE FROM test_4
WHERE id IN (
	SELECT id FROM test_b);
SELECT `data` FROM test_4; 
DROP TABLE test_4;

 -- 5) используя группировку и count ( принцип объединения таблиц по строкам , вместо JOIN по столбцам)
 
	-- а) через промежуточную таблицу
	CREATE TABLE IF NOT EXISTS test_dup LIKE test_a;
	INSERT INTO test_dup SELECT * FROM test_a;
	INSERT INTO test_dup(id) SELECT id FROM test_b;
	SELECT * FROM test_dup ORDER BY id;
	-- получили табличку с, по сути UNION двух таблиц (которые сам union не сделает из-за разного числа столбцов)

	-- теперь можно вывести те строчки, количество повторений у которых равно 1
	SELECT d.`data`
	FROM (
			SELECT *
			FROM test_dup
			GROUP BY id
			HAVING COUNT(id) = 1) as d;
	 -- можно придраться , что это вызов уже не из таблички test_a. Тогда можно так:
	SELECT a.`data`
	 FROM test_a a
	 WHERE a.id IN ( 
					SELECT id
					FROM test_dup
					GROUP BY id
					HAVING COUNT(id) = 1) ;
	-- Тут все по честному, просто сравниваем со списком из промежуточной таблицы. 
	DROP TABLE test_dup;

	-- б) Все это также можно сделать внутри одного запроса через UNION 
    SELECT `data`
    FROM test_a
    WHERE test_a.id IN(
			SELECT *
			FROM(
				SELECT a.id as a_id
				FROM test_a a
				LEFT JOIN test_b b
				ON a.id = b.id
				UNION ALL
				SELECT b.id as b_id
				FROM test_b b
				LEFT JOIN test_a a
				ON a.id = b.id) as un_t
			GROUP BY a_id
			HAVING  COUNT(a_id) < 2 );

 -- *6)  EXISTS ? Без использования NOT так и не понял как, все такие эта функция работает на 1 или больше = TRUE , и тут либо всё, либо ничего.
 SELECT `data` as result 
 FROM test_a a
 WHERE  NOT EXISTS -- Видел два вложенных NOT EXIST, что проверяет истинно ли X для всех вариантов Y  . Но два EXISTS - это left join просто выходит
		(SELECT id FROM test_b  b WHERE a.id = b.id)
; 
        


-- *7) Вроде ты упомянул на семинаре, что можно как-то через обратные к join ключи? 

SELECT a.id,a.`data`,b.id as b_id
FROM test_a a
LEFT JOIN test_b b
ON b.id = a.id  -- от перемены мест результат не меняется
;

