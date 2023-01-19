/*
Используя операторы языка SQL,
создайте табличку “sales”. Заполните ее данными
*/
USE lesson_2;
CREATE TABLE IF NOT EXISTS sales
	( id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    order_date DATE,
    count_product INT DEFAULT 0
    );

TRUNCATE sales;
INSERT sales (order_date,count_product)
VALUES ("2022-01-01",156),
		("2022-01-02",180),
        ("2022-01-03",21),
        ("2022-01-04",124),
        ("2022-01-05",341);
        
SELECT * FROM sales;

/*
Для данных таблицы “sales” укажите тип заказа в зависимости от кол-ва :
меньше 100 - Маленький заказ
От 100 до 300 - Средний заказ
больше 300 - Большой заказ
*/

-- Через IF
SELECT *, IF( count_product < 100, "Маленький заказ",
	IF( count_product > 300, "Большой заказ", "Средний заказ")) 
    AS order_score_if ,
-- Через CASE 
	CASE 
	WHEN count_product < 100 THEN "Маленький заказ"
	WHEN count_product > 300 THEN "Большой заказ"
    ELSE "Средний заказ" 
END  AS order_score_case
FROM sales;


/*
Создайте таблицу “orders”, заполните ее значениями

*/

CREATE TABLE IF NOT EXISTS orders
	( id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    employee_id VARCHAR(6) NOT NULL,
    amount FLOAT DEFAULT 0,
    order_status VARCHAR(10)
    );

TRUNCATE orders ;

INSERT  orders (employee_id,amount,order_status)
VALUES ("e03",15.0,"OPEN"),
		("e01",25.50,"OPEN"),
        ("e05",100.70,"CLOSED"),
        ("e02",22.18,"OPEN"),
        ("e04",9.50,"CANCELLED");
        
SELECT * FROM orders;
/*
Выберите все заказы. В зависимости от поля order_status выведите столбец full_order_status:
OPEN – «Order is in open state» ; CLOSED - «Order is closed»; CANCELLED - «Order is cancelled»
*/

-- Через IF
SELECT *, IF( order_status  RLIKE "^C+",  -- если вначале хотя бы одна "C"
	IF( order_status RLIKE "^.L+", "Order is closed", "Order is cancelled"), -- если вначале хотя бы один любой символ + "L"
	"Order is in open state") 
    AS order_score_if ,
-- Через CASE 
	CASE 
	WHEN order_status = "OPEN" THEN "Order is in open state"
	WHEN order_status = "CLOSED" THEN "Order is closed"
    WHEN order_status = "CANCELLED" THEN "Order is cancelled"
    ELSE "Empty status error" 
END  AS order_popup
FROM orders;