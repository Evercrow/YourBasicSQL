-- Подключимся к нужной schema
USE lesson_1;

-- Выведем созданную таблицу в графический интерфейс
SELECT  *
FROM mobile_phone;

-- 2.Выведите название, производителя и цену для товаров, количество которых превышает 2
SELECT ProductName, Manufacturer, Price
FROM mobile_phone
WHERE ProductCount > 2;

-- 3.Выведите весь ассортимент товаров марки “Samsung”
SELECT *
FROM mobile_phone
WHERE Manufacturer = "Samsung";

-- 4.Выведите информацию о телефонах, где суммарный чек больше 100 000 и меньше 145 000

SELECT *
FROM mobile_phone
WHERE Manufacturer = "Samsung";

-- 5. С помощью регулярных выражений найти:
-- 5.1 Товары, в которых есть упоминание "Iphone"
SELECT ProductName , Manufacturer, ProductCount , Price
FROM mobile_phone
WHERE ProductName LIKE "%Iphone%" AND ProductCount > 0; -- добавлю от себя условие, что мы ищем остатки по складу

-- 5.2. "Galaxy"
SELECT ProductName , Manufacturer, ProductCount , Price
FROM mobile_phone
WHERE ProductName LIKE "Galaxy%" AND ProductCount > 0; -- добавлю от себя условие, что мы ищем остатки по складу
-- 5.3.  Товары, в которых есть ЦИФРЫ
SELECT ProductName , Manufacturer, ProductCount , Price
FROM mobile_phone
-- WHERE ProductName RLIKE '[[:digit:]+]' AND ProductCount > 0; -- ищется хотя бы одно совпадения из класса символов :digit:
WHERE ProductName RLIKE '[0-9]' AND ProductCount > 0; -- ищется хотя бы одно совпадения из диапазона 0-9

-- 5.4.  Товары, в которых есть ЦИФРА "8" 
SELECT ProductName , Manufacturer, ProductCount , Price
FROM mobile_phone
WHERE ProductName LIKE '%8%' AND ProductCount > 0;

-- 6. Задача с тройной звездочкой себе , как найти все римские обозначения?
SELECT ProductName , Manufacturer
FROM mobile_phone
WHERE ProductName RLIKE '[XVIL]+$' AND ProductCount > 0; -- так нахожу , чтобы было хотя бы одно римско-буквенное обозначение на конце названия модели, вроде все айфоны поймал
/* Заметки про регулярки, "расшифровано" с https://dev.mysql.com/doc/refman/8.0/en/regexp.html#function_regexp-like
 ^ - указатель начала строки, 'Petya' ,'^Pe' -> 1 
	'Petya' ,'^et' -> 0 
$ - указатель конца строки , 'Petya' ,'a$' ->1
	'Petya' ,'y$' ->0
. - заменитель одного любого символа(похоже на _) , со служебными символами вроде переноса строки работает только с добавлением спец-аргумента: pat , 'm' или (?m)pat 

а* -  последовательность из 0 или больше символов a 
	'Baaan', '^Ba*n' -> 1
	'Bn', '^Ba*n' -> 1
    .* - любая последовательность
а+ - последовательность из 1 или больше символов a 
a? - 0 или 1 символов a
pat1|pat2  - сравнение c выражением pat1 ИЛИ pat2
(abc)* - 0 или более раз последовательность 'abc'
a{m} - точно m раз повторения строки a
a{m,} - от 0 до m раз повторения строки a
a{m,n} - от m до n раз (m<=n) повторения строки a
[a-dX] - символ из диапазона от a до d ИЛИ X. Чтобы искать ']' , пишут []-dX] , для - его указывают первым или последним.  
	[^a-dX]  - ^ используется как отрицание, символ НЕ из диапазона a-d
	внутри квадратных скобок также можно оперировать классами:
    [=character_class=] - указание какого-то эквивалентного класса по одному из символов, принадлежащих этому классу, нельзя задавать как конечную точку диапазона символов: например [[=o=]], [[=(+)=]], и [o(+)] все синонимы , если у нас символы +  и o заданы одним классом( одним весом сравнения collation value)    
    [:character_class:] - один из стандартных классов из набора ctype(3) . Может меняться в зависимости от локали.
						alnum	Alphanumeric characters
						alpha	Alphabetic characters
						blank	Whitespace characters
						cntrl	Control characters
						digit	Digit characters
						graph	Graphic characters
						lower	Lowercase alphabetic characters
						print	Graphic or space characters
						punct	Punctuation characters
						space	Space, tab, newline, and carriage return
						upper	Uppercase alphabetic characters
						xdigit	Hexadecimal digit characters
*/




