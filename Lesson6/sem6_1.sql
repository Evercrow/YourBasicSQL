create SCHEMA lesson_6;
use lesson_6;

/*
Создайте хранимую процедуру hello(), которая будет возвращать приветствие,
в зависимости от текущего времени суток.
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
*/

DROP PROCEDURE IF EXISTS hello;
DELIMITER //
CREATE PROCEDURE hello()
BEGIN
		-- "Тело" процедуры
		CASE 
			WHEN  curtime() BETWEEN "06:00:00" AND "11:59:59" 
				THEN SELECT "Доброе утро";
            WHEN  curtime() BETWEEN "12:00:00" AND "17:59:59" 
				THEN SELECT "Добрый день";
            WHEN  curtime() BETWEEN "18:00:00" AND "23:59:59"
				THEN SELECT "Добрый вечер";
            ELSE 
				SELECT "Доброй ночи";
		END CASE ;
END //
DELIMITER ;

CALL hello();


DROP FUNCTION IF EXISTS  fibonacci;
DELIMITER $$
CREATE FUNCTION fibonacci(num INT) -- num -- количество чисел Фибоначчи для вывода на экран
RETURNS VARCHAR(30) -- max длина вывод в workbench
DETERMINISTIC -- сохранение вызоыва функции с конкретным аргументом в кэш
BEGIN
	DECLARE fib1 INT DEFAULT 0; -- fib1 = 0
    DECLARE fib2 INT DEFAULT 1; -- fib2 = 1
    DECLARE fib3 INT DEFAULT 0; -- fib3 = 0
	DECLARE result VARCHAR(30) DEFAULT '0 1'; 
    
    IF num = 1 THEN
		RETURN fib1;
	ELSEIF num = 2 THEN
		RETURN CONCAT(fib1," ",fib2); -- "0" + "1" = "01"
	ELSE
		WHILE num > 2 DO
			SET fib3 = fib1 + fib2;
            SET fib1 = fib2;
            SET fib2 = fib3;
            SET num = num - 1;
            SET result = CONCAT(result, ",", fib3);
		END WHILE;
        RETURN result;
	END IF;
END $$
DELIMITER ;

SELECT fibonacci(12); -- топ возможного



