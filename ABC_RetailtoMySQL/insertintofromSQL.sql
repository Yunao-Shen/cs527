# Store whole abc_retail.txt as a table called raw

insert into employees(employee_lastname, employee_firstname, employee_title)
select distinct employee_lastname, employee_firstname, employee_title
from raw;
select * from employees;

insert into products(product_name)
select distinct product_name
from raw;
select * from products;

insert into companys(company_name)
select distinct company_name
from raw;
select * from companys;

insert into customers(customer_contactname, customer_city, customer_country, customer_phone, company_id)
select distinct r.customer_contactname, r.customer_city, r.customer_country, r.customer_phone, c.company_id
from raw as r
join companys as c
on r.company_name = c.company_name;
select * from customers;

insert into orders(order_id, order_date, order_shippeddate, order_freight, order_shipcity, order_shipcountry, employee_id, customer_id)
select distinct r.order_id, r.order_date, r.order_shippeddate, r.order_freight, r.order_shipcity, r.order_shipcountry, e.employee_id, c.customer_id
from raw as r
join employees as e
on r.employee_lastname= e.employee_lastname and r.employee_firstname= e.employee_firstname
join customers as c
on r.customer_contactname = c.customer_contactname and r.customer_phone = c.customer_phone;
select * from orders limit 100;

insert into order_products(order_quantity, order_unitprice, order_amount, order_id, product_id)
select distinct r.order_quantity, r.order_unitprice, r.order_amount, r.order_id, p.product_id
from raw as r
join products as p
on p.product_name = r.product_name;
select * from order_products limit 100;
