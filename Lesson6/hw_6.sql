--     Создайте функцию, которая принимает кол-во сек и форматирует их в кол-во дней, часов, минут и секунд.
-- Пример: 123456 ->'1 days 10 hours 17 minutes 36 seconds '
USE lesson_6;

-- сначала взялся писать процедуру, потом посчитал количество символов в нужном выводе .
-- в итоге слегка потренировал временные таблицы, инчае процедура слишком бесполезна для меня - иначе функция, которая ничего не возвращает, и имеет принт всего в 30 символов очень уныла для меня , 
-- а как вызвать процедуру внутри SELECT, чтобы увеличить окно показа, не нашел.
CREATE TEMPORARY TABLE IF NOT EXISTS stored_call(
		requested_time VARCHAR(100) NOT NULL);



DROP PROCEDURE IF EXISTS showtime;
DELIMITER //
CREATE PROCEDURE showtime(secs INT)
BEGIN
	DECLARE result VARCHAR(100) DEFAULT "";
	DECLARE temp INT ;
    
    SET temp = floor(secs/86400);
    SET result = CONCAT(temp," days ");
    SET secs = secs-temp*86400;
    
    SET temp = floor(secs/3600);
    SET result = CONCAT(result,temp," hours ");
    SET secs = secs-temp*3600;
    
    SET temp = floor(secs/60);
    SET result = CONCAT(result,temp," minutes ");
    SET secs = secs-temp*60;
    
    SET result = CONCAT(result,secs," seconds ");
    
    truncate stored_call;
    INSERT INTO stored_call(requested_time) VALUE (result);
END //
DELIMITER ;

CALL showtime(1800);
SELECT * from stored_call;

SET @secs = 123456;
SELECT floor(@secs/3600);

SELECT "1 days 10 hours 17 minutes 36 seconds ";

DROP FUNCTION IF EXISTS  from_sec_to;
DELIMITER $$
CREATE FUNCTION from_sec_to(secs INT) -- num -- количество чисел Фибоначчи для вывода на экран
RETURNS VARCHAR(60) -- max длина вывод в workbench
DETERMINISTIC -- сохранение вызоыва функции с конкретным аргументом в кэш
BEGIN
	DECLARE result VARCHAR(100) DEFAULT "";
	DECLARE temp INT ;
    
    SET temp = floor(secs/86400);
    SET result = CONCAT(temp," days ");
    SET secs = secs-temp*86400;
    
    SET temp = floor(secs/3600);
    SET result = CONCAT(result,temp," hours ");
    SET secs = secs-temp*3600;
    
    SET temp = floor(secs/60);
    SET result = CONCAT(result,temp," minutes ");
    SET secs = secs-temp*60;
    
    SET result = CONCAT(result,secs," seconds ");
    
	RETURN result;
END $$
DELIMITER ;


SELECT from_sec_to(123456) as show_time; -- выводится без проблем



-- 2.	Выведите только четные числа от 1 до 10 включительно. (Через функцию / процедуру)
-- Пример: 2,4,6,8,10 (можно сделать через шаг +  2: х = 2, х+=2)

DROP PROCEDURE IF EXISTS show_odds;
DELIMITER //
CREATE PROCEDURE show_odds(num INT)
BEGIN
	DECLARE result VARCHAR(100) DEFAULT "";
    
    WHILE num >= 2 DO
		SET	result = CONCAT(num," ",result);
        SET num = num - 2;
    END WHILE;
    
	truncate stored_call;
    INSERT INTO stored_call(requested_time) VALUE (result);
END //
DELIMITER ;

CALL show_odds(20);
SELECT * FROM stored_call ;


DROP PROCEDURE IF EXISTS show_odds10;

DELIMITER //
CREATE PROCEDURE show_odds10()
BEGIN
	DECLARE result VARCHAR(30) DEFAULT "";
	DECLARE num INT DEFAULT 10;
    REPEAT
		SET	result = concat(num," ",result);
        SET num = num - 2;
	UNTIL num < 2
    END REPEAT;
	SELECT result;
END //
DELIMITER ;
-- здесь более базово, но еще  попробовал repeat-until.

CALL show_odds10();