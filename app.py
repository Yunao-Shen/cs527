from flask import Flask, render_template, request

from mysql import buildQueryFromInput, connect_mysql
from redshift import connect_redshift

app = Flask(__name__)


@app.route('/')
def index():
    return render_template('index.html')

# @app.route('/mysql/', methods = ['POST'])
@app.route('/mysql/instacart', methods = ['POST'])
@app.route('/mysql/abc_retail', methods = ['POST'])
def queryMysql():
    url = request.path
    _, db, db_table = url.split('/')
    raw_query = request.form['query']
    # return render_template('index.html', query=raw_query)
    q = buildQueryFromInput(raw_query)

    connection = connect_mysql(host='cs527project1group5.cnpt9dsbfddc.us-east-1.rds.amazonaws.com',
                               user='admin',
                               password='cs527project1',
                               db=db_table,
                               port=3306)

    try:
        col_name, res, query_time = connection.make_query(q)
    except Exception as e:
        col_name=[]
        res = []
        query_time = 'query error'
    connection.disconnect()
    return render_template('index.html',
                           db=db,
                           db_table=db_table,
                           col_name=col_name,
                           res=res,
                           query_time=query_time,
                           query=raw_query)

@app.route('/redshift/instacart', methods = ['POST'])
@app.route('/redshift/abc_retail', methods = ['POST'])
def queryRedshift():
    url = request.path
    _, db, db_table = url.split('/')
    raw_query = request.form['query']
    # return render_template('index.html', query=raw_query)
    q = buildQueryFromInput(raw_query)

    connection = connect_redshift(host='cs527project1group5.cj3ezfweedz4.us-east-1.redshift.amazonaws.com',
                               user='admin',
                               password='CS527project1',
                               dbname='instacart',
                               port='5439',
                               options='-c search_path={schema}'.format(schema=db_table))
    try:
        col_name, res, query_time = connection.make_query(q)
    except Exception as e:
        col_name=[]
        res = []
        query_time = 'query error'
    connection.disconnect()
    return render_template('index.html',
                           db=db,
                           db_table=db_table,
                           col_name=col_name,
                           res=res,
                           query_time=query_time,
                           query=raw_query)

if __name__ == '__main__':
    app.run()
