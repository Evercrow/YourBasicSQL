# ставим библиотеку-коннектор в питон 
# pip install mysql-connector-python

import mysql.connector
from getpass import getpass


## Запрос на создание
def create_table(cursor,t_name ='test'):
    if t_name =='test':
        create_db_query = '''
                CREATE TABLE IF NOT EXISTS testing_python(
                    id INT PRIMARY KEY AUTO_INCREMENT,
                    some_str VARCHAR(30) NOT NULL DEFAULT "no query yet"
                );
                '''
    else:
        create_db_query = '''CREATE TABLE IF NOT EXISTS movies(
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        title VARCHAR(100),
                        release_year YEAR(4),
                        genre VARCHAR(100),
                        collection_in_mil INT
                        )'''
    try:
        cursor.execute(create_db_query)
    except mysql.connector.Error as err:
        print(err)
        exit(1)

# Запрос на чтение
def select_data(cursor, t_name ='test', filter_start= 1995,filter_end = 1997):
    if t_name == 'test':
        read_query = ("SELECT some_str FROM testing_python "
                "WHERE id in(%s,%s)  ")
        filters = (1,3)
        cursor.execute(read_query, filters)
        for row in cursor.fetchall():
            print(*row)

    else:
        read_query = ("SELECT title,release_year,genre FROM movies "
                "WHERE release_year BETWEEN %s and %s")
        filters = (filter_start, filter_end)
        cursor.execute(read_query, filters)
        for (title,release_year,genre) in cursor : #cursor.fetchall() чтобы работать со списком из кортежей
            print("{}, {}, {}".format(
                    title,release_year,genre))

    

    


# Запрос на изменение данных

def write_data(cursor,which = 'test'):
    if which == 'test':
        write_query = '''
            INSERT INTO testing_python(some_str) VALUES("test_log1"),("test-log2"),("test log3")
        '''
    else:
        write_query=f"""
        INSERT INTO {which} (title, release_year, genre, collection_in_mil)
        VALUES
            ("Forrest Gump", 1994, "Drama", 330.2),
            ("3 Idiots", 2009, "Drama", 2.4),
            ("Eternal Sunshine of the Spotless Mind", 2004, "Drama", 34.5),
            ("Good Will Hunting", 1997, "Drama", 138.1),
            ("Skyfall", 2012, "Action", 304.6),
            ("Gladiator", 2000, "Action", 188.7),
            ("Black", 2005, "Drama", 3.0),
            ("Titanic", 1997, "Romance", 659.2),
            ("The Shawshank Redemption", 1994, "Drama",28.4),
            ("Udaan", 2010, "Drama", 1.5),
            ("Home Alone", 1990, "Comedy", 286.9),
            ("Casablanca", 1942, "Romance", 1.0),
            ("Avengers: Endgame", 2019, "Action", 858.8),
            ("Night of the Living Dead", 1968, "Horror", 2.5),
            ("The Godfather", 1972, "Crime", 135.6),
            ("Haider", 2014, "Action", 4.2),
            ("Inception", 2010, "Adventure", 293.7),
            ("Evil", 2003, "Horror", 1.3),
            ("Toy Story 4", 2019, "Animation", 434.9),
            ("Air Force One", 1997, "Drama", 138.1),
            ("The Dark Knight", 2008, "Action",535.4),
            ("Bhaag Milkha Bhaag", 2013, "Sport", 4.1),
            ("The Lion King", 1994, "Animation", 423.6),
            ("Pulp Fiction", 1994, "Crime", 108.8),
            ("Kai Po Che", 2013, "Sport", 6.0),
            ("Beasts of No Nation", 2015, "War", 1.4),
            ("Andadhun", 2018, "Thriller", 2.9),
            ("The Silence of the Lambs", 1991, "Crime", 68.2),
            ("Deadpool", 2016, "Action", 363.6),
            ("Drishyam", 2015, "Mystery", 3.0)
        """

    
    # Добавление одной строки можно делать еще так:
    # cursor.execute("sql-запрос с плейсхолдерами %s", (кортеж значений))
    #Добавление на последнюю строчку можно делать, получая значение ключа  из "курсора"
    # emp_no = cursor.lastrowid
    cursor.executemany(write_query)
    cnx.commit() #необходимо для подтверждения изменений


# Запрос на удаление

def del_table(cursor,table_name='testing_python'):
    del_query = '''
        DROP TABLE {};
    '''.format(table_name)
    try:
        cursor.execute(del_query)
    except mysql.connector.Error as err:
        print(err)
        exit(1)



try:
    cnx = mysql.connector.connect(user='evercrow',host='127.0.0.1',password=getpass("Введи пароль(он без отображения) :"),
                              database='lesson_6')
except mysql.connector.Error as err:
    print(err)
cursor = cnx.cursor()

# #базовая табличка

# create_table(cursor)
# write_data(cursor)
# select_data(cursor)
# del_table(cursor)

# табличка побольше movies

create_table(cursor,"movies")
write_data(cursor,"movies")
select_data(cursor,"movies",2000,2005)
del_table(cursor,"movies")

cursor.close()
cnx.close()

