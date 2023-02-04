use lesson_5;

-- load data from  csv file

-- табличку нужно сначала создать, load data  не создаст за нас столбцы с аттрибутами

CREATE TABLE IF NOT EXISTS cars
(
	id INT NOT NULL PRIMARY KEY,
    name VARCHAR(45),
    cost INT
); 
TRUNCATE cars; 
-- теперь убираем ошибку Error Code: 1290. The MySQL server is running with the --  option so it cannot execute this statement
SHOW VARIABLES LIKE 'secure%';
-- видим, что там указан путь к специфичной папке в месте установки mySQL 
 -- возможные опции :
--  NULL любой импорт и экспорт из файлов запрещен
-- пустое "" - любой разрешен
-- Directory path - разрешение только для указанного пути
-- поменять настройку мы можем только через ручное изменение secure-file-priv=... в файле  my.cnf (Mac, Linux) or my.ini и перезапуском сервера mySQL
 
-- подгружать можно только с локального хоста или подключенного сервера. Можно подключить к серверу  интернет ссылку через "поток" в коммандной строке :
/*
wget -O - 'http://wwww.myweb.com/temp/file.csv' |
    mysql \
        --user=root \
        --password=password \
        --execute="LOAD DATA LOCAL INFILE '/dev/stdin' INTO TABLE table_name"
*/
-- LOAD DATA LOCAL INFILE 'D:/GB education/SQL/Lessson5/test_db.csv - Лист1.csv'
-- поменял с дефолтного на свою учебную папку : [D:/GB education/SQL/]Lesson5/test_db.csv.csv
-- LOAD DATA INFILE "D:/GB education/SQL/Lesson5/test_db.csv"
LOAD DATA INFILE "D:/GB education/SQL/Lesson5/test_db.csv"
INTO TABLE cars
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
IGNORE 1 ROWS;
-- Error Code: 3948. Loading local data is disabled; this must be enabled on both the client and server sides
SET GLOBAL local_infile = 'ON';

SELECT * FROM cars;

-- И, наконец, приступим к задаче

-- 1. Создайте представление, в которое попадут автомобили стоимостью до 25 000 долларов
CREATE OR REPLACE VIEW cheap_car AS
	SELECT * FROM cars
    WHERE cost < 25000;
    
SELECT * FROM cheap_car;

-- 2. Изменить в существующем представлении порог для стоимости: пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW)

ALTER VIEW cheap_car AS
	SELECT * FROM cars
	WHERE cost <30000;

SELECT * FROM cheap_car;

-- 3. Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди”

CREATE OR REPLACE VIEW skoda_and_audi AS
	SELECT * FROM cars
    WHERE name LIKE "Skoda%" OR name LIKE "Audi%";  -- в табличке видимо закрались пробелы на конце из-за особенности считывания из файла (есть пробелы между "" типа "Skoda ")
    
SELECT * FROM skoda_and_audi;

/*4.
Добавьте новый столбец под названием «время до следующей станции». Чтобы получить это значение, мы вычитаем время станций для пар смежных станций.
Мы можем вычислить это значение без использования оконной функции SQL, но это может быть очень сложно. Проще это сделать с помощью оконной функции LEAD .
 Эта функция сравнивает значения из одной строки со следующей строкой, чтобы получить результат. 
 В этом случае функция сравнивает значения в столбце «время» для станции со станцией сразу после нее.
 */
 CREATE TABLE IF NOT EXISTS stations
(
train_id INT NOT NULL,
station varchar(20) NOT NULL,
station_time TIME NOT NULL
);

TRUNCATE stations;
INSERT stations(train_id, station, station_time)
VALUES (110, "SanFrancisco", "10:00:00"),
(110, "Redwood Sity", "10:54:00"),
(110, "Palo Alto", "11:02:00"),
(110, "San Jose", "12:35:00"),
(120, "SanFrancisco", "11:00:00"),
(120, "Palo Alto", "12:49:00"),
(120, "San Jose", "13:30:00");

SELECT * from stations;

SELECT * , 
		timediff( LEAD(station_time) OVER(),station_time )  AS time_to_next_station_diff
FROM stations;
-- все таки остались отрицательные значения после timediff. 
-- чтобы привести  в разумный вид, просто в конце применитьь фильтр  не сработает, так как он такого столбца еще не знает
-- WHERE time_to_next_station_diff > 0 ;
-- поэтому навешиваю сверху на это дело IF . Тут тоже не хватает какого-нибудь псевдонима или переменной , чтобы не повторять запись внутри if . Это с переменными будем делать?
-- ну и заодно применю другую функцию subtime, разницы среди них никакой не заметил:

SELECT * , 
		timediff( LEAD(station_time) OVER(PARTITION BY train_id ORDER BY station_time ),station_time )  AS time_to_next_station_diff,    -- < 0 исправлено доп. группировкой
        
		IF ( 
        subtime(LEAD(station_time) OVER() , station_time ) > 0 ,
        subtime(LEAD(station_time) OVER() , station_time), "") AS time_to_next_station_sub		
FROM stations;

-- ручной способ. Видно, что при прямо переводе в числа происходит неправильная конвертация часов во время, нужно использовать специальные функции конвертации в секунды(в целые числа по сути)

SELECT * , 
        TIME(LEAD(station_time) OVER(PARTITION BY train_id ORDER BY station_time) - station_time)   AS time_to_next_station_manual_bad,
		sec_to_time( time_to_sec( LEAD(station_time) OVER(PARTITION BY train_id ORDER BY station_time) ) - time_to_sec(station_time) ) AS time_to_next_station_manual_good
	
FROM stations;
