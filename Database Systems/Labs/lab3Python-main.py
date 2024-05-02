import mysql.connector
from mysql.connector import Error


def main():
    server = '127.0.0.1'
    username = 'it'
    password = 'password'
    database = 'lab3'


    try:
        # establish datavase connection
        conn = mysql.connector.connect(host=server, user=username, password=password, database=database)


        # check successful connectio
        if conn.is_connected():
            print('Connected to MySQL database')


            cursor = conn.cursor()


            #insert data
            query = "INSERT INTO table1 (data, date_added) VALUES (%s, %s)"
            values = ("CSI", "2024-05-01")
            cursor.execute(query, values)
            conn.commit()


            # select data
            query = "SELECT * FROM table1 WHERE data = %s"
            cursor.execute(query, ("CSI",))


        #print results
            rows = cursor.fetchall()
            for row in rows:
                print(f"ID: {row[0]} Data: {row[1]} Date Added: {row[2]}")


            cursor.close()


    except Error as e:
        print(f"SQL Error: {e}")

    finally:
        if conn.is_connected():
            conn.close()
            print('Connection closed.')


if __name__ == "__main__":
     main()
