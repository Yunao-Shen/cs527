CREATE TABLE abc_retail.raw(
order_id int,
order_date date default null,
order_shippeddate date default null,
order_freight numeric(20,2),
order_shipcity varchar(255),
order_shipcountry varchar(255),
order_unitprice numeric(20,2),
order_quantity numeric(20,2),
order_amount numeric(20,2),
product_name varchar(255),
employee_lastname varchar(255),
employee_firstname varchar(255),
employee_title varchar(255),
company_name varchar(255),
customer_contactname varchar(255),
customer_city varchar(255),
customer_country varchar(255),
customer_phone varchar(255)
);

# load data infile 'E:\\inRutgers\\CS\\527Database\\project1\\ABC_Retail_headless2.txt' into table raw fields ENCLOSED BY '"';

CREATE TABLE abc_retail.employees
(
  employee_id INT NOT NULL AUTO_INCREMENT,
  employee_lastname VARCHAR(255) NOT NULL,
  employee_firstname VARCHAR(255) NOT NULL,
  employee_title VARCHAR(255),
  PRIMARY KEY (employee_id)
);

CREATE TABLE abc_retail.products
(
  product_id INT NOT NULL AUTO_INCREMENT,
  product_name VARCHAR(255) NOT NULL,
  PRIMARY KEY (product_id),
  UNIQUE (product_name)
);

CREATE TABLE abc_retail.companys
(
  company_id INT NOT NULL AUTO_INCREMENT,
  company_name VARCHAR(255) NOT NULL,
  PRIMARY KEY (company_id),
  UNIQUE (company_name)
);

CREATE TABLE abc_retail.customers
(
  customer_id INT NOT NULL AUTO_INCREMENT,
  customer_contactname VARCHAR(255) NOT NULL,
  customer_city VARCHAR(255),
  customer_country VARCHAR(255),
  customer_phone VARCHAR(255),
  company_id INT NOT NULL,
  PRIMARY KEY (customer_id),
  FOREIGN KEY (company_id) REFERENCES companys(company_id)
);

CREATE TABLE abc_retail.orders
(
  order_id INT NOT NULL,
  order_date DATE,
  order_shippeddate DATE,
  order_freight NUMERIC(20,2),
  order_shipcity VARCHAR(255),
  order_shipcountry VARCHAR(255),
  employee_id INT NOT NULL,
  customer_id INT NOT NULL,
  PRIMARY KEY (order_id),
  FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE abc_retail.order_products
(
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  order_quantity NUMERIC(20,2) NOT NULL,
  order_amount NUMERIC(20,2) NOT NULL,
  order_unitPrice NUMERIC(20,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);