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

CREATE TABLE abc_retail.employees
(
  employee_id int not null identity(1,1),
  employee_lastname varchar(255) not null,
  employee_firstname varchar(255) not null,
  employee_title varchar(255),
  primary key (employee_id)
);

CREATE TABLE abc_retail.products
(
  product_id int not null identity(1,1),
  product_name varchar(255) not null,
  primary key (product_id),
  unique (product_name)
);

CREATE TABLE abc_retail.companys
(
  company_id int not null identity(1,1),
  company_name varchar(255) not null,
  primary key (company_id),
  unique (company_name)
);

CREATE TABLE abc_retail.customers
(
  customer_id int not null identity(1,1),
  customer_contactname varchar(255) not null,
  customer_city varchar(255),
  customer_country varchar(255),
  customer_phone varchar(255),
  company_id int not null,
  primary key (customer_id),
  foreign key (company_id) references abc_retail.companys(company_id)
);

CREATE TABLE abc_retail.orders
(
  order_id int not null,
  order_date date,
  order_shippeddate date,
  order_freight numeric(20,2),
  order_shipcity varchar(255),
  order_shipcountry varchar(255),
  employee_id int not null,
  customer_id int not null,
  primary key (order_id),
  foreign key (employee_id) references abc_retail.employees(employee_id),
  foreign key (customer_id) references abc_retail.customers(customer_id)
);

CREATE TABLE abc_retail.order_products
(
  order_id int not null,
  product_id int not null,
  order_quantity numeric(20,2) not null,
  order_amount numeric(20,2) not null,
  order_unitprice numeric(20,2) not null,
  foreign key (order_id) references abc_retail.orders(order_id),
  foreign key (product_id) references abc_retail.products(product_id)
);
