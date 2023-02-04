use lesson_6;

CREATE TABLE IF NOT EXISTS bankaccounts(accountno varchar(20) PRIMARY KEY NOT NULL, funds decimal(8,2));
truncate bankaccounts;
INSERT INTO bankaccounts VALUES("ACC1", 1000);
INSERT INTO bankaccounts VALUES("ACC2", 1000);

 -- Изменим баланс на аккаунтах
 
START TRANSACTION; -- старт транзакции
UPDATE bankaccounts SET funds=funds-100 WHERE accountno='ACC1'; 
UPDATE bankaccounts SET funds=funds+100 WHERE accountno='ACC2'; 
COMMIT; -- сохранение даных в таблицу
ROLLBACK;


SELECT *
FROM bankaccounts;

-- /*
-- START TRANSACTION; -- старт транзакции
-- UPDATE bankaccounts SET funds=funds-100 WHERE accountno='ACC1'; 
-- UPDATE bankaccounts SET funds=funds+100 WHERE accountno='ACC2'; 
-- ROLLBACK; -- откат изменений до состояний перед START TRANSACTION 


-- SELECT *
-- FROM bankaccounts;
-- будет неверный результат в том же скрипте , так как откат будет до не того старта. Лучше каждую транзакцию в отдельном скрипте( та самая логическая единица) 
-- */

-- Реализуйте процедуру, внутри которой с помощью цикла выведите числа от N до 1:
-- N = 5=>5,4,3,2,1,

DROP  PROCEDURE loop_example;
DELIMITER $$

CREATE PROCEDURE loop_example(s VARCHAR(1) )
	BEGIN
		DECLARE N INT;
        DECLARE result VARCHAR(30) DEFAULT "";
        SET N = 5;
        
        REPEAT
			SET result = concat(result, s ,N) ;
            SET N = N-1;
        UNTIL N <= 0 
        END REPEAT;
        SELECT result ;
END $$
DELIMITER ;

;
CALL loop_example(sep);


