import psycopg2
from time import time

class connect_redshift():
    def __init__(self, host, dbname, user, password, port, options):
        self.db = psycopg2.connect(
            host=host, dbname=dbname, port=port, user=user, password=password, options=options)
        self.cursor = self.db.cursor()

    def make_query(self, query):
        start_time = int(round(time() * 1000))
        self.cursor.execute(query)
        self.db.commit()

        col_info = self.cursor.description
        if col_info != None:
            result = self.cursor.fetchall()
        else:
            result = []

        query_time = str(int(round(time() * 1000)) - start_time) + " ms"

        if len(result) > 100:
            result = result[:99]

        col_name = []
        if col_info != None:
            for i in range(len(col_info)):
                col_name.append(col_info[i][0])

        return col_name, result, query_time

    def disconnect(self):
        self.cursor.close()
        self.db.close()