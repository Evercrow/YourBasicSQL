use lesson_4;

CREATE TABLE IF NOT EXISTS  `shops` (
	`id` INT,
    `shopname` VARCHAR (100),
    PRIMARY KEY (id)
);
DROP TABLE `cats`;
CREATE TABLE  `cats` (
	`name` VARCHAR (100),
    `id` INT,
    PRIMARY KEY (id),
    shops_id INT,
    CONSTRAINT fk_cats_shops_id FOREIGN KEY (shops_id)
       REFERENCES `shops` (id)
);


TRUNCATE `shops`;
INSERT INTO `shops`
VALUES 
		(1, "Четыре лапы"),
        (2, "Мистер Зоо"),
        (3, "МурзиЛЛа"),
        (4, "Кошки и собаки");


INSERT INTO `cats`
VALUES 
		("Murzik",1,1),
        ("Nemo",2,2),
        ("Vicont",3,1),
        ("Zuza",4,3);
        
 -- Вывести всех котиков по магазинам по id (условие соединения shops.id = cats.shops_id)
-- Здесь логично будет вывести INNER JOIN 

SELECT c.`name`, `shopname`
FROM cats  c 
JOIN shops
ON shops.id = c.shops_id;

-- так как условие заостряет внимание на ВСЕХ котиках, можно использовать outer join по котикам
SELECT cats.`name`, `shopname`
FROM cats 
LEFT OUTER JOIN shops
ON shops.id = cats.shops_id;
-- результат тот же


-- Вывести магазин, в котором продается кот “Мурзик” (попробуйте выполнить 2 способами)
-- 1) Просто с фильтром 
SELECT c.`name`, `shopname`
FROM cats  c 
JOIN shops
ON shops.id = c.shops_id
WHERE c.`name` = 'Murzik';

-- 2) с подзапросом select - делаем выборку с Мурзиком из cats (1 строка), и клеим на нее соответствие по FK из таблички shops
SELECT c.`name`, `shopname`
FROM shops 
RIGHT JOIN (SELECT `name`,`shops_id` from `cats` WHERE `name` = 'Murzik') c
ON shops.id = c.shops_id;

-- Вывести магазины, в котором НЕ продаются коты “Мурзик” и “Zuza”
SELECT shops.*, cats.*
FROM shops
LEFT JOIN  cats -- выводим именно магазины, поэтому left join. Если про котов информации нет, то считаем, что такие коты там не продаются
ON shops.id = cats.shops_id
-- WHERE cats.`name` NOT IN ('Murzik','Zuza'); по имени не выйдет, так как Мурзик и Виконт в одном магазине ,значит, нужно по id
WHERE shops.id NOT IN(SELECT `shops_id` from cats WHERE `name` IN ('Murzik','Zuza'));


------- Последнее задание, таблица:

DROP TABLE IF EXISTS Analysis;

CREATE TABLE Analysis
(
	an_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	an_name varchar(50),
	an_cost INT,
	an_price INT,
	an_group INT
);

INSERT INTO analysis (an_name, an_cost, an_price, an_group)
VALUES 
	('Общий анализ крови', 30, 50, 1),
	('Биохимия крови', 150, 210, 1),
	('Анализ крови на глюкозу', 110, 130, 1),
	('Общий анализ мочи', 25, 40, 2),
	('Общий анализ кала', 35, 50, 2),
	('Общий анализ мочи', 25, 40, 2),
	('Тест на COVID-19', 160, 210, 3);

DROP TABLE IF EXISTS GroupsAn;

CREATE TABLE GroupsAn
(
	gr_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	gr_name varchar(50),
	gr_temp FLOAT(5,1),
	FOREIGN KEY (gr_id) REFERENCES Analysis (an_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO groupsan (gr_name, gr_temp)
VALUES 
	('Анализы крови', -12.2),
	('Общие анализы', -20.0),
	('ПЦР-диагностика', -20.5);

SELECT * FROM groupsan;

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders
(
	ord_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	ord_datetime DATETIME,	-- 'YYYY-MM-DD hh:mm:ss'
	ord_an INT,
	FOREIGN KEY (ord_an) REFERENCES Analysis (an_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Orders (ord_datetime, ord_an)
VALUES 
	('2020-02-04 07:15:25', 1),
	('2020-02-04 07:20:50', 2),
	('2020-02-04 07:30:04', 1),
	('2020-02-04 07:40:57', 1),
	('2020-02-05 07:05:14', 1),
	('2020-02-05 07:15:15', 3),
	('2020-02-05 07:30:49', 3),
	('2020-02-06 07:10:10', 2),
	('2020-02-06 07:20:38', 2),
	('2020-02-07 07:05:09', 1),
	('2020-02-07 07:10:54', 1),
	('2020-02-07 07:15:25', 1),
	('2020-02-08 07:05:44', 1),
	('2020-02-08 07:10:39', 2),
	('2020-02-08 07:20:36', 1),
	('2020-02-08 07:25:26', 3),
	('2020-02-09 07:05:06', 1),
	('2020-02-09 07:10:34', 1),
	('2020-02-09 07:20:19', 2),
	('2020-02-10 07:05:55', 3),
	('2020-02-10 07:15:08', 3),
	('2020-02-10 07:25:07', 1),
	('2020-02-11 07:05:33', 1),
	('2020-02-11 07:10:32', 2),
	('2020-02-11 07:20:17', 3),
	('2020-02-12 07:05:36', 1),
	('2020-02-12 07:10:54', 2),
	('2020-02-12 07:20:19', 3),
	('2020-02-12 07:35:38', 1);

-- Вывести название и цену для всех анализов, которые продавались 5 февраля 2020 и всю следующую неделю.

-- Сначала примерно посмотрим что когда продавалось по табличке заказов
SELECT o.ord_datetime, a.an_name,a.an_price,    o.ord_an, an_id
FROM Analysis as a
RIGHT JOIN  Orders as o
ON o.ord_an = an_id;

-- встречаются только анализы с id 1 - 3

-- с 5 по 12 включительно группировкой по именам проданных анализов
SELECT a.an_name ,a.an_price ,SUM(a.an_price) AS total_sold
FROM Analysis as a
RIGHT JOIN  (SELECT * FROM Orders as o WHERE o.ord_datetime BETWEEN '2020-02-05 00:00:00' and '2020-02-12 00:00:00') as o
ON o.ord_an = an_id
GROUP BY a.an_name;
-- HAVING o.ord_datetime BETWEEN '2020-02-05 00:00:00' and '2020-02-12 00:00:00' красиво сгруппировать не сработает, так как уже фильтруем агрегированную таблицу, сгруппированную на 4-е февраля; 

-- Как вариант, можно группировать по дням с обрезанием datetime через DAY().  Выведем с 6 по 11
SELECT DAY(o.ord_datetime) AS `Feb day`, GROUP_CONCAT(DISTINCT a.an_name) AS `Analysis names`  ,SUM(a.an_price) AS total_sold -- здесь убрал вывод цены на конкретный анализ(выводит только первую в группе), но нашел агг.функцию для строк
FROM Analysis as a
RIGHT JOIN  Orders as o
ON o.ord_an = an_id
GROUP BY `Feb day`
HAVING `Feb day` BETWEEN 6 and 11;
 -- LIMIT 5 OFFSET IF( MIN(`Feb day`) >= 6, 0 ,6 - MIN(`Feb day`)) ;  -- пытаюсь использовать вместо date between limit c проверкой начальной даты, но ругается на синтаксис

