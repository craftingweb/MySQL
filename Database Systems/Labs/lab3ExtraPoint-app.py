from flask import Flask, request, jsonify
import mysql.connector
from mysql.connector import Error

app = Flask(__name__)

@app.route('/insert', methods=['POST'])
def insert_data():
    server = '127.0.0.1'
    username = 'it'
    password = 'password'
    database = 'lab3'

    try:
        # Establish database connection
        conn = mysql.connector.connect(host=server, user=username, password=password, database=database)

        if conn.is_connected():
            cursor = conn.cursor()

            # Get data from request
            data = request.json
            data_value = data.get('data')
            date_value = data.get('date_added')

            # Insert data into table
            query = "INSERT INTO table1 (data, date_added) VALUES (%s, %s)"
            values = (data_value, date_value)
            cursor.execute(query, values)
            conn.commit()

            cursor.close()
            return jsonify({'message': 'Data inserted successfully'}), 201

    except Error as e:
        return jsonify({'error': f"SQL Error: {e}"}), 500

    finally:
        if conn.is_connected():
            conn.close()

@app.route('/select', methods=['GET'])
def select_data():
    server = '127.0.0.1'
    username = 'it'
    password = 'password'
    database = 'lab3'

    try:
        # Establish database connection
        conn = mysql.connector.connect(host=server, user=username, password=password, database=database)

        if conn.is_connected():
            cursor = conn.cursor()

            # Select data from table
            query = "SELECT * FROM table1"
            cursor.execute(query)

            rows = cursor.fetchall()
            data_list = [{'id': row[0], 'data': row[1], 'date_added': str(row[2])} for row in rows]

            cursor.close()
            return jsonify(data_list)

    except Error as e:
        return jsonify({'error': f"SQL Error: {e}"}), 500

    finally:
        if conn.is_connected():
            conn.close()

if __name__ == '__main__':
    app.run(debug=True)
