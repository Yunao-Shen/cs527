create table employees
(
  employee_id int not null identity(1,1),
  employee_lastname varchar(255) not null,
  employee_firstname varchar(255) not null,
  employee_title varchar(255),
  primary key (employee_id)
);

create table products
(
  product_id int not null identity(1,1),
  product_name varchar(255) not null,
  primary key (product_id),
  unique (product_name)
);

create table companys
(
  company_id int not null identity(1,1),
  company_name varchar(255) not null,
  primary key (company_id),
  unique (company_name)
);

create table customers
(
  customer_id int not null identity(1,1),
  customer_contactname varchar(255) not null,
  customer_city varchar(255),
  customer_country varchar(255),
  customer_phone varchar(255),
  company_id int not null,
  primary key (customer_id),
  foreign key (company_id) references companys(company_id)
);

create table orders
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
  foreign key (employee_id) references employees(employee_id),
  foreign key (customer_id) references customers(customer_id)
);

create table order_products
(
  order_id int not null,
  product_id int not null,
  order_quantity numeric(20,2) not null,
  order_amount numeric(20,2) not null,
  order_unitprice numeric(20,2) not null,
  foreign key (order_id) references orders(order_id),
  foreign key (product_id) references products(product_id)
);

insert into employees(employee_lastname, employee_firstname, employee_title)
select distinct employee_lastname, employee_firstname, employee_title
from raws;

insert into products(product_name)
select distinct product_name
from raws;

insert into companys(company_name)
select distinct company_name
from raws;
select * from companys;

insert into customers(customer_contactname, customer_city, customer_country, customer_phone, company_id)
select distinct r.customer_contactname, r.customer_city, r.customer_country, r.customer_phone, c.company_id
from raws as r
join companys as c
on r.company_name = c.company_name;
select * from customers;

insert into orders(order_id, order_date, order_shippeddate, order_freight, order_shipcity, order_shipcountry, employee_id, customer_id)
select distinct r.order_id, r.order_date, r.order_shippeddate, r.order_freight, r.order_shipcity, r.order_shipcountry, e.employee_id, c.customer_id
from raws as r
join employees as e
on r.employee_lastname= e.employee_lastname and r.employee_firstname= e.employee_firstname
join customers as c
on r.customer_contactname = c.customer_contactname and r.customer_phone = c.customer_phone;
select * from orders limit 100;

insert into order_products(order_quantity, order_unitprice, order_amount, order_id, product_id)
select distinct r.order_quantity, r.order_unitprice, r.order_amount, r.order_id, p.product_id
from raws as r
join products as p
on p.product_name = r.product_name;
select * from order_products limit 100;

select count(*) from companys;
select count(*) from employees;
select count(*) from customers;
select count(*) from products;
select count(*) from orders;
select count(*) from order_products;